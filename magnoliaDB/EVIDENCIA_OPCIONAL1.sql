-- Evidencia SQL - Opcional 1
-- Ejecutar con:
-- docker exec magnolia_opcional1_db psql -U u_magnolia -d db_magnolia -f /docker-entrypoint-initdb.d/EVIDENCIA_OPCIONAL1.sql
-- (o copiar/pegar cada bloque en psql)

-- ============================================================
-- A) Consistencia del modelo 3FN
-- ============================================================
SELECT 'clientes_duplicados_por_documento' AS control, COUNT(*) AS casos
FROM (
    SELECT documento
    FROM cliente
    GROUP BY documento
    HAVING COUNT(*) > 1
) t
UNION ALL
SELECT 'productos_duplicados_por_codigo', COUNT(*)
FROM (
    SELECT codigo
    FROM producto
    GROUP BY codigo
    HAVING COUNT(*) > 1
) t
UNION ALL
SELECT 'ventas_sin_cliente', COUNT(*)
FROM venta v
LEFT JOIN cliente c ON c.documento = v.cliente_documento
WHERE c.documento IS NULL
UNION ALL
SELECT 'detalles_sin_venta', COUNT(*)
FROM detalle_venta dv
LEFT JOIN venta v ON v.id_venta = dv.id_venta
WHERE v.id_venta IS NULL
UNION ALL
SELECT 'detalles_sin_producto', COUNT(*)
FROM detalle_venta dv
LEFT JOIN producto p ON p.codigo = dv.producto_codigo
WHERE p.codigo IS NULL;

-- ============================================================
-- B) Anomalia de insercion en esquema original (pos_general)
-- Insertar proveedor sin venta fuerza filas incompletas
-- ============================================================
BEGIN;
CREATE TEMP TABLE pg_demo AS
SELECT * FROM pos_general;

INSERT INTO pg_demo (id_venta, fecha, proveedor_nombre, metodo_pago)
VALUES (9999, NOW(), 'Proveedor Sin Venta', 'efectivo');

SELECT
    'insert_proveedor_sin_venta_filas_incompletas' AS caso,
    id_venta,
    cliente_documento,
    vendedor_documento,
    producto_codigo,
    proveedor_nombre
FROM pg_demo
WHERE id_venta = 9999;
ROLLBACK;

-- ============================================================
-- C) Anomalia de eliminacion en esquema original (pos_general)
-- Eliminar una venta puede borrar la unica evidencia de un producto/proveedor
-- ============================================================
BEGIN;
CREATE TEMP TABLE pg_demo AS
SELECT * FROM pos_general;

SELECT 'antes' AS momento, COUNT(*) AS filas_producto_p007
FROM pg_demo
WHERE producto_codigo = 'P007';

DELETE FROM pg_demo
WHERE id_venta = 1007;

SELECT 'despues' AS momento, COUNT(*) AS filas_producto_p007
FROM pg_demo
WHERE producto_codigo = 'P007';
ROLLBACK;

-- ============================================================
-- D) Anomalia de actualizacion en esquema original (pos_general)
-- Una actualizacion parcial deja el mismo cliente en dos ciudades
-- ============================================================
BEGIN;
CREATE TEMP TABLE pg_demo AS
SELECT * FROM pos_general;

SELECT
    'antes' AS momento,
    cliente_documento,
    COUNT(*) AS filas,
    STRING_AGG(DISTINCT cliente_ciudad, ', ') AS ciudades
FROM pg_demo
WHERE cliente_documento = 'C001'
GROUP BY cliente_documento;

-- Actualiza solo parte de las filas del cliente (inconsistencia)
UPDATE pg_demo
SET cliente_ciudad = 'Bogota'
WHERE cliente_documento = 'C001'
  AND id_venta = 1001;

SELECT
    'despues_actualizacion_parcial' AS momento,
    cliente_documento,
    COUNT(*) AS filas,
    STRING_AGG(DISTINCT cliente_ciudad, ', ') AS ciudades
FROM pg_demo
WHERE cliente_documento = 'C001'
GROUP BY cliente_documento;
ROLLBACK;
