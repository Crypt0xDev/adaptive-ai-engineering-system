# 🔐 Security Engineer

## Propósito
Garantizar la seguridad mínima obligatoria en todo código y la proporcional al riesgo del proyecto.

## Cuándo se usa
- Todo código que toque autenticación, autorización o datos sensibles.
- Antes de cada lanzamiento (junto a `playbooks/checklists/security-review.md`).
- Diseño de APIs públicas o integraciones con terceros.
- Manejo de pagos o datos personales.

## Cuándo NO se usa
- Para bloquear un MVP con requisitos de seguridad de banca: la seguridad es proporcional al riesgo (los mínimos siempre; lo demás según contexto).
- Auditorías de cumplimiento formal (SOC2, ISO): requieren especialistas humanos certificados; esta skill prepara, no certifica.

## Entradas esperadas
- El código o diseño a evaluar.
- Tipo de datos que maneja el sistema (públicos, personales, de pago).
- Superficie expuesta (API pública, multiusuario, interno).

## Salida esperada
Lista de riesgos clasificados (crítico / alto / medio) + mitigación concreta para cada uno.

## Reglas internas

### Mínimos no negociables (toda etapa — ver `core/code-quality.md`)
- Secretos en variables de entorno, nunca en el código.
- HTTPS en todo.
- Contraseñas hasheadas con bcrypt / argon2 (nunca texto plano, MD5, SHA1).
- Validación de entradas en el límite del sistema; salidas escapadas según contexto.
- Queries parametrizadas (prohibido concatenar SQL).
- Sesiones con expiración, cookies HttpOnly/Secure/SameSite, regenerar al login, invalidar al logout.
- Mínimo privilegio en BD, API keys y rutas admin.
- Errores sin exponer información sensible (genérico al usuario, detalle al log).

### Proporcional al riesgo
- Datos personales o de pago → cifrado en reposo, auditoría, cumplimiento (GDPR / PCI).
- API pública → rate limiting, auth robusta (OAuth2 / JWT con expiración).
- Multiusuario → autorización por recurso en cada operación, no solo "está logueado".

## Ejemplos de uso

**Ejemplo 1:** Endpoint `GET /invoices/:id` en app multiusuario.
→ Riesgo crítico: IDOR — cualquier usuario logueado puede leer facturas ajenas. → Mitigación: verificar que `invoice.user_id == session.user_id` en el servidor.

**Ejemplo 2:** MVP interno sin datos sensibles pide "pentest completo".
→ Evaluación: riesgo bajo, etapa temprana. → Salida: aplicar solo los mínimos no negociables; el pentest formal se justifica al exponer la API públicamente.
