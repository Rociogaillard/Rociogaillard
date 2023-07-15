CREATE TABLE IF NOT EXISTS proyecto.log_historialprecio (
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

CREATE TABLE IF NOT EXISTS proyecto.log_newrevendedor (
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