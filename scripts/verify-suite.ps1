[CmdletBinding()]
param(
    [string]$Root = (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)),
    [switch]$RunTests
)

$ErrorActionPreference = 'Stop'
$libs = Join-Path $Root 'libs'
if (-not (Test-Path $libs)) { throw "Diretório de módulos não encontrado: $libs" }

$oldGoWork = $env:GOWORK
$oldGoProxy = $env:GOPROXY
$oldGoNoSumDB = $env:GONOSUMDB
$env:GOWORK = 'off'
$env:GOPROXY = 'direct'
$env:GONOSUMDB = 'github.com/junhinhow/*'
$failures = [System.Collections.Generic.List[string]]::new()

try {
    $repos = Get-ChildItem $libs -Directory | Sort-Object Name
    if ($repos.Count -ne 37) {
        $failures.Add("esperados 37 módulos, encontrados $($repos.Count)")
    }

    foreach ($repo in $repos) {
        $path = $repo.FullName
        if (-not (Test-Path (Join-Path $path '.git'))) {
            $failures.Add("$($repo.Name): não é um repositório Git")
            continue
        }

        Push-Location $path
        try {
            $dirty = (git status --porcelain 2>&1) -join "`n"
            if ($dirty) { $failures.Add("$($repo.Name): working tree sujo") }

            $remote = git remote get-url origin 2>$null
            if (-not $remote) { $failures.Add("$($repo.Name): remote origin ausente") }

            $build = & go build ./... 2>&1
            if ($LASTEXITCODE -ne 0) {
                $failures.Add("$($repo.Name): go build falhou: $(($build | Select-Object -Last 1))")
                continue
            }

            if ($RunTests) {
                $vet = & go vet ./... 2>&1
                if ($LASTEXITCODE -ne 0) { $failures.Add("$($repo.Name): go vet falhou") }
                $test = & go test -race ./... 2>&1
                if ($LASTEXITCODE -ne 0) { $failures.Add("$($repo.Name): go test -race falhou") }
            }

            $formatted = (gofmt -l . 2>&1) -join ', '
            if ($formatted) { $failures.Add("$($repo.Name): arquivos não formatados: $formatted") }
            Write-Host "OK  $($repo.Name)"
        } finally {
            Pop-Location
        }
    }
} finally {
    if ($null -eq $oldGoWork) { Remove-Item Env:GOWORK -ErrorAction SilentlyContinue }
    else { $env:GOWORK = $oldGoWork }
    if ($null -eq $oldGoProxy) { Remove-Item Env:GOPROXY -ErrorAction SilentlyContinue }
    else { $env:GOPROXY = $oldGoProxy }
    if ($null -eq $oldGoNoSumDB) { Remove-Item Env:GONOSUMDB -ErrorAction SilentlyContinue }
    else { $env:GONOSUMDB = $oldGoNoSumDB }
}

if ($failures.Count -gt 0) {
    Write-Host "`nFalhas:" -ForegroundColor Red
    $failures | ForEach-Object { Write-Host "- $_" -ForegroundColor Red }
    exit 1
}

Write-Host "`nVerificação concluída: $($repos.Count) módulos OK." -ForegroundColor Green
