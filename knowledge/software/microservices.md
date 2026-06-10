# 🧩 Microservicios: cuándo sí y cuándo no

> La arquitectura debe aplicarse solo cuando el contexto lo justifique, no como regla fija.

## ❌ Cuándo NO usar microservicios

- Proyecto en etapa idea / MVP (el dominio aún cambia demasiado).
- Equipo pequeño (< 2-3 equipos independientes): un solo equipo mantiene mejor un monolito.
- Límites de dominio aún no probados en producción.
- "Porque lo usa Netflix/Google" (cargo cult — ver `anti-patterns/`).
- Para resolver problemas de código desordenado: un monolito desordenado se convierte en microservicios desordenados + red.

## ✅ Cuándo SÍ se justifica separar en dos o más servicios

Se separa un servicio cuando se cumplen **varias** de estas condiciones a la vez (no una sola):

1. **Límite de dominio probado**: el módulo tiene un lenguaje, datos y reglas propios, con poca comunicación con el resto (bounded context real).
2. **Escala independiente**: una parte necesita 10x más recursos que el resto (ej. procesamiento de imágenes vs CRUD), y escalar el monolito completo es costoso.
3. **Equipos independientes**: hay un equipo que puede poseer el servicio completo (código, deploy, guardia). Ley de Conway: la arquitectura sigue a la organización.
4. **Ciclos de despliegue en conflicto**: una parte cambia a diario y otra es estable, y los deploys se bloquean entre sí.
5. **Requisitos técnicos incompatibles**: lenguaje/runtime distinto justificado (ej. ML en Python dentro de un sistema Java), o requisitos de cumplimiento que exigen aislamiento (ej. PCI para pagos).

## 📏 Reglas al separar

- **Extraer, no diseñar desde cero**: el primer microservicio se extrae de un monolito modular donde el límite ya se probó.
- **Un servicio = su base de datos**: sin compartir tablas entre servicios; comunicación solo por API o eventos.
- **Empezar por el borde**: extraer primero módulos con pocas dependencias (ej. notificaciones, generación de reportes), no el corazón del dominio.
- **Contratos versionados** entre servicios; un servicio no rompe a otro al desplegar.
- **Costo asumido conscientemente**: cada servicio añade red, latencia, observabilidad, deploys y modos de fallo distribuidos. Si ese costo no compra nada, no separar.

## 🚦 Señales para evolucionar (del monolito modular a servicios)

- Builds/deploys del monolito bloquean a varios equipos a diario.
- Un módulo concreto consume recursos desproporcionados y medidos.
- Conflictos de merge constantes entre equipos en los mismos módulos.

Documentar la decisión de extracción como ADR en `knowledge/` (es irreversible en la práctica).
