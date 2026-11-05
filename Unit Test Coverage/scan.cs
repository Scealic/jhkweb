#:package Microsoft.CodeAnalysis.CSharp@4.14.0
// Member-level static test-reference scan.
// Usage: dotnet run scan.cs -- <outDir> <repoName>|<srcDir;srcDir>|<testDir;testDir> ...
using System.Text;
using System.Text.RegularExpressions;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

var outDir = args[0];
Directory.CreateDirectory(outDir);
var summary = new StringBuilder();
summary.AppendLine("repo|srcTypes|testedTypes|contractTypes|members|referencedMembers|tests|testCases|datedAuthors|emptyAuthors|noAuthor|noDescription");
var detail = new StringBuilder();
detail.AppendLine("repo|kind|folder|type|member|status");

string[] contractBases = ["IExternalCommand", "IExternalCommandAvailability", "CommandBase", "IExternalCommandBase", "IExternalCommandMvvm",
    "PushButtonBase", "IRibbonPushButton", "IRibbonStackedButton", "IRibbonPullDownButton", "IRibbonSplitButton", "IRibbonComboBox",
    "AvailabilityBase", "Window", "UserControl", "IRibbonPanelConfiguration"];

foreach (var spec in args.Skip(1))
{
    var parts = spec.Split('|');
    var repo = parts[0];
    var srcDirs = parts[1].Split(';', StringSplitOptions.RemoveEmptyEntries);
    var testDirs = parts[2].Split(';', StringSplitOptions.RemoveEmptyEntries);
    bool Skip(string f) => f.Contains($"{Path.DirectorySeparatorChar}obj{Path.DirectorySeparatorChar}") || f.Contains($"{Path.DirectorySeparatorChar}bin{Path.DirectorySeparatorChar}") || f.EndsWith(".g.cs") || f.EndsWith(".g.i.cs");
    var srcFiles = srcDirs.SelectMany(d => Directory.EnumerateFiles(d, "*.cs", SearchOption.AllDirectories)).Where(f => !Skip(f)).ToList();
    var testFiles = testDirs.SelectMany(d => Directory.EnumerateFiles(d, "*.cs", SearchOption.AllDirectories)).Where(f => !Skip(f)).ToList();

    // Test corpus: per file, identifiers + string literal contents
    var testTokens = new List<HashSet<string>>();
    int tests = 0, cases = 0, dated = 0, empty = 0, noAuthor = 0, noDesc = 0;
    foreach (var tf in testFiles)
    {
        var tree = CSharpSyntaxTree.ParseText(File.ReadAllText(tf));
        var root = tree.GetRoot();
        var set = new HashSet<string>(StringComparer.Ordinal);
        foreach (var t in root.DescendantTokens())
        {
            if (t.IsKind(SyntaxKind.IdentifierToken)) set.Add(t.ValueText);
            else if (t.IsKind(SyntaxKind.StringLiteralToken) || t.IsKind(SyntaxKind.InterpolatedStringTextToken))
                foreach (Match m in Regex.Matches(t.ValueText, @"[A-Za-z_][A-Za-z0-9_]*")) set.Add(m.Value);
        }
        // file name as a token too (fixture <Type>Tests)
        set.Add(Path.GetFileNameWithoutExtension(tf));
        testTokens.Add(set);
        foreach (var a in root.DescendantNodes().OfType<AttributeSyntax>())
        {
            var n = a.Name.ToString();
            if (n is not ("Test" or "TestCase" or "NUnit.Framework.Test" or "NUnit.Framework.TestCase")) continue;
            if (n.EndsWith("TestCase")) cases++; else tests++;
            var args2 = a.ArgumentList?.Arguments ?? default;
            var author = args2.FirstOrDefault(x => x.NameEquals?.Name.Identifier.Text == "Author");
            var desc = args2.FirstOrDefault(x => x.NameEquals?.Name.Identifier.Text == "Description");
            if (author is null) noAuthor++;
            else if (Regex.IsMatch(author.Expression.ToString(), @"On:\s*\d{4}")) dated++;
            else empty++;
            if (desc is null) noDesc++;
        }
    }
    bool AnyRef(string type) => testTokens.Any(s => s.Contains(type) || s.Contains(type + "Tests"));
    bool MemberRef(string type, string member) => testTokens.Any(s => (s.Contains(type) || s.Contains(type + "Tests")) && s.Contains(member));

    int srcTypes = 0, testedTypes = 0, contractTypes = 0, members = 0, refMembers = 0;
    var seenTypes = new HashSet<string>();
    foreach (var sf in srcFiles)
    {
        var root = CSharpSyntaxTree.ParseText(File.ReadAllText(sf)).GetRoot();
        var folder = Path.GetRelativePath(srcDirs.First(d => sf.StartsWith(d)), Path.GetDirectoryName(sf)!).Replace('\\', '/');
        foreach (var td in root.DescendantNodes().OfType<MemberDeclarationSyntax>().Where(n => n is BaseTypeDeclarationSyntax or DelegateDeclarationSyntax))
        {
            var mods = td.Modifiers.Select(m => m.Text).ToList();
            if (mods.Contains("private") || (mods.Contains("protected") && !mods.Contains("internal"))) continue;
            string name = td switch { BaseTypeDeclarationSyntax b => b.Identifier.Text, DelegateDeclarationSyntax d => d.Identifier.Text, _ => "?" };
            var key = folder + "/" + name;
            bool partialDup = !seenTypes.Add(key);
            var bases = (td as TypeDeclarationSyntax)?.BaseList?.Types.Select(t => Regex.Replace(t.Type.ToString(), @"<.*>", "").Split('.').Last()).ToList() ?? [];
            bool contract = repo == "Kelly-Revit-v5" && (bases.Any(b => contractBases.Contains(b)) || Regex.IsMatch(name, @"(Command|PushButton|CommandEnabler|Window|View|StackedButtons|PullDownButton|SplitButton)(V\d)?$") || name.StartsWith("Is") && name.EndsWith("Enabler"));
            string kind = td switch { InterfaceDeclarationSyntax => "interface", EnumDeclarationSyntax => "enum", DelegateDeclarationSyntax => "delegate", RecordDeclarationSyntax => "record", StructDeclarationSyntax => "struct", _ => "class" };
            if (contract) kind = "contract-" + kind;
            bool isExt = td is ClassDeclarationSyntax cds && cds.Modifiers.Any(x => x.Text == "static") && cds.Members.OfType<MethodDeclarationSyntax>().Any(md => md.ParameterList.Parameters.FirstOrDefault()?.Modifiers.Any(x => x.Text == "this") == true);
            bool typeRef = AnyRef(name) || (isExt && ((TypeDeclarationSyntax)td).Members.OfType<MethodDeclarationSyntax>().Any(md => md.ParameterList.Parameters.FirstOrDefault()?.Modifiers.Any(x => x.Text == "this") == true && testTokens.Any(s => s.Contains(md.Identifier.Text))));
            if (!partialDup)
            {
                if (contract) contractTypes++; else { srcTypes++; if (typeRef) testedTypes++; }
            }
            if (!typeRef && !partialDup) detail.AppendLine($"{repo}|{kind}|{folder}|{name}||type-untested");
            if (contract || td is not TypeDeclarationSyntax tdecl) continue;
            foreach (var m in tdecl.Members)
            {
                string? mname = m switch
                {
                    MethodDeclarationSyntax md => md.Identifier.Text,
                    PropertyDeclarationSyntax pd => pd.Identifier.Text,
                    EventDeclarationSyntax ed => ed.Identifier.Text,
                    EventFieldDeclarationSyntax ef => ef.Declaration.Variables.First().Identifier.Text,
                    ConstructorDeclarationSyntax cd => cd.Modifiers.Any(x => x.Text == "static") ? null : ".ctor",
                    IndexerDeclarationSyntax => "this[]",
                    OperatorDeclarationSyntax od => "op_" + od.OperatorToken.Text,
                    _ => null
                };
                if (mname is null) continue;
                if (m is MethodDeclarationSyntax md2 && md2.Modifiers.Any(x => x.Text == "partial") && md2.Body is null && md2.ExpressionBody is null) continue;
                members++;
                bool r = mname switch { ".ctor" => typeRef, "this[]" => typeRef, _ when mname.StartsWith("op_") => typeRef, _ => MemberRef(name, mname) || (isExt && testTokens.Any(s => s.Contains(mname))) };
                if (r) refMembers++;
                else
                {
                    var acc = string.Join(" ", m.Modifiers.Where(x => x.Text is "public" or "internal" or "protected" or "private").Select(x => x.Text));
                    detail.AppendLine($"{repo}|{(acc == "" ? (kind == "interface" ? "public" : "private") : acc)}|{folder}|{name}|{mname}|member-unreferenced");
                }
            }
        }
    }
    summary.AppendLine($"{repo}|{srcTypes}|{testedTypes}|{contractTypes}|{members}|{refMembers}|{tests}|{cases}|{dated}|{empty}|{noAuthor}|{noDesc}");
}
File.WriteAllText(Path.Combine(outDir, "summary.psv"), summary.ToString());
File.WriteAllText(Path.Combine(outDir, "detail.psv"), detail.ToString());
Console.Write(summary);
