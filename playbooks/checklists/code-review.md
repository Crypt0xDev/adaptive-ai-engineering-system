# ✅ Checklist: Code Review

## Simplicidad
- [ ] ¿Existe una solución más simple que haga lo mismo?
- [ ] ¿Hay abstracciones con una sola implementación sin justificar?
- [ ] ¿Hay código para futuros hipotéticos? (YAGNI)

## Corrección
- [ ] ¿Los casos límite del flujo principal están cubiertos?
- [ ] ¿Los errores se manejan donde se puede actuar sobre ellos?
- [ ] ¿Tests del comportamiento de valor (no de implementación)?

## Mantenibilidad (core/code-quality.md)
- [ ] ¿Sin código duplicado? (reutiliza lo existente; extraído a la tercera repetición)
- [ ] ¿Nombres descriptivos por intención de negocio? (sin `data`, `temp`, `doStuff`)
- [ ] ¿Funciones pequeñas con una sola responsabilidad? (~30-40 líneas, ≤3 niveles de anidación)
- [ ] ¿Bajo acoplamiento? (comunicación por contratos, sin globals mutables, sin ciclos)
- [ ] ¿Documentado? (comentarios del porqué, docstrings en funciones públicas)
- [ ] ¿Lo entiende un dev nuevo en 10 minutos?
- [ ] ¿Consistente con el estilo del código circundante?

## Seguridad (core/code-quality.md)
- [ ] ¿Validación de usuarios en el servidor y autorización por recurso?
- [ ] ¿Contraseñas con política mínima y hasheadas con bcrypt/argon2?
- [ ] ¿Queries parametrizadas en todo acceso a datos?
- [ ] ¿Entradas validadas/sanitizadas y salidas escapadas según contexto?
- [ ] ¿Sesiones con expiración, cookies HttpOnly/Secure/SameSite, invalidación al logout?
- [ ] ¿Mínimo privilegio en BD, API keys y rutas admin?
- [ ] ¿Dependencias auditadas y fijadas en lockfile?
- [ ] ¿Errores sin exponer stack traces, rutas internas ni SQL al usuario?
- [ ] ¿Secretos fuera del código (variables de entorno)?

## Veredicto
Clasificar cada hallazgo como **Bloqueante** / **Importante** / **Sugerencia**, siempre proponiendo la alternativa.
