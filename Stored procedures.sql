USE proyecto;

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
DECLARE subtotal, iva, total DECIMAL(11,2);

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
