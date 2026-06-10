# 🧹 Code Quality & Security Rules

Reglas obligatorias al escribir o modificar código. A diferencia de los patrones de arquitectura (que dependen del contexto), estas reglas aplican **siempre**, en cualquier etapa del proyecto.

---

## 🚫 Lo que el código NUNCA debe tener

### Código duplicado
- Antes de escribir, buscar si la lógica ya existe en el proyecto y reutilizarla.
- Si una lógica se repite 3 veces, extraerla (regla de tres de `principles.md`).
- No copiar/pegar bloques: extraer función o módulo compartido.

### Nombres poco descriptivos
- Prohibido: `data`, `temp`, `x`, `aux`, `doStuff`, abreviaturas crípticas.
- Variables y funciones nombradas por su intención de negocio: `calcularTotalConImpuestos()`, no `calc()`.
- Booleanos como preguntas: `isActive`, `hasPermission`.

### Funciones muy grandes
- Una función = una responsabilidad. Si necesita "y" para describirse, dividirla.
- Guía: si no cabe en una pantalla (~30-40 líneas) o tiene más de 3 niveles de anidación, refactorizar.
- Máximo 3-4 parámetros; más que eso, agrupar en un objeto.

### Acoplamiento excesivo
- Los módulos se comunican por interfaces/contratos claros, no tocando internals ajenos.
- Sin variables globales mutables compartidas.
- Dependencias en una sola dirección; sin ciclos entre módulos.

### Falta de comentarios y documentación
- Comentar el **porqué** (decisiones, restricciones, trade-offs), el código limpio ya dice el qué.
- Toda función pública/exportada con docstring breve: qué hace, parámetros, retorno.
- README del proyecto actualizado: cómo instalar, configurar y ejecutar.

---

## ✅ Lo que el código SIEMPRE debe mantener

### Mantenibilidad
- Código limpio y consistente con el estilo del proyecto.
- Un dev nuevo debe entender cualquier módulo en minutos.

### Seguridad en validación de usuarios
- Validar identidad en el servidor, nunca confiar solo en el cliente.
- Autorización verificada por recurso en cada operación (no solo "está logueado").

### Contraseñas seguras
- Exigir política mínima (longitud ≥ 8-12, no contraseñas comunes).
- Nunca registrar contraseñas en logs ni devolverlas en respuestas.

### Consultas parametrizadas
- Toda query con placeholders/prepared statements u ORM.
- **Prohibido** concatenar o interpolar input del usuario en SQL.

### Escape y sanitización de datos
- Validar y sanitizar toda entrada en el límite del sistema (tipo, formato, longitud, rango).
- Escapar salida según contexto (HTML, SQL, shell, URL) para prevenir XSS e inyecciones.

### Gestión correcta de sesiones
- Tokens/cookies con expiración; cookies `HttpOnly`, `Secure`, `SameSite`.
- Regenerar ID de sesión al iniciar sesión; invalidar al cerrar sesión y al cambiar contraseña.

### Almacenamiento seguro de contraseñas
- Hashing con bcrypt / argon2 / scrypt (con salt automático).
- **Prohibido**: texto plano, MD5, SHA1/SHA256 sin key-stretching, cifrado reversible.

### Mínimo privilegio
- Usuarios de BD, API keys y roles con solo los permisos que necesitan.
- Endpoints y rutas admin restringidos por rol, no ocultos por oscuridad.

### Dependencias actualizadas
- Revisar vulnerabilidades al agregar dependencias (`npm audit`, `pip-audit` o equivalente).
- Preferir dependencias mantenidas y populares; evitar paquetes abandonados.
- Versiones fijadas en lockfile.

### Manejo de errores sin exponer información sensible
- Al usuario: mensaje genérico ("Ocurrió un error, intenta de nuevo").
- Al log interno: detalle completo (stack trace, contexto) — sin contraseñas ni tokens.
- Nunca exponer stack traces, rutas internas, versiones o SQL en respuestas de producción.

---

## 🧠 Buenas prácticas de programación

| ✔️ Correcto | ❌ Incorrecto |
|------------|---------------|
| Una función hace una sola cosa | Funciones que hacen demasiadas cosas |
| Nombres claros, cortos y descriptivos | Nombres confusos o demasiado largos |
| Parámetros útiles y necesarios | Parámetros innecesarios o "por si acaso" |
| Código fácil de probar (dependencias inyectadas, sin estado oculto) | Código difícil de testear (globals, Singletons, efectos ocultos) |
| Arquitectura basada en contexto | Aplicar patrones sin necesidad real |

## 🏛️ Arquitectura y patrones según contexto

> La arquitectura (microservicios, OOP, patrones como Singleton) se aplica **solo cuando el contexto lo justifica**, no como regla fija.

Criterios detallados en `knowledge/`:

- **Microservicios** → `knowledge/software/microservices.md`: cuándo separar en dos o más servicios (límite de dominio probado + escala independiente + equipos independientes), y cuándo no (MVP, equipo pequeño, cargo cult).
- **OOP, polimorfismo y relaciones entre entidades** → `knowledge/software/oop-and-patterns.md`: OOP cuando hay entidades con estado e invariantes; polimorfismo con 2+ implementaciones reales; cada relación justificada por un caso de uso real.
- **Singleton** → mismo archivo: solo cuando el sistema requiere genuinamente una única instancia (pool de conexiones, config, logger), y aun así preferir inyección de dependencias sobre acceso global.
- **Modelado y normalización de BD** → `knowledge/databases/data-modeling.md`: 3FN por defecto, integridad en la BD, desnormalizar solo con medición y documentación.

---

## 🔄 Cómo se aplica

1. **Al escribir código**: estas reglas se cumplen desde el primer borrador, no "después".
2. **Al revisar**: `skills/code-reviewer/` y `playbooks/checklists/code-review.md` verifican cada punto.
3. **Al avanzar el proyecto**: la arquitectura escala según contexto (`engine/`), pero estas reglas son constantes en toda etapa.
