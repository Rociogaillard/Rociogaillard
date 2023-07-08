USE proyecto;

DELIMITER $$

CREATE FUNCTION `subtotal`(cliente INT, producto INT, cantidad INT) 
RETURNS decimal(11,2)
NO SQL
BEGIN
   DECLARE precio DECIMAL (11,2);
   DECLARE comision DECIMAL (11,2);
   DECLARE flete DECIMAL (11,2);
   DECLARE subtotal DECIMAL (11,2);
   
   SELECT producto.precio INTO precio
   FROM producto
   WHERE id_producto = producto;
   
   SELECT comision.comision INTO comision
   FROM comision
   WHERE id_revendedor = cliente;
   
   SELECT flete.tasa INTO flete
   FROM flete
   JOIN direccion ON flete.id_direccion = direccion.id_direccion
   JOIN revendedor ON direccion.id_revendedor = revendedor.id_revendedor
   WHERE direccion.id_revendedor = cliente;
   
   SET subtotal = precio * cantidad * (1 - comision) + flete;   
   RETURN subtotal;
   
END $$
   
   
CREATE FUNCTION `iva` (subtotal DECIMAL) 
RETURNS DECIMAL (11,2) 
NO SQL
DETERMINISTIC 
BEGIN
  DECLARE total DECIMAL (11,2);
  DECLARE iva DECIMAL(11,2);
  SET iva = 0.21;
  SET total = subtotal + (subtotal * iva);
  RETURN total;
END $$

DELIMITER ;

SELECT subtotal(3,45,2);

SELECT iva(4800.80);

  