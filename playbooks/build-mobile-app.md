# 📱 Playbook: Build Mobile App

## Skills involucradas
`product-manager` → `ux-designer` → `software-architect` → `devops-engineer`

## Fases

### 1. Decisión de plataforma (software-architect)
| Contexto | Elección |
|----------|----------|
| MVP, equipo web | React Native / Expo o Flutter |
| Necesidad fuerte de APIs nativas / rendimiento | Nativo (Swift / Kotlin) |
| Solo validar idea | PWA primero |

### 2. UX (ux-designer)
- Diseñar para offline parcial y conexiones lentas.
- Estados de carga/error en cada pantalla.
- Seguir guías de plataforma (HIG / Material).

### 3. Backend
- Reusar la API existente o crear una mínima (ver `build-api.md`).
- Auth con tokens de larga vida + refresh.

### 4. Distribución (devops-engineer)
- Builds automatizados (EAS, Fastlane).
- Crash reporting desde el día uno (Sentry, Crashlytics).
- Plan de releases: las stores tienen revisión, no hay hotfix instantáneo.

## Qué NO hacer al inicio
Apps nativas duplicadas con equipo pequeño, sincronización offline compleja, notificaciones push antes de tener usuarios.
