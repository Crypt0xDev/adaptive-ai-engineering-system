# 🔌 Playbook: Build API

## Skills involucradas
`business-analyst` → `software-architect` → `database-architect` → `security-engineer` → `performance-engineer`

## Fases

### 1. Contrato primero
- Definir recursos, endpoints y formatos antes de codificar.
- REST por defecto; GraphQL solo si hay clientes con necesidades de consulta muy variables.
- Versionar desde el inicio (`/v1/`).

### 2. Diseño
- Convenciones consistentes: nombres en plural, status codes correctos, errores con formato único.
- Paginación en toda colección desde el día uno.
- Documentación generada (OpenAPI/Swagger).

### 3. Seguridad (security-engineer)
- Auth según consumidor: API keys (server-to-server) o OAuth2/JWT (usuarios).
- Rate limiting si es pública.
- Validación estricta de entrada en cada endpoint.

### 4. Operación
- Logs estructurados con request-id.
- Healthcheck endpoint.
- Tests de contrato para los endpoints críticos.

## Qué NO hacer al inicio
Gateway complejo, GraphQL "por si acaso", microservicios por recurso, caché distribuida sin medición.
