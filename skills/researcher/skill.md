# 🔬 Researcher

## Propósito
Investigar tecnologías, herramientas y enfoques antes de decisiones importantes.

## Cuándo se usa
- Evaluación de stack, frameworks o librerías para una necesidad concreta.
- Decisiones build vs buy.
- Problemas sin solución conocida en el equipo.

## Cuándo NO se usa
- La decisión ya está tomada y solo se busca confirmación (sesgo).
- Tecnología que el equipo ya domina y funciona: no investigar reemplazos sin dolor real.
- Decisiones triviales o reversibles de bajo costo: elegir lo obvio y seguir (investigarlas es procrastinación).

## Entradas esperadas
- La pregunta concreta a responder (no "¿qué framework es mejor?" sino "¿cuál cubre X necesidad en nuestro contexto?").
- Criterios de evaluación y su peso (madurez, comunidad, mantenimiento, fit con el equipo).
- Time-box acordado.

## Salida esperada
Comparativa breve + recomendación única + trade-offs explícitos + qué señal obligaría a reevaluar.

## Reglas internas
- Time-box obligatorio: una investigación sin límite de tiempo es procrastinación.
- Máximo 2-4 opciones candidatas; más opciones = menos decisión.
- Evaluar con evidencia (docs, issues abiertos, frecuencia de releases, prueba mínima), no con opiniones.
- Preferir tecnología aburrida y probada salvo ventaja clara.
- La popularidad no es un criterio; el fit con el contexto sí.
- Recomendar UNA opción: una comparativa sin recomendación es trabajo incompleto.

## Ejemplos de uso

**Ejemplo 1:** "¿Qué ORM usamos para el proyecto Node + PostgreSQL?"
→ Time-box 2h, candidatos: Prisma, Drizzle, Knex. Criterios: madurez, migraciones, fit con TypeScript del equipo. → Salida: Prisma (DX y migraciones maduras); trade-off: menos control SQL fino; señal de reevaluación: queries complejas que el ORM no exprese.

**Ejemplo 2:** "¿Construimos nuestro motor de búsqueda o usamos uno?"
→ Build vs buy: catálogo de 50k productos, equipo de 3. → Salida: Meilisearch gestionado (buy); construir solo se justificaría con necesidades de ranking propias del negocio.
