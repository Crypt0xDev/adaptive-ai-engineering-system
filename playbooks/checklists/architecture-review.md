# ✅ Checklist: Architecture Review

## Contexto
- [ ] ¿La arquitectura corresponde a la etapa real del proyecto (escalera de `core/decision-rules.md`)?
- [ ] ¿Cada componente tiene una justificación de negocio en una frase?
- [ ] ¿Está documentado qué NO se hará y por qué?

## Simplicidad
- [ ] ¿Se puede eliminar alguna capa o servicio sin perder funcionalidad?
- [ ] ¿Hay abstracciones sin segundo consumidor?
- [ ] ¿Se evitaron microservicios sin límites de dominio probados?

## Evolución
- [ ] ¿Las decisiones irreversibles (BD, API pública, contratos) están documentadas en `knowledge/`?
- [ ] ¿Hay señales definidas que indicarían cuándo evolucionar al siguiente nivel?

## Riesgos
- [ ] ¿Identificado el punto único de fallo más probable?
- [ ] ¿Las integraciones externas tienen manejo de fallo?
