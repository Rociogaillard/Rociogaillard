USE proyecto;

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

