# ✅ Checklist: Security Review

## Mínimos no negociables
- [ ] Secretos fuera del código (variables de entorno / vault).
- [ ] HTTPS en todos los entornos públicos.
- [ ] Contraseñas con hashing fuerte (bcrypt / argon2).
- [ ] Queries parametrizadas en todo acceso a datos.
- [ ] Validación de entradas en el límite del sistema.

## Autenticación y autorización
- [ ] Tokens con expiración y renovación segura.
- [ ] Autorización verificada por recurso (no solo "está logueado").
- [ ] Sin IDs predecibles que permitan acceso a datos ajenos (IDOR).

## Datos
- [ ] Datos sensibles identificados y cifrados en reposo si aplica.
- [ ] Sin datos sensibles en logs.
- [ ] Cumplimiento aplicable revisado (GDPR / PCI / sectorial).

## Superficie
- [ ] Dependencias sin vulnerabilidades conocidas (npm audit / equivalente).
- [ ] Rate limiting en endpoints públicos y de login.
- [ ] Headers de seguridad configurados (CSP, HSTS, etc.).
