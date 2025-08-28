# M5\_AE3\_ABP — Clientes y Pedidos (MySQL 8.x)

## ✅ Qué hace el script

1. **Crea** la base `clientes_pedidos_db` y hace `USE`.
2. **Limpia** tablas si existían (`DROP TABLE IF EXISTS` en orden seguro).
3. **Crea** el modelo ERD:

   * `clientes(id PK, nombre, direccion, telefono)`
   * `pedidos(id PK, cliente_id FK→clientes.id, fecha, total)` con `ON DELETE/UPDATE CASCADE`
4. **Inserta** 5 clientes y 10 pedidos.
5. **Ejecuta consultas** que pide el ejercicio:

   * Clientes con sus pedidos.
   * Pedidos por cliente específico (filtrado por `cliente_id`).
   * Totales por cliente (cantidad y suma).
   * `UPDATE` de dirección por `id`.
   * `DELETE` de un cliente y (por cascada) sus pedidos.
   * Top 3 clientes por cantidad de pedidos.

---

## 🛠 Requisitos

* **MySQL 8.x** (o 5.7 con InnoDB).
* Usuario con permisos para `CREATE DATABASE` (si no, usa una BD existente y elimina la parte de creación).
* Cliente: **MySQL Workbench**, **phpMyAdmin** o **CLI**.

---

## ▶️ Cómo ejecutarlo

### Opción A: MySQL Workbench / phpMyAdmin

1. Abre el archivo `.sql`.
2. Conéctate a tu servidor MySQL.
3. Ejecuta **todo** el script (Run All).
4. Verifica que la salida de:

   ```sql
   SELECT DATABASE();
   ```

   muestre `clientes_pedidos_db`.

### Opción B: CLI

```bash
mysql -u <usuario> -p
# luego, en el prompt:
SOURCE /ruta/al/archivo.sql;
```

---

## 🔎 Qué puedes cambiar fácilmente

* Consultar otro cliente en la sección “Pedidos por cliente específico”:

  ```sql
  -- Cambia 3 por el ID que quieras
  WHERE cliente_id = 3
  ```
* Dirección a actualizar:

  ```sql
  -- Cambia el texto y/o el id
  SET direccion = 'Nueva Dirección 123'
  WHERE id = 2;
  ```
* Cliente a eliminar (y sus pedidos por cascada):

  ```sql
  DELETE FROM clientes WHERE id = 5;
  ```

---

## ✅ Verificaciones rápidas

* ¿Se creó la BD?

  ```sql
  SELECT DATABASE();                -- debe ser clientes_pedidos_db
  SHOW DATABASES LIKE 'clientes_pedidos_db';
  ```
* ¿Existen las tablas?

  ```sql
  SHOW TABLES;
  DESCRIBE clientes;
  DESCRIBE pedidos;
  ```
* ¿Se insertaron datos?

  ```sql
  SELECT * FROM clientes;
  SELECT * FROM pedidos;
  ```

---

## 🧰 Troubleshooting

* **“Access denied; you need (at least) the CREATE privilege”**
  Tu usuario no puede crear BDs. Quita el bloque `CREATE DATABASE …; USE …;` y reemplázalo por `USE <tu_bd_existente>;`.
* **Errores de sintaxis tipo “Incorrect syntax near …”**
  Estás conectado a **SQL Server (MSSQL)**. Cambia la conexión a **MySQL** (puerto 3306) o usa Workbench/phpMyAdmin.
* **Error de FK al crear `pedidos`**
  Asegúrate de ejecutar en orden y que `clientes` exista antes. El script ya lo hace; si corriste por partes, vuelve a ejecutarlo completo.
* **No ves resultados**
  Ejecuta por bloques y revisa cada `SELECT` de verificación incluido en el script.

---



* `clientes_pedidos_db.sql` 
* `README.md` 


