# 📈 Playbook: Build Dashboard

## Skills involucradas
`business-analyst` → `ux-designer` → `database-architect` → `performance-engineer`

## Fases

### 1. Métricas primero (business-analyst)
- Definir qué decisiones tomará el usuario con el dashboard.
- Cada gráfico debe responder una pregunta de negocio concreta; si no, fuera.

### 2. ¿Construir o usar BI?
- Uso interno y datos en SQL → considerar Metabase / Grafana / Looker Studio antes de construir.
- Construir solo si es de cara al cliente o necesita interacción a medida.

### 3. UX (ux-designer)
- Lo más importante arriba a la izquierda.
- Pocos gráficos con significado > muchos gráficos decorativos.
- Estados vacíos y rangos de fechas por defecto sensatos.

### 4. Datos (database-architect + performance-engineer)
- Consultas directas con índices mientras el volumen lo permita.
- Agregaciones precalculadas (vistas materializadas) solo cuando las consultas duelan.
- Cache de resultados con TTL corto antes que infraestructura analítica dedicada.

## Qué NO hacer al inicio
Data warehouse, pipelines ETL, tiempo real por WebSockets — hasta que el volumen o el negocio lo exijan.
