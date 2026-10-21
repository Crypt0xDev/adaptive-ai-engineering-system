---
name: graphql-evaluacion-implementacion
description: "Evalúa si GraphQL es conveniente y necesario para un proyecto (vs REST u otra alternativa) antes de implementarlo, y si corresponde, lo implementa con buena estructura, seguridad (sanitización, control de profundidad/complejidad de queries, autorización por resolver) y código limpio. Úsala SIEMPRE que se mencione GraphQL, se pida agregar una API GraphQL a un proyecto, o se discuta si conviene GraphQL vs REST, en cualquier stack. Aplica el criterio de decisiones-tecnicas-fundamentadas y la estructura de buenas-practicas-ingenieria al caso GraphQL."
---

# Evaluación e implementación de GraphQL

## Paso 1 — Evaluar si GraphQL conviene (siempre primero, nunca asumir que sí)

No implementar GraphQL solo porque se mencionó, y no decidir "en el aire": antes de recomendar, analizar el proyecto real (mismo criterio que `decisiones-tecnicas-fundamentadas`).

### 1.1 Diagnóstico del proyecto concreto

- Revisar la API/endpoints actuales: ¿cuántas entidades, cuántos clientes la consumen, hay over-fetching/under-fetching real (parámetros tipo `?include=`, `?fields=`, o múltiples llamadas encadenadas para armar una vista)?
- Revisar stack y experiencia del equipo con GraphQL (si nunca lo usaron, eso pesa en el costo de mantenimiento).
- Revisar la etapa (prototipo/MVP vs sistema a mantener y crecer).
- Si algún dato está en duda, preguntar antes de asumir — no inventar contexto.

### 1.2 Señales de decisión

**A favor de GraphQL:**
- El cliente necesita combinaciones variables de datos anidados (distintas vistas piden distintos subconjuntos del mismo recurso).
- Problema real de over/under-fetching con el REST actual.
- Múltiples clientes (web, mobile, admin) con necesidades de datos distintas.
- El proyecto se va a mantener en el tiempo, no es un MVP descartable.

**En contra (quedarse en REST o simplificar):**
- CRUD simple, pocas entidades, un solo cliente.
- Proyecto chico / MVP / prueba de concepto donde REST ya cubre todo.
- Equipo sin experiencia en GraphQL y sin tiempo para mantener la complejidad extra (resolvers, N+1, caching distinto a REST).
- Ya hay un REST funcionando bien y migrar no resuelve un problema concreto — no migrar por moda.

### 1.3 Confirmación antes de implementar

- Resumir en 3-5 líneas el diagnóstico y la conclusión, con razón específica del proyecto.
- Si la decisión es "sí", decirlo como recomendación y esperar confirmación antes de escribir código, salvo que el usuario ya lo haya pedido de forma inequívoca.
- Si algún dato no se pudo verificar, decirlo en vez de asumir el mejor caso.

## Paso 2 — Diseño con buena estructura

Aplicar `buenas-practicas-ingenieria` (SOLID con criterio, sin over-engineering). Específico de GraphQL:

- **Separar capas**: schema/types, resolvers y lógica de negocio (services) en archivos distintos. Los resolvers orquestan, no contienen lógica de negocio ni SQL directo.
- **Schema-first o code-first** según lo que ya use el stack; si es nuevo, schema-first da un contrato claro entre front y back.
- **Nombrar tipos y campos** con el dominio, no calcando las tablas de la DB.
- **Paginación desde el diseño** en listados (el modelo basado en conexiones/cursores es el estándar de GraphQL; preferirlo sobre offset).
- **Errores consistentes**: no devolver stack traces ni mensajes crudos de DB.

## Paso 3 — Seguridad y confiabilidad (verificado contra la guía oficial de graphql.org)

- **Sanitizar y validar toda entrada** en resolvers antes de pasarla a la capa de datos. GraphQL no exime de validar inputs.
- **Limitar la profundidad de queries** (depth limiting): rechazar la operación ANTES de ejecutarla. Aplicar un límite extra, más chico, a la anidación de listas, porque las listas anidadas crecen de forma exponencial.
- **Analizar el costo/complejidad de queries** (cost analysis): asignar pesos a tipos y campos y rechazar las que superen un costo máximo. Útil cuando el solo depth limiting no alcanza.
- **Rate limiting en la capa de lógica de negocio**, no solo en la de red: el cliente elige los campos, así que el servidor no sabe de antemano cuán cara es una request; contar requests por ventana de tiempo en la red no lo captura.
- **Introspection en producción**: se puede desactivar para APIs de clientes propios, PERO la guía oficial lo llama "seguridad por oscuridad" y aclara que NO alcanza por sí solo. Combinarlo con autorización real y con ocultar los mensajes de error detallados (un atacante puede inferir el schema desde los errores aunque la introspection esté apagada).
- **Autorización por resolver o por campo**, no solo a nivel del endpoint único: un mismo endpoint GraphQL expone muchos sub-accesos.
- **Limitar el batching**: poner un tope a la cantidad de operaciones por batch y a los alias de un mismo campo por operación (ej. `friends1`, `friends2`… `friends100`), que son vías de abuso.
- **Resolver el N+1** con batching de las consultas a la fuente de datos (el patrón DataLoader es la implementación habitual), desde el diseño, no como parche.
- **Timeouts** en las requests, y HTTPS en el transporte.
- **No exponer campos/relaciones sensibles por defecto**: cada campo del schema es una decisión explícita de qué se expone, no un reflejo automático del modelo de datos.

> Si al implementar surge una duda sobre la sintaxis o las garantías exactas de la librería GraphQL del stack (graphql-js, Strawberry, Apollo, etc.), verificar contra su documentación oficial antes de afirmarlo. Documentación oficial > blogs.

## Paso 4 — Código limpio

- Consistencia con el resto del proyecto (naming, carpetas, manejo de errores).
- Tests de los resolvers críticos (autenticación, pagos, datos sensibles) como mínimo.
- Documentar el schema con descripciones en tipos y campos no obvios.

## Checklist antes de dar por terminado

1. ¿Se evaluó y justificó que GraphQL era necesario (no "porque sí")?
2. ¿Resolvers separados de la lógica de negocio?
3. ¿Depth limiting (con límite extra a listas anidadas) y cost analysis activos?
4. ¿Introspection tratada como capa débil, acompañada de autorización real y errores ocultos?
5. ¿Autorización revisada por resolver, no solo por endpoint?
6. ¿N+1 resuelto con batching/DataLoader donde aplica?
7. ¿Batching y alias limitados?
8. ¿Inputs sanitizados igual que en REST?

## Se aplica junto con

- **decisiones-tecnicas-fundamentadas** — el Paso 1 es un caso concreto de esa skill.
- **buenas-practicas-ingenieria** — los Pasos 2-4 heredan su estructura, nombrado y escala.
