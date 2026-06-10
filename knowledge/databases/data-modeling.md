# 🗄️ Modelado de datos y normalización

Buenas prácticas de diseño de esquema. Complementa a `skills/database-architect/`.

## 💡 Idea clave

El diseño de base de datos debe estar basado en:

> 📌 **el dominio del problema + las consultas futuras del sistema**

No solo en almacenar datos, sino en cómo serán usados, consultados y escalados.

## ✔️ Proceso de buen diseño (en orden)

1. **Entender los requisitos del sistema**: qué hace el negocio, qué información necesita y con qué frecuencia.
2. **Definir claramente las entidades del dominio**: sustantivos del negocio con identidad propia (Cliente, Pedido, Producto).
3. **Establecer relaciones adecuadas**: solo las que el negocio exige, con la cardinalidad correcta (ver sección Relaciones).
4. **Definir atributos correctos y necesarios**: cada columna responde a una necesidad real; sin campos "por si acaso".
5. **Aplicar normalización** (3FN por defecto, ver tabla abajo).
6. **Probar y optimizar según el uso real**: validar el modelo con las consultas principales del sistema e indexar según patrones de acceso medidos.

## ⚠️ Errores comunes a evitar

- **No identificar correctamente las entidades** → tablas que mezclan conceptos o conceptos repartidos en varias tablas sin razón.
- **Campos innecesarios o redundantes** → columnas que nadie consulta o que duplican información derivable.
- **No definir claves primarias** → toda tabla tiene PK, sin excepción.
- **No aplicar normalización correctamente** → grupos repetidos, dependencias parciales o transitivas (ver formas normales).
- **Generar datos duplicados** → el mismo hecho almacenado en dos lugares sin un responsable de sincronizarlo.
- **No pensar en consultas futuras o patrones de uso** → un modelo "bonito" que hace imposibles las consultas que el sistema necesita a diario.

## Reglas de diseño del esquema

- **Modelar el negocio, no la UI**: las tablas reflejan entidades reales del dominio, no pantallas.
- **Tipos correctos**: dinero en enteros (centavos) o `DECIMAL` (nunca float), fechas con zona horaria (`timestamptz`), booleanos reales (no `'S'/'N'`).
- **Integridad en la BD**: primary keys siempre, foreign keys y constraints (`NOT NULL`, `UNIQUE`, `CHECK`) en la base, no solo en la app.
- **Nombres consistentes**: un solo idioma y convención (`snake_case` plural para tablas: `orders`, `order_items`).
- **Sin columnas multivalor**: nunca guardar listas en un campo (`"1,2,3"`); usar tabla relacionada.
- **Migraciones versionadas** desde el día uno; nunca alterar el esquema a mano en producción.

## Normalización

Normalizar hasta **3FN por defecto**:

| Forma | Regla práctica |
|-------|----------------|
| 1FN | Cada celda un solo valor; sin grupos repetidos (`telefono1`, `telefono2` → tabla `phones`) |
| 2FN | Todo atributo depende de la clave completa (importa en claves compuestas) |
| 3FN | Ningún atributo depende de otro atributo no clave (ciudad no se deduce de código postal dentro de la misma tabla) |

### Desnormalizar solo cuando
- Hay una consulta medida como lenta que la normalización encarece, y
- Se documenta el dato duplicado y quién lo mantiene sincronizado.

Ejemplo válido: snapshot del precio en `order_items` — no es desnormalización incorrecta, es un **hecho histórico** del negocio (el precio al momento de la compra).

## Relaciones

- **1:N** — la habitual: FK en el lado "muchos" (`orders.customer_id`).
- **N:M** — tabla intermedia con nombre de negocio si lo tiene (`enrollments` mejor que `student_course`).
- **1:1** — sospechosa: casi siempre son la misma tabla; separar solo por seguridad (datos sensibles) o por columnas enormes poco consultadas.
- Cada relación se justifica con un caso de uso real que la recorra (ver `knowledge/software/oop-and-patterns.md`).

## Índices

- Crear según consultas reales (WHERE, JOIN, ORDER BY frecuentes), no especulativos.
- FKs casi siempre indexadas.
- Cada índice cuesta en escritura: medir antes de añadir más.
