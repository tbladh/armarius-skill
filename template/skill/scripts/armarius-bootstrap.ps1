$ErrorActionPreference = "Stop"
$ScriptPath = Join-Path $PSScriptRoot "armarius_bootstrap.py"

foreach ($command in @("python3", "python", "py")) {
    if (Get-Command $command -ErrorAction SilentlyContinue) {
        if ($command -eq "py") {
            & $command @("-3", $ScriptPath) @args
        } else {
            & $command $ScriptPath @args
        }
        exit $LASTEXITCODE
    }
}

[Console]::Error.WriteLine("Armarius needs Python 3, but no python3, python, or py launcher was found on PATH.")
exit 127
