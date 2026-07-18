# Opcional 1 - Solucion propuesta

## 1) Problemas del diseno inicial (tabla unica `pos_general`)

### a) Insertar un proveedor sin ventas
En `pos_general`, el proveedor aparece junto con datos de venta, cliente, vendedor y producto.
Por eso, para registrar un proveedor sin venta se obliga a inventar o repetir columnas que no aplican.
Esto es una **anomalia de insercion**.

### b) Eliminar la ultima venta registrada
Si la ultima fila donde aparece un producto/proveedor/cliente se elimina, tambien se pierde
informacion maestra de esas entidades (por ejemplo, nombre del proveedor o ciudad).
Esto es una **anomalia de eliminacion**.

### c) Cambiar de ciudad un cliente
La ciudad del cliente esta repetida en multiples filas (una por venta y por producto vendido).
Actualizarla requiere cambiar muchas filas; si alguna queda sin actualizar, aparecen inconsistencias.
Esto es una **anomalia de actualizacion**.

## 2) Diseno ER (texto)

Entidades y relaciones principales:

- Departamento (1) -> (N) Ciudad
- Ciudad (1) -> (N) Cliente
- Ciudad (1) -> (N) Proveedor
- Ciudad (1) -> (N) Sucursal (opcional en este dataset)
- Sucursal (1) -> (N) Vendedor
- Proveedor (1) -> (N) Producto
- Categoria (1) -> (N) Producto
- Cliente (1) -> (N) Venta
- Vendedor (1) -> (N) Venta
- MetodoPago (1) -> (N) Venta
- Venta (1) -> (N) DetalleVenta
- Producto (1) -> (N) DetalleVenta

## 3) Dependencias funcionales (DF) del esquema original

DF relevantes en el esquema inicial:

1. `id_venta -> fecha, cliente_documento, vendedor_documento, metodo_pago, banco`
2. `cliente_documento -> cliente_nombre, cliente_ciudad, cliente_departamento, cliente_telefono`
3. `vendedor_documento -> vendedor_nombre, vendedor_sucursal`
4. `producto_codigo -> producto_nombre, categoria, proveedor_nombre, garantia_meses`
5. `proveedor_nombre -> proveedor_ciudad, proveedor_departamento`
6. `(id_venta, producto_codigo) -> cantidad, precio_unitario`

Esto evidencia dependencias parciales y transitivas cuando se guarda todo en una sola relacion.

## 4) Normalizacion hasta 3FN

Resumen del proceso:

1. **1FN**: atributos atomicos y filas por item vendido.
2. **2FN**: separar datos que no dependen de toda la clave compuesta de detalle.
3. **3FN**: eliminar dependencias transitivas (por ejemplo, ciudad->departamento, proveedor->ciudad).

Resultado: tablas maestras (`cliente`, `vendedor`, `producto`, `proveedor`, `ciudad`, etc.)
y tablas transaccionales (`venta`, `detalle_venta`) sin redundancia innecesaria.

## 5) Transformacion al modelo relacional (REL)

Relaciones finales implementadas en SQL:

- `departamento(id_departamento PK, nombre UQ)`
- `ciudad(id_ciudad PK, nombre, id_departamento FK, UQ(nombre,id_departamento))`
- `sucursal(id_sucursal PK, nombre UQ, id_ciudad FK NULL)`
- `cliente(documento PK, nombre, telefono, id_ciudad FK)`
- `vendedor(documento PK, nombre, id_sucursal FK)`
- `proveedor(id_proveedor PK, nombre UQ, id_ciudad FK)`
- `categoria(id_categoria PK, nombre UQ)`
- `producto(codigo PK, nombre, id_categoria FK, id_proveedor FK, garantia_meses)`
- `metodo_pago(id_metodo_pago PK, nombre UQ)`
- `venta(id_venta PK, fecha, cliente_documento FK, vendedor_documento FK, id_metodo_pago FK, banco)`
- `detalle_venta(id_venta FK, producto_codigo FK, cantidad, precio_unitario, PK(id_venta, producto_codigo))`

## Archivos SQL usados

- `10_opcional1_legacy_pos_general.sql`: esquema inicial + datos de ejemplo.
- `11_opcional1_modelo_3fn.sql`: modelo normalizado 3FN.
- `12_opcional1_migracion.sql`: migracion de datos de `pos_general` hacia el modelo 3FN.
