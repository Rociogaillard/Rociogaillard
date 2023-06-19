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
WHERE id IN (
 SELECT DISTINCT id_revendedor
 FROM factura
); 

SELECT
  UPPER(producto.descripcion) AS descripcion,
  producto.precio
FROM producto
JOIN pedido ON producto.id = pedido.id_producto
WHERE pedido.id_revendedor = 3;
  
  
CREATE VIEW proyecto.producto_vw AS(
SELECT
  categoria_producto.categoria AS categoria,
  producto.descripcion AS descripcion,
  marca_producto.marca AS marca
FROM  producto
JOIN  categoria_producto ON categoria_producto.id = producto.id_categoria
JOIN marca_producto ON marca_producto.id = producto.id_marca
GROUP BY categoria, descripcion, marca);
