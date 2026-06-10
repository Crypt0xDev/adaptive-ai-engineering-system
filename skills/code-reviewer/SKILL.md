---
name: code-reviewer
description: Revisa codigo con criterio senior: simplicidad, calidad y seguridad. Usar antes de integrar cualquier cambio de codigo.
---

# 🔎 Code Reviewer

## Propósito
Revisar código y decisiones técnicas con criterio de ingeniero senior, verificando las reglas obligatorias de `core/code-quality.md`.

## Cuándo se usa
- Antes de integrar cualquier cambio de código (PR / merge).
- Autoverificación de todo código generado por el sistema, antes de entregarlo.
- Auditoría de código existente cuando hay dudas de calidad.

## Cuándo NO se usa
- Revisión de requisitos o alcance (eso es `business-analyst` / `product-manager`).
- Decisiones de arquitectura global (eso es `software-architect`; esta skill revisa el código resultante).
- Prototipos descartables que no se integrarán (revisarlos es desperdicio — pero si se integran, se revisan).

## Entradas esperadas
- El diff o código a revisar.
- Contexto del proyecto (etapa, convenciones existentes).
- El checklist `playbooks/checklists/code-review.md`.

## Salida esperada
Hallazgos clasificados (**Bloqueante** / **Importante** / **Sugerencia**), cada uno con su alternativa propuesta — nunca solo señalar el problema.

## Reglas internas

### Checklist
**Simplicidad**
- ¿Existe una solución más simple que haga lo mismo?
- ¿Hay abstracciones con una sola implementación sin justificar?
- ¿Hay capas que solo pasan datos sin añadir valor?

**Contexto**
- ¿La solución corresponde a la etapa real del proyecto?
- ¿Se está construyendo para un futuro hipotético? (YAGNI)

**Mantenibilidad** (`core/code-quality.md`)
- ¿Sin duplicación, nombres por intención, funciones pequeñas, bajo acoplamiento, documentado?
- ¿Lo puede entender un dev nuevo en 10 minutos?

**Seguridad** (`core/code-quality.md`)
- ¿Entradas validadas, queries parametrizadas, secretos fuera del código, errores sin info sensible?

### Clasificación
1. **Bloqueante:** rompe el sistema o viola reglas de `core/`.
2. **Importante:** deuda que dolerá pronto.
3. **Sugerencia:** mejora opcional, no exigir.

## Ejemplos de uso

**Ejemplo 1:** PR con query construida concatenando input del usuario.
→ **Bloqueante** (viola `core/code-quality.md`): inyección SQL. Alternativa propuesta: query parametrizada con el mismo comportamiento.

**Ejemplo 2:** PR que añade una interfaz + factory para una única implementación.
→ **Importante** (abstracción prematura): eliminar la interfaz, dejar la clase concreta; extraer cuando exista la segunda implementación.
