# Integra el Adaptive AI Engineering System en Claude de forma GLOBAL.
# Un solo comando:  .\install.ps1
# Tras ejecutarlo, Claude aplica estas reglas de ingenieria en TODOS tus proyectos.

$ErrorActionPreference = 'Stop'

# Ruta absoluta de este repo (fuente unica de las reglas), en formato con "/"
$repo = ($PSScriptRoot -replace '\\', '/')

# Config global de Claude del usuario
$claudeDir = Join-Path $env:USERPROFILE '.claude'
$globalMd  = Join-Path $claudeDir 'CLAUDE.md'
if (-not (Test-Path $claudeDir)) { New-Item -ItemType Directory -Force $claudeDir | Out-Null }

# Marcadores para un bloque idempotente (se puede reinstalar sin duplicar)
$begin = '<!-- BEGIN adaptive-ai-engineering-system -->'
$end   = '<!-- END adaptive-ai-engineering-system -->'

# El bloque importa las reglas SIEMPRE activas desde el repo.
# Las skills, playbooks y checklists se consultan bajo demanda desde el propio sistema.
$block = @"
$begin
# Adaptive AI Engineering System (reglas globales de ingenieria)

Actua como un ingeniero senior. El contexto siempre define la solucion: no apliques
SOLID, DDD, microservicios ni patrones por defecto, solo cuando el contexto lo justifique.
Antes de responder: entender -> analizar contexto -> evaluar complejidad -> solucion mas
simple -> justificar. Las reglas de calidad y seguridad de codigo son obligatorias siempre.

Sistema completo (skills, playbooks, knowledge, checklists) en: $repo

@$repo/core/principles.md
@$repo/core/decision-rules.md
@$repo/core/code-quality.md
@$repo/anti-patterns/anti-patterns.md
$end
"@

# Lee el contenido actual (si existe) y elimina cualquier bloque previo del sistema
if (Test-Path $globalMd) {
    $content = Get-Content $globalMd -Raw
    if ($null -eq $content) { $content = '' }
    $pattern = "(?s)" + [regex]::Escape($begin) + ".*?" + [regex]::Escape($end) + "\r?\n?"
    $content = [regex]::Replace($content, $pattern, '')
    $content = $content.TrimEnd()
    if ($content.Length -gt 0) { $content += "`n`n" }
} else {
    $content = ''
}

# Escribe en UTF-8 sin BOM para que Claude lo lea limpio
$final = $content + $block + "`n"
[System.IO.File]::WriteAllText($globalMd, $final, (New-Object System.Text.UTF8Encoding($false)))

# Instala las 12 skills en ~/.claude/skills/ para que Claude Code las descubra
# automaticamente, SIN necesitar el comando /plugin (que no esta en todos los entornos).
$skillsSrc = Join-Path $PSScriptRoot 'skills'
$skillsDst = Join-Path $claudeDir 'skills'
$skillCount = 0
if (Test-Path $skillsSrc) {
    if (-not (Test-Path $skillsDst)) { New-Item -ItemType Directory -Force $skillsDst | Out-Null }
    Get-ChildItem -Path $skillsSrc -Directory | ForEach-Object {
        if (Test-Path (Join-Path $_.FullName 'SKILL.md')) {
            $dest = Join-Path $skillsDst $_.Name
            if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
            Copy-Item -Recurse -Force $_.FullName $dest
            $skillCount++
        }
    }
}

# Soporte de desinstalacion: si se pasa -Uninstall, revierte reglas y skills
if ($args -contains '-Uninstall') {
    [System.IO.File]::WriteAllText($globalMd, ($content.TrimEnd() + "`n"), (New-Object System.Text.UTF8Encoding($false)))
    Get-ChildItem -Path $skillsSrc -Directory | ForEach-Object {
        $dest = Join-Path $skillsDst $_.Name
        if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    }
    Write-Host "Desinstalado: bloque y skills removidos." -ForegroundColor Yellow
    return
}

Write-Host ""
Write-Host "OK  Adaptive AI Engineering System integrado en Claude (global)." -ForegroundColor Green
Write-Host "    Reglas:  $globalMd"
Write-Host "    Skills:  $skillsDst  ($skillCount skills)"
Write-Host "    Fuente:  $repo"
Write-Host ""
Write-Host "Claude aplica las reglas y descubre las skills en TODOS tus proyectos." -ForegroundColor Cyan
Write-Host "No requiere el comando /plugin. Para desinstalar:  .\install.ps1 -Uninstall"
