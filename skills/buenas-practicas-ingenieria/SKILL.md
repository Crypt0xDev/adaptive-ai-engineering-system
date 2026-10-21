---
name: buenas-practicas-ingenieria
description: "Aplica buenas prácticas de ingeniería de software (SOLID, estructura de carpetas mantenible, separación de responsabilidades, escalabilidad, nombrado y ubicación de archivos) con criterio en cualquier tarea de código y en cualquier lenguaje — backend, frontend, scripts, hardware/firmware. Úsala SIEMPRE que se escriba, revise o estructure código nuevo, se agregue una feature a un proyecto existente, o se discuta arquitectura/organización. No es aplicación ciega de patrones; evalúa si el proyecto amerita esa estructura antes de imponerla, y respeta la convención ya existente en vez de reescribirla por preferencia personal. Prioriza mantenibilidad a largo plazo sin caer en over-engineering ni ensuciar código ya funcionando."
---

# Buenas prácticas de ingeniería (con criterio)

## Principio central

Mantenibilidad y escalabilidad SÍ, pero solo la que el proyecto necesita en su tamaño y etapa actual. La meta no es "aplicar SOLID" como checklist, es que el código se pueda leer, modificar y crecer sin romperse — a veces eso es SOLID estricto, a veces una función simple sin capas.

## Paso 0 (siempre primero): ¿el proyecto ya tiene una convención?

Antes de proponer estructura o refactor, mirar cómo está organizado el proyecto existente (carpetas, capas, nombres, imports, linter/formatter configurado). Si ya hay un patrón consistente, seguirlo — no imponer el patrón "ideal" propio encima de algo que ya funciona. Señalar una inconsistencia solo si complica mantenibilidad real, y como sugerencia, no como reescritura no pedida.

## Verificar antes de afirmar

No inventar APIs, nombres de métodos, firmas, flags ni versiones de librerías. Si hay duda sobre cómo se usa una librería/framework o qué versión soporta algo, verificar contra la documentación oficial antes de escribir el código. Documentación oficial > blogs. Si no se puede verificar, decirlo en vez de suponer.

## Cuándo SÍ aplicar estructura/SOLID de forma más estricta

- Backend con múltiples entidades/capas: separar routers/schemas/models/services/repositorios cuando el dominio ya tiene 3+ entidades relacionadas.
- Código que se sabe va a crecer (nuevas features, tenants, endpoints).
- Lógica de negocio con reglas que van a cambiar (facturación, promociones): aislarla de la capa HTTP/DB para testear y modificar sin tocar todo.
- Multi-tenant o multi-cliente: la separación de responsabilidades ahí no es opcional.

## Cuándo NO forzar SOLID/capas (evitar over-engineering)

- Scripts puntuales, utilidades de un solo uso, prototipos, o MVPs para validar una idea con un cliente.
- Un CRUD chico de 1-2 entidades sin lógica de negocio real todavía.
- Firmware/Arduino simple (loop + funciones).
- Cuando una abstracción hoy no tiene un segundo caso de uso real a la vista (YAGNI).

## Nombrado y ubicación de archivos

- **Nombres que reflejen el dominio, no la implementación**: `appointments/`, `promotions/` mejor que todo en `utils/` o `misc/`. El nombre debe decir qué hay adentro sin abrir el archivo.
- **Un archivo, una responsabilidad clara**: si mezcla cosas no relacionadas, dividirlo; si dos archivos siempre cambian juntos, quizá van juntos.
- **Ubicación predecible**: cada archivo donde un dev razonable lo buscaría. Seguir la convención del framework (estructura default de Next.js, FastAPI, etc.) antes que inventar una propia.
- **Consistencia de casing**: respetar el estilo del proyecto (kebab-case, camelCase, snake_case), no mezclar.
- **Evitar nombres genéricos** (`helpers.js`, `data.py`, `temp`, `test2`): no dicen nada y se vuelven cajón de sastre.
- Para proyectos chicos, la estructura estándar del framework alcanza; no armar 8 carpetas para 3 archivos.

## Escalabilidad: diseñar pensando en volumen (100+ de algo)

Cuando una entidad puede crecer a 100, 1.000 o más (registros, usuarios, ítems en lista), diseñar para eso desde el inicio, sin sobre-ingeniería:

**Backend / datos:**
- **Paginación desde el arranque** en cualquier listado que pueda crecer — nunca devolver "todos los registros" sin límite.
- **Índices** en columnas por las que se filtra/ordena/joinea seguido.
- **Evitar N+1**: cargar relaciones en batch (eager load / joins / dataloaders) en vez de una query por ítem en un loop.
- **No traer a memoria colecciones enteras** para filtrar/contar en código lo que la DB resuelve con una query.

**Frontend:**
- **Virtualización / lazy rendering** para listas largas (no montar 1.000 nodos en el DOM de una).
- **Paginación o scroll infinito** consumiendo la paginación del backend, no traer todo y cortar en el cliente.
- **Estados de carga/vacío/error** contemplados, no solo el caso feliz con pocos datos.

Regla: no optimizar para millones si el caso real son decenas, pero dejar el diseño listo para crecer un orden de magnitud sin reescribir.

## Reglas prácticas al escribir o revisar código

1. **Una función/clase, una responsabilidad.** Si al nombrarla necesitás un "y", separarla.
2. **Dependencias explícitas, no hardcodeadas.** Inyectar lo que puede cambiar (DB, cliente de notificaciones) — sin armar un container de DI si no se justifica.
3. **No repetir lógica de negocio** en dos lugares: si una regla se usa en dos partes, va a un service/helper compartido.
4. **Manejo de errores real**: nada de `catch` vacío que traga el error; validar inputs en los bordes (entrada de API, formularios) y fallar con mensajes claros, sin exponer detalles internos/DB al usuario.
5. **Nada de secretos hardcodeados**: claves, tokens, credenciales y URLs de DB en variables de entorno, nunca en el código ni en el repo.
6. **Seguir el linter/formatter del proyecto** (Prettier, Black, ESLint, etc.) en vez del estilo propio.
7. **Comentar el porqué, no el qué**: comentarios donde la intención no es obvia; no narrar línea por línea.
8. **Los cambios nuevos siguen el estilo del archivo que tocan.** Consistencia local > pureza teórica.

## Seguridad: mínimos no negociables (toda etapa, incluso un MVP)

Estos aplican siempre, no "después". La seguridad extra es proporcional al riesgo (datos de pago/personales piden más), pero estos son el piso:

- **Queries parametrizadas / prepared statements u ORM.** Prohibido concatenar o interpolar input del usuario en SQL.
- **Validar y sanitizar toda entrada** en el límite del sistema (tipo, formato, longitud, rango); **escapar la salida** según contexto (HTML, SQL, shell, URL) para evitar XSS e inyecciones.
- **Contraseñas con hashing** bcrypt / argon2 / scrypt (salt automático). Prohibido texto plano, MD5, SHA1/SHA256 sin key-stretching, o cifrado reversible. Nunca loguear ni devolver contraseñas.
- **Autorización por recurso en cada operación**, no solo "está logueado": verificar en el servidor que el recurso pertenece al usuario (evitar IDOR, ej. `GET /invoices/:id` donde cualquiera lee facturas ajenas).
- **Sesiones**: tokens/cookies con expiración; cookies `HttpOnly`, `Secure`, `SameSite`; regenerar el ID al iniciar sesión; invalidar al cerrar sesión y al cambiar contraseña.
- **Mínimo privilegio**: usuarios de BD, API keys y rutas admin con solo los permisos necesarios; rutas admin restringidas por rol, no ocultas por oscuridad.
- **HTTPS en todo.**
- **Dependencias**: revisar vulnerabilidades al agregarlas (`npm audit`, `pip-audit` o equivalente), preferir paquetes mantenidos, versiones fijadas en lockfile.
- **Errores sin filtrar info sensible**: al usuario, mensaje genérico; al log interno, el detalle (sin contraseñas ni tokens). Nunca stack traces, rutas internas, versiones ni SQL en respuestas de producción.

## Al proponer una refactorización

- Explicar en 1-2 líneas qué problema concreto resuelve (no "esto es más SOLID" sin más).
- Cambios grandes van como sugerencia aparte, no mezclados con la feature pedida — un cambio hace una sola cosa.
- Ante duda sobre si vale la pena el refactor, preguntar antes de aplicarlo, salvo corrección trivial.
- No tocar código no relacionado al pedido.

## Checklist rápido antes de escribir código nuevo

1. ¿El proyecto ya tiene un patrón/convención para esto? → seguirlo.
2. ¿Verifiqué las APIs/versiones de librería en vez de suponerlas?
3. ¿Esta pieza va a crecer o repetirse? → abstracción mínima + diseño escalable (paginación/índices/virtualización).
4. ¿Es un caso aislado o prototipo? → simple y directo, sin capas de más.
5. ¿Los archivos tienen nombres claros y están donde se los buscaría?
6. ¿Se cumplen los mínimos de seguridad (queries parametrizadas, hashing de contraseñas, autorización por recurso, inputs validados, secretos fuera del código)?
7. ¿Estoy tocando algo que no se me pidió? → no, salvo aclararlo como sugerencia separada.

## Se aplica junto con

- **decisiones-tecnicas-fundamentadas** — decide QUÉ enfoque/tecnología usar; esta skill guía CÓMO implementarlo bien.
- **graphql-evaluacion-implementacion** — hereda estas reglas de estructura y escala para el caso GraphQL.
