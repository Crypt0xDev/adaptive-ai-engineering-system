<#
.SYNOPSIS
  Integra el Adaptive AI Engineering System en Claude.

.DESCRIPTION
  GLOBAL:   integra reglas en ~/.claude/CLAUDE.md via imports al repo (fuente unica)
            y copia las skills a ~/.claude/skills/.
  PROYECTO: copia reglas + skills dentro de <Path>/.claude/ y escribe <Path>/CLAUDE.md
            con imports RELATIVOS, para que el proyecto sea autocontenido y portable
            (se puede commitear y compartir con el equipo, sin depender de rutas absolutas).

  Compatible con Windows PowerShell 5.1 y PowerShell 7+ (Windows, Linux, macOS).

.EXAMPLE
  .\install.ps1                       # Instalacion global
  .\install.ps1 -Project              # Instalacion en el proyecto actual
  .\install.ps1 -Project C:\repo\app  # Instalacion en un proyecto concreto
  .\install.ps1 -Uninstall            # Desinstala la version global
  .\install.ps1 -Project -Uninstall   # Desinstala del proyecto actual
#>
[CmdletBinding()]
param(
    # Activa el modo por proyecto (en vez del global).
    [switch] $Project,

    # Ruta del proyecto (solo con -Project). Por defecto, el directorio actual.
    [Parameter(Position = 0)]
    [string] $Path,

    # Revierte la instalacion (global o de proyecto, segun -Project).
    [switch] $Uninstall
)

$ErrorActionPreference = 'Stop'

# Ruta absoluta de este repo (fuente de las reglas), en formato con "/"
$repo = ($PSScriptRoot -replace '\\', '/')

$begin = '<!-- BEGIN adaptive-ai-engineering-system -->'
$end   = '<!-- END adaptive-ai-engineering-system -->'

# Archivos de reglas que se copian en modo proyecto
$ruleFiles = @(
    'core/principles.md',
    'core/decision-rules.md',
    'core/code-quality.md',
    'core/best-practices.md',
    'anti-patterns/anti-patterns.md'
)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Elimina cualquier bloque previo del sistema de un archivo markdown (idempotente).
function Remove-Block([string] $File) {
    if (-not (Test-Path $File)) { return '' }
    $content = Get-Content $File -Raw
    if ($null -eq $content) { $content = '' }
    $pattern = "(?s)" + [regex]::Escape($begin) + ".*?" + [regex]::Escape($end) + "\r?\n?"
    $content = [regex]::Replace($content, $pattern, '')
    return $content.TrimEnd()
}

# Escribe texto en UTF-8 sin BOM para que Claude lo lea limpio.
function Write-Utf8NoBom([string] $File, [string] $Text) {
    $dir = Split-Path -Parent $File
    if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
    [System.IO.File]::WriteAllText($File, $Text, (New-Object System.Text.UTF8Encoding($false)))
}

# Copia las skills (dirs con SKILL.md) desde el repo hacia $Dest. Devuelve el conteo.
function Copy-Skills([string] $Dest) {
    $skillsSrc = Join-Path $PSScriptRoot 'skills'
    $count = 0
    if (Test-Path $skillsSrc) {
        if (-not (Test-Path $Dest)) { New-Item -ItemType Directory -Force $Dest | Out-Null }
        Get-ChildItem -Path $skillsSrc -Directory | ForEach-Object {
            if (Test-Path (Join-Path $_.FullName 'SKILL.md')) {
                $d = Join-Path $Dest $_.Name
                if (Test-Path $d) { Remove-Item -Recurse -Force $d }
                Copy-Item -Recurse -Force $_.FullName $d
                $count++
            }
        }
    }
    return $count
}

# ---------------------------------------------------------------------------
# MODO PROYECTO
# ---------------------------------------------------------------------------
if ($Project) {
    $target = if ($Path) { $Path } else { (Get-Location).Path }
    if (-not (Test-Path $target)) { throw "No existe el directorio destino: $target" }
    $target = (Resolve-Path $target).Path

    $projectMd = Join-Path $target 'CLAUDE.md'
    $claudeDir = Join-Path $target '.claude'
    $rulesDst  = Join-Path $claudeDir 'adaptive-engineering'
    $skillsDst = Join-Path $claudeDir 'skills'

    if ($Uninstall) {
        $content = Remove-Block $projectMd
        if ($content.Length -gt 0) { Write-Utf8NoBom $projectMd ($content + "`n") }
        elseif (Test-Path $projectMd) { Remove-Item -Force $projectMd }
        if (Test-Path $rulesDst) { Remove-Item -Recurse -Force $rulesDst }
        Get-ChildItem -Path (Join-Path $PSScriptRoot 'skills') -Directory | ForEach-Object {
            $d = Join-Path $skillsDst $_.Name
            if (Test-Path $d) { Remove-Item -Recurse -Force $d }
        }
        Write-Host "Desinstalado del proyecto: $target" -ForegroundColor Yellow
        return
    }

    # Copia las reglas dentro del proyecto (autocontenido)
    foreach ($f in $ruleFiles) {
        $src = Join-Path $PSScriptRoot ($f -replace '/', [IO.Path]::DirectorySeparatorChar)
        $dst = Join-Path $rulesDst   ($f -replace '/', [IO.Path]::DirectorySeparatorChar)
        $dstDir = Split-Path -Parent $dst
        if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory -Force $dstDir | Out-Null }
        Copy-Item -Force $src $dst
    }
    $skillCount = Copy-Skills $skillsDst

    $block = @"
$begin
# Adaptive AI Engineering System (reglas de este proyecto)

Actua como un ingeniero senior. El contexto siempre define la solucion: no apliques
SOLID, DDD, microservicios ni patrones por defecto, solo cuando el contexto lo justifique.
Antes de responder: entender -> analizar contexto -> evaluar complejidad -> solucion mas
simple -> justificar. Las reglas de calidad y seguridad de codigo son obligatorias siempre.

Reglas y skills copiadas en .claude/ (proyecto autocontenido y portable).

@.claude/adaptive-engineering/core/principles.md
@.claude/adaptive-engineering/core/decision-rules.md
@.claude/adaptive-engineering/core/code-quality.md
@.claude/adaptive-engineering/anti-patterns/anti-patterns.md
$end
"@

    $content = Remove-Block $projectMd
    if ($content.Length -gt 0) { $content += "`n`n" }
    Write-Utf8NoBom $projectMd ($content + $block + "`n")

    Write-Host ""
    Write-Host "OK  Adaptive AI Engineering System integrado en el PROYECTO." -ForegroundColor Green
    Write-Host "    Proyecto: $target"
    Write-Host "    Reglas:   $projectMd  (+ $rulesDst)"
    Write-Host "    Skills:   $skillsDst  ($skillCount skills)"
    Write-Host ""
    Write-Host "El proyecto es autocontenido: podes commitear CLAUDE.md y .claude/ y compartirlo." -ForegroundColor Cyan
    Write-Host "Para desinstalar:  .\install.ps1 -Project -Path `"$target`" -Uninstall"
    return
}

# ---------------------------------------------------------------------------
# MODO GLOBAL
# ---------------------------------------------------------------------------
$claudeDir = Join-Path ([Environment]::GetFolderPath('UserProfile')) '.claude'
$globalMd  = Join-Path $claudeDir 'CLAUDE.md'
$skillsDst = Join-Path $claudeDir 'skills'
if (-not (Test-Path $claudeDir)) { New-Item -ItemType Directory -Force $claudeDir | Out-Null }

if ($Uninstall) {
    $content = Remove-Block $globalMd
    Write-Utf8NoBom $globalMd ($content.TrimEnd() + "`n")
    Get-ChildItem -Path (Join-Path $PSScriptRoot 'skills') -Directory | ForEach-Object {
        $d = Join-Path $skillsDst $_.Name
        if (Test-Path $d) { Remove-Item -Recurse -Force $d }
    }
    Write-Host "Desinstalado (global): bloque y skills removidos." -ForegroundColor Yellow
    return
}

# Instala las 12 skills en ~/.claude/skills/ para que Claude Code las descubra
# automaticamente, SIN necesitar el comando /plugin.
$skillCount = Copy-Skills $skillsDst

# El bloque importa las reglas SIEMPRE activas desde el repo (fuente unica).
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

$content = Remove-Block $globalMd
if ($content.Length -gt 0) { $content += "`n`n" }
Write-Utf8NoBom $globalMd ($content + $block + "`n")

Write-Host ""
Write-Host "OK  Adaptive AI Engineering System integrado en Claude (global)." -ForegroundColor Green
Write-Host "    Reglas:  $globalMd"
Write-Host "    Skills:  $skillsDst  ($skillCount skills)"
Write-Host "    Fuente:  $repo"
Write-Host ""
Write-Host "Claude aplica las reglas y descubre las skills en TODOS tus proyectos." -ForegroundColor Cyan
Write-Host "No requiere el comando /plugin. Para desinstalar:  .\install.ps1 -Uninstall"
