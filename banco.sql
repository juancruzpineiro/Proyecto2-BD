## -----     PROYECTO 1 - BASES DE DATOS     ----- ##
## -----      Dulce, Sahid (LU 139.656)      ----- ##
## -----    Piñeiro, Juan Cruz (LU 121.302)  ----- ##

#-------------------------------------------------------------------------

# Creación de la Base de Datos y Tablas 

CREATE DATABASE BANCO CHARACTER SET latin1 COLLATE latin1_spanish_ci;
USE BANCO;

-- Ciudad (cod postal, nombre)
CREATE TABLE Ciudad(	
    cod_postal INT UNSIGNED NOT NULL,
    CHECK (cod_postal > 999 AND cod_postal <= 9999),
    nombre VARCHAR(100) NOT NULL,

    CONSTRAINT pk_cod_postal
    PRIMARY KEY(cod_postal)
) ENGINE=InnoDB;

-- Sucursal (nro suc, nombre, direccion, telefono, horario, cod postal)
CREATE TABLE Sucursal(
    nro_suc INT(3) UNSIGNED NOT NULL AUTO_INCREMENT,  
    
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(12) NOT NULL,
	horario VARCHAR(5) NOT NULL,
    cod_postal INT UNSIGNED NOT NULL,
    
    CONSTRAINT pk_suc
    PRIMARY KEY(nro_suc),

    CONSTRAINT fk_sucursal_cod_postal
    FOREIGN KEY(cod_postal) REFERENCES Ciudad(cod_postal)
) ENGINE=InnoDB;

-- Empleado (legajo, apellido, nombre, tipo doc, nro doc, direccion, telefono, cargo, password, nro suc)
CREATE TABLE Empleado(
    legajo INT(4) UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    tipo_doc VARCHAR(20) NOT NULL,
    nro_doc INT UNSIGNED NOT NULL,
    CHECK (nro_doc >= 10000000 AND nro_doc <= 99999999),
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(12) NOT NULL,
	cargo VARCHAR(100) NOT NULL,
    password VARCHAR(32) NOT NULL,
	nro_suc INT(3) UNSIGNED NOT NULL,
        
    CONSTRAINT pk_legajo
    PRIMARY KEY(legajo),

    CONSTRAINT fk_empleado_nro_suc
    FOREIGN KEY(nro_suc) REFERENCES Sucursal(nro_suc)
) ENGINE=InnoDB;

-- Cliente (nro cliente, apellido, nombre, tipo doc, nro doc, direccion, telefono, fecha nac)
CREATE TABLE Cliente(
	nro_cliente BIGINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
	nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    tipo_doc VARCHAR(20) NOT NULL,
    nro_doc INT UNSIGNED NOT NULL,
    CHECK (nro_doc >= 10000000 AND nro_doc <= 99999999),
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(12) NOT NULL,
	fecha_nac DATE NOT NULL, 
     
    CONSTRAINT pk_nro_cliente
    PRIMARY KEY(nro_cliente)

) ENGINE=InnoDB;

-- Plazo Fijo (nro plazo, capital, fecha inicio, fecha fin, tasa interes, interes, nro suc)
CREATE TABLE Plazo_Fijo(
	
    nro_plazo BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    capital DECIMAL(16,2) UNSIGNED NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    tasa_interes DECIMAL(4, 2) UNSIGNED NOT NULL, 
    interes DECIMAL(16, 2) UNSIGNED NOT NULL, 

    nro_suc INT UNSIGNED NOT NULL,
    
    CONSTRAINT pk_nro_plazo
    PRIMARY KEY(nro_plazo),

    CONSTRAINT fk_plazo_fijo_nro_suc
    FOREIGN KEY(nro_suc) REFERENCES Sucursal(nro_suc)
) ENGINE=InnoDB;

-- Tasa Plazo Fijo(periodo, monto inf, monto sup, tasa)
CREATE TABLE Tasa_Plazo_Fijo (
    periodo INT UNSIGNED NOT NULL
    CHECK (periodo >= 100 AND periodo <= 999), 
    monto_inf DECIMAL(16, 2) UNSIGNED,
    monto_sup DECIMAL(16, 2) UNSIGNED  , 
    tasa DECIMAL(4, 2) UNSIGNED NOT NULL,
    
    CONSTRAINT pk_tasa_plazo_fijo
    PRIMARY KEY (periodo,monto_inf,monto_sup) 
) ENGINE=InnoDB;

-- Plazo Cliente (nro plazo, nro cliente) 
CREATE TABLE Plazo_Cliente (
    nro_plazo BIGINT UNSIGNED NOT NULL , 
	nro_cliente BIGINT(5) UNSIGNED NOT NULL,
    
    CONSTRAINT pk_plazo_cliente PRIMARY KEY (nro_plazo, nro_cliente), 

    CONSTRAINT fk_plazo_cliente_nro_plazo_plazo_fijo
    FOREIGN KEY (nro_plazo) REFERENCES Plazo_Fijo(nro_plazo),

    CONSTRAINT fk_plazo_cliente_nro_cliente_cliente 
    FOREIGN KEY (nro_cliente) REFERENCES Cliente(nro_cliente) 
)    ENGINE=InnoDB;

-- Prestamo (nro prestamo, fecha, cant meses, monto, tasa interes, interes, valor cuota, legajo, nro cliente)
CREATE TABLE Prestamo (
    nro_prestamo BIGINT(8) UNSIGNED NOT NULL AUTO_INCREMENT,  
    fecha DATE NOT NULL,  -- Fecha del préstamo
    cant_meses TINYINT UNSIGNED NOT NULL CHECK (cant_meses >= 1 AND cant_meses <= 99), 
    monto DECIMAL(10, 2) UNSIGNED NOT NULL, 
    tasa_interes DECIMAL(4, 2) UNSIGNED NOT NULL ,  
    interes DECIMAL(9, 2) UNSIGNED NOT NULL, 
    valor_cuota DECIMAL(9, 2) UNSIGNED NOT NULL,  
    legajo INT UNSIGNED NOT NULL,  
    nro_cliente BIGINT(5) UNSIGNED NOT NULL,
    
    CONSTRAINT pk_prestamo PRIMARY KEY (nro_prestamo),  
    CONSTRAINT fk_prestamo_empleado FOREIGN KEY (legajo) REFERENCES Empleado(legajo),  
    CONSTRAINT fk_prestamo_cliente FOREIGN KEY (nro_cliente) REFERENCES Cliente(nro_cliente) 
) ENGINE=InnoDB;

--  Pago(nro prestamo, nro pago, fecha venc, fecha pago)
CREATE TABLE Tasa_Prestamo (
    periodo SMALLINT UNSIGNED NOT NULL,  
    monto_inf DECIMAL(10, 2) UNSIGNED NOT NULL,  
    monto_sup DECIMAL(10, 2) UNSIGNED NOT NULL,  
    tasa DECIMAL(4, 2) UNSIGNED NOT NULL, 
    
    CONSTRAINT pk_tasa_prestamo PRIMARY KEY (periodo, monto_inf, monto_sup),  
    
    CONSTRAINT chk_monto_inf CHECK (monto_inf > 0),  
    CONSTRAINT chk_monto_sup CHECK (monto_sup > 0),  
    CONSTRAINT chk_tasa CHECK (tasa > 0) 
) ENGINE=InnoDB;

-- Tasa Prestamo(periodo, monto inf, monto sup, tasa)
CREATE TABLE Pago ( 
    nro_prestamo BIGINT UNSIGNED NOT NULL,  
    nro_pago TINYINT UNSIGNED NOT NULL CHECK (nro_pago >= 1 AND nro_pago <= 99),  
    fecha_venc DATE NOT NULL, 
    fecha_pago DATE,  
    
    CONSTRAINT pk_pago PRIMARY KEY (nro_prestamo, nro_pago),  
    CONSTRAINT fk_pago_prestamo FOREIGN KEY (nro_prestamo) REFERENCES Prestamo(nro_prestamo) 
) ENGINE=InnoDB;

-- Caja Ahorro (nro ca, CBU, saldo)
CREATE TABLE Caja_Ahorro (
    nro_ca BIGINT(8) UNSIGNED NOT NULL AUTO_INCREMENT,  
    CBU BIGINT UNSIGNED NOT NULL CHECK (CBU >= 100000000000000000 AND CBU <= 999999999999999999),  
    saldo DECIMAL(16, 2) UNSIGNED NOT NULL CHECK (saldo >= 0),
    
    CONSTRAINT pk_caja_ahorro PRIMARY KEY (nro_ca)
) ENGINE=InnoDB;

-- Cliente CA (nro cliente, nro ca)
CREATE TABLE Cliente_CA ( 
    nro_cliente BIGINT UNSIGNED NOT NULL,  
    nro_ca BIGINT UNSIGNED NOT NULL,  
    
    CONSTRAINT pk_cliente_ca PRIMARY KEY (nro_cliente, nro_ca),  
    CONSTRAINT fk_cliente_ca_caja FOREIGN KEY (nro_ca) REFERENCES Caja_Ahorro(nro_ca),  
    CONSTRAINT fk_cliente_ca_cliente FOREIGN KEY (nro_cliente) REFERENCES Cliente(nro_cliente)  
) ENGINE=InnoDB;

-- Tarjeta(nro tarjeta, PIN, CVT, fecha venc, nro cliente, nro ca)
CREATE TABLE Tarjeta (
    nro_tarjeta BIGINT(16) UNSIGNED NOT NULL AUTO_INCREMENT, 
    PIN CHAR(32) NOT NULL,  
    CVT CHAR(32) NOT NULL,  
    fecha_venc DATE NOT NULL, 
    nro_cliente BIGINT UNSIGNED NOT NULL,
    nro_ca BIGINT UNSIGNED NOT NULL, 
    
    CONSTRAINT pk_tarjeta PRIMARY KEY (nro_tarjeta), 
    CONSTRAINT fk_tarjeta_cliente_ca FOREIGN KEY (nro_cliente, nro_ca) REFERENCES Cliente_CA(nro_cliente, nro_ca)  
) ENGINE=InnoDB;

-- Caja (cod caja)
CREATE TABLE Caja (
    cod_caja INT(5) UNSIGNED NOT NULL AUTO_INCREMENT,  
    
    CONSTRAINT pk_caja PRIMARY KEY (cod_caja) 
) ENGINE=InnoDB;

-- Ventanilla (cod caja, nro suc)
CREATE TABLE Ventanilla (
    cod_caja INT(5) UNSIGNED NOT NULL, 
    nro_suc INT UNSIGNED NOT NULL ,  
    
    CONSTRAINT pk_ventanilla PRIMARY KEY (cod_caja),  
    CONSTRAINT fk_ventanilla_caja FOREIGN KEY (cod_caja) REFERENCES Caja(cod_caja),  
    CONSTRAINT fk_ventanilla_sucursal FOREIGN KEY (nro_suc) REFERENCES Sucursal(nro_suc)  
) ENGINE=InnoDB;

-- ATM(cod caja, cod postal, direccion)
CREATE TABLE ATM (
    cod_caja INT(5) UNSIGNED NOT NULL,  
    cod_postal INT UNSIGNED NOT NULL,
    direccion VARCHAR(255) NOT NULL, 
    
    CONSTRAINT pk_atm PRIMARY KEY (cod_caja), 
    CONSTRAINT fk_atm_cod_caja FOREIGN KEY (cod_caja) REFERENCES Caja(cod_caja),   
    CONSTRAINT fk_atm_cod_postal FOREIGN KEY (cod_postal) REFERENCES Ciudad(cod_postal) 
) ENGINE=InnoDB;

-- Transaccion (nro trans, fecha, hora, monto)
CREATE TABLE Transaccion (
    nro_trans BIGINT(10) UNSIGNED NOT NULL AUTO_INCREMENT,  
    fecha DATE NOT NULL,  
    hora TIME NOT NULL, 
    monto DECIMAL(16, 2) UNSIGNED NOT NULL CHECK (monto > 0), 
    
    CONSTRAINT pk_transaccion PRIMARY KEY (nro_trans)  
) ENGINE=InnoDB;

-- Debito (nro trans, descripcion, nro cliente, nro ca)
CREATE TABLE Debito (
    nro_trans BIGINT UNSIGNED NOT NULL, 
    descripcion TEXT,  
    nro_cliente BIGINT UNSIGNED NOT NULL,  
    nro_ca BIGINT UNSIGNED NOT NULL,
    
    
    CONSTRAINT pk_debito PRIMARY KEY (nro_trans), 
    
    CONSTRAINT fk_debito_transaccion FOREIGN KEY (nro_trans) REFERENCES Transaccion(nro_trans),
    CONSTRAINT fk_debito_cliente_ca FOREIGN KEY (nro_cliente, nro_ca) REFERENCES Cliente_CA(nro_cliente, nro_ca)  
) ENGINE=InnoDB;

-- Transaccion por caja (nro trans, cod caja)
CREATE TABLE Transaccion_por_Caja (
    nro_trans BIGINT UNSIGNED NOT NULL,  
    cod_caja INT(5) UNSIGNED NOT NULL,  
    
    CONSTRAINT pk_transaccion_por_caja PRIMARY KEY (nro_trans),  
    
    CONSTRAINT fk_transaccion_por_caja_transaccion FOREIGN KEY (nro_trans) REFERENCES Transaccion(nro_trans),  
    CONSTRAINT fk_transaccion_por_caja_caja FOREIGN KEY (cod_caja) REFERENCES Caja(cod_caja)  
) ENGINE=InnoDB;

-- Deposito (nro trans, nro ca)
CREATE TABLE Deposito (
    nro_trans BIGINT UNSIGNED NOT NULL, 
    nro_ca BIGINT UNSIGNED NOT NULL,
    
    CONSTRAINT pk_deposito PRIMARY KEY (nro_trans),
    
    CONSTRAINT fk_deposito_transaccion_por_caja FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_Caja(nro_trans),  
    CONSTRAINT fk_deposito_caja_ahorro FOREIGN KEY (nro_ca) REFERENCES Caja_Ahorro(nro_ca)  
) ENGINE=InnoDB;

-- Extraccion (nro trans, nro cliente, nro ca)
CREATE TABLE Extraccion (
    nro_trans BIGINT UNSIGNED NOT NULL,  
    nro_cliente BIGINT UNSIGNED NOT NULL,  
    nro_ca BIGINT UNSIGNED NOT NULL, 
    
    CONSTRAINT pk_extraccion PRIMARY KEY (nro_trans),  
    
    CONSTRAINT fk_extraccion_transaccion_por_caja FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_Caja(nro_trans),  
    CONSTRAINT fk_extraccion_cliente_ca FOREIGN KEY (nro_cliente, nro_ca) REFERENCES Cliente_CA(nro_cliente, nro_ca)  
) ENGINE=InnoDB;

--  Transferencia (nro trans, nro cliente, origen, destino)
CREATE TABLE Transferencia (
    nro_trans BIGINT UNSIGNED NOT NULL,
    nro_cliente BIGINT UNSIGNED NOT NULL,
    origen BIGINT UNSIGNED NOT NULL, 
    destino BIGINT UNSIGNED NOT NULL, 
    
    CONSTRAINT pk_transferencia PRIMARY KEY (nro_trans),  
    
    CONSTRAINT fk_transferencia_transaccion_por_caja FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_Caja(nro_trans), 
    CONSTRAINT fk_transferencia_cliente_origen FOREIGN KEY (nro_cliente, origen) REFERENCES Cliente_CA(nro_cliente, nro_ca),  
    CONSTRAINT fk_transferencia_caja_destino FOREIGN KEY (destino) REFERENCES Caja_Ahorro(nro_ca)  
) ENGINE=InnoDB;



#-------------------------------------------------------------------------

# Creación de usuarios y asignación de privilegios


-- Creación del usuario Admin y otorgamiento de privilegios.
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON banco.* TO 'admin'@'localhost' WITH GRANT OPTION;

-- Creación del usuario Empleado y asiganción de privilegios.
CREATE USER 'empleado'@'%' IDENTIFIED BY 'empleado';
GRANT SELECT ON banco.Empleado TO 'empleado'@'%';
GRANT SELECT ON banco.Sucursal TO 'empleado'@'%';
GRANT SELECT ON banco.Tasa_Plazo_Fijo TO 'empleado'@'%';
GRANT SELECT ON banco.Tasa_Prestamo TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Prestamo TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Plazo_Fijo TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Plazo_Cliente TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Caja_Ahorro TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Tarjeta TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.Cliente_CA TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.Cliente TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.Pago TO 'empleado'@'%';

-- Creación de las sub-vistas para trans_cajas_ahorro
CREATE VIEW vista_debito AS
SELECT 
    ca.nro_ca, ca.saldo, t.nro_trans, t.fecha, t.hora,  'debito' AS tipo,
    t.monto, NULL AS cod_caja, cc.nro_cliente,
    c.tipo_doc, c.nro_doc, c.nombre, c.apellido, NULL AS destino
FROM Debito d
JOIN Caja_Ahorro ca ON d.nro_ca = ca.nro_ca
JOIN Cliente_CA cc ON ca.nro_ca = cc.nro_ca AND d.nro_cliente = cc.nro_cliente
JOIN Cliente c ON c.nro_cliente = cc.nro_cliente
JOIN Transaccion t ON d.nro_trans = t.nro_trans;

CREATE VIEW vista_deposito AS
SELECT 
    ca.nro_ca, ca.saldo, t.nro_trans, t.fecha, t.hora,  'deposito' AS tipo,
    t.monto, tpc.cod_caja, NULL AS nro_cliente,
		NULL AS tipo_doc, NULL AS nro_doc, NULL AS nombre, NULL AS apellido, NULL AS destino
FROM Deposito d
JOIN Caja_Ahorro ca ON d.nro_ca = ca.nro_ca
JOIN Transaccion_por_caja tpc  
JOIN Transaccion t ON d.nro_trans = t.nro_trans AND t.nro_trans = tpc.nro_trans;

CREATE VIEW vista_extraccion AS
SELECT 
    ca.nro_ca, ca.saldo, e.nro_trans, t.fecha, t.hora,  'extraccion' AS tipo,
    t.monto, tpc.cod_caja, cc.nro_cliente,
    c.tipo_doc, c.nro_doc, c.nombre, c.apellido, NULL AS destino
FROM Extraccion e
JOIN Transaccion t ON e.nro_trans = t.nro_trans
JOIN Caja_Ahorro ca ON e.nro_ca = ca.nro_ca
JOIN Cliente_CA cc ON ca.nro_ca = cc.nro_ca AND e.nro_cliente = cc.nro_cliente
JOIN Cliente c ON c.nro_cliente = cc.nro_cliente
JOIN Transaccion_por_caja tpc ON t.nro_trans = tpc.nro_trans ;

CREATE VIEW vista_transferencia AS
SELECT 
    ca.nro_ca, ca.saldo, tf.nro_trans, t.fecha, t.hora,  'transferencia' AS tipo,
    t.monto, tpc.cod_caja, cc.nro_cliente,
    c.tipo_doc, c.nro_doc, c.nombre, c.apellido, tf.destino
FROM Transferencia tf
JOIN Caja_Ahorro ca ON tf.origen = ca.nro_ca
JOIN Cliente_CA cc ON ca.nro_ca = cc.nro_ca AND tf.nro_cliente = cc.nro_cliente
JOIN Cliente c ON c.nro_cliente = cc.nro_cliente
JOIN Transaccion_por_caja tpc 
JOIN Transaccion t ON tf.nro_trans = tpc.nro_trans AND t.nro_trans = tpc.nro_trans;

-- Creación de la vista trans_cajas_ahorro
CREATE VIEW trans_cajas_ahorro AS
SELECT * FROM vista_debito
UNION ALL
SELECT * FROM vista_deposito
UNION ALL
SELECT * FROM vista_extraccion
UNION ALL
SELECT * FROM vista_transferencia;


-- Creación del usuario ATM, que accede a la vista trans_cajas_ahorro y modicicación de la tarjeta
CREATE USER 'atm'@'%' IDENTIFIED BY 'atm';
GRANT SELECT ON banco.trans_cajas_ahorro TO 'atm'@'%';
GRANT SELECT, UPDATE ON banco.tarjeta TO 'atm'@'%';



	