# Sync refactor templates from umlspec-kit to local specify installation
# Usage: .\sync-local-templates.ps1 [target-project-path]

param(
    [string]$TargetProject = "."
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Get-Item $ScriptDir).Parent.Parent.FullName
$SpecifyHome = if ($env:SPECIFY_HOME) { $env:SPECIFY_HOME } else { ".specify" }

# Colors
$Header = @{ ForegroundColor = 'Cyan'; Object = '' }
$Success = @{ ForegroundColor = 'Green'; Object = '' }
$Warning = @{ ForegroundColor = 'Yellow'; Object = '' }
$Error = @{ ForegroundColor = 'Red'; Object = '' }

Write-Host "╔════════════════════════════════════════════════════════════╗" @Header
Write-Host "║  Sync Local Refactor Templates - Specify v2.0.0+          ║" @Header
Write-Host "╚════════════════════════════════════════════════════════════╝" @Header
Write-Host ""

# Step 1: Verify files exist in umlspec-kit
Write-Host "Step 1: Verify source templates" @Warning
$refactorTemplates = @(
    "templates/spec-template.refactor.md",
    "templates/plan-template.refactor.md",
    "templates/commands/spec.refactor.md",
    "templates/commands/plan.refactor.md"
)

foreach ($template in $refactorTemplates) {
    $fullPath = Join-Path $RepoRoot $template
    if (-not (Test-Path $fullPath)) {
        Write-Host "✗ Missing: $template" @Error
        exit 1
    }
}
Write-Host "✓ All refactor templates found in $RepoRoot" @Success
Write-Host ""

# Step 2: Navigate to target project
Write-Host "Step 2: Check target project" @Warning
if (-not (Test-Path $TargetProject)) {
    Write-Host "✗ Target project not found: $TargetProject" @Error
    exit 1
}
Push-Location $TargetProject
Write-Host "✓ Working in: $(Get-Location)" @Success
Write-Host ""

# Step 3: Create .specify directory structure if needed
Write-Host "Step 3: Setup .specify directory" @Warning
if (-not (Test-Path $SpecifyHome)) {
    New-Item -ItemType Directory -Path "$SpecifyHome/templates/commands" -Force | Out-Null
    Write-Host "✓ Created: $SpecifyHome" @Success
}
else {
    Write-Host "✓ Found existing: $SpecifyHome" @Success
}
Write-Host ""

# Step 4: Copy refactor templates
Write-Host "Step 4: Copy refactor templates" @Warning
$templates = @(
    @{ Source = "templates/spec-template.refactor.md"; Dest = "$SpecifyHome/templates/" },
    @{ Source = "templates/plan-template.refactor.md"; Dest = "$SpecifyHome/templates/" },
    @{ Source = "templates/commands/spec.refactor.md"; Dest = "$SpecifyHome/templates/commands/" },
    @{ Source = "templates/commands/plan.refactor.md"; Dest = "$SpecifyHome/templates/commands/" }
)

foreach ($file in $templates) {
    $sourcePath = Join-Path $RepoRoot $file.Source
    Copy-Item -Path $sourcePath -Destination $file.Dest -Force
}
Write-Host "✓ Synced 4 template files" @Success
Write-Host ""

# Step 5: Show summary
Write-Host "╔════════════════════════════════════════════════════════════╗" @Header
Write-Host "║  ✅ Sync Complete                                          ║" @Header
Write-Host "╚════════════════════════════════════════════════════════════╝" @Header
Write-Host ""

Write-Host "Templates synced to:" @Success
Write-Host "  📂 $(Join-Path (Get-Location) $SpecifyHome)/templates/"
Write-Host ""

Write-Host "Next steps:" @Success
Write-Host "  1️⃣  Create spec: specify spec refactor `"[description]`""
Write-Host "  2️⃣  Create plan: specify plan refactor"
Write-Host "  3️⃣  Create tasks: specify tasks refactor"
Write-Host ""

Write-Host "Documentation:" @Success
Write-Host "  📖 Setup Guide: $RepoRoot/docs/LOCAL_SETUP_GUIDE.md"
Write-Host "  📖 Validation: $RepoRoot/docs/refactor-template-validation-report.md"
Write-Host ""

Write-Host "AC-1~AC-4 Framework:" @Warning
Write-Host "  • AC-1: User Behavior Consistency (E2E Parity)"
Write-Host "  • AC-2: Performance Consistency (No Regression)"
Write-Host "  • AC-3: SLA Consistency (No Degradation)"
Write-Host "  • AC-4: Lossless Release (MTTR ≤ target)"
Write-Host ""

Pop-Location
