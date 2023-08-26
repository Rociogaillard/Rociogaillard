-- Creación de base de datos y tabla
CREATE DATABASE gaillard;

USE gaillard;

CREATE TABLE IF NOT EXISTS gaillard.revendedor (
	id_revendedor INT AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    fecha_ingreso DATETIME NOT NULL,
    nivel VARCHAR(10),
    PRIMARY KEY (id_revendedor),
    INDEX nombre (nombre, apellido)
);

CREATE TABLE IF NOT EXISTS gaillard.email (
	id_email INT AUTO_INCREMENT,
    id_revendedor INT,
    email VARCHAR(120) NOT NULL,
    email_principal TINYINT DEFAULT 1,
    CONSTRAINT fk_email_revendedor FOREIGN KEY (id_revendedor) REFERENCES revendedor (id_revendedor) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uni_email UNIQUE (email),
	PRIMARY KEY (id_email)
    );
    
    CREATE TABLE IF NOT EXISTS gaillard.telefono (
	id_telefono INT AUTO_INCREMENT,
    id_revendedor INT,
    telefono INT NOT NULL,
    telefono_principal TINYINT DEFAULT 1,
    CONSTRAINT fk_telefono_revendedor FOREIGN KEY (id_revendedor) REFERENCES revendedor (id_revendedor) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id_telefono)
    );
    
    
    CREATE TABLE IF NOT EXISTS gaillard.direccion (
	id_direccion INT AUTO_INCREMENT,
    id_revendedor INT,
    direccion VARCHAR(200) NOT NULL,
    cod_postal VARCHAR(10) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    provincia VARCHAR(50) NOT NULL,
    pais VARCHAR(50) DEFAULT 'ARGENTINA',
    direccion_principal TINYINT DEFAULT 1,
    CONSTRAINT fk_direccion_revendedor FOREIGN KEY (id_revendedor) REFERENCES revendedor (id_revendedor) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id_direccion)
);

CREATE TABLE IF NOT EXISTS gaillard.categoria_producto (
id_categoria INT AUTO_INCREMENT,
categoria VARCHAR(50) NOT NULL,
PRIMARY KEY (id_categoria)
); 

CREATE TABLE IF NOT EXISTS gaillard.marca_producto (
id_marca INT AUTO_INCREMENT,
marca VARCHAR(50) NOT NULL,
PRIMARY KEY (id_marca)
);

CREATE TABLE IF NOT EXISTS gaillard.producto (
	id_producto INT AUTO_INCREMENT,
    id_categoria INT NOT NULL,
    id_marca INT NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    tipo_comercial VARCHAR(30) NOT NULL,
    precio INT NOT NULL,
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria_producto (id_categoria) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_producto_marca FOREIGN KEY (id_marca) REFERENCES marca_producto (id_marca) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id_producto)
    );
    
        
CREATE TABLE IF NOT EXISTS gaillard.flete (
	id_flete INT AUTO_INCREMENT,
    id_direccion INT NOT NULL,
    tasa DECIMAL(11,2) NOT NULL,
    CONSTRAINT fk_valor_flete FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id_flete)
    );
    
CREATE TABLE IF NOT EXISTS gaillard.comision (
	id_comision INT AUTO_INCREMENT,
    id_revendedor INT NOT NULL,
    comision DECIMAL(11,2) NOT NULL,
    CONSTRAINT fk_comision_revendedor FOREIGN KEY (id_revendedor) REFERENCES revendedor (id_revendedor) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id_comision)
    );
      
    
CREATE TABLE IF NOT EXISTS gaillard.factura (
id_factura INT AUTO_INCREMENT,
id_revendedor INT NOT NULL,
subtotal DECIMAL(11,2) DEFAULT 0,
iva DECIMAL(11,2) DEFAULT 0, 
total DECIMAL(11,2) DEFAULT 0,
fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP(),
CONSTRAINT fk_factura_revendedor FOREIGN KEY (id_revendedor) REFERENCES revendedor (id_revendedor) ON DELETE RESTRICT ON UPDATE CASCADE,
PRIMARY KEY (id_factura)
); 
    
	CREATE TABLE IF NOT EXISTS gaillard.pedido (
	id_pedido INT AUTO_INCREMENT,
    id_revendedor INT NOT NULL,
    id_factura INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio INT NOT NULL,
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP(),
    CONSTRAINT fk_revendedor_pedido FOREIGN KEY (id_revendedor) REFERENCES revendedor (id_revendedor) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_factura_pedido FOREIGN KEY (id_factura) REFERENCES factura (id_factura) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_producto_pedido FOREIGN KEY (id_producto) REFERENCES producto (id_producto) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id_pedido)
    );
    
    CREATE TABLE IF NOT EXISTS gaillard.stock (
	id_stock INT AUTO_INCREMENT,
    id_producto INT NOT NULL,
    unidades INT NOT NULL,
    CONSTRAINT fk_stock_producto FOREIGN KEY (id_producto) REFERENCES producto (id_producto) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id_stock)
    );
    
CREATE TABLE IF NOT EXISTS gaillard.medio_pago (
 id_mpago INT AUTO_INCREMENT,
 id_factura INT NOT NULL,
 medio VARCHAR(30) NOT NULL,
 estado VARCHAR(30),
 CONSTRAINT fk_factura_medio FOREIGN KEY (id_factura) REFERENCES factura (id_factura) ON DELETE RESTRICT ON UPDATE CASCADE,
PRIMARY KEY (id_mpago)
);

CREATE TABLE IF NOT EXISTS gaillard.venta_temporal (
id_venta_temporal INT AUTO_INCREMENT,
id_revendedor INT NOT NULL,
id_producto INT NOT NULL,
cantidad INT NOT NULL,
CONSTRAINT fk_venta_temporal_revendedor FOREIGN KEY (id_revendedor) REFERENCES revendedor (id_revendedor) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_venta_temporal_producto FOREIGN KEY (id_producto) REFERENCES producto (id_producto) ON DELETE RESTRICT ON UPDATE CASCADE,
PRIMARY KEY (id_venta_temporal)
); 

-- Consultas

USE gaillard;

SELECT *
FROM producto
WHERE precio < 1000; 

SELECT
apellido
, nombre
FROM revendedor
ORDER BY apellido DESC; 

SELECT *
FROM revendedor
WHERE id_revendedor IN (
 SELECT DISTINCT id_revendedor
 FROM factura
); 

SELECT
  UPPER(producto.descripcion) AS descripcion,
  producto.precio
FROM producto
JOIN pedido ON producto.id_producto = pedido.id_producto
WHERE pedido.id_revendedor = 3;

-- Vistas

CREATE VIEW gaillard.producto_vw AS(
SELECT   
  producto.id_producto AS sku,
  producto.descripcion AS descripcion,
  categoria_producto.categoria AS categoria,
  marca_producto.marca AS marca
FROM  producto
JOIN  categoria_producto ON categoria_producto.id_categoria = producto.id_categoria
JOIN marca_producto ON marca_producto.id_marca = producto.id_marca
GROUP BY sku, descripcion, categoria, marca);

SELECT * from gaillard.producto_vw;

CREATE VIEW gaillard.factura_vw AS(
SELECT   
  factura.id_factura AS factura,
  revendedor.nombre AS nombre,
  revendedor.apellido AS apellido,
  factura.total AS total
FROM factura
JOIN  revendedor ON factura.id_revendedor = revendedor.id_revendedor
GROUP BY factura, nombre, apellido, total);

SELECT * from gaillard.factura_vw;

CREATE VIEW gaillard.pedido_vw AS(
SELECT   
  pedido.id_pedido AS pedido,
  factura.id_factura AS factura,
  revendedor.nombre AS nombre,
  revendedor.apellido AS apellido,
  producto.id_producto AS producto,
  producto.descripcion AS descripción,
  pedido.cantidad AS cantidad,
  pedido.precio AS precio
FROM pedido
JOIN factura ON pedido.id_factura = factura.id_factura
JOIN producto ON pedido.id_producto = producto.id_producto
JOIN revendedor ON pedido.id_revendedor = revendedor.id_revendedor
GROUP BY pedido, factura, nombre, apellido, producto, descripción, cantidad, precio)
ORDER BY pedido ASC;

SELECT * from gaillard.pedido_vw;

CREATE VIEW gaillard.info_pagos_vw AS(
SELECT   
  factura.id_factura AS factura,
  medio_pago.medio AS medio_pago,
  medio_pago.estado AS estado,
  factura.subtotal AS subtotal,
  factura.iva AS iva,
  factura.total AS total
FROM  medio_pago
JOIN  factura ON medio_pago.id_factura = factura.id_factura
GROUP BY factura, medio_pago, estado, subtotal, iva, total)
ORDER BY estado DESC;

SELECT * from gaillard.info_pagos_vw;

CREATE VIEW gaillard.stock_vw AS(
SELECT   
  producto.id_producto AS producto,
  producto.descripcion AS descripción,
  stock.unidades AS cantidad_disponible
FROM  stock
JOIN  producto ON stock.id_producto = producto.id_producto
GROUP BY producto, descripción, cantidad_disponible);

SELECT * from gaillard.stock_vw;

CREATE VIEW gaillard.top_productos_vw AS(
SELECT   
  pedido.id_producto AS producto,
  producto.descripcion AS descripción,
  SUM(pedido.cantidad) AS cantidad_vendida
FROM  pedido
JOIN  producto ON pedido.id_producto = producto.id_producto
GROUP BY producto, descripción)
ORDER BY cantidad_vendida DESC;

SELECT * from gaillard.top_productos_vw;

-- Funciones

USE gaillard;

DELIMITER $$

CREATE FUNCTION calcular_subtotal (cliente INT, suma_productos DECIMAL(11,2)) 
RETURNS decimal(11,2)
NO SQL
BEGIN
   DECLARE comision DECIMAL (11,2);
   DECLARE flete DECIMAL (11,2);
   DECLARE subtotal DECIMAL (11,2);
   
   SELECT comision.comision INTO comision
   FROM comision
   WHERE id_revendedor = cliente;
   
   SELECT flete.tasa INTO flete
   FROM flete
   JOIN direccion ON flete.id_direccion = direccion.id_direccion
   JOIN revendedor ON direccion.id_revendedor = revendedor.id_revendedor
   WHERE direccion.id_revendedor = cliente;
   
   SET subtotal = suma_productos * (1 - comision) + flete;   
   RETURN subtotal;
   
END $$
   
   
CREATE FUNCTION calcular_iva (subtotal DECIMAL) 
RETURNS DECIMAL (11,2) 
NO SQL
DETERMINISTIC 
BEGIN
  DECLARE total DECIMAL (11,2);
  DECLARE iva DECIMAL(11,2);
  SET iva = 0.21;
  SET total = subtotal * iva;
  RETURN total;
END $$

CREATE FUNCTION calcular_total (subtotal DECIMAL) 
RETURNS DECIMAL (11,2) 
NO SQL
DETERMINISTIC 
BEGIN
  DECLARE total DECIMAL (11,2);
  SET total = subtotal + calcular_iva(subtotal);
  RETURN total;
END $$

DELIMITER ;

-- Stored procedures

USE gaillard;

DELIMITER $$

CREATE PROCEDURE sp_venta_producto (IN in_id_revendedor INT, IN in_id_producto INT, IN in_cantidad INT)
BEGIN
    IF in_id_revendedor <= 0 OR in_id_producto <=0 OR in_cantidad <=0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Todos los campos son requeridos';
    ELSE
       INSERT INTO venta_temporal (id_revendedor, id_producto, cantidad)
       VALUES (in_id_revendedor, in_id_producto, in_cantidad);
	END IF;
END $$


CREATE PROCEDURE sp_generar_factura (IN in_id_revendedor INT)
BEGIN 
DECLARE var_id_factura INT;
DECLARE subtotal DECIMAL(11,2);
DECLARE iva DECIMAL(11,2);
DECLARE total DECIMAL(11,2);

IF in_id_revendedor <= 0 THEN
SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Todos los campos son requeridos';
    ELSE
    INSERT INTO factura
    VALUES (NULL, in_id_revendedor, NULL, NULL, NULL, NOW());

SET @var_id_factura = LAST_INSERT_ID();

INSERT INTO pedido (id_revendedor, id_factura, id_producto, cantidad, precio)
SELECT 
   vt.id_revendedor,
   @var_id_factura,
   vt.id_producto,
   vt.cantidad,
   p.precio
   
FROM venta_temporal vt
JOIN producto p ON vt.id_producto = p.id_producto
WHERE vt.id_revendedor = in_id_revendedor;

DELETE FROM venta_temporal WHERE id_revendedor = in_id_revendedor;

WITH tabla_temporal_1 AS(
  SELECT id_factura,
		SUM(cantidad * precio) AS suma_productos
  FROM proyecto.pedido
  WHERE id_factura = @var_id_factura
  GROUP BY id_factura
  )
  
  SELECT suma_productos
  INTO @suma_productos
  FROM tabla_temporal_1;

SELECT calcular_subtotal (in_id_revendedor, @suma_productos) INTO @subtotal; 

UPDATE factura
SET subtotal = @subtotal, iva = calcular_iva(@subtotal), total = calcular_total(@subtotal)
WHERE id_factura = @var_id_factura;

END IF;

END $$


-- Triggers

CREATE TABLE IF NOT EXISTS gaillard.log_historialprecio (
 id_historialprecio INT AUTO_INCREMENT,
 id_producto INT NOT NULL,
 old_precio INT NOT NULL,
 new_precio INT NOT NULL,
 fecha_actualizacion DATE,
 usuario VARCHAR(30),
PRIMARY KEY (id_historialprecio)
);

DELIMITER $$

CREATE TRIGGER tr_precios 
AFTER UPDATE ON producto
FOR EACH ROW
BEGIN
  IF NEW.precio <> OLD.precio THEN
    INSERT INTO log_historialprecio (id_producto, old_precio, new_precio, fecha_actualizacion, usuario)
    VALUES (NEW.id_producto, OLD.precio, NEW.precio, NOW(), CURRENT_USER());
    END IF;
END $$

CREATE TABLE IF NOT EXISTS gaillard.log_newrevendedor (
id_newrevendedor INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_revendedor INT NOT NULL,
fecha_ingreso DATE,
nivel VARCHAR(10),
usuario VARCHAR(30)
);


DELIMITER $$

CREATE TRIGGER tr_newrevendedor
AFTER INSERT ON revendedor
FOR EACH ROW
BEGIN
    INSERT INTO log_newrevendedor (id_revendedor, fecha_ingreso, nivel, usuario)
    VALUES (NEW.id_revendedor, NEW.fecha_ingreso, NEW.nivel, CURRENT_USER());
END $$