param(
    [switch] $Codex,
    [switch] $Claude,
    [switch] $Cursor,
    [switch] $Kiro,
    [switch] $Cline,
    [switch] $Copilot,
    [switch] $Windsurf,
    [switch] $Yes
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$InstallHome = if ($env:ARMARIUS_INSTALL_HOME) { $env:ARMARIUS_INSTALL_HOME } else { $HOME }

function Invoke-Python {
    param([string[]] $PythonArgs)
    foreach ($command in @("python3", "python", "py")) {
        if (Get-Command $command -ErrorAction SilentlyContinue) {
            $argv = $PythonArgs
            if ($command -eq "py") {
                $argv = @("-3") + $PythonArgs
            }
            & $command @argv
            if ($LASTEXITCODE -ne 0) {
                throw "Python command failed: $command"
            }
            return
        }
    }
    throw "Armarius installer needs Python 3, but no Python launcher was found on PATH."
}

function Install-One {
    param(
        [string] $Harness,
        [string] $RootDir,
        [string] $RenderedSkillDir
    )

    $SkillName = Split-Path -Leaf $RenderedSkillDir
    $DestDir = Join-Path $RootDir $SkillName
    $StageDir = Join-Path $RootDir ".$SkillName.new.$PID"
    $BackupDir = Join-Path $RootDir ".$SkillName.previous.$PID"

    New-Item -ItemType Directory -Force -Path $RootDir | Out-Null

    if ((Test-Path $DestDir) -and -not $Yes) {
        $reply = Read-Host "Replace existing $Harness install at $DestDir? [y/N]"
        if ($reply -notin @("y", "Y", "yes", "YES")) {
            Write-Host "Skipped $Harness."
            return
        }
    }

    if (Test-Path $StageDir) { Remove-Item -Recurse -Force $StageDir }
    if (Test-Path $BackupDir) { Remove-Item -Recurse -Force $BackupDir }
    Copy-Item -Recurse $RenderedSkillDir $StageDir
    if (Test-Path $DestDir) {
        Move-Item $DestDir $BackupDir
    }
    try {
        Move-Item $StageDir $DestDir
        if (Test-Path $BackupDir) { Remove-Item -Recurse -Force $BackupDir }
        Write-Host "Installed ${Harness}: $DestDir"
    } catch {
        if (Test-Path $BackupDir) { Move-Item $BackupDir $DestDir }
        throw "Could not install $Harness; restored the previous install."
    }
}

$Target = "codex"
if ($Claude) { $Target = "claude" }
if ($Cursor) { $Target = "cursor" }
if ($Kiro) { $Target = "kiro" }
if ($Cline) { $Target = "cline" }
if ($Copilot) { $Target = "copilot" }
if ($Windsurf) { $Target = "windsurf" }
if ($Codex) { $Target = "codex" }

$RenderRoot = Join-Path ([System.IO.Path]::GetTempPath()) "armarius-render.$PID"
New-Item -ItemType Directory -Force -Path $RenderRoot | Out-Null
try {
    $RenderOutput = Invoke-Python @("$RepoRoot/scripts/render_skill.py", "--repo-root", $RepoRoot, "--output-dir", $RenderRoot)
    $RenderedSkillDir = ($RenderOutput | Select-Object -Last 1).ToString().Trim()
    switch ($Target) {
        "codex" { Install-One "Codex" (Join-Path $InstallHome ".agents/skills") $RenderedSkillDir }
        "claude" { Install-One "Claude" (Join-Path $InstallHome ".claude/skills") $RenderedSkillDir }
        "cursor" { Install-One "Cursor" (Join-Path $InstallHome ".cursor/skills") $RenderedSkillDir }
        "kiro" { Install-One "Kiro" (Join-Path $InstallHome ".kiro/skills") $RenderedSkillDir }
        "cline" { Install-One "Cline" (Join-Path $InstallHome ".cline/skills") $RenderedSkillDir }
        "copilot" { Install-One "GitHub Copilot" (Join-Path $InstallHome ".copilot/skills") $RenderedSkillDir }
        "windsurf" { Install-One "Windsurf" (Join-Path $InstallHome ".codeium/windsurf/skills") $RenderedSkillDir }
    }
} finally {
    if (Test-Path $RenderRoot) { Remove-Item -Recurse -Force $RenderRoot }
}
