# 🛒 Playbook: Build E-commerce

## Skills involucradas
`business-analyst` → `product-manager` → `software-architect` → `security-engineer` → `performance-engineer`

## Fase 0 — ¿Construir o usar plataforma?
- Catálogo estándar → **Shopify / WooCommerce**. No construir.
- Construir solo si el modelo de venta es genuinamente atípico o el e-commerce es el core diferencial del negocio.

## Si se construye

### 1. Dominio mínimo
Catálogo → carrito → checkout → orden → pago. Nada más en v1.

### 2. Pagos (security-engineer)
- Stripe / proveedor local. **Nunca tocar datos de tarjeta** (PCI vía proveedor).
- Idempotencia en creación de órdenes y webhooks de pago.

### 3. Datos (database-architect)
- PostgreSQL; precios en enteros (centavos); órdenes inmutables (snapshot de precios).
- Inventario con control de concurrencia (no vender lo que no hay).

### 4. Rendimiento (performance-engineer)
- El catálogo es lectura intensiva: caché de páginas de producto cuando haya tráfico real.
- Imágenes optimizadas vía CDN.

## Qué NO hacer al inicio
Motor de recomendaciones, multi-moneda, multi-bodega, marketplace — hasta que el negocio lo pida.
