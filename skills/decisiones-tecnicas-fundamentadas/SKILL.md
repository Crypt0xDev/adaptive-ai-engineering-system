---
name: decisiones-tecnicas-fundamentadas
description: "Ante cualquier decisión técnica de desarrollo (elegir arquitectura, librería, framework, base de datos, patrón, enfoque de implementación, refactor, etc.), primero levanta el contexto real del proyecto haciendo las preguntas necesarias, analiza el caso concreto, y recién entonces da una decisión fundamentada y argumentada — basada en la realidad del proyecto, nunca en un contexto imaginado o supuestos no verificados. Úsala SIEMPRE que haya que elegir entre opciones técnicas, recomendar una tecnología/enfoque, o cuando el usuario pida 'qué me conviene' / 'cuál uso' / 'está bien esto'. Es la skill base de decisión del set."
---

# Decisiones técnicas fundamentadas en contexto real

## Principio central

Ninguna decisión técnica se da "en el aire". Antes de recomendar algo, entender el proyecto real: tamaño, etapa, stack, restricciones y quién lo mantiene. Una recomendación basada en un proyecto imaginado es peor que ninguna: suena convincente pero no aplica al caso real.

## Regla de oro: no inventar, verificar

- **No inventar contexto.** Si un dato necesario para decidir no está confirmado, se pregunta o se marca explícitamente como supuesto — nunca se asume el mejor caso y se sigue como si fuera verdad.
- **Verificar con herramientas reales.** Lo que dependa de hechos externos (si una librería existe, su versión actual, qué recomienda la documentación oficial, si ya hay una solución hecha) se comprueba con búsqueda web o docs oficiales antes de afirmarlo. Documentación oficial > blogs.
- **Si no se puede verificar, decirlo.** No rellenar un hueco con una afirmación que suena segura.

## Paso 1 — Levantar contexto real (antes de opinar)

Averiguar lo que falte de esto (preguntar solo lo que no se sabe ya por la conversación o el código a la vista):

- **Etapa y objetivo**: ¿prototipo/MVP para validar con un cliente, o sistema a mantener y crecer?
- **Tamaño real**: cuántas entidades, usuarios esperados, volumen de datos, cuántos devs lo tocan.
- **Stack y restricciones existentes**: qué ya usa el proyecto, qué sabe manejar el equipo, límites de hosting/presupuesto.
- **El problema concreto que se quiere resolver**: muchas veces la "decisión" pedida ("¿uso GraphQL?", "¿Redis?") es una solución buscando un problema — confirmar cuál es el dolor real primero.

Si con el código/contexto disponible alcanza, no preguntar de más; si un factor decisivo está en duda, preguntarlo antes de decidir.

## Paso 2 — Analizar el caso concreto (no el genérico)

- Comparar las opciones reales contra el contexto levantado, no contra un "manual de buenas prácticas" abstracto.
- Nombrar los trade-offs específicos para ESTE proyecto, no "X es más escalable" a secas.
- Considerar "no hacer nada / seguir con lo que hay" como alternativa válida cuando aplique.
- Si la decisión depende de un hecho verificable (qué soporta una herramienta, si ya existe algo hecho), verificarlo ahora, no suponerlo.

### Escalera de complejidad (empezar en el nivel más bajo que funcione)

Ubicar el proyecto en el escalón mínimo viable y subir solo con evidencia (dolor real, no anticipado):

| Nivel | Cuándo |
|-------|--------|
| Script / función | Tarea puntual, sin estado |
| Monolito simple | MVP, equipo chico, dominio incierto |
| Monolito modular | Dominio claro, equipo creciendo |
| Servicios separados | Límites de dominio probados + necesidad real de escala independiente |

Nunca empezar en microservicios: se extraen donde duele, no se diseñan desde cero.

### Reversible vs irreversible

- **Reversible** (nombres, estructura interna, un patrón acotado): decidir rápido, no sobreanalizar.
- **Irreversible** (motor de base de datos, API pública, contratos de datos): analizar más y dejar documentada la razón. Estas sí frenan aunque el usuario no esté presente.

## Paso 3 — Dar la decisión fundamentada

- Una recomendación clara (no "depende" a secas), con la razón concreta anclada al contexto real.
- Los trade-offs que se aceptan y qué se descarta.
- Marcar qué parte de la decisión depende de un dato NO confirmado, si lo hubo.
- Distinguir explícitamente: **hecho** (verificado) / **estimación** / **recomendación** / **opinión**.
- Si el contexto no alcanza para recomendar con confianza razonable, decirlo y pedir el dato que falta, en vez de forzar una respuesta.

Para decisiones de peso (arquitectura, stack, algo irreversible), cerrar con este formato:

```
Decisión: <qué se eligió>
Razón: <1-3 frases ligadas al contexto>
Qué NO haremos y por qué: <lista>
Señales para evolucionar: <qué dolor justificaría el siguiente nivel>
```

## Anti-patterns a detectar y frenar

Si la propuesta (propia o del usuario) cae en uno de estos, nombrarlo y ofrecer el antídoto:

- **Sobreingeniería** — resolver problemas que no existen (config/flexibilidad sin consumidores). Antídoto: KISS + escalera de complejidad.
- **Abstracción prematura** — interfaces/factories/capas genéricas antes de 2+ casos reales. Antídoto: regla de tres (abstraer en la tercera repetición).
- **Microservicios innecesarios** — dividir sin límites de dominio probados. Antídoto: monolito modular primero.
- **Cargo cult** — copiar arquitecturas de Netflix/Google en un contexto distinto. Antídoto: el contexto define la solución, no la empresa que lo hizo.
- **Resume-driven development** — elegir tecnología por moda o CV. Antídoto: stack que el equipo domina, salvo razón fuerte documentada.
- **Optimización prematura** — optimizar sin medir. Antídoto: medir → cuello real → optimizar solo eso.

## Qué NO hacer

- No recomendar la tecnología de moda por defecto sin justificar contra el caso real.
- No asumir escala/crecimiento futuro no mencionado para justificar complejidad hoy (YAGNI).
- No dar una respuesta larga y segura sobre un proyecto del que se sabe poco — ese es el "contexto imaginado" a evitar.
- No preguntar lo ya respondido en la conversación o visible en el código.

## Checklist antes de cerrar una decisión

1. ¿Entendí el problema real, o resuelvo el que asumí?
2. ¿La recomendación se apoya en datos reales del proyecto, no en un caso genérico?
3. ¿Verifiqué los hechos externos en vez de suponerlos?
4. ¿Marqué qué es supuesto vs confirmado, y qué es hecho / estimación / recomendación / opinión?
5. ¿Consideré "no cambiar nada" como opción?

## Se aplica junto con

- **buenas-practicas-ingenieria** — una vez decidido el enfoque, aquella guía cómo implementarlo con buena estructura.
- **graphql-evaluacion-implementacion** — aplicación concreta de esta skill al caso "¿conviene GraphQL?".
