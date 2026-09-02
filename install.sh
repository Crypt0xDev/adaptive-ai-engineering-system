#!/usr/bin/env bash
# Integra el Adaptive AI Engineering System en Claude.
#
# Uso:
#   ./install.sh                      Instalacion GLOBAL (aplica en todos tus proyectos)
#   ./install.sh --project [DIR]      Instalacion POR PROYECTO (self-contained, portable)
#   ./install.sh --uninstall          Desinstala la version global
#   ./install.sh --project [DIR] --uninstall   Desinstala del proyecto
#   ./install.sh --help               Muestra esta ayuda
#
# GLOBAL:  integra reglas en ~/.claude/CLAUDE.md via imports al repo (fuente unica)
#          y copia las skills a ~/.claude/skills/.
# PROYECTO: copia reglas + skills dentro de <DIR>/.claude/ y escribe <DIR>/CLAUDE.md
#          con imports RELATIVOS, para que el proyecto sea autocontenido y portable
#          (se puede commitear y compartir con el equipo, sin depender de rutas absolutas).
#
# Compatible con Linux y macOS (bash 3.2+, herramientas POSIX).

set -euo pipefail

# Ruta absoluta de este repo (fuente de las reglas)
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

begin='<!-- BEGIN adaptive-ai-engineering-system -->'
end='<!-- END adaptive-ai-engineering-system -->'

# Archivos de reglas que se copian en modo proyecto (rutas relativas al repo)
rule_files=(
  "core/principles.md"
  "core/decision-rules.md"
  "core/code-quality.md"
  "core/best-practices.md"
  "anti-patterns/anti-patterns.md"
)

print_help() {
  sed -n '2,20p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

# Elimina cualquier bloque previo del sistema de un archivo markdown (idempotente).
# $1 = ruta del archivo.
strip_block() {
  local file="$1" tmp
  [ -f "$file" ] || { : > "$file"; return; }
  tmp="$(mktemp)"
  awk -v b="$begin" -v e="$end" '
    $0==b {skip=1}
    skip!=1 {print}
    $0==e {skip=0}
  ' "$file" | sed -e 's/[[:space:]]*$//' > "$tmp"
  # Quita lineas en blanco finales
  awk 'NF{p=NR} {a[NR]=$0} END{for(i=1;i<=p;i++)print a[i]}' "$tmp" > "$file"
  rm -f "$tmp"
}

# Copia las skills (dirs con SKILL.md) desde el repo hacia $1. Devuelve el conteo por stdout.
copy_skills() {
  local dst="$1" count=0 d name
  mkdir -p "$dst"
  for d in "$repo"/skills/*/; do
    [ -f "$d/SKILL.md" ] || continue
    name="$(basename "$d")"
    rm -rf "${dst:?}/$name"
    cp -R "$d" "$dst/$name"
    count=$((count + 1))
  done
  echo "$count"
}

# ---------------------------------------------------------------------------
# Parseo de argumentos
# ---------------------------------------------------------------------------
mode="global"
uninstall=0
target=""

while [ $# -gt 0 ]; do
  case "$1" in
    --project)
      mode="project"
      # Ruta opcional a continuacion (si no empieza con "-")
      if [ -n "${2:-}" ] && [ "${2#-}" = "$2" ]; then
        target="$2"
        shift
      fi
      ;;
    --uninstall) uninstall=1 ;;
    -h|--help)   print_help; exit 0 ;;
    *) echo "Opcion desconocida: $1 (usa --help)" >&2; exit 1 ;;
  esac
  shift
done

# ---------------------------------------------------------------------------
# MODO PROYECTO
# ---------------------------------------------------------------------------
if [ "$mode" = "project" ]; then
  target="${target:-$PWD}"
  target="$(cd "$target" 2>/dev/null && pwd)" || { echo "No existe el directorio destino: $target" >&2; exit 1; }

  project_md="$target/CLAUDE.md"
  claude_dir="$target/.claude"
  rules_dst="$claude_dir/adaptive-engineering"
  skills_dst="$claude_dir/skills"

  if [ "$uninstall" -eq 1 ]; then
    strip_block "$project_md"
    rm -rf "$rules_dst"
    for d in "$repo"/skills/*/; do
      rm -rf "${skills_dst:?}/$(basename "$d")"
    done
    echo "Desinstalado del proyecto: $target"
    exit 0
  fi

  # Copia las reglas dentro del proyecto (autocontenido)
  mkdir -p "$rules_dst/core" "$rules_dst/anti-patterns"
  for f in "${rule_files[@]}"; do
    cp "$repo/$f" "$rules_dst/$f"
  done
  skill_count="$(copy_skills "$skills_dst")"

  # Escribe el bloque con imports RELATIVOS al proyecto
  strip_block "$project_md"
  {
    [ -s "$project_md" ] && echo ""
    cat <<EOF
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
EOF
  } >> "$project_md"

  echo ""
  echo "OK  Adaptive AI Engineering System integrado en el PROYECTO."
  echo "    Proyecto: $target"
  echo "    Reglas:   $project_md  (+ $rules_dst)"
  echo "    Skills:   $skills_dst  ($skill_count skills)"
  echo ""
  echo "El proyecto es autocontenido: podes commitear CLAUDE.md y .claude/ y compartirlo."
  echo "Para desinstalar:  ./install.sh --project \"$target\" --uninstall"
  exit 0
fi

# ---------------------------------------------------------------------------
# MODO GLOBAL
# ---------------------------------------------------------------------------
claude_dir="$HOME/.claude"
global_md="$claude_dir/CLAUDE.md"
skills_dst="$claude_dir/skills"
mkdir -p "$claude_dir"

if [ "$uninstall" -eq 1 ]; then
  strip_block "$global_md"
  for d in "$repo"/skills/*/; do
    rm -rf "${skills_dst:?}/$(basename "$d")"
  done
  echo "Desinstalado (global): bloque y skills removidos."
  exit 0
fi

# Instala las 12 skills en ~/.claude/skills/ para que Claude Code las descubra
# automaticamente, SIN necesitar el comando /plugin.
skill_count="$(copy_skills "$skills_dst")"

# Anade el bloque actualizado con imports ABSOLUTOS al repo (fuente unica)
strip_block "$global_md"
{
  [ -s "$global_md" ] && echo ""
  cat <<EOF
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
EOF
} >> "$global_md"

echo ""
echo "OK  Adaptive AI Engineering System integrado en Claude (global)."
echo "    Reglas:  $global_md"
echo "    Skills:  $skills_dst  ($skill_count skills)"
echo "    Fuente:  $repo"
echo ""
echo "Claude aplica las reglas y descubre las skills en TODOS tus proyectos."
echo "No requiere el comando /plugin. Para desinstalar:  ./install.sh --uninstall"
