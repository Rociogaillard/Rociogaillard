START TRANSACTION;

DELETE FROM email
WHERE id_email = 5;

ROLLBACK;

COMMIT;

-- INSERT INTO email (id_revendedor,email) VALUES
-- ('5', 'gabriel.martinez@gmail.com');

START TRANSACTION;

INSERT INTO producto (id_categoria, id_marca, descripcion, tipo_comercial, precio) VALUES
('7', '2', 'Hidratante corporal castaña', 'Promocionado', '3000');
INSERT INTO producto (id_categoria, id_marca, descripcion, tipo_comercial, precio) VALUES
('7', '2', 'Hidratante corporal maracuya', 'No promocionado', '3200');
INSERT INTO producto (id_categoria, id_marca, descripcion, tipo_comercial, precio) VALUES
('2', '8', 'Labial nude', 'No promocionado', '2600');
INSERT INTO producto (id_categoria, id_marca, descripcion, tipo_comercial, precio) VALUES
('2', '8', 'Manteca cacao', 'Promocionado', '2100');

SAVEPOINT primeros_cuatro;

INSERT INTO producto (id_categoria, id_marca, descripcion, tipo_comercial, precio) VALUES
('1', '5', 'Kaiak vital femenino', 'Promocionado', '6000');
INSERT INTO producto (id_categoria, id_marca, descripcion, tipo_comercial, precio) VALUES
('1', '5', 'Kaiak vital masculino', 'Promocionado', '6000');
INSERT INTO producto (id_categoria, id_marca, descripcion, tipo_comercial, precio) VALUES
('3', '12', 'Crema antiseñales +45', 'Promocionado', '9600');
INSERT INTO producto (id_categoria, id_marca, descripcion, tipo_comercial, precio) VALUES
('5', '11', 'Deos roll on hombre', 'Promocionado', '850');

SAVEPOINT ultimos_cuatro;

RELEASE SAVEPOINT ultimos_cuatro;

ROLLBACK TO primeros_cuatro;
COMMIT;
