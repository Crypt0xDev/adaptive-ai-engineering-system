---
name: ahorro-tokens-archivos
description: "Estrategia obligatoria para leer o generar archivos PDF, Word (.docx), Excel (.xlsx) y PowerPoint (.pptx) minimizando el consumo de tokens y sin perder contexto. Úsala SIEMPRE que el usuario suba, mencione o pida analizar/resumir/leer un archivo pdf, word, excel o ppt/pptx, especialmente si son trabajos universitarios largos y desestructurados (sin índice claro). También al generar o editar estos formatos, para evitar volcar el archivo completo al contexto en cada paso. Se aplica ANTES de las skills docx/pdf/pptx/xlsx: define CÓMO leerlos/editarlos barato, no cómo darles formato."
---

# Ahorro de tokens en archivos PDF / Word / Excel / PPT

## Principio central

**Nunca volcar un archivo completo al contexto de una.** Primero un vistazo barato (estructura + resumen corto), después profundizar solo en lo que el usuario realmente necesita. Un PDF/Word universitario desestructurado puede tener 20-50k+ tokens de texto plano; leerlo entero cuando solo hace falta una sección es tirar tokens.

## Flujo de LECTURA (2 pasos, siempre)

### Paso 1 — Vistazo barato (obligatorio, primero)

Según el tipo de archivo, extraer SOLO esto, nunca el texto completo:

- **PDF**: número de páginas + primeras líneas de cada página o bloque grande para detectar dónde arrancan las secciones. Con texto seleccionable, extracción por página; OCR/rasterizado solo si es escaneado.
- **Word (.docx)**: lista de headings/títulos (si hay estilos) o, sin estructura, el primer renglón de cada párrafo largo, para armar un mapa aproximado.
- **Excel (.xlsx)**: nombres de hojas + dimensiones (filas × columnas) + encabezados + 2-3 filas de muestra por hoja. Nunca cargar todas las filas.
- **PowerPoint (.pptx)**: título de cada slide + primera línea de notas si existen. No extraer el body completo de cada slide todavía.

Con eso, armar un resumen corto (pocas líneas por página/sección/hoja/slide) y mostrarlo.

### Paso 2 — Profundización dirigida (solo si hace falta)

Preguntar (o inferir si es obvio por el pedido) qué parte se necesita a fondo, y ahí sí extraer el texto/datos completos SOLO de esa sección/hoja/slide, no del archivo entero.

Si el pedido ya es específico ("resumime la conclusión", "dame la hoja Ventas"), saltear la pregunta y extraer directo esa parte, con el mismo filtro de "solo lo necesario".

### Excepción

Si el archivo es corto (pocas páginas / una hoja chica / pocas slides), el vistazo y la profundización colapsan en un solo paso. No hace falta burocracia para un PDF de 2 páginas.

## Flujo de GENERACIÓN / EDICIÓN

Para formato y contenido, usar las skills correspondientes (`docx`, `pdf`, `pptx`, `xlsx`); esta skill solo agrega disciplina de tokens alrededor:

- Al editar un archivo ya generado, no releerlo completo para verificar un cambio chico: usar búsqueda puntual (grep / str_replace con contexto acotado), no `view` sin rango.
- Si hace falta confirmar estructura antes de editar (qué heading existe, qué columna tiene qué hoja), aplicar el Paso 1 de arriba.
- Al iterar en varias rondas de feedback sobre un documento largo, no repetir la lectura completa en cada ronda: mantener en contexto lo ya extraído y pedir solo el delta.

## Qué NO hacer

- No usar `cat`/`view` sin rango sobre un PDF/Word/Excel/PPT grande "para revisar todo".
- No convertir el documento entero a texto plano cuando el pedido es puntual ("¿qué dice la página 5?").
- No re-extraer un archivo ya leído en el mismo hilo si la parte pedida ya está en contexto.
- No usar OCR/rasterizado en PDFs que ya tienen texto seleccionable.

## Se aplica junto con

- **redaccion-academica** — cuando el archivo leído es fuente de un trabajo académico, esta skill hace la lectura barata y aquella define cómo citarlo.
- **docx / pdf / pptx / xlsx** — para el formato de salida; esta skill decide cuánto leer antes de invocarlas.
