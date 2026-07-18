-- Opcional 1 - Esquema original (desnormalizado) + datos de ejemplo

DROP TABLE IF EXISTS pos_general;
DROP TYPE IF EXISTS mpago;

CREATE TYPE mpago AS ENUM (
    'efectivo',
    'tarjeta_credito',
    'tarjeta_debito',
    'transferencia',
    'billetera_digital'
);

CREATE TABLE pos_general (
    id_venta INTEGER NOT NULL,
    fecha TIMESTAMP NOT NULL,
    cliente_documento VARCHAR(20),
    cliente_nombre VARCHAR(100),
    cliente_ciudad VARCHAR(50),
    cliente_departamento VARCHAR(50),
    cliente_telefono VARCHAR(20),
    vendedor_documento VARCHAR(20),
    vendedor_nombre VARCHAR(100),
    vendedor_sucursal VARCHAR(100),
    producto_codigo VARCHAR(20),
    producto_nombre VARCHAR(100),
    categoria VARCHAR(50),
    proveedor_nombre VARCHAR(100),
    proveedor_ciudad VARCHAR(50),
    proveedor_departamento VARCHAR(50),
    cantidad INTEGER CHECK (cantidad > 0),
    precio_unitario NUMERIC(10,2) CHECK (precio_unitario >= 0),
    metodo_pago mpago NOT NULL,
    banco VARCHAR(50),
    garantia_meses INTEGER CHECK (garantia_meses >= 0)
);

INSERT INTO pos_general (
    id_venta, fecha, cliente_documento, cliente_nombre, cliente_ciudad, cliente_departamento, cliente_telefono,
    vendedor_documento, vendedor_nombre, vendedor_sucursal,
    producto_codigo, producto_nombre, categoria,
    proveedor_nombre, proveedor_ciudad, proveedor_departamento,
    cantidad, precio_unitario, metodo_pago, banco, garantia_meses
)
VALUES
(1001, '2026-06-01 10:15:00', 'C001', 'Ana Ruiz', 'Cali', 'Valle del Cauca', '3001111111', 'V001', 'Mario Diaz', 'Centro', 'P001', 'Arroz 1kg', 'Granos', 'Alimentos del Sur', 'Cali', 'Valle del Cauca', 2, 5200, 'efectivo', NULL, 0),
(1001, '2026-06-01 10:15:00', 'C001', 'Ana Ruiz', 'Cali', 'Valle del Cauca', '3001111111', 'V001', 'Mario Diaz', 'Centro', 'P002', 'Frijol 1kg', 'Granos', 'Alimentos del Sur', 'Cali', 'Valle del Cauca', 1, 7600, 'efectivo', NULL, 0),
(1002, '2026-06-01 11:05:00', 'C002', 'Luis Perez', 'Palmira', 'Valle del Cauca', '3002222222', 'V002', 'Lucia Rojas', 'Norte', 'P003', 'Leche 1L', 'Lacteos', 'Lacteos Andinos', 'Medellin', 'Antioquia', 3, 4300, 'tarjeta_debito', 'Banco de Bogota', 0),
(1003, '2026-06-02 09:30:00', 'C003', 'Sofia Gomez', 'Cali', 'Valle del Cauca', '3003333333', 'V001', 'Mario Diaz', 'Centro', 'P004', 'Detergente 500g', 'Aseo', 'Hogar Plus', 'Bogota', 'Cundinamarca', 2, 9800, 'tarjeta_credito', 'Bancolombia', 6),
(1004, '2026-06-02 16:40:00', 'C004', 'Carlos Mina', 'Yumbo', 'Valle del Cauca', '3004444444', 'V003', 'Diana Toro', 'Sur', 'P005', 'Aceite 1L', 'Despensa', 'Aceites del Pacifico', 'Buenaventura', 'Valle del Cauca', 1, 13200, 'transferencia', 'Davivienda', 0),
(1005, '2026-06-03 13:20:00', 'C005', 'Marta Leon', 'Cali', 'Valle del Cauca', '3005555555', 'V002', 'Lucia Rojas', 'Norte', 'P003', 'Leche 1L', 'Lacteos', 'Lacteos Andinos', 'Medellin', 'Antioquia', 2, 4300, 'billetera_digital', 'Nequi', 0),
(1006, '2026-06-03 15:00:00', 'C001', 'Ana Ruiz', 'Cali', 'Valle del Cauca', '3001111111', 'V001', 'Mario Diaz', 'Centro', 'P006', 'Cafe 250g', 'Despensa', 'Cafe Dorado', 'Manizales', 'Caldas', 1, 12500, 'tarjeta_debito', 'Banco de Bogota', 0),
(1007, '2026-06-04 08:45:00', 'C006', 'Pedro Arias', 'Palmira', 'Valle del Cauca', '3006666666', 'V003', 'Diana Toro', 'Sur', 'P007', 'Pan tajado', 'Panaderia', 'Panes del Valle', 'Palmira', 'Valle del Cauca', 4, 3600, 'efectivo', NULL, 0);
