# 🧬 OOP, polimorfismo y patrones: cuándo aplicarlos

> OOP y los patrones (como Singleton) se aplican solo cuando el contexto lo justifique, no como regla fija.

## Programación orientada a objetos

### ✅ Cuándo aplicar OOP
- El dominio tiene **entidades con estado y comportamiento propios** (Pedido, Cuenta, Reserva) cuyas reglas conviene encapsular juntas.
- Hay **invariantes que proteger** (ej. "un pedido no puede confirmarse sin items") — la clase garantiza que nunca exista en estado inválido.
- Existen **variantes reales de comportamiento** que se benefician de una interfaz común.

### ❌ Cuándo NO
- Lógica de transformación de datos pura (entrada → salida): funciones simples son más claras y testeables.
- Clases que solo tienen getters/setters sin comportamiento (anemic model): es un struct disfrazado, usar un objeto de datos simple.
- Crear jerarquías de herencia "para reusar código": preferir composición; herencia solo para verdaderas relaciones "es-un" con comportamiento polimórfico.

## Polimorfismo

### ✅ Cuándo
- Existen **2+ implementaciones reales hoy** del mismo contrato (ej. `PasarelaPago` → Stripe, PayPal) y el código cliente no debe conocer cuál usa.
- Los `if/switch` sobre el mismo "tipo" se repiten en varios lugares: reemplazarlos por polimorfismo elimina la duplicación.

### ❌ Cuándo NO
- Una sola implementación "por si acaso" llega otra (YAGNI — abstracción prematura).
- Un único `switch` en un solo lugar: es más simple y legible que una jerarquía de clases.

## Relaciones entre entidades

### Necesarias
- La relación existe en el **negocio real** y el código la consulta o la valida (Pedido → Cliente, Factura → Pedido).
- La cardinalidad refleja la regla de negocio (un pedido pertenece a UN cliente).

### No necesarias (evitarlas)
- Relaciones bidireccionales "por comodidad" cuando solo se navega en una dirección — generan acoplamiento y ciclos.
- Relaciones especulativas para consultas que nadie hace.
- Entidades intermedias sin significado de negocio.

**Regla:** cada relación debe justificarse con un caso de uso real que la recorra. Si nadie la consulta, no existe.

## Patrón Singleton

### ✅ Uso correcto (raro)
Solo cuando **conceptualmente debe existir UNA instancia en todo el sistema** y crear más sería un error:
- Pool de conexiones a BD, configuración cargada una vez, logger.
- Incluso en estos casos, preferir **crear una instancia única e inyectarla** (inyección de dependencias) antes que un Singleton con acceso global estático.

### ❌ Uso incorrecto (lo habitual)
- Como variable global disfrazada para "acceder a algo desde cualquier parte" → acoplamiento oculto, imposible de testear.
- Para servicios con estado mutable compartido → bugs de concurrencia.
- Por defecto/costumbre, sin preguntar si la unicidad es un requisito del dominio.

**Regla:** si puedes pasar la dependencia por constructor, hazlo. El Singleton es la última opción, dependiendo del contexto del proyecto y la arquitectura, no la primera.

## 🚀 Idea clave

La arquitectura (microservicios, OOP, patrones como Singleton) debe aplicarse **solo cuando el contexto lo justifique**, no como regla fija. Ver `core/decision-rules.md` (Paso 3 — patrones bajo demanda).
