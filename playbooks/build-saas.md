# 🧩 Playbook: Build SaaS

## Skills involucradas
`startup-advisor` → `product-manager` → `software-architect` → `database-architect` → `security-engineer` → `devops-engineer`

## Fases

### 1. Validación (startup-advisor + product-manager)
- Definir la hipótesis de negocio y el MVP mínimo que la valida.
- Cortar todo lo que no valide la hipótesis.

### 2. Arquitectura (software-architect + database-architect)
- Por defecto: monolito simple (Next.js / Rails / Laravel o similar) + PostgreSQL.
- Multi-tenancy: columna `tenant_id` en una sola BD; esquemas o BDs separadas solo con evidencia.

### 3. Esenciales SaaS
- Auth (usar proveedor: Clerk, Auth0, Supabase — no construir).
- Suscripciones y pagos (Stripe — no construir billing).
- Emails transaccionales (Resend, Postmark).
- Onboarding mínimo que lleve al usuario al valor rápido.

### 4. Seguridad (security-engineer)
- Aislamiento por tenant en cada query.
- Mínimos no negociables de `skills/security-engineer/skill.md`.

### 5. Lanzamiento (devops-engineer)
- PaaS, CI/CD, backups, monitoreo de errores.
- Pasar `playbooks/checklists/launch-checklist.md`.

## Qué NO hacer al inicio
Microservicios, Kubernetes, billing propio, feature flags complejos, multi-región.
