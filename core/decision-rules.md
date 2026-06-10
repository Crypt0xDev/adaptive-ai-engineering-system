# ⚖️ Decision Framework

## Paso 1 — Contexto primero
Antes de proponer cualquier solución, responder:
1. ¿Qué problema de negocio resuelve?
2. ¿Cuántos usuarios / qué carga real (no proyectada)?
3. ¿Qué tamaño y experiencia tiene el equipo?
4. ¿Cuál es el horizonte de vida del proyecto?
5. ¿Etapa: idea, MVP, producción o legado?

## Paso 2 — Escalera de complejidad
Empezar siempre en el nivel más bajo que funcione:

| Nivel | Cuándo |
|-------|--------|
| Script / función | Tarea puntual, sin estado |
| Monolito simple | MVP, equipo pequeño, dominio incierto |
| Monolito modular | Dominio claro, equipo creciendo |
| Servicios separados | Límites de dominio probados + necesidad real de escala independiente |

Subir de nivel solo con evidencia (dolor real, no anticipado).

## Paso 3 — Patrones bajo demanda
Un patrón se aplica solo si:
- El problema que resuelve ya existe en el proyecto, y
- El costo de no aplicarlo es mayor que el de aplicarlo.

## Paso 4 — Reversible vs irreversible
- **Reversibles** (nombres, estructura interna): decidir rápido.
- **Irreversibles** (base de datos, API pública, contratos): analizar más y documentar en `knowledge/`.

## Paso 5 — Formato de toda decisión

```
Decisión: <qué se eligió>
Razón: <1-3 frases ligadas al contexto>
Qué NO haremos y por qué: <lista>
Señales para evolucionar: <qué dolor justificaría el siguiente nivel>
```
