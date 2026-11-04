#!/usr/bin/perl
# Read-only check of the layer rules across the six Kelly repos. Run before an analysis (baseline) and after the moves (audit).
#   perl check-rules.pl [root]          root defaults to /c/repo/jhkweb
# Sections:
#   1. Autodesk/Revit API use in Kelly-Windows-Data, Kelly-Windows, Kelly-Domain (src, .cs/.xaml/.csproj), plus RevitAPIUI in Kelly-Revit-Logic.
#   2. Lower layers naming a higher layer's namespace (dependency direction).
#   3. Protected files (IExternalCommand classes, *View.xaml(.cs), *View.cs, *ViewModel.cs) outside Kelly-Revit.
#      Interfaces and abstract framework types in Kelly-Revit-UI, and the files listed in %KNOWN, are reported as allowed.
#   4. Files whose namespace does not match their folder.
#   5. Counts: IExternalCommand classes and view/view-model files in Kelly-Revit; the word "Revit" in the Revit-free layers (comments included).
# Exit code 1 when section 1, 2, 3 (not allowed) or 4 has a hit.
use strict;
use warnings;
use File::Find;

my $root = shift // '/c/repo/jhkweb';
# Revit-free generic WPF window that predates the rule; confirm with the user before moving it.
my %KNOWN = map { $_ => 1 } ('Kelly-Windows-v3/src/Wpf/ProgressView.xaml', 'Kelly-Windows-v3/src/Wpf/ProgressView.xaml.cs');

# [repo-relative source folder, root namespace, layer index]
my @projects = (
  ['Kelly-Windows-Data-v3/src', 'Kelly.Windows.Data', 0],
  ['Kelly-Windows-v3/src',      'Kelly.Windows',      1],
  ['Kelly-Domain/src',       'Kelly.Domain',       2],
  ['Kelly-Revit-Logic-v5/src',  'Kelly.Revit.Logic',  3],
  ['Kelly-Revit-UI/src',     'Kelly.Revit.UI',     4],
  ['Kelly-Revit-v5/src',        'Kelly.Revit.Core',   5],
);
for my $m (glob "$root/Kelly-Revit-v5/modules/*") {
  next unless -d $m;
  (my $name = $m) =~ s{.*/}{};
  push @projects, ["Kelly-Revit-v5/modules/$name", "Kelly.Revit.$name", 5];
}
# Namespaces a layer must not name: everything owned by a higher layer.
my @forbidden = (
  qr/\b(?:Kelly\.Windows\.(?!Data\b)\w+|Kelly\.Domain\b|Kelly\.Revit\b)/,     # Data
  qr/\b(?:Kelly\.Domain\b|Kelly\.Revit\b)/,                                   # Windows
  qr/\bKelly\.Revit\b/,                                                       # Domain
  qr/\bKelly\.Revit\.(?!Logic\b)\w+/,                                         # Logic
  qr/\bKelly\.Revit\.(?!Logic\b|UI\b)\w+/,                                    # UI
);

my (@revit, @direction, @protected, @namespace, %count);
sub rel { my $p = shift; $p =~ s{^\Q$root\E/}{}; $p }
sub slurp { my $f = shift; open(my $h, '<:raw', $f) or return ''; local $/; my $t = <$h>; close $h; $t =~ s/^\xEF\xBB\xBF//; $t }

for my $p (@projects) {
  my ($dir, $ns, $layer) = @$p;
  my $abs = "$root/$dir";
  next unless -d $abs;
  my @files;
  find({ no_chdir => 1, wanted => sub {
    if (-d $_ && m{/(?:bin|obj|TestLogs|\.vs)$}) { $File::Find::prune = 1; return }
    push @files, $_ if -f $_ && /\.(?:cs|xaml|csproj)$/;
  } }, $abs);
  for my $f (sort @files) {
    my $r = rel($f);
    my $t = slurp($f);
    (my $code = $t) =~ s{//[^\n]*|/\*.*?\*/}{}gs if $f =~ /\.cs$/;
    $code //= $t;
    # 1. Revit API in Revit-free layers; RevitAPIUI in Logic.
    if ($layer <= 2) {
      while ($t =~ /^(.*(?:\bAutodesk\b|RevitAPI).*)$/mg) { push @revit, "$r: " . trim($1) }
    } elsif ($layer == 3 && $f =~ /\.(?:cs|csproj)$/) {
      while ($t =~ /^(.*(?:Autodesk\.Revit\.UI\b|RevitAPIUI|AdWindows|Telerik).*)$/mg) { push @revit, "$r: " . trim($1) }
    }
    $count{revitWord} += () = $t =~ /\bRevit\b/g if $layer <= 2 && $f =~ /\.(?:cs|xaml)$/;
    # 2. Dependency direction (code only, comments stripped).
    if ($layer <= 4 && $f =~ /\.(?:cs|xaml)$/) {
      my $re = $forbidden[$layer];
      while ($code =~ /^(.*$re.*)$/mg) { push @direction, "$r: " . trim($1) }
    }
    next unless $f =~ /\.(?:cs|xaml)$/;
    # 3. Protected files.
    my $isView = $f =~ /(?:View\.xaml|View\.xaml\.cs|View\.cs|ViewModel\.cs)$/;
    # Commands implement IExternalCommand directly or through a Kelly-Revit-UI contract (IExternalCommandBase, IExternalCommandMvvm).
    my @commands  = $f =~ /\.cs$/ ? ($code =~ /\bclass\s+(\w+)[^{;]*:\s*[^{;]*\bIExternalCommand(?:Base|Mvvm)?\b/g) : ();
    my @contracts = $f =~ /\.cs$/ ? ($code =~ /\binterface\s+(\w+)[^{;]*:\s*[^{;]*\bIExternalCommand\b/g) : ();
    if ($layer == 5) {
      $count{views}++ if $isView;
      $count{commands} += @commands;
    } elsif ($isView || @commands || @contracts) {
      my $what = $isView ? 'view/view-model file' : @commands ? 'IExternalCommand class ' . join(', ', @commands) : 'IExternalCommand contract ' . join(', ', @contracts);
      my $abstract = $code =~ /\b(?:interface|abstract\s+class)\b/ && !grep { $code !~ /\babstract\s+(?:\w+\s+)*class\s+$_\b/ } @commands;
      my $allowed = $KNOWN{$r} ? 'known' : ($layer == 4 && $abstract) ? 'framework abstraction' : '';
      push @protected, [$r, $what, $allowed];
    }
    # 4. Namespace == folder.
    next unless $f =~ /\.cs$/ && $f !~ m{/GlobalUsings\.cs$|/IsExternalInit\.cs$|/AssemblyInfo\.cs$};
    my ($declared) = $code =~ /^\s*namespace\s+([\w.]+)/m;
    next unless defined $declared;
    (my $sub = $f) =~ s{^\Q$abs\E/?}{};
    $sub =~ s{/?[^/]+$}{};
    my $expected = join('.', $ns, grep { length } split m{/}, $sub);
    push @namespace, "$r: namespace $declared, expected $expected" unless $declared eq $expected;
  }
}

sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; length($s) > 160 ? substr($s, 0, 157) . '...' : $s }
sub section { my ($title, @lines) = @_; printf "== %s: %d\n", $title, scalar @lines; print "  $_\n" for @lines[0 .. ($#lines < 59 ? $#lines : 59)]; print "  ... and ", @lines - 60, " more\n" if @lines > 60 }

section('1. Revit API in Kelly-Windows-Data-v3/Kelly-Windows-v3/Kelly-Domain, RevitAPIUI/AdWindows/Telerik in Kelly-Revit-Logic-v5', @revit);
section('2. Lower layer names a higher layer', @direction);
my @bad = map { "$_->[0]: $_->[1]" } grep { !$_->[2] } @protected;
my @ok  = map { "$_->[0]: $_->[1] ($_->[2])" } grep { $_->[2] } @protected;
section('3. Protected files outside Kelly-Revit (not allowed)', @bad);
section('3. Protected files outside Kelly-Revit (allowed)', @ok);
section('4. Namespace does not match folder', @namespace);
printf "== 5. Kelly-Revit: %d IExternalCommand classes, %d view/view-model files; the word \"Revit\" appears %d times in Revit-free layers (read them: comments are allowed only if they describe no Revit behaviour)\n",
  $count{commands} // 0, $count{views} // 0, $count{revitWord} // 0;
exit((@revit || @direction || @bad || @namespace) ? 1 : 0);
