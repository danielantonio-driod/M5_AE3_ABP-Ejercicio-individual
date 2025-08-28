-- ==========================================================
-- M5_AE3_ABP — Clientes y Pedidos (MySQL 8.x)
-- Script único: crea BD, tablas, inserta datos y corre consultas
-- ==========================================================

/* ----------------------------------------------------------
   0) Crear y usar la base de datos (verificación incluida)
-----------------------------------------------------------*/
CREATE DATABASE IF NOT EXISTS clientes_pedidos_db
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE clientes_pedidos_db;

-- Verificación rápida
SELECT DATABASE() AS base_actual;
-- Debe mostrar: clientes_pedidos_db

/* ----------------------------------------------------------
   1) Limpiar tablas en orden seguro (por si ya existen)
-----------------------------------------------------------*/
SET FOREIGN_KEY_CHECKS =0;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS clientes;
SET FOREIGN_KEY_CHECKS = 1;

/* ----------------------------------------------------------
   2) Crear tablas según el ERD
      clientes 1..N pedidos
-----------------------------------------------------------*/
CREATE TABLE clientes (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(150),
  telefono VARCHAR(20),
  PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE pedidos (
  id INT NOT NULL AUTO_INCREMENT,
  cliente_id INT NOT NULL,
  fecha DATE NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id),
  INDEX idx_pedidos_cliente_id (cliente_id),
  CONSTRAINT fk_pedidos_clientes
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Verificación de estructura
SHOW TABLES;
DESCRIBE clientes;
DESCRIBE pedidos;

/* ----------------------------------------------------------
   3) Insertar al menos 5 clientes
-----------------------------------------------------------*/
INSERT INTO clientes (nombre, direccion, telefono) VALUES
('Ana García',     'Av. Central 123',      '911111111'),
('Luis Pérez',     'Calle Norte 456',      '922222222'),
('María López',    'Pasaje Sur 789',       '933333333'),
('Carlos Díaz',    'Av. Pacífico 321',     '944444444'),
('Javiera Torres', 'Camino Los Andes 654', '955555555');

-- Verificar
SELECT * FROM clientes ORDER BY id;

/* ----------------------------------------------------------
   4) Insertar al menos 10 pedidos (cliente_id asignado)
-----------------------------------------------------------*/
INSERT INTO pedidos (cliente_id, fecha, total) VALUES
(1, '2025-08-01', 120.00),
(1, '2025-08-10',  75.50),
(2, '2025-08-03', 210.00),
(2, '2025-08-12',  59.90),
(3, '2025-08-05',  99.99),
(3, '2025-08-15', 350.00),
(3, '2025-08-20',  49.90),
(4, '2025-08-07', 500.00),
(5, '2025-08-09',  25.00),
(5, '2025-08-18', 199.90);

-- Verificar
SELECT * FROM pedidos ORDER BY id;

/* ----------------------------------------------------------
   5) Proyectar todos los clientes y sus respectivos pedidos
-----------------------------------------------------------*/
SELECT
  c.id   AS cliente_id,
  c.nombre,
  p.id   AS pedido_id,
  p.fecha,
  p.total
FROM clientes c
JOIN pedidos  p ON p.cliente_id = c.id
ORDER BY c.id, p.fecha;

/* ----------------------------------------------------------
   6) Proyectar todos los pedidos de un cliente específico (por ID)
      Cambia el valor del WHERE si quieres otro cliente
-----------------------------------------------------------*/
SELECT id AS pedido_id, fecha, total
FROM pedidos
WHERE cliente_id = 3
ORDER BY fecha;

/* ----------------------------------------------------------
   7) Calcular el total de todos los pedidos para cada cliente
-----------------------------------------------------------*/
SELECT
  c.id        AS cliente_id,
  c.nombre,
  COUNT(p.id)                 AS cantidad_pedidos,
  COALESCE(SUM(p.total),0.00) AS total_pedidos
FROM clientes c
LEFT JOIN pedidos p ON p.cliente_id = c.id
GROUP BY c.id, c.nombre
ORDER BY c.id;

/* ----------------------------------------------------------
   8) Actualizar la dirección de un cliente dado su id
-----------------------------------------------------------*/
UPDATE clientes
SET direccion = 'Nueva Dirección 123'
WHERE id = 2;

-- Verificar
SELECT * FROM clientes WHERE id = 2;

/* ----------------------------------------------------------
   9) Eliminar un cliente específico y todos sus pedidos asociados
      (gracias a ON DELETE CASCADE)
-----------------------------------------------------------*/
DELETE FROM clientes
WHERE id = 5;

-- Verificar que se borró el cliente y sus pedidos
SELECT * FROM clientes WHERE id = 5;
SELECT * FROM pedidos  WHERE cliente_id = 5;

/* ----------------------------------------------------------
   10) Proyectar los tres clientes con más pedidos (descendente)
-----------------------------------------------------------*/
SELECT
  c.id        AS cliente_id,
  c.nombre,
  COUNT(p.id) AS cantidad_pedidos
FROM clientes c
LEFT JOIN pedidos p ON p.cliente_id = c.id
GROUP BY c.id, c.nombre
ORDER BY cantidad_pedidos DESC, c.id ASC
LIMIT 3;

-- ======================= FIN DEL SCRIPT =======================
