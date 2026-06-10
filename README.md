# 🧠 Adaptive AI Engineering System

## 📌 Descripción

Sistema de ingeniería de software asistido por IA que toma decisiones de desarrollo **basadas en el contexto real del proyecto**.

No es un generador de código simple, sino un motor que analiza, razona y decide cómo construir software de forma eficiente: evita la sobreingeniería y aplica buenas prácticas solo cuando aportan valor real.

---

## ⚙️ Principio central

> **El contexto siempre define la solución.**

No existen reglas absolutas. SOLID, DDD, Clean Architecture, patrones y microservicios solo se aplican si el contexto lo justifica. Lo único obligatorio **siempre** es la calidad y la seguridad del código.

---

## 🚀 Instalación

El sistema se integra con Claude de tres formas, según dónde lo uses:

### 1. Plugin de Claude Code (recomendado — distribuible)

Instálalo en cualquier máquina con dos comandos dentro de Claude Code:

```
/plugin marketplace add Crypt0xDev/adaptive-ai-engineering-system
/plugin install adaptive-engineering@crypt0xdev
```

Esto habilita las 12 skills de roles senior, que Claude invoca automáticamente según el contexto.

### 2. Reglas globales en Claude Code (esta máquina)

Aplica las reglas de ingeniería en **todos** tus proyectos locales con un solo comando:

```powershell
.\install.ps1        # Windows
```
```bash
./install.sh         # Linux / macOS
```

Integra las reglas en `~/.claude/CLAUDE.md` vía imports (fuente única en este repo). Desinstala con `.\install.ps1 -Uninstall` o `./install.sh --uninstall`.

### 3. Claude web / Desktop

Claude web y Desktop no leen archivos locales: copia el contenido de
[`integrations/claude-web-desktop.md`](integrations/claude-web-desktop.md) en tus
**instrucciones personales** o en un **Proyecto** de claude.ai.

---

## 🏗️ Estructura del sistema

```
.claude-plugin/        # Manifiestos de plugin y marketplace de Claude Code
│   ├── plugin.json
│   └── marketplace.json
│
├── core/              # Reglas fundamentales (siempre activas)
│   ├── principles.md          # KISS, YAGNI, SOLID contextual
│   ├── decision-rules.md      # Marco de decisión + escalera de complejidad
│   ├── code-quality.md        # Calidad y seguridad obligatorias
│   └── best-practices.md
│
├── engine/            # Motor de decisión
│   ├── context-analyzer.md
│   └── architecture-decider.md
│
├── skills/            # 12 roles senior (formato SKILL.md invocable)
│   ├── software-architect/    database-architect/   security-engineer/
│   ├── ux-designer/           product-manager/       business-analyst/
│   ├── startup-advisor/       devops-engineer/       performance-engineer/
│   ├── code-reviewer/         researcher/            skill-creator/
│
├── playbooks/         # Guías por tipo de proyecto + checklists
│   ├── build-saas.md, build-api.md, build-mobile-app.md, ...
│   └── checklists/            # architecture, database, security, launch, code-review
│
├── knowledge/         # Criterio por área (software, databases, ui-ux, ...)
│   ├── software/microservices.md, oop-and-patterns.md
│   └── databases/data-modeling.md
│
├── anti-patterns/     # Errores a evitar
├── integrations/      # Versión para Claude web / Desktop
├── install.ps1 / install.sh   # Instalador global para Claude Code
└── CLAUDE.md          # Constitución del comportamiento de la IA
```

---

## 🧩 Skills incluidas

| Skill | Para qué |
|-------|----------|
| `software-architect` | Arquitectura mínima viable según contexto |
| `database-architect` | Modelo de datos, motor, normalización |
| `security-engineer` | Seguridad obligatoria y proporcional al riesgo |
| `ux-designer` | Experiencias simples centradas en el usuario |
| `product-manager` | Alcance, MVP y priorización |
| `business-analyst` | Requisitos verificables |
| `startup-advisor` | Velocidad y validación en etapa temprana |
| `devops-engineer` | Despliegue e infraestructura por etapa |
| `performance-engineer` | Optimización basada en mediciones |
| `code-reviewer` | Revisión de calidad y seguridad |
| `researcher` | Evaluación de tecnologías y enfoques |
| `skill-creator` | Meta-skill: estándar para crear skills |

---

## 🧠 Filosofía

- El contexto siempre es lo primero.
- La simplicidad es la base; la complejidad solo se usa si es necesaria.
- Las reglas (SOLID, Clean Code, etc.) no son absolutas.
- La calidad y la seguridad del código sí son obligatorias siempre.
- La IA debe analizar y justificar antes de actuar.

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Sigue las pautas de `CONTRIBUTING.md` y respeta la filosofía del proyecto. Toda skill nueva debe seguir el estándar de `skills/skill-creator/SKILL.md`.

## 📄 Licencia

Licencia MIT. Consulta el archivo `LICENSE` para más detalles.
