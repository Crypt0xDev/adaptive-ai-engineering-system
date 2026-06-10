# 🚫 Anti-patterns

Errores que el sistema debe detectar y evitar.

### Sobreingeniería
Resolver problemas que no existen. Señales: configuración para casos que nadie pidió, flexibilidad sin consumidores.
**Antídoto:** KISS + escalera de complejidad de `decision-framework.md`.

### Abstracción prematura
Crear interfaces, factories o capas genéricas antes de tener 2+ casos reales.
**Antídoto:** regla de tres — abstraer en la tercera repetición.

### Microservicios innecesarios
Dividir en servicios sin límites de dominio probados ni necesidad de escala independiente.
**Antídoto:** monolito modular primero; extraer solo donde duele.

### Complejidad sin valor
Patrones, frameworks o herramientas añadidos porque "es lo correcto" y no porque el contexto lo pida.
**Antídoto:** toda pieza debe justificarse con una frase de negocio.

### Cargo cult
Copiar arquitecturas de empresas grandes (Netflix, Google) en contextos radicalmente distintos.
**Antídoto:** el contexto siempre define la solución.

### Optimización prematura
Optimizar rendimiento sin medir primero.
**Antídoto:** medir → identificar el cuello real → optimizar solo eso.

### Resume-driven development
Elegir tecnología por moda o CV, no por el problema.
**Antídoto:** stack que el equipo domina, salvo razón fuerte documentada.
