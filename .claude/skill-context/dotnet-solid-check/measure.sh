#!/usr/bin/env bash
# Re-measures every quantity "SOLID Check.md" cites, so each re-check compares like with like.
# Usage: bash measure.sh [since]   (since: a git date, e.g. "2026-10-20 10:30"; default 2 days ago)
# Read-only: runs grep, wc and git log; never builds, tests or edits.

ROOT=/c/repo/jhkweb
SINCE=${1:-"2 days ago"}
X="--include=*.cs --exclude-dir=obj --exclude-dir=bin"
REPOS="Kelly-Windows-Data-v3 Kelly-Windows-v3 Kelly-Domain Kelly-Revit-Logic-v5 Kelly-Revit-UI Kelly-Revit-v5"

cd "$ROOT" || exit 1

# Code lines only: comment and XML doc lines (starting with //) and using aliases (using A = B.C;) do not count; using var x = ... does.
code() { grep -rn "$1" $X $2 2>/dev/null | grep -vE '^[^:]+:[0-9]+:\s*(//|using [A-Za-z_.]+ = [A-Za-z_.]+;)'; }
count() { code "$1" "$2" | wc -l; }
files() { code "$1" "$2" | cut -d: -f1 | sort -u | wc -l; }

echo "# Changes since $SINCE"
for r in $REPOS; do
    echo "## $r [$(git -C $r branch --show-current)]"
    git -C $r log --since="$SINCE" --format='  %h %ad %s' --date=format:'%m-%d %H:%M' | cut -c1-150
    echo "  src/modules files changed: $(git -C $r log --since="$SINCE" --name-only --format= -- src modules | sort -u | wc -l)"
    echo "  uncommitted: $(git -C $r status --short | tr '\n' ' ')"
done

echo
echo "# Largest source files (lines)"
for r in $REPOS; do
    echo "## $r"
    find $r/src $r/modules -name '*.cs' -not -path '*/obj/*' -not -path '*/bin/*' 2>/dev/null | xargs wc -l 2>/dev/null | grep -v ' total$' | sort -rn | head -5 | sed "s|$r/||"
done

echo
echo "# Counts per repo (src, and modules for Kelly-Revit)"
# TaskDlg: files that show a Revit TaskDialog directly (TaskDialog.Show or new TaskDialog), not counting RevitUserPrompt, the seam's own implementation.
# TaskDialogSimple and HandleIt are UserPrompt wrappers, so their callers are not bypasses.
printf "%-20s %8s %8s %8s %8s %8s %8s %8s\n" repo static-cls ifaces MsgBox TaskDlg UserPrompt newSqlSvc NotImpl
for r in $REPOS; do
    S="$r/src"; [ -d $r/modules ] && S="$r/src $r/modules"
    printf "%-20s %8s %8s %8s %8s %8s %8s %8s\n" $r \
        "$(grep -rlE 'static class' $X $S | wc -l)" \
        "$(grep -rhE '^\s*(public|internal) interface ' $X $S | wc -l)" \
        "$(files MessageBox "$S")" \
        "$(code 'TaskDialog\.Show(\|new TaskDialog(' "$S" | grep -v 'Prompts/RevitUserPrompt.cs' | cut -d: -f1 | sort -u | wc -l)" \
        "$(files 'UserPrompt' "$S")" \
        "$(count 'new SqlServerService' "$S")" \
        "$(count 'NotImplementedException' "$S")"
done

echo
echo "# Specific items"
echo "Windows-Data IDatabaseDataService file:   $(ls Kelly-Windows-Data-v3/src/Database/IDatabaseDataService.cs 2>/dev/null || echo gone)"
echo "Windows-Data reader/writer interfaces:    $(ls Kelly-Windows-Data-v3/src/Database/IDatabase{Reader,Writer}.cs 2>/dev/null | wc -l)"
echo "Windows-Data CacheBase new SqlServerService: $(grep -c 'new SqlServerService' Kelly-Windows-Data-v3/src/Caching/CacheBase.cs 2>/dev/null)"
echo "Windows SqlRecordCache new SqlServerService: $(grep -c 'new SqlServerService' Kelly-Windows-v3/src/Persistence/SqlRecordCache.cs 2>/dev/null)"
echo "Domain files naming USP_:                 $(grep -rl 'USP_' $X Kelly-Domain/src | wc -l)"
echo "Domain IColorPalette Color0x properties:  $(grep -c 'Color0' Kelly-Domain/src/Signatures/IColorPalette.cs 2>/dev/null)"
echo "Domain DefinitionSetBase uses registry:   $(grep -c 'DefinitionRegistry.Resolve' Kelly-Domain/src/Definitions/DefinitionSetBase.cs 2>/dev/null)"
echo "Domain PCF files touching File/Directory: $(grep -rlE 'File\.|Directory\.' $X Kelly-Domain/src/Pcf | wc -l)"
echo "Logic DocumentExtensions lines:           $(wc -l < Kelly-Revit-Logic-v5/src/Documents/DocumentExtensions.cs 2>/dev/null)"
echo "Logic Spool lines / UserPrompt uses:      $(wc -l < Kelly-Revit-Logic-v5/src/Spools/Spool.cs 2>/dev/null) / $(grep -c UserPrompt Kelly-Revit-Logic-v5/src/Spools/Spool.cs 2>/dev/null)"
echo "Logic FabricationPartExtensions 'is Fabrication': $(grep -cE 'is Fabrication' Kelly-Revit-Logic-v5/src/Fabrication/FabricationPartExtensions.cs 2>/dev/null)"
echo "Logic TaskDialogSimple still wraps UserPrompt: $(grep -c 'UserPrompt.Show' Kelly-Revit-Logic-v5/src/Common/TaskDialogSimple.cs 2>/dev/null) calls (0 would make every TaskDialogSimple caller a bypass)"
echo "PenetrationTagTools Stop after RollBack (finally): $(grep -A3 'finally' Kelly-Revit-Logic-v5/src/Elements/PenetrationTagTools.cs 2>/dev/null | grep -c 'operationService.Stop();')"
echo "UI ViewModel lines / implements IViewModel: $(wc -l < Kelly-Revit-UI/src/Mvvm/ViewModel.cs 2>/dev/null) / $(grep -cE 'class ViewModel\b.*IViewModel' Kelly-Revit-UI/src/Mvvm/ViewModel.cs 2>/dev/null)"
echo "UI RibbonHost static UiControlledApplication: $(grep -c 'static.*UiControlledApplication' Kelly-Revit-UI/src/Ribbon/RibbonHost.cs 2>/dev/null)"
echo "Revit SpoolManagerViewModel lines:        $(wc -l < Kelly-Revit-v5/modules/AllTrade/Commands/Spools/SpoolManager/SpoolManagerViewModel.cs 2>/dev/null)"
echo "Revit direct TaskDialog files / UserPrompt files / TaskDialogSimple-only files: $(code 'TaskDialog\.Show(\|new TaskDialog(' 'Kelly-Revit-v5/src Kelly-Revit-v5/modules' | cut -d: -f1 | sort -u | wc -l) / $(files UserPrompt 'Kelly-Revit-v5/src Kelly-Revit-v5/modules') / $(grep -rl 'TaskDialogSimple\.' $X Kelly-Revit-v5/src Kelly-Revit-v5/modules | xargs grep -LE 'TaskDialog\.Show\(|new TaskDialog\(' | wc -l)"
echo "Revit Command.UiDocument uses:            $(grep -rnE '(Command|CommandBase)\.UiDocument' $X Kelly-Revit-v5/modules | wc -l)"
echo "Revit GetService<AutoUpdaterService>:     $(grep -rn 'GetService<AutoUpdaterService>' $X Kelly-Revit-v5/modules | wc -l)"
echo "Revit FabricationCustomDataUpdater V1/V2: $(ls -d Kelly-Revit-v5/modules/Contenter/Commands/FabricationCustomDataUpdaterV* 2>/dev/null | wc -l) folders"
echo "Revit RibbonService hard-coded module DLLs: $(grep -oE 'Kelly\.Revit\.[A-Za-z]+\.dll' Kelly-Revit-v5/src/Services/RibbonService.cs 2>/dev/null | wc -l)"
