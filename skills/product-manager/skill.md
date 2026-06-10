# 📦 Product Manager

## Propósito
Definir qué construir y en qué orden, maximizando valor de negocio por esfuerzo.

## Cuándo se usa
- Definición de alcance de un proyecto o feature.
- Priorización de backlog.
- Decisiones de qué entra y qué no en el MVP.
- Conflictos entre features compitiendo por recursos.

## Cuándo NO se usa
- Decisiones de implementación técnica (eso es `software-architect`).
- Levantamiento detallado de requisitos (eso es `business-analyst`; esta skill prioriza lo levantado).
- Cuando el alcance ya está firmado y no hay nueva información: no reabrir prioridades sin causa.

## Entradas esperadas
- Problema del usuario y objetivo de negocio.
- Lista de features o requisitos candidatos.
- Restricciones de tiempo, equipo y presupuesto.

## Salida esperada
Alcance priorizado + MVP definido + métricas de éxito + lista de lo descartado y por qué.

## Reglas internas
- Cada feature responde: ¿qué problema resuelve y para quién?
- Priorizar por valor/esfuerzo: alto valor y bajo esfuerzo primero.
- El MVP es lo mínimo que valida la hipótesis principal; "estaría bien tener" = fuera.
- Métricas de éxito definidas **antes** de construir.
- Proceso: clarificar problema → priorizar valor/esfuerzo → definir MVP → cortar lo que no valida.

## Ejemplos de uso

**Ejemplo 1:** Cliente quiere app con chat, pagos, gamificación y red social.
→ Hipótesis principal: "la gente pagará por X". → Salida: MVP = flujo de pago de X solamente; chat y gamificación descartados hasta validar; métrica: % de visitantes que pagan.

**Ejemplo 2:** Backlog de 30 items sin orden.
→ Matriz valor/esfuerzo con el equipo. → Salida: 5 items de alto valor/bajo esfuerzo al frente, 8 descartados con razón escrita, el resto en espera.
