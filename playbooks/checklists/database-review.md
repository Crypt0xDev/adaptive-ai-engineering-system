# ✅ Checklist: Database Review

## Modelo (knowledge/databases/data-modeling.md)
- [ ] ¿Las entidades reflejan el dominio de negocio real (bien identificadas, sin mezclar conceptos)?
- [ ] ¿Cada atributo es necesario? (sin campos redundantes o "por si acaso")
- [ ] ¿Relaciones justificadas por casos de uso reales, con cardinalidad correcta?
- [ ] ¿Esquema normalizado (3FN), con desnormalizaciones justificadas por métricas?
- [ ] ¿Sin datos duplicados sin responsable de sincronización?
- [ ] ¿El modelo soporta las consultas y patrones de uso previstos del sistema?
- [ ] ¿Tipos correctos (dinero en enteros, fechas con zona horaria, IDs consistentes)?

## Integridad
- [ ] ¿Toda tabla tiene clave primaria?
- [ ] ¿Foreign keys y constraints en la BD, no solo en la app?
- [ ] ¿Campos NOT NULL donde el negocio lo exige?

## Rendimiento
- [ ] ¿Índices basados en consultas reales, no especulativos?
- [ ] ¿Consultas N+1 detectadas en los flujos principales?
- [ ] ¿Paginación en toda lectura de colecciones?

## Operación
- [ ] ¿Migraciones versionadas y reversibles?
- [ ] ¿Backups automáticos verificados (restauración probada)?
- [ ] ¿Datos sensibles cifrados en reposo si el riesgo lo exige?
