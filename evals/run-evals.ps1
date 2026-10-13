param(
    [ValidateSet("baseline", "skill", "both")]
    [string]$Condition = "both",
    [string]$CaseId = "C1,C2,C3,C4,C5,C6,C7,C8",
    [string]$Model = "gpt-6-luna",
    [ValidateSet("minimal", "low", "medium", "high", "xhigh")]
    [string]$Reasoning = "low",
    [ValidatePattern("^[a-z0-9.-]+$")]
    [string]$RunLabel = "v0.1",
    [string]$CodexExe = "",
    [string]$GitExe = "",
    [string]$PythonExe = "",
    [switch]$ImplicitSkill,
    [switch]$DiscoverHostSkills,
    [switch]$ValidateOnly
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$skillRoot = Join-Path $repoRoot "maintainable-coding"
$fixtureRoot = Join-Path $PSScriptRoot "fixtures\task-service"
$runRoot = Join-Path $PSScriptRoot ".runs\$RunLabel"
$artifactRoot = Join-Path $PSScriptRoot "artifacts\$RunLabel"
$caseIds = $CaseId -split ","
if (-not $caseIds -or ($caseIds | Where-Object { $_ -notmatch "^(C[1-8]|N[12])$" })) {
    throw "CaseId must be a comma-separated list containing C1-C8 or N1-N2"
}

function Resolve-Executable([string]$Value, [string]$Name, [string[]]$Fallbacks) {
    if ($Value) {
        if (-not (Test-Path -LiteralPath $Value)) { throw "$Name not found: $Value" }
        return (Resolve-Path -LiteralPath $Value).Path
    }
    $command = Get-Command $Name -ErrorAction SilentlyContinue
    if ($command) { return $command.Source }
    foreach ($candidate in $Fallbacks) {
        if (Test-Path -LiteralPath $candidate) { return (Resolve-Path -LiteralPath $candidate).Path }
    }
    throw "$Name executable not found"
}

$CodexExe = Resolve-Executable $CodexExe "codex.exe" @()
$GitExe = Resolve-Executable $GitExe "git.exe" @(
    (Join-Path $env:USERPROFILE ".cache\codex-runtimes\codex-primary-runtime\dependencies\native\git\cmd\git.exe")
)
$PythonExe = Resolve-Executable $PythonExe "python.exe" @(
    (Join-Path $env:USERPROFILE ".cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe")
)

foreach ($id in $caseIds) {
    $promptPath = Join-Path $PSScriptRoot "prompts\$id.md"
    if (-not (Test-Path -LiteralPath $promptPath)) { throw "Missing prompt: $promptPath" }
}
foreach ($required in @(
    (Join-Path $skillRoot "SKILL.md"),
    (Join-Path $skillRoot "references\new-project.md"),
    (Join-Path $skillRoot "references\change-review.md"),
    (Join-Path $fixtureRoot "pyproject.toml")
)) {
    if (-not (Test-Path -LiteralPath $required)) { throw "Missing evaluation input: $required" }
}
if ($ValidateOnly) {
    Write-Output "Evaluation inputs and executables are valid."
    exit 0
}

$conditions = if ($Condition -eq "both") { @("baseline", "skill") } else { @($Condition) }

foreach ($currentCondition in $conditions) {
    foreach ($id in $caseIds) {
        $workPath = Join-Path $runRoot "$currentCondition\$id"
        $outputPath = Join-Path $artifactRoot "$currentCondition\$id"
        if ((Test-Path -LiteralPath $workPath) -or (Test-Path -LiteralPath $outputPath)) {
            throw "Refusing to overwrite an existing run: $currentCondition/$id"
        }
        New-Item -ItemType Directory -Path $workPath -Force | Out-Null
        New-Item -ItemType Directory -Path $outputPath -Force | Out-Null

        if ($id -ne "C1") {
            Copy-Item -Path (Join-Path $fixtureRoot "*") -Destination $workPath -Recurse
        }
        [IO.File]::WriteAllText((Join-Path $workPath ".gitignore"), ".codex/`r`n__pycache__/`r`n*.py[cod]`r`n.pytest_cache/`r`n")
        if ($currentCondition -eq "skill") {
            $installedSkill = Join-Path $workPath ".codex\skills\maintainable-coding"
            New-Item -ItemType Directory -Path (Split-Path -Parent $installedSkill) -Force | Out-Null
            Copy-Item -LiteralPath $skillRoot -Destination $installedSkill -Recurse
        }

        & $GitExe -C $workPath init -q
        & $GitExe -C $workPath config user.name "ClearCode Eval"
        & $GitExe -C $workPath config user.email "eval@localhost"
        & $GitExe -C $workPath add --all
        & $GitExe -C $workPath commit -q -m "Evaluation fixture"

        $request = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot "prompts\$id.md")
        $skillInstruction = if ($currentCondition -eq "skill" -and -not $ImplicitSkill) {
            "Read .codex/skills/maintainable-coding/SKILL.md completely, then use `$maintainable-coding to complete this request. `n`n"
        } else { "" }
        $prompt = "$skillInstruction$request`n`nWork only in the current repository. Do not commit. Complete the request and run relevant checks."
        $tracePath = Join-Path $outputPath "trace.jsonl"
        $stderrPath = Join-Path $outputPath "stderr.log"
        $finalPath = Join-Path $outputPath "final.md"
        $discoveryArgs = if ($DiscoverHostSkills) { @() } else { @("--enable", "skip_host_skill_discovery") }
        $codexArgs = @(
            "--approve-for-me", "exec", "--ephemeral", "--ignore-user-config", "--model", $Model,
            "-c", "model_reasoning_effort=`"$Reasoning`"", "--sandbox", "workspace-write",
            "--json"
        ) + $discoveryArgs + @(
            "--disable", "plugins", "--disable", "apps",
            "--disable", "computer_use", "--disable", "browser_use",
            "--disable", "in_app_browser", "--disable", "image_generation",
            "--disable", "multi_agent", "--disable", "hooks",
            "-o", $finalPath, "-C", $workPath, $prompt
        )

        $savedPath = $env:PATH
        if ($id -eq "C6") {
            $env:PATH = (($savedPath -split ";") | Where-Object { $_ -and $_ -notmatch "(?i)anaconda" }) -join ";"
        }
        $savedErrorActionPreference = $ErrorActionPreference
        $timer = [Diagnostics.Stopwatch]::StartNew()
        try {
            $ErrorActionPreference = "Continue"
            & $CodexExe @codexArgs 2> $stderrPath | Set-Content -LiteralPath $tracePath -Encoding UTF8
            $codexExit = $LASTEXITCODE
        } finally {
            $timer.Stop()
            $env:PATH = $savedPath
            $ErrorActionPreference = $savedErrorActionPreference
        }

        & $GitExe -C $workPath add -N . 2>$null
        & $GitExe -C $workPath diff -- . ":!.codex" | Set-Content -LiteralPath (Join-Path $outputPath "diff.patch") -Encoding UTF8

        $testExit = $null
        $testState = "not_run"
        $testsPath = Join-Path $workPath "tests"
        if (Test-Path -LiteralPath $testsPath) {
            $savedPythonPath = $env:PYTHONPATH
            $sourcePath = Join-Path $workPath "src"
            $env:PYTHONPATH = if (Test-Path -LiteralPath $sourcePath) { $sourcePath } else { $workPath }
            try {
                $ErrorActionPreference = "Continue"
                $testOutput = & $PythonExe -m unittest discover -s $testsPath -v 2>&1
                $testExit = $LASTEXITCODE
                $testState = if ($testExit -eq 0) { "passed" } else { "failed" }
                $testOutput | Set-Content -LiteralPath (Join-Path $outputPath "tests.txt") -Encoding UTF8
            } finally {
                $env:PYTHONPATH = $savedPythonPath
                $ErrorActionPreference = $savedErrorActionPreference
            }
        }

        $usage = $null
        foreach ($line in Get-Content -LiteralPath $tracePath) {
            try {
                $event = $line | ConvertFrom-Json
                if ($event.usage) { $usage = $event.usage }
            } catch { }
        }
        [ordered]@{
            case = $id
            condition = $currentCondition
            model = $Model
            reasoning = $Reasoning
            codex_version = (& $CodexExe --version)
            codex_exit = $codexExit
            elapsed_seconds = [Math]::Round($timer.Elapsed.TotalSeconds, 2)
            fixture_tests = $testState
            fixture_test_exit = $testExit
            usage = $usage
        } | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $outputPath "metadata.json") -Encoding UTF8

        Write-Output "$currentCondition/$id completed: codex=$codexExit tests=$testState seconds=$([Math]::Round($timer.Elapsed.TotalSeconds, 1))"
    }
}
