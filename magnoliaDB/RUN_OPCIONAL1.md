# Como levantar el contenedor (Opcional 1)

## 1) Construir y ejecutar

Desde la carpeta `magnoliaDB`:

```powershell
docker compose -f docker-compose.opcional1.yml up -d --build
```

## 2) Verificar estado

```powershell
docker ps --filter "name=magnolia_opcional1_db"
docker logs magnolia_opcional1_db --tail 80
```

## 3) Conectarse con psql

```powershell
docker exec -it magnolia_opcional1_db psql -U u_magnolia -d db_magnolia
```

## 4) Verificar carga del modelo

Dentro de `psql`:

```sql
SELECT COUNT(*) AS filas_pos_general FROM pos_general;
SELECT COUNT(*) AS clientes FROM cliente;
SELECT COUNT(*) AS productos FROM producto;
SELECT COUNT(*) AS ventas FROM venta;
SELECT COUNT(*) AS detalle_venta FROM detalle_venta;
```

## 5) Bajar contenedor

```powershell
docker compose -f docker-compose.opcional1.yml down
```

Para borrar tambien el volumen de datos:

```powershell
docker compose -f docker-compose.opcional1.yml down -v
```
