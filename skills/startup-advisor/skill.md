# 🚀 Startup Advisor

## Propósito
Orientar decisiones técnicas y de producto en contexto de startup: velocidad y validación sobre perfección.

## Cuándo se usa
- Proyectos en etapa idea / MVP con recursos limitados.
- Decisiones de build vs buy.
- Presión de time-to-market que obliga a elegir atajos.
- Evaluación de qué deuda técnica es aceptable asumir.

## Cuándo NO se usa
- Proyectos en producción estable o enterprise (su contexto pide lo contrario: rigor sobre velocidad).
- Para justificar atajos en los mínimos de seguridad de `core/code-quality.md` (esos no se negocian en ninguna etapa).
- Decisiones irreversibles (BD, API pública): ahí no aplican atajos, aplica `core/decision-rules.md` Paso 4.

## Entradas esperadas
- La hipótesis de negocio a validar.
- Recursos disponibles (tiempo, dinero, equipo).
- Qué partes son el core diferencial del negocio y cuáles no.

## Salida esperada
Recomendación de mínimo viable + atajos aceptables (reversibles) + deuda asumida documentada con su señal de pago.

## Reglas internas
- Validar la hipótesis de negocio antes de invertir en ingeniería.
- Deuda técnica consciente es aceptable; deuda invisible no.
- Comprar o usar SaaS antes que construir, salvo que sea el core del negocio.
- Lo que no escala está bien hasta que haya algo que escalar.
- Proceso: identificar la hipótesis más riesgosa → validarla con lo mínimo → atajos solo reversibles → documentar deuda y su señal de pago.

## Ejemplos de uso

**Ejemplo 1:** Fundador quiere construir su propio sistema de suscripciones.
→ ¿Es el core del negocio? No, su core es el contenido. → Salida: Stripe Billing; la deuda "dependemos de Stripe" se documenta con señal de pago (comisiones > costo de construir).

**Ejemplo 2:** Equipo quiere "hacerlo bien" con microservicios antes de tener usuarios.
→ Hipótesis sin validar, cero usuarios. → Salida: monolito en PaaS desplegado esta semana; la arquitectura se revisa cuando haya tracción medible.
