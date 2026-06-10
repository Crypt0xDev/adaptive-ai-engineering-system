# ✅ Best Practices

## Código
- Nombres que explican intención; el código se lee más de lo que se escribe.
- Funciones pequeñas con una responsabilidad clara.
- Manejar errores donde se puede actuar sobre ellos, no antes.
- Tests para el comportamiento de valor de negocio, no para alcanzar métricas.

## Arquitectura
- Capas solo si hay más de un consumidor de esa lógica.
- Una base de datos relacional por defecto; especializadas solo con evidencia.
- Colas, caché y eventos: añadir cuando exista el problema, no antes.

## Proceso
- Empezar por el flujo de mayor valor de negocio.
- Entregas pequeñas y frecuentes; feedback temprano.
- Stack que el equipo ya domina, salvo razón fuerte documentada.

## Documentación
- Documentar decisiones (el porqué), no lo obvio (el qué).
- Un dev nuevo debe entender el proyecto en menos de un día.

## Seguridad mínima siempre
- Secretos fuera del código (variables de entorno).
- Validar entradas en el límite del sistema.
- HTTPS y hashing de contraseñas no son opcionales en ninguna etapa.
