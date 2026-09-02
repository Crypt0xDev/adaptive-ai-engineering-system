# 🔎 Análisis de entornos y servidores

> Análisis del **Adaptive AI Engineering System**: dónde y cómo se ejecuta, su
> compatibilidad multiplataforma (Windows / Linux / macOS), sus métodos de
> instalación, los problemas detectados y las mejoras aplicadas en esta rama.

---

## 1. Resumen ejecutivo

Este repositorio **no es una aplicación que corre en un servidor**: es un paquete
de **reglas + skills + playbooks + knowledge** que configura el comportamiento de
Claude en distintos *entornos de ejecución* (Claude Code CLI, plugin, web/Desktop).
Su "runtime" es, por tanto, el propio Claude y el sistema operativo donde vive la
configuración del usuario (`~/.claude/`) o del proyecto (`.claude/`).

El análisis se centró en dos ejes:

1. **Entornos donde el sistema se instala/consume** (por SO y por producto Claude).
2. **Portabilidad de los mecanismos de instalación** (`install.sh`, `install.ps1`,
   plugin, integración web).

Se detectaron problemas concretos de portabilidad, consistencia y validación, y se
implementaron mejoras: un **modo de instalación por proyecto** (autocontenido y
portable), la **corrección de la lógica de desinstalación en PowerShell**, un
**validador reutilizable** y un **CI real** que sustituye al placeholder anterior.

---

## 2. Entornos de ejecución soportados

El sistema se consume desde tres productos Claude, con distintos requisitos:

| Entorno | Cómo lee las reglas | Requiere SO local | Fuente |
|---|---|---|---|
| **Claude Code (CLI)** | `~/.claude/CLAUDE.md` + `~/.claude/skills/` (global) o `<proyecto>/CLAUDE.md` + `<proyecto>/.claude/` (por proyecto) | Sí (Windows/Linux/macOS) | `install.sh` / `install.ps1` |
| **Plugin de Claude Code** | Marketplace + `plugin.json` (`.claude-plugin/`) | No (se resuelve por Claude Code) | `/plugin marketplace add …` |
| **Claude web / Desktop** | Instrucciones personales o de Proyecto (texto pegado) | No | `integrations/claude-web-desktop.md` |

**Conclusión:** el único punto realmente dependiente del sistema operativo son los
**instaladores locales** (`install.sh` / `install.ps1`). El plugin y la vía web son
agnósticos del SO. Por eso el foco de portabilidad está en los scripts.

---

## 3. Matriz de compatibilidad (entorno × método)

| Método | Windows | Linux | macOS | Notas |
|---|:---:|:---:|:---:|---|
| Plugin (`/plugin`) | ✅ | ✅ | ✅ | Independiente del SO |
| Global (`install.*`) | ✅ (`.ps1`) | ✅ (`.sh`) | ✅ (`.sh`) | PowerShell 7+ también corre `.ps1` en Linux/macOS |
| **Por proyecto (nuevo)** | ✅ (`.ps1 -Project`) | ✅ (`.sh --project`) | ✅ (`.sh --project`) | Autocontenido y versionable |
| Web / Desktop | ✅ | ✅ | ✅ | Copiar/pegar; sin archivos locales |

---

## 4. Análisis de portabilidad de los instaladores

### 4.1 `install.sh` (Linux / macOS)

- Usa `bash` con `set -euo pipefail`, `awk`, `sed`, `mktemp` y `cp -R`: todo
  disponible en Linux y en el `bash 3.2` que trae macOS.
- La normalización de espacios (`sed 's/[[:space:]]*$//'`) y los bloques `awk`
  usados son compatibles con las variantes BSD (macOS) y GNU (Linux).
- **Mejora aplicada:** se extrajo la lógica repetida a funciones (`strip_block`,
  `copy_skills`) y se añadió el modo `--project`.

### 4.2 `install.ps1` (Windows / multiplataforma con PowerShell 7+)

- Escribe en **UTF-8 sin BOM**, correcto para que Claude lea el `CLAUDE.md` limpio.
- **Problema detectado (corregido):** la rama de `-Uninstall` estaba **al final**
  del script, después de escribir el bloque y copiar las skills. Es decir,
  `install.ps1 -Uninstall` **instalaba y luego desinstalaba**: efecto final
  correcto, pero con trabajo inútil y lógica frágil. Ahora la desinstalación se
  resuelve **antes** de instalar (como en `install.sh`).
- **Problema detectado (corregido):** el parámetro de proyecto no podía ser a la
  vez "bandera" y "ruta". Se separó en `-Project` (switch) + `-Path` (ruta
  opcional) para que `-Project` funcione sin argumento y no consuma al `-Uninstall`.
- Se usa `[Environment]::GetFolderPath('UserProfile')` para el home, válido en los
  tres SO bajo PowerShell 7+.

### 4.3 Consistencia entre ambos

Convenciones de flags alineadas por plataforma y documentadas en el README:

| Acción | bash | PowerShell |
|---|---|---|
| Global | `./install.sh` | `.\install.ps1` |
| Por proyecto | `./install.sh --project [DIR]` | `.\install.ps1 -Project [-Path DIR]` |
| Desinstalar | `… --uninstall` | `… -Uninstall` |

---

## 5. Hallazgos y estado

| # | Hallazgo | Severidad | Estado |
|---|---|---|---|
| 1 | `install.ps1 -Uninstall` instalaba antes de desinstalar | Media | ✅ Corregido |
| 2 | El parámetro de proyecto en `.ps1` no admitía uso como bandera | Media | ✅ Corregido (nuevo) |
| 3 | No existía instalación **por proyecto** (solo global/plugin) | Media | ✅ Implementado |
| 4 | El README listaba un `CLAUDE.md` en la raíz que no existe y está en `.gitignore` | Baja | ✅ Aclarado en README |
| 5 | CI era un *placeholder* sin validación real | Media | ✅ CI real + `validate.sh` |
| 6 | No había validación de JSON/skills/imports | Media | ✅ `scripts/validate.sh` |

---

## 6. Mejoras implementadas en esta rama

1. **Instalación por proyecto** (`--project` / `-Project`): copia reglas a
   `<proyecto>/.claude/adaptive-engineering/`, skills a `<proyecto>/.claude/skills/`
   y escribe `<proyecto>/CLAUDE.md` con **imports relativos**. Resultado:
   autocontenido, versionable y portable entre máquinas y equipos.
2. **Corrección de `install.ps1`**: desinstalación temprana y parámetros
   `-Project`/`-Path` bien definidos.
3. **Refactor de `install.sh`**: funciones reutilizables y modos global/proyecto.
4. **`scripts/validate.sh`**: valida manifiestos JSON, frontmatter de las 12 skills,
   existencia de los archivos importados y un smoke test de instalación por proyecto.
5. **CI real** (`.github/workflows/ci.yml`): `shellcheck`, `PSScriptAnalyzer`,
   `validate.sh` y smoke tests de ambos instaladores.
6. **README actualizado**: nuevo método de instalación por proyecto y aclaración
   sobre el `CLAUDE.md`.

### Decisión de diseño: global (imports) vs. proyecto (copia)

- **Global:** usa `@import` a rutas absolutas de este repo → una única fuente de
  verdad en la máquina, ideal para uso personal en muchos proyectos.
- **Por proyecto:** **copia** las reglas y skills dentro del repo destino → el
  proyecto no depende de rutas de la máquina, se puede commitear y compartir.
  Se prioriza portabilidad sobre "fuente única" porque ese es el objetivo del modo.

Esto respeta el principio del propio sistema (*el contexto define la solución*):
cada modo elige el trade-off correcto para su caso de uso, sin sobreingeniería.

---

## 7. Limitaciones y recomendaciones futuras

- **`install.ps1` en Windows nativo** no pudo ejecutarse en este entorno (sin
  PowerShell local); el CI lo cubre con PSScriptAnalyzer y un smoke test bajo
  PowerShell 7 en Linux. Se recomienda una verificación manual puntual en Windows.
- **Versionado del plugin**: `plugin.json` está en `1.0.0`. Conviene definir una
  política de versión (SemVer) y changelog al publicar cambios que afecten skills.
- **Deriva de contenido web vs. repo**: `integrations/claude-web-desktop.md` es una
  copia manual de las reglas. A futuro podría generarse desde `core/` para evitar
  divergencias.
- **Tests de contenido de skills**: hoy se valida la *estructura*; a futuro se puede
  añadir *linting* de estilo/longitud de cada `SKILL.md`.

---

## 8. Cómo reproducir la validación

```bash
# Linux / macOS
./scripts/validate.sh

# Instalación por proyecto de prueba
./install.sh --project /ruta/a/un/proyecto
./install.sh --project /ruta/a/un/proyecto --uninstall
```

El mismo flujo se ejecuta automáticamente en cada push/PR a `main` vía GitHub Actions.
