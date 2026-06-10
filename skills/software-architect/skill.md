# 🏗️ Software Architect

## Propósito
Decidir la arquitectura mínima viable según el contexto real del proyecto.

## Cuándo se usa
- Inicio de un proyecto nuevo.
- Cambios estructurales importantes (nuevos dominios, integraciones grandes).
- Dudas de diseño entre dos enfoques arquitectónicos.
- Evaluación de evolución (ej. de monolito a servicios).

## Cuándo NO se usa
- Cambios locales dentro de un módulo (no requieren decisión arquitectónica).
- Elección de librerías puntuales (eso es `researcher`).
- Cuando la arquitectura ya está decidida y solo se implementa: no reabrir decisiones sin dolor nuevo.

## Entradas esperadas
- Resumen de contexto de `engine/context-analyzer.md` (etapa, dominio, carga real, equipo).
- Restricciones conocidas (presupuesto, plazos, stack del equipo).

## Salida esperada
```
Arquitectura: <decisión>
Razón: <1-3 frases ligadas al contexto>
Qué NO haremos y por qué: <lista>
Señales para evolucionar: <qué dolor justificaría el siguiente nivel>
```

## Reglas internas

### Matriz de decisión
| Contexto | Arquitectura |
|----------|--------------|
| Idea / prototipo | Script o app de un módulo |
| MVP, dominio incierto | Monolito simple |
| Producción, dominio claro | Monolito modular |
| Escala probada + equipos independientes | Extraer servicios donde duele |

- Nunca empezar en microservicios: se extraen, no se diseñan desde cero (criterios en `knowledge/software/microservices.md`).
- Capas solo si hay más de un consumidor de esa lógica.
- Ubicar siempre el proyecto en la escalera de complejidad de `core/decision-rules.md`.
- Decisiones irreversibles se documentan en `knowledge/`.

## Ejemplos de uso

**Ejemplo 1:** Startup de 2 personas pide "arquitectura para su SaaS".
→ Contexto: MVP, dominio incierto, equipo mínimo. → Salida: monolito simple (Next.js + PostgreSQL), NO haremos microservicios ni colas; señal para evolucionar: equipos bloqueándose en deploys.

**Ejemplo 2:** Empresa con monolito modular donde el módulo de reportes consume 80% del CPU medido.
→ Contexto: producción, dolor medido, límite de dominio claro. → Salida: extraer solo el servicio de reportes, el resto permanece en el monolito.
