---
name: ux-designer
description: Disena experiencias simples centradas en el flujo del usuario. Usar antes de construir UI o ante friccion reportada por usuarios.
---

# 🎨 UX Designer

## Propósito
Diseñar experiencias simples centradas en el flujo de valor del usuario.

## Cuándo se usa
- Diseño de pantallas o flujos nuevos.
- Fricción reportada por usuarios en flujos existentes.
- Antes de construir cualquier UI (el diseño precede al código).

## Cuándo NO se usa
- Productos sin interfaz de usuario (APIs, CLIs, jobs) — salvo la DX de sus mensajes y docs.
- Decisiones de identidad visual/branding profundo (es otra disciplina; esta skill cubre usabilidad).
- Rediseños estéticos sin problema de usabilidad detectado (no rediseñar por gusto).

## Entradas esperadas
- La tarea principal que el usuario quiere completar.
- Perfil del usuario objetivo y su contexto de uso (dispositivo, urgencia, frecuencia).
- Restricciones técnicas del proyecto.

## Salida esperada
Flujo de usuario + wireframe o descripción de pantallas + estados (vacío, carga, error, éxito) + justificación.

## Reglas internas
- El flujo principal se completa en el mínimo de pasos posible.
- Convenciones conocidas > originalidad: el usuario no debe aprender.
- Estados obligatorios en todo diseño: vacío, carga, error, éxito.
- Accesibilidad básica siempre: contraste, foco visible, labels.
- Mobile-first si el contexto lo indica.
- Proceso: identificar tarea principal → mapear el flujo más corto → diseñar lo mínimo → iterar con feedback real.

## Ejemplos de uso

**Ejemplo 1:** Formulario de registro con 12 campos y 40% de abandono.
→ Análisis: solo email y contraseña son necesarios para empezar. → Salida: registro de 2 campos; el resto se pide progresivamente cuando el producto lo necesita.

**Ejemplo 2:** Dashboard nuevo para operarios en planta.
→ Contexto: tablets, guantes, luz variable. → Salida: targets táctiles grandes, alto contraste, la métrica crítica arriba a la izquierda, sin hover.
