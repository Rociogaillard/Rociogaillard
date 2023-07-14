CREATE DATABASE proyecto;

USE proyecto;

CREATE TABLE IF NOT EXISTS proyecto.revendedor (
	id_revendedor INT AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    fecha_ingreso DATETIME NOT NULL,
    nivel VARCHAR(10),
    PRIMARY KEY (id_revendedor),
    INDEX nombre (nombre, apellido)
);

CREATE TABLE IF NOT EXISTS proyecto.email (
	id_email INT AUTO_INCREMENT,
    id_revendedor INT,
    email VARCHAR(120) NOT NULL,
    email_principal TINYINT DEFAULT 1,
    CONSTRAINT fk_email_revendedor FOREIGN KEY (id_revendedor) REFERENCES revendedor (id_revendedor) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uni_email UNIQUE (email),
	PRIMARY KEY (id_email)
    );
    
    CREATE TABLE IF NOT EXISTS proyecto.telefono (
	id_telefono INT AUTO_INCREMENT,
    id_revendedor INT,
    telefono INT NOT NULL,
    telefono_principal TINYINT DEFAULT 1,
    CONSTRAINT fk_telefono_revendedor FOREIGN KEY (id_revendedor) REFERENCES revendedor (id_revendedor) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id_telefono)
    );
    
    
    CREATE TABLE IF NOT EXISTS proyecto.direccion (
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

CREATE TABLE IF NOT EXISTS proyecto.categoria_producto (
id_categoria INT AUTO_INCREMENT,
categoria VARCHAR(50) NOT NULL,
PRIMARY KEY (id_categoria)
); 

CREATE TABLE IF NOT EXISTS proyecto.marca_producto (
id_marca INT AUTO_INCREMENT,
marca VARCHAR(50) NOT NULL,
PRIMARY KEY (id_marca)
);

CREATE TABLE IF NOT EXISTS proyecto.producto (
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
    
        
CREATE TABLE IF NOT EXISTS proyecto.flete (
	id_flete INT AUTO_INCREMENT,
    id_direccion INT NOT NULL,
    tasa DECIMAL(11,2) NOT NULL,
    CONSTRAINT fk_valor_flete FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id_flete)
    );
    
CREATE TABLE IF NOT EXISTS proyecto.comision (
	id_comision INT AUTO_INCREMENT,
    id_revendedor INT NOT NULL,
    comision DECIMAL(11,2) NOT NULL,
    CONSTRAINT fk_comision_revendedor FOREIGN KEY (id_revendedor) REFERENCES revendedor (id_revendedor) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id_comision)
    );
      
    
CREATE TABLE IF NOT EXISTS proyecto.factura (
id_factura INT AUTO_INCREMENT,
id_revendedor INT NOT NULL,
subtotal DECIMAL(11,2) DEFAULT 0,
iva DECIMAL(11,2) DEFAULT 0, 
total DECIMAL(11,2) DEFAULT 0,
fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP(),
CONSTRAINT fk_factura_revendedor FOREIGN KEY (id_revendedor) REFERENCES revendedor (id_revendedor) ON DELETE RESTRICT ON UPDATE CASCADE,
PRIMARY KEY (id_factura)
); 
    
	CREATE TABLE IF NOT EXISTS proyecto.pedido (
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
    
    CREATE TABLE IF NOT EXISTS proyecto.stock (
	id_stock INT AUTO_INCREMENT,
    id_producto INT NOT NULL,
    unidades INT NOT NULL,
    CONSTRAINT fk_stock_producto FOREIGN KEY (id_producto) REFERENCES producto (id_producto) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id_stock)
    );
    
CREATE TABLE IF NOT EXISTS proyecto.medio_pago (
 id_mpago INT AUTO_INCREMENT,
 id_factura INT NOT NULL,
 medio VARCHAR(30) NOT NULL,
 estado VARCHAR(30),
 CONSTRAINT fk_factura_medio FOREIGN KEY (id_factura) REFERENCES factura (id_factura) ON DELETE RESTRICT ON UPDATE CASCADE,
PRIMARY KEY (id_mpago)
);

CREATE TABLE IF NOT EXISTS proyecto.venta_temporal (
id_venta_temporal INT AUTO_INCREMENT,
id_revendedor INT NOT NULL,
id_producto INT NOT NULL,
cantidad INT NOT NULL,
CONSTRAINT fk_venta_temporal_revendedor FOREIGN KEY (id_revendedor) REFERENCES revendedor (id_revendedor) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT fk_venta_temporal_producto FOREIGN KEY (id_producto) REFERENCES producto (id_producto) ON DELETE RESTRICT ON UPDATE CASCADE,
PRIMARY KEY (id_venta_temporal)
); 
