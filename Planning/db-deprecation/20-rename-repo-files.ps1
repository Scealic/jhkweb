<#
    Rename the 54 deprecated stored-procedure definitions in the SSDT repos.

    For each procedure this script:
      1. git mv  <Name>.sql  ->  DEPREC_<Name>.sql
      2. rewrites the CREATE PROCEDURE statement to the new name
      3. updates the matching <Build Include="..."/> entry in the .sqlproj

    Without step 3 the project will not build; without steps 1-2 the next
    SSDT deploy would recreate the original procedure names and silently
    undo the server-side rename.

    CREATE statement forms in these repos are not consistent. All of these
    occur and are handled, with the file's existing bracketing preserved:

        CREATE PROCEDURE [dbo].[Name]
        CREATE PROCEDURE [dbo].Name
        CREATE PROCEDURE dbo.Name
        CREATE PROC      [dbo].[Name]
        CREATE OR ALTER PROCEDURE [dbo].[Name]

    Exactly one replacement is made per file. If zero matches are found the
    script throws before writing anything, leaving that file's content intact.

    Encoding: files are rewritten as UTF-8 with BOM and existing CRLF line
    endings are preserved, matching the repo's current format.

    Run with -WhatIf first. Requires a clean working tree.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string] $Root = 'C:\repo\jhkweb',
    [switch] $AllowDirtyTree
)

$ErrorActionPreference = 'Stop'
$map = Import-Csv (Join-Path $PSScriptRoot 'repo-rename-map.csv')
if (-not $map) { throw 'repo-rename-map.csv not found or empty.' }

$utf8Bom = New-Object System.Text.UTF8Encoding($true)
$repos   = $map | Select-Object -ExpandProperty Repo -Unique

function Get-CreatePattern([string] $ObjectName) {
    # schema may be [bracketed] or bare; object name may be [bracketed] or bare.
    # Group 1 = everything up to and including an optional opening bracket.
    # Group 2 = the optional closing bracket.
    '(CREATE\s+(?:OR\s+ALTER\s+)?PROC(?:EDURE)?\s+(?:\[[^\]]+\]|[A-Za-z_][A-Za-z0-9_]*)\s*\.\s*\[?)' +
    [Regex]::Escape($ObjectName) + '(\]?)(?![A-Za-z0-9_])'
}

# --- Pre-flight -------------------------------------------------------
foreach ($r in $repos) {
    $rp = Join-Path $Root $r
    if (-not (Test-Path $rp)) { throw "Repo not found: $rp" }
    if (-not $AllowDirtyTree) {
        $dirty = @(& git -C $rp status --porcelain)
        if ($dirty) {
            throw "Working tree for $r is not clean ($($dirty.Count) entries). Commit or stash first, or pass -AllowDirtyTree."
        }
    }
}

# Verify every file exists, no destination collides, and the CREATE statement
# is actually matchable - all BEFORE touching anything.
$unmatched = @()
foreach ($m in $map) {
    $src = Join-Path (Join-Path $Root $m.Repo) $m.File
    if (-not (Test-Path -LiteralPath $src)) { throw "Missing source file: $src" }
    $dstLeaf = 'DEPREC_' + (Split-Path -Leaf $m.File)
    $dst     = Join-Path (Split-Path -Parent $src) $dstLeaf
    if (Test-Path -LiteralPath $dst) { throw "Destination already exists: $dst" }

    $text = [System.IO.File]::ReadAllText($src)
    $rx   = [Regex]::new((Get-CreatePattern $m.OldName),
                         [Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $n    = $rx.Matches($text).Count
    if ($n -ne 1) { $unmatched += "{0}: {1} match(es)" -f $m.OldName, $n }
}
# No two rows may point at the same file (duplicate basenames across schemas).
$dupPaths = $map | Group-Object { $_.Repo + '|' + $_.File } | Where-Object Count -gt 1
if ($dupPaths) {
    $dupPaths | ForEach-Object { Write-Host ("  duplicate target path: " + $_.Name) -ForegroundColor Red }
    throw "$($dupPaths.Count) file path(s) are mapped more than once. Nothing changed."
}

# Every Build Include entry must exist before we rename anything.
$missingInc = @()
foreach ($r in $repos) {
    $projRel = ($map | Where-Object Repo -eq $r | Select-Object -First 1).Proj
    $xmlPre  = [System.IO.File]::ReadAllText((Join-Path (Join-Path $Root $r) $projRel))
    foreach ($m in ($map | Where-Object Repo -eq $r)) {
        if (-not $xmlPre.Contains('Include="' + $m.OldInc + '"')) { $missingInc += "$r : $($m.OldInc)" }
    }
}
if ($missingInc) {
    $missingInc | ForEach-Object { Write-Host "  missing Include: $_" -ForegroundColor Red }
    throw "$($missingInc.Count) Build Include entr(ies) not found. Nothing changed."
}

if ($unmatched) {
    $unmatched | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    throw "$($unmatched.Count) file(s) do not have exactly one matchable CREATE statement. Nothing changed."
}
Write-Host "Pre-flight OK: $($map.Count) procedures across $($repos.Count) repo(s); all CREATE statements matchable." -ForegroundColor Green

# --- 1 & 2: move files and rewrite CREATE statements ------------------
$moved = 0
foreach ($m in $map) {
    $repoPath = Join-Path $Root $m.Repo
    $src      = Join-Path $repoPath $m.File
    $dstLeaf  = 'DEPREC_' + (Split-Path -Leaf $m.File)
    $dst      = Join-Path (Split-Path -Parent $src) $dstLeaf

    if ($PSCmdlet.ShouldProcess($m.File, "git mv -> $dstLeaf and rewrite CREATE")) {
        & git -C $repoPath mv -- $m.File (Join-Path (Split-Path -Parent $m.File) $dstLeaf)
        if ($LASTEXITCODE -ne 0) { throw "git mv failed for $($m.File)" }

        $text = [System.IO.File]::ReadAllText($dst)
        $rx   = [Regex]::new((Get-CreatePattern $m.OldName),
                             [Text.RegularExpressions.RegexOptions]::IgnoreCase)
        $new  = $rx.Replace($text, ('${1}' + $m.NewName + '${2}'), 1)   # first match only
        if ($new -eq $text) { throw "CREATE statement not rewritten in $dst - check the definition by hand." }

        [System.IO.File]::WriteAllText($dst, $new, $utf8Bom)
        $moved++
    }
}

# --- 3: update the .sqlproj Build Include entries ---------------------
foreach ($r in $repos) {
    $projRel = ($map | Where-Object Repo -eq $r | Select-Object -First 1).Proj
    $projAbs = Join-Path (Join-Path $Root $r) $projRel

    if ($PSCmdlet.ShouldProcess($projRel, 'update Build Include entries')) {
        $xml = [System.IO.File]::ReadAllText($projAbs)
        $n = 0
        foreach ($m in ($map | Where-Object Repo -eq $r)) {
            $old = 'Include="' + $m.OldInc + '"'
            $new = 'Include="' + $m.NewInc + '"'
            if ($xml.Contains($old)) { $xml = $xml.Replace($old, $new); $n++ }
            else { Write-Warning "Include entry not found for $($m.OldName)" }
        }
        [System.IO.File]::WriteAllText($projAbs, $xml, $utf8Bom)
        Write-Host "$r : updated $n Build Include entries." -ForegroundColor Green
    }
}

Write-Host "`nDone. $moved file(s) renamed." -ForegroundColor Green
Write-Host "Review with:  git -C <repo> status  /  git -C <repo> diff --cached" -ForegroundColor Cyan
Write-Host "Then build the .sqlproj before committing." -ForegroundColor Cyan
