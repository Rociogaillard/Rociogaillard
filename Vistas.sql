USE proyecto;

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

CREATE VIEW proyecto.factura_vw AS(
SELECT   
  factura.id_factura AS factura,
  revendedor.nombre AS nombre,
  revendedor.apellido AS apellido,
  factura.total AS total
FROM factura
JOIN  revendedor ON factura.id_revendedor = revendedor.id_revendedor
GROUP BY factura, nombre, apellido, total);

SELECT * from proyecto.factura_vw;

CREATE VIEW proyecto.pedido_vw AS(
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

SELECT * from proyecto.pedido_vw;

CREATE VIEW proyecto.info_pagos_vw AS(
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

SELECT * from proyecto.info_pagos_vw;

CREATE VIEW proyecto.stock_vw AS(
SELECT   
  producto.id_producto AS producto,
  producto.descripcion AS descripción,
  stock.unidades AS cantidad_disponible
FROM  stock
JOIN  producto ON stock.id_producto = producto.id_producto
GROUP BY producto, descripción, cantidad_disponible);

SELECT * from proyecto.stock_vw;