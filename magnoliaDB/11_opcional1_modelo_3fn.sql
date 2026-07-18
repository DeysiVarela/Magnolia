-- Opcional 1 - Modelo relacional normalizado en 3FN

DROP TABLE IF EXISTS detalle_venta;
DROP TABLE IF EXISTS venta;
DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS categoria;
DROP TABLE IF EXISTS proveedor;
DROP TABLE IF EXISTS vendedor;
DROP TABLE IF EXISTS sucursal;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS ciudad;
DROP TABLE IF EXISTS departamento;
DROP TABLE IF EXISTS metodo_pago;

CREATE TABLE departamento (
    id_departamento BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE ciudad (
    id_ciudad BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    id_departamento BIGINT NOT NULL REFERENCES departamento(id_departamento),
    UNIQUE (nombre, id_departamento)
);

CREATE TABLE sucursal (
    id_sucursal BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    id_ciudad BIGINT REFERENCES ciudad(id_ciudad)
);

CREATE TABLE cliente (
    documento VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    id_ciudad BIGINT REFERENCES ciudad(id_ciudad)
);

CREATE TABLE vendedor (
    documento VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_sucursal BIGINT NOT NULL REFERENCES sucursal(id_sucursal)
);

CREATE TABLE proveedor (
    id_proveedor BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    id_ciudad BIGINT REFERENCES ciudad(id_ciudad)
);

CREATE TABLE categoria (
    id_categoria BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE producto (
    codigo VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_categoria BIGINT NOT NULL REFERENCES categoria(id_categoria),
    id_proveedor BIGINT NOT NULL REFERENCES proveedor(id_proveedor),
    garantia_meses INTEGER NOT NULL DEFAULT 0 CHECK (garantia_meses >= 0)
);

CREATE TABLE metodo_pago (
    id_metodo_pago SMALLSERIAL PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE venta (
    id_venta INTEGER PRIMARY KEY,
    fecha TIMESTAMP NOT NULL,
    cliente_documento VARCHAR(20) NOT NULL REFERENCES cliente(documento),
    vendedor_documento VARCHAR(20) NOT NULL REFERENCES vendedor(documento),
    id_metodo_pago SMALLINT NOT NULL REFERENCES metodo_pago(id_metodo_pago),
    banco VARCHAR(50)
);

CREATE TABLE detalle_venta (
    id_venta INTEGER NOT NULL REFERENCES venta(id_venta) ON DELETE CASCADE,
    producto_codigo VARCHAR(20) NOT NULL REFERENCES producto(codigo),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(10,2) NOT NULL CHECK (precio_unitario >= 0),
    PRIMARY KEY (id_venta, producto_codigo)
);
