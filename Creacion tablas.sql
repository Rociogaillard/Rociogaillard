CREATE DATABASE proyecto;

USE proyecto;

CREATE TABLE IF NOT EXISTS proyecto.revendedor (
	id INT AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    fecha_ingreso DATETIME NOT NULL,
    nivel VARCHAR(10),
    PRIMARY KEY (id),
    INDEX nombre (nombre, apellido)
);

CREATE TABLE IF NOT EXISTS proyecto.email (
	id INT AUTO_INCREMENT,
    id_revendedor INT,
    email VARCHAR(120) NOT NULL,
    email_principal TINYINT DEFAULT 1,
    CONSTRAINT fk_email_revendedor FOREIGN KEY (id_revendedor) REFERENCES revendedor (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uni_email UNIQUE (email),
	PRIMARY KEY (id)
    );
    
    CREATE TABLE IF NOT EXISTS proyecto.telefono (
	id INT AUTO_INCREMENT,
    id_revendedor INT,
    telefono INT NOT NULL,
    telefono_principal TINYINT DEFAULT 1,
    CONSTRAINT fk_telefono_revendedor FOREIGN KEY (id_revendedor) REFERENCES revendedor (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id)
    );
    
    
    CREATE TABLE IF NOT EXISTS proyecto.direccion (
	id INT AUTO_INCREMENT,
    id_revendedor INT,
    direccion VARCHAR(200) NOT NULL,
    cod_postal VARCHAR(10) NOT NULL,
    cuidad VARCHAR(50) NOT NULL,
    provincia VARCHAR(50) NOT NULL,
    pais VARCHAR(50) DEFAULT 'ARGENTINA',
    direccion_principal TINYINT DEFAULT 1,
    CONSTRAINT fk_direccion_revendedor FOREIGN KEY (id_revendedor) REFERENCES revendedor (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS proyecto.categoria_producto (
 id INT AUTO_INCREMENT,
categoria VARCHAR(50) NOT NULL,
PRIMARY KEY (id)
); 

CREATE TABLE IF NOT EXISTS proyecto.marca_producto (
 id INT AUTO_INCREMENT,
marca VARCHAR(50) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS proyecto.producto (
	id INT AUTO_INCREMENT,
    id_categoria INT NOT NULL,
    id_marca INT NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    tipo_comercial VARCHAR(30) NOT NULL,
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria_producto (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_producto_marca FOREIGN KEY (id_marca) REFERENCES marca_producto (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id)
    );
    
    CREATE TABLE IF NOT EXISTS proyecto.precio (
	id INT AUTO_INCREMENT,
    id_producto INT NOT NULL,
    precio DECIMAL(11,2) NOT NULL,
    CONSTRAINT fk_precio_producto FOREIGN KEY (id_producto) REFERENCES producto (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id)
    );
    
    
    CREATE TABLE IF NOT EXISTS proyecto.pedido (
	id INT AUTO_INCREMENT,
    id_producto INT NOT NULL,
    id_precio INT NOT NULL,
    cantidad INT NOT NULL,
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP(),
    CONSTRAINT fk_producto_pedido FOREIGN KEY (id_producto) REFERENCES producto (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_precio_pedido FOREIGN KEY (id_precio) REFERENCES precio (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id)
    );
    

CREATE TABLE IF NOT EXISTS proyecto.flete (
	id INT AUTO_INCREMENT,
    id_direccion INT NOT NULL,
    tasa DECIMAL(11,2) NOT NULL,
    CONSTRAINT fk_valor_flete FOREIGN KEY (id_direccion) REFERENCES direccion (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id)
    );
    
CREATE TABLE IF NOT EXISTS proyecto.comision (
	id INT AUTO_INCREMENT,
    id_revendedor INT NOT NULL,
    comision DECIMAL(11,2) NOT NULL,
    CONSTRAINT fk_comision_revendedor FOREIGN KEY (id_revendedor) REFERENCES revendedor (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id)
    );
    
CREATE TABLE IF NOT EXISTS proyecto.factura (
id INT AUTO_INCREMENT,
id_revendedor INT NOT NULL,
id_pedido INT NOT NULL,
id_comision INT NOT NULL,
id_flete INT NOT NULL,
subtotal DECIMAL(11,2) DEFAULT 0,
iva DECIMAL(11,2) DEFAULT 0, 
total DECIMAL(11,2) DEFAULT 0,
fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP(),
CONSTRAINT fk_factura_revendedor FOREIGN KEY (id_revendedor) REFERENCES revendedor (id) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_factura_pedido FOREIGN KEY (id_pedido) REFERENCES pedido (id) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_factura_comision FOREIGN KEY (id_comision) REFERENCES comision (id) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_factura_flete FOREIGN KEY (id_flete) REFERENCES flete (id) ON DELETE RESTRICT ON UPDATE CASCADE,
PRIMARY KEY (id)
); 
    
    CREATE TABLE IF NOT EXISTS proyecto.stock (
	id INT AUTO_INCREMENT,
    id_producto INT NOT NULL,
    unidades INT NOT NULL,
    CONSTRAINT fk_stock_producto FOREIGN KEY (id_producto) REFERENCES producto (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id)
    );