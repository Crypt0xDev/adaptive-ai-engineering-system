# 🔍 Context Analyzer

Analiza el estado real del proyecto antes de cualquier decisión. Es el primer paso del flujo del sistema.

## Entradas a evaluar

### Negocio
- Propósito del producto y usuarios objetivo
- Etapa: idea / MVP / producción / legado
- Restricciones de tiempo y presupuesto

### Técnico
- Stack actual y deuda técnica existente
- Volumen de datos y tráfico real (no proyectado)
- Integraciones externas

### Equipo
- Tamaño y seniority
- Conocimiento del dominio
- Capacidad de mantenimiento a largo plazo

## Salida

Un resumen de contexto con:

```
Etapa: <idea|mvp|produccion|legado>
Complejidad del dominio: <baja|media|alta>
Carga real: <baja|media|alta>
Equipo: <solo|pequeño|mediano|grande>
Riesgo principal: <descripción>
```

Este resumen alimenta a `architecture-decider.md` y determina qué skills de `skills/` activar.
