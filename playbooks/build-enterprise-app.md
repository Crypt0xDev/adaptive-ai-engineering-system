# 🏢 Playbook: Build Enterprise App

## Skills involucradas
`business-analyst` → `software-architect` → `database-architect` → `security-engineer` → `devops-engineer` → `code-reviewer`

## Diferencias de contexto
Aquí el contexto sí justifica más estructura: múltiples stakeholders, cumplimiento, integraciones legadas, horizonte de vida largo.

## Fases

### 1. Requisitos (business-analyst)
- Mapear stakeholders, procesos actuales e integraciones existentes (ERP, AD/SSO, legados).
- Requisitos con criterios de aceptación firmados.

### 2. Arquitectura (software-architect)
- Monolito modular con límites de dominio claros — preparado para extraer, no extraído.
- Contratos explícitos con sistemas externos; anticorrupción en los bordes con legados.

### 3. Seguridad y cumplimiento (security-engineer)
- SSO corporativo (SAML / OIDC), RBAC por recurso.
- Auditoría de acciones sensibles desde el día uno.
- Cumplimiento aplicable (GDPR, SOC2, normativa sectorial).

### 4. Calidad y operación
- CI/CD con ambientes (dev / staging / prod), revisión obligatoria de código.
- Migraciones de datos ensayadas; plan de rollback.
- Documentación de decisiones en `knowledge/`.

## Qué NO hacer
Big-bang rewrite de los sistemas legados; microservicios sin equipos que los posean; frameworks internos propios.
