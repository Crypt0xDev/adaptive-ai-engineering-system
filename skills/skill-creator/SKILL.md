---
name: skill-creator
description: Disena y mantiene las skills del sistema con estandar modular. Usar al crear o modificar una skill.
---

# 🛠️ Skill Creator (Skill Development Expert)

## Propósito
Diseñar y mantener las skills del sistema. Es la meta-skill: define el estándar que toda skill debe cumplir. Quien desarrolla skills trabaja siempre en este modo.

## Cuándo se usa
- Crear una nueva skill para el sistema.
- Modificar o refactorizar una skill existente.
- Auditar que las skills cumplan el estándar.
- Detectar y fusionar skills con lógica duplicada.

## Cuándo NO se usa
- Para resolver el problema de dominio directamente (eso lo hace la skill correspondiente, no esta).
- Para crear una skill de algo que ocurrió una sola vez (esperar a que el patrón se repita — regla de tres).
- Para documentación general del proyecto (eso va en `core/` o `knowledge/`).

## Entradas esperadas
- La capacidad o problema recurrente que la skill debe cubrir.
- El contexto donde se usará (qué tipo de proyectos, qué etapa).
- Las skills existentes (para verificar que no haya solapamiento).

## Salida esperada
Una carpeta `skills/<nombre-kebab-case>/` con un `SKILL.md` que cumple la estructura obligatoria (ver plantilla abajo).

## Reglas internas

### Al crear cualquier skill, SIEMPRE:
- **Responsabilidad única**: una skill = una capacidad. Si necesita "y" para describirse, son dos skills.
- **Nombres claros y descriptivos**: el nombre dice qué hace (`security-engineer`, no `helper`).
- **Sin duplicación de lógica**: si otra skill ya cubre parte, referenciarla (`ver skills/x/`), no copiarla.
- **Bajo acoplamiento**: una skill referencia a otras por nombre, nunca depende de sus detalles internos.
- **Secciones pequeñas y específicas**: procesos de 3-6 pasos; si crece más, la skill abarca demasiado.
- **Diseño contextual**: toda skill incluye cuándo NO usarse — una skill sin contraindicaciones está mal diseñada.
- **Mantenibilidad primero**: que un lector nuevo entienda la skill en 5 minutos.

### Al crear cualquier skill, NUNCA:
- Aplicar patrones o estructura extra sin necesidad real (no sobreingeniería).
- Crear dependencias innecesarias entre skills.
- Dejar el propósito ambiguo o solapado con otra skill.

## Proceso (antes de escribir cualquier skill)
1. **Analizar el objetivo**: ¿qué capacidad recurrente cubre? ¿ya existe en otra skill?
2. **Entender el contexto**: ¿en qué proyectos y etapas se activará?
3. **Definir responsabilidad única**: una frase sin "y".
4. **Diseñar estructura clara**: completar la plantilla, sin secciones vacías ni de relleno.
5. **Optimizar para reutilización**: eliminar todo lo específico de un solo proyecto.

## Plantilla obligatoria

```markdown
# <emoji> <Nombre de la skill>

## Propósito
<Una frase: qué capacidad cubre y para qué>

## Cuándo se usa
<Disparadores concretos>

## Cuándo NO se usa
<Contraindicaciones y límites — obligatorio>

## Entradas esperadas
<Qué contexto/información necesita para activarse>

## Salida esperada
<Formato concreto del resultado que produce>

## Reglas internas
<Las reglas que la skill aplica, alineadas con core/>

## Ejemplos de uso
<1-2 ejemplos breves: situación → cómo actúa la skill → resultado>
```

## Ejemplos de uso

**Ejemplo 1 — Crear skill nueva:**
Situación: el sistema necesita evaluar accesibilidad web de forma recurrente.
Acción: verificar que `ux-designer` no lo cubre ya por completo → definir responsabilidad única ("auditar accesibilidad según WCAG") → crear `skills/accessibility-auditor/SKILL.md` con la plantilla.
Resultado: skill nueva sin solapamiento, con criterios de cuándo no usarla (no aplica a CLIs ni APIs sin UI).

**Ejemplo 2 — Rechazar skill innecesaria:**
Situación: se propone una skill "validador de JSON".
Acción: analizar el objetivo → es una tarea puntual, no una capacidad de ingeniería recurrente del sistema.
Resultado: no se crea; se resuelve con una función normal en el proyecto que lo necesite.

## Mantenimiento
- Una skill que no se usa en 3 meses se elimina o se fusiona: el sistema también evita la sobreingeniería de sí mismo.
- Si dos skills comparten más de la mitad de sus reglas, fusionarlas.
