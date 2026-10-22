param(
    [string]$Root = (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path))
)

$ErrorActionPreference = 'Stop'

$Libs = Join-Path $Root 'libs'

$Repos = @(
    'charm-a11y','charm-banner','charm-charts','charm-cli','charm-color','charm-command','charm-config','charm-devtools','charm-dialog','charm-diff','charm-form','charm-fuzzy','charm-gallery','charm-i18n','charm-image','charm-input','charm-json','charm-keys','charm-layout','charm-lint','charm-logs','charm-mock','charm-nav','charm-notify','charm-palette','charm-panes','charm-progress','charm-record','charm-router','charm-spinner','charm-store','charm-table-cli','charm-test','charm-themes','charm-toast','charm-update','charm-wizard'
)

Write-Host "==> Charm Suite bootstrap"
Write-Host "    root: $Root"
Write-Host "    libs: $Libs"
Write-Host

New-Item -ItemType Directory -Force -Path $Libs | Out-Null

foreach ($repo in $Repos) {
    $target = Join-Path $Libs $repo
    if (Test-Path (Join-Path $target '.git')) {
        Write-Host "  [skip] $repo (already cloned)"
    } else {
        Write-Host "  [clone] $repo"
        git clone --quiet "https://github.com/junhinhow/$repo.git" $target
    }
}

Write-Host
Write-Host "==> Generating go.work"
$lines = @('go 1.25.8', '', 'use (')
foreach ($repo in $Repos) { $lines += "    .\libs\$repo" }
$lines += ')'
$goWork = Join-Path $Root 'go.work'
[System.IO.File]::WriteAllText($goWork, ($lines -join "`n"), (New-Object System.Text.UTF8Encoding $false))

Write-Host "==> go work sync"
Push-Location $Root
try { go work sync } finally { Pop-Location }

Write-Host
Write-Host "==> Done. Next steps:"
Write-Host "    cd $Root"
Write-Host "    go build ./libs/...   # build every lib"
Write-Host "    (cd libs/charm-diff; go test ./...)   # run one lib's tests"