# Refresh the GitHub folder from the development workspace.
# Run from this folder:  .\sync-source.ps1
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$root = Resolve-Path (Join-Path $here '..\..')

Copy-Item -Recurse -Force (Join-Path $root 'src\*') (Join-Path $here 'src\')
Copy-Item -Recurse -Force (Join-Path $root 'tests\*') (Join-Path $here 'tests\')
Copy-Item -Force (Join-Path $root 'console\main.cpp') (Join-Path $here 'console\')
Copy-Item -Force (Join-Path $root 'console\CMakeLists.txt') (Join-Path $here 'console\')
Copy-Item -Force (Join-Path $root 'CMakeLists.txt') (Join-Path $here 'CMakeLists.txt')

$docs = @('ARCHITECTURE.md','PROTOCOL.md','DIAGNOSTICS.md','PACKAGE.md','TEST-PLAN.md','SECURITY.md','GLOSSARY.md')
foreach ($d in $docs) {
    Copy-Item -Force (Join-Path $root "docs\$d") (Join-Path $here "docs\$d")
}

Write-Host "Synced source and public docs from $root"
Write-Host "Review: git status"
