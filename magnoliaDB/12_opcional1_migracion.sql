-- Opcional 1 - Migracion de datos desde pos_general al modelo 3FN

INSERT INTO departamento (nombre)
SELECT DISTINCT d.nombre
FROM (
    SELECT TRIM(cliente_departamento) AS nombre
    FROM pos_general
    WHERE cliente_departamento IS NOT NULL AND TRIM(cliente_departamento) <> ''
    UNION
    SELECT TRIM(proveedor_departamento) AS nombre
    FROM pos_general
    WHERE proveedor_departamento IS NOT NULL AND TRIM(proveedor_departamento) <> ''
) AS d
ON CONFLICT (nombre) DO NOTHING;

INSERT INTO ciudad (nombre, id_departamento)
SELECT DISTINCT
    TRIM(c.nombre) AS nombre,
    d.id_departamento
FROM (
    SELECT cliente_ciudad AS nombre, cliente_departamento AS departamento
    FROM pos_general
    UNION
    SELECT proveedor_ciudad AS nombre, proveedor_departamento AS departamento
    FROM pos_general
) AS c
JOIN departamento AS d
  ON d.nombre = TRIM(c.departamento)
WHERE c.nombre IS NOT NULL
  AND TRIM(c.nombre) <> ''
  AND c.departamento IS NOT NULL
  AND TRIM(c.departamento) <> ''
ON CONFLICT (nombre, id_departamento) DO NOTHING;

INSERT INTO sucursal (nombre)
SELECT DISTINCT TRIM(vendedor_sucursal)
FROM pos_general
WHERE vendedor_sucursal IS NOT NULL AND TRIM(vendedor_sucursal) <> ''
ON CONFLICT (nombre) DO NOTHING;

INSERT INTO cliente (documento, nombre, telefono, id_ciudad)
SELECT DISTINCT
    TRIM(pg.cliente_documento) AS documento,
    TRIM(pg.cliente_nombre) AS nombre,
    NULLIF(TRIM(pg.cliente_telefono), '') AS telefono,
    c.id_ciudad
FROM pos_general AS pg
LEFT JOIN departamento AS d
  ON d.nombre = TRIM(pg.cliente_departamento)
LEFT JOIN ciudad AS c
  ON c.nombre = TRIM(pg.cliente_ciudad)
 AND c.id_departamento = d.id_departamento
WHERE pg.cliente_documento IS NOT NULL
  AND TRIM(pg.cliente_documento) <> ''
ON CONFLICT (documento) DO UPDATE
SET nombre = EXCLUDED.nombre,
    telefono = EXCLUDED.telefono,
    id_ciudad = EXCLUDED.id_ciudad;

INSERT INTO vendedor (documento, nombre, id_sucursal)
SELECT DISTINCT
    TRIM(pg.vendedor_documento) AS documento,
    TRIM(pg.vendedor_nombre) AS nombre,
    s.id_sucursal
FROM pos_general AS pg
JOIN sucursal AS s
  ON s.nombre = TRIM(pg.vendedor_sucursal)
WHERE pg.vendedor_documento IS NOT NULL
  AND TRIM(pg.vendedor_documento) <> ''
ON CONFLICT (documento) DO UPDATE
SET nombre = EXCLUDED.nombre,
    id_sucursal = EXCLUDED.id_sucursal;

INSERT INTO proveedor (nombre, id_ciudad)
SELECT DISTINCT
    TRIM(pg.proveedor_nombre) AS nombre,
    c.id_ciudad
FROM pos_general AS pg
LEFT JOIN departamento AS d
  ON d.nombre = TRIM(pg.proveedor_departamento)
LEFT JOIN ciudad AS c
  ON c.nombre = TRIM(pg.proveedor_ciudad)
 AND c.id_departamento = d.id_departamento
WHERE pg.proveedor_nombre IS NOT NULL
  AND TRIM(pg.proveedor_nombre) <> ''
ON CONFLICT (nombre) DO UPDATE
SET id_ciudad = EXCLUDED.id_ciudad;

INSERT INTO categoria (nombre)
SELECT DISTINCT TRIM(categoria)
FROM pos_general
WHERE categoria IS NOT NULL AND TRIM(categoria) <> ''
ON CONFLICT (nombre) DO NOTHING;

INSERT INTO producto (codigo, nombre, id_categoria, id_proveedor, garantia_meses)
SELECT DISTINCT
    TRIM(pg.producto_codigo) AS codigo,
    TRIM(pg.producto_nombre) AS nombre,
    c.id_categoria,
    p.id_proveedor,
    COALESCE(pg.garantia_meses, 0) AS garantia_meses
FROM pos_general AS pg
JOIN categoria AS c
  ON c.nombre = TRIM(pg.categoria)
JOIN proveedor AS p
  ON p.nombre = TRIM(pg.proveedor_nombre)
WHERE pg.producto_codigo IS NOT NULL
  AND TRIM(pg.producto_codigo) <> ''
ON CONFLICT (codigo) DO UPDATE
SET nombre = EXCLUDED.nombre,
    id_categoria = EXCLUDED.id_categoria,
    id_proveedor = EXCLUDED.id_proveedor,
    garantia_meses = EXCLUDED.garantia_meses;

INSERT INTO metodo_pago (nombre)
VALUES
('efectivo'),
('tarjeta_credito'),
('tarjeta_debito'),
('transferencia'),
('billetera_digital')
ON CONFLICT (nombre) DO NOTHING;

INSERT INTO venta (id_venta, fecha, cliente_documento, vendedor_documento, id_metodo_pago, banco)
SELECT DISTINCT
    pg.id_venta,
    pg.fecha,
    TRIM(pg.cliente_documento) AS cliente_documento,
    TRIM(pg.vendedor_documento) AS vendedor_documento,
    mp.id_metodo_pago,
    NULLIF(TRIM(pg.banco), '') AS banco
FROM pos_general AS pg
JOIN metodo_pago AS mp
  ON mp.nombre = CAST(pg.metodo_pago AS VARCHAR)
WHERE pg.id_venta IS NOT NULL
  AND pg.cliente_documento IS NOT NULL
  AND pg.vendedor_documento IS NOT NULL
ON CONFLICT (id_venta) DO UPDATE
SET fecha = EXCLUDED.fecha,
    cliente_documento = EXCLUDED.cliente_documento,
    vendedor_documento = EXCLUDED.vendedor_documento,
    id_metodo_pago = EXCLUDED.id_metodo_pago,
    banco = EXCLUDED.banco;

INSERT INTO detalle_venta (id_venta, producto_codigo, cantidad, precio_unitario)
SELECT
    pg.id_venta,
    TRIM(pg.producto_codigo) AS producto_codigo,
    pg.cantidad,
    pg.precio_unitario
FROM pos_general AS pg
WHERE pg.id_venta IS NOT NULL
  AND pg.producto_codigo IS NOT NULL
  AND TRIM(pg.producto_codigo) <> ''
ON CONFLICT (id_venta, producto_codigo) DO UPDATE
SET cantidad = EXCLUDED.cantidad,
    precio_unitario = EXCLUDED.precio_unitario;
