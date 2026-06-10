# 🏗️ Architecture Decider

Recibe el resumen de `context-analyzer.md` y decide la arquitectura mínima viable, apoyándose en `skills/software-architect/`.

## Matriz de decisión

| Contexto | Arquitectura recomendada |
|----------|--------------------------|
| Idea / prototipo, equipo solo | Script o app de un solo módulo |
| MVP, dominio incierto | Monolito simple, capas mínimas |
| Producción, dominio claro | Monolito modular (módulos por dominio) |
| Escala probada + equipos independientes | Extraer servicios solo donde duele |

## Reglas

1. **Nunca empezar en microservicios.** Se extraen, no se diseñan desde cero.
2. **Capas solo si hay más de un consumidor** de esa lógica.
3. **Base de datos:** una relacional por defecto; especializadas solo con evidencia.
4. **Abstracciones externas** (colas, caché, eventos): añadir cuando exista el problema, no antes.

## Formato de salida

```
Arquitectura: <decisión>
Razón: <1-3 frases ligadas al contexto>
Qué NO haremos y por qué: <lista>
Señales para evolucionar: <qué dolor justificaría el siguiente nivel>
```

Verificar después con `playbooks/checklists/architecture-review.md` y documentar decisiones irreversibles en `knowledge/`.
