#!/usr/bin/env bash
# Valida la integridad del Adaptive AI Engineering System.
# Uso:  ./scripts/validate.sh
#
# Comprueba:
#   1. JSON valido en los manifiestos de plugin/marketplace.
#   2. Cada skill tiene SKILL.md con frontmatter (name + description).
#   3. Los archivos importados por los instaladores existen.
#   4. Smoke test: install.sh en modo proyecto crea e (des)instala bien.
#
# Compatible con Linux y macOS. No requiere dependencias mas alla de
# bash, awk y python3 (o node) para validar JSON.

set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo"

fail=0
pass() { printf '  \033[32mOK\033[0m   %s\n' "$1"; }
err()  { printf '  \033[31mFAIL\033[0m %s\n' "$1"; fail=1; }

# --- Selecciona un validador de JSON disponible ---
json_check() {
  if command -v python3 >/dev/null 2>&1; then
    python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "$1"
  elif command -v node >/dev/null 2>&1; then
    node -e 'JSON.parse(require("fs").readFileSync(process.argv[1],"utf8"))' "$1"
  else
    echo "No hay python3 ni node para validar JSON" >&2
    return 2
  fi
}

echo "1) Manifiestos JSON"
for f in .claude-plugin/plugin.json .claude-plugin/marketplace.json; do
  if [ -f "$f" ] && json_check "$f" 2>/dev/null; then pass "$f"; else err "$f (JSON invalido o ausente)"; fi
done

echo "2) Skills (SKILL.md + frontmatter)"
skill_total=0
for d in skills/*/; do
  [ -d "$d" ] || continue
  skill_total=$((skill_total + 1))
  name="$(basename "$d")"
  md="$d/SKILL.md"
  if [ ! -f "$md" ]; then err "$name: falta SKILL.md"; continue; fi
  # Frontmatter: debe empezar con '---' y contener name: y description:
  if [ "$(head -1 "$md")" != "---" ]; then err "$name: SKILL.md sin frontmatter"; continue; fi
  fm="$(awk 'NR>1 && $0=="---"{exit} NR>1{print}' "$md")"
  if printf '%s\n' "$fm" | grep -q '^name:' && printf '%s\n' "$fm" | grep -q '^description:'; then
    pass "$name"
  else
    err "$name: frontmatter incompleto (falta name/description)"
  fi
done
[ "$skill_total" -ge 1 ] || err "No se encontraron skills"

echo "3) Archivos importados por los instaladores"
for f in core/principles.md core/decision-rules.md core/code-quality.md \
         core/best-practices.md anti-patterns/anti-patterns.md; do
  if [ -f "$f" ]; then pass "$f"; else err "$f (referenciado por install.sh/install.ps1, no existe)"; fi
done

# Cuenta subdirectorios de $1 sin usar `ls` (evita SC2012 y nombres raros)
count_dirs() { find "$1" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' '; }

echo "4) Smoke test: install.sh --project"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
if bash install.sh --project "$tmp" >/dev/null 2>&1 \
   && [ -f "$tmp/CLAUDE.md" ] \
   && [ "$(count_dirs "$tmp/.claude/skills")" -eq "$skill_total" ] \
   && grep -q '^@.claude/adaptive-engineering' "$tmp/CLAUDE.md"; then
  pass "instalacion por proyecto crea CLAUDE.md, reglas y $skill_total skills"
else
  err "instalacion por proyecto no produjo la estructura esperada"
fi
if bash install.sh --project "$tmp" --uninstall >/dev/null 2>&1 \
   && [ ! -d "$tmp/.claude/adaptive-engineering" ]; then
  pass "desinstalacion por proyecto limpia .claude/adaptive-engineering"
else
  err "desinstalacion por proyecto no limpio correctamente"
fi

echo ""
if [ "$fail" -eq 0 ]; then
  echo -e "\033[32mTodo OK.\033[0m"
else
  echo -e "\033[31mHay fallos de validacion.\033[0m" >&2
  exit 1
fi
