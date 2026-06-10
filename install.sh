#!/usr/bin/env bash
# Integra el Adaptive AI Engineering System en Claude de forma GLOBAL.
# Un solo comando:  ./install.sh         (instala)
#                   ./install.sh --uninstall
# Tras ejecutarlo, Claude aplica estas reglas en TODOS tus proyectos.

set -euo pipefail

# Ruta absoluta de este repo (fuente unica de las reglas)
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

claude_dir="$HOME/.claude"
global_md="$claude_dir/CLAUDE.md"
mkdir -p "$claude_dir"
[ -f "$global_md" ] || touch "$global_md"

begin='<!-- BEGIN adaptive-ai-engineering-system -->'
end='<!-- END adaptive-ai-engineering-system -->'

# Elimina cualquier bloque previo del sistema (idempotente)
tmp="$(mktemp)"
awk -v b="$begin" -v e="$end" '
  $0==b {skip=1}
  skip!=1 {print}
  $0==e {skip=0}
' "$global_md" | sed -e 's/[[:space:]]*$//' > "$tmp"
# quita lineas en blanco finales
awk 'NF{p=NR} {a[NR]=$0} END{for(i=1;i<=p;i++)print a[i]}' "$tmp" > "$global_md"

skills_dst="$claude_dir/skills"

if [ "${1:-}" = "--uninstall" ]; then
  for d in "$repo"/skills/*/; do
    name="$(basename "$d")"
    rm -rf "$skills_dst/$name"
  done
  echo "Desinstalado: bloque y skills removidos."
  exit 0
fi

# Instala las 12 skills en ~/.claude/skills/ para que Claude Code las descubra
# automaticamente, SIN necesitar el comando /plugin.
skill_count=0
mkdir -p "$skills_dst"
for d in "$repo"/skills/*/; do
  [ -f "$d/SKILL.md" ] || continue
  name="$(basename "$d")"
  rm -rf "$skills_dst/$name"
  cp -R "$d" "$skills_dst/$name"
  skill_count=$((skill_count + 1))
done

# Anade el bloque actualizado
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
