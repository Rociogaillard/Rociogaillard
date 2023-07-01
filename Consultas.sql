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
  
  
CREATE VIEW proyecto.producto_vw AS(
SELECT   
  producto.id_producto AS sku,
  producto.descripcion AS descripcion,
  categoria_producto.categoria AS categoria,
  marca_producto.marca AS marca
FROM  producto
JOIN  categoria_producto ON categoria_producto.id_categoria = producto.id_categoria
JOIN marca_producto ON marca_producto.id_marca = producto.id_marca
GROUP BY sku, descripcion, categoria, marca);

SELECT * from proyecto.producto_vw;