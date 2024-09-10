-- drop database BANCO;

CREATE DATABASE BANCO CHARACTER SET latin1 COLLATE latin1_spanish_ci;
USE BANCO;

-- Ciudad (cod postal, nombre)
CREATE TABLE Ciudad(
    cod_postal INT UNSIGNED NOT NULL,
    CHECK (cod_postal > 999 AND cod_postal <= 9999),
    -- PREGUNTAR SI ES ASÍ LO QUE PIDEN, 4 DÍGITOS O CHAR
    nombre VARCHAR(100) NOT NULL,

    CONSTRAINT pk_cod_postal
    PRIMARY KEY(cod_postal)
) ENGINE=InnoDB;

-- Sucursal (nro suc, nombre, direccion, telefono, horario, cod postal)
CREATE TABLE Sucursal(
    nro_suc INT UNSIGNED NOT NULL,
    CHECK (nro_suc > 99 AND nro_suc <= 999),  -- PREGUNTAR SI ESTO ESTÁ BIEN
    
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(12),
	horario VARCHAR(5),
    cod_postal INT UNSIGNED NOT NULL,
    
    CONSTRAINT pk_suc
    PRIMARY KEY(nro_suc),

    CONSTRAINT fk_sucursal_cod_postal
    FOREIGN KEY(cod_postal) REFERENCES Ciudad(cod_postal)
) ENGINE=InnoDB;

-- Empleado (legajo, apellido, nombre, tipo doc, nro doc, direccion, telefono, cargo, 
-- password, nro suc)
-- legajo es un natural de 4 cifras; apellido, nombre, tipo doc, direccion, telefono, cargo y password
-- son cadenas de caracteres; nro doc es un natural de 8 cifras; nro suc corresponde al n´umero de
-- una sucursal. El campo password debe ser una cadena de 32 caracteres, para poder almacenarlo
-- de forma segura utilizando la funci´on de hash MD5 provista por MySQL(ver secci´on B.2)
CREATE TABLE Empleado(
    legajo INT UNSIGNED NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    tipo_doc VARCHAR(10) NOT NULL,
    nro_doc INT UNSIGNED NOT NULL,
    CHECK (nro_doc >= 10000000 AND nro_doc <= 99999999),
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(12),
	cargo VARCHAR(100),
    nro_suc INT UNSIGNED NOT NULL,
    
    password VARCHAR(32) NOT NULL,-- Ver qué onda con el hash
    

    
    CONSTRAINT pk_legajo
    PRIMARY KEY(legajo),

    CONSTRAINT fk_empleado_nro_suc
    FOREIGN KEY(nro_suc) REFERENCES Sucursal(nro_suc)
) ENGINE=InnoDB;

-- Cliente (nro cliente, apellido, nombre, tipo doc, nro doc, direccion, telefono, fecha nac)
CREATE TABLE Cliente(
	nro_cliente BIGINT UNSIGNED NOT NULL,
	CHECK (nro_cliente > 9999 AND nro_cliente <= 100000),
	nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    tipo_doc VARCHAR(10) NOT NULL,
    nro_doc INT SIGNED NOT NULL,
    CHECK (nro_doc >= 10000000 AND nro_doc <= 99999999),
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(12),
	fecha_nac VARCHAR(100), -- No especifica qué tipo de dato es
	nro_suc INT UNSIGNED NOT NULL,
    
    CONSTRAINT pk_nro_cliente
    PRIMARY KEY(nro_cliente),

    CONSTRAINT fk_cliente_nro_suc
    FOREIGN KEY(nro_suc) REFERENCES Sucursal(nro_suc) -- por que numero de sucursal foreign key?
) ENGINE=InnoDB;

-- Plazo Fijo (nro plazo, capital, fecha inicio, fecha fin, tasa interes, interes, nro suc)
-- SIN TERMINAR 
CREATE TABLE Plazo_Fijo(
	
    nro_plazo BIGINT UNSIGNED NOT NULL CHECK (nro_plazo >= 10000000 AND nro_plazo <= 99999999),
    capital DECIMAL(10, 2) CHECK (capital > 0),
    fecha_inicio DATE,
    fecha_fin DATE,
    tasa_interes DECIMAL(5, 2) CHECK (tasa_interes > 0), -- Real positivo con 2 decimales
    interes DECIMAL(10, 2) CHECK (interes >= 0), -- Real positivo con 2 decimales
	-- COLOCAR LOS NOT NULL, Y CUIDADO CON INTERES QUE ES DEBIL XD
    
	
    nro_suc INT UNSIGNED NOT NULL,
    
    CONSTRAINT pk_nro_plazo
    PRIMARY KEY(nro_plazo),

    CONSTRAINT fk_plazo_fijo_nro_suc
    FOREIGN KEY(nro_suc) REFERENCES Sucursal(nro_suc)
) ENGINE=InnoDB;

CREATE TABLE Tasa_Plazo_Fijo (
    periodo INT UNSIGNED NOT NULL
    CHECK (periodo >= 100 AND periodo <= 999), 
    monto_inf DECIMAL(10, 2)  
    CHECK (monto_inf > 0),
    monto_sup DECIMAL(10, 2)  
    CHECK (monto_sup > 0), 
    tasa DECIMAL(5, 2)
    CHECK (tasa > 0),
    
    CONSTRAINT pk_tasa_plazo_fijo
    PRIMARY KEY (periodo,monto_inf,monto_sup)  -- PREGUNTAR SI ES LLAVE COMPUESTA DE A TRES, Y CUANDO SE USA "key";
) ENGINE=InnoDB;

CREATE TABLE Plazo_Cliente (
    nro_plazo BIGINT UNSIGNED NOT NULL , 
    nro_cliente BIGINT UNSIGNED NOT NULL,
    
    CONSTRAINT pk_plazo_cliente PRIMARY KEY (nro_plazo, nro_cliente),  -- Clave primaria compuesta,CONSULTAR

    CONSTRAINT fk_plazo_cliente_nro_plazo_plazo_fijo
    FOREIGN KEY (nro_plazo) REFERENCES Plazo_Fijo(nro_plazo),

    CONSTRAINT fk_plazo_cliente_nro_cliente_cliente 
    FOREIGN KEY (nro_cliente) REFERENCES Cliente(nro_cliente) 
)    ENGINE=InnoDB;

CREATE TABLE Prestamo (
    nro_prestamo BIGINT UNSIGNED NOT NULL CHECK (nro_prestamo >= 10000000 AND nro_prestamo <= 99999999),  -- Natural de 8 cifras
    fecha DATE NOT NULL,  -- Fecha del préstamo
    cant_meses TINYINT UNSIGNED NOT NULL CHECK (cant_meses >= 1 AND cant_meses <= 99),  -- Natural de 2 cifras (1 a 99 meses)
    monto DECIMAL(10, 2) NOT NULL CHECK (monto > 0),  -- Monto del préstamo, real positivo con 2 decimales
    tasa_interes DECIMAL(5, 2) NOT NULL CHECK (tasa_interes > 0),  -- Tasa de interés, real positivo con 2 decimales
    interes DECIMAL(10, 2)  CHECK (interes > 0),  -- CONSULTAR SI EL HECHO DE QUE EN EL GRAFICO SE VEAN COMO
    valor_cuota DECIMAL(10, 2)  CHECK (valor_cuota > 0),  -- ATRIBUTOS DEBILES SIGNIFICA QUE NO DEBEN SER NO NULOS
    legajo INT UNSIGNED NOT NULL,  -- Referencia al legajo del empleado
    nro_cliente BIGINT UNSIGNED NOT NULL,  -- Referencia al número de cliente
    
    CONSTRAINT pk_prestamo PRIMARY KEY (nro_prestamo),  -- Clave primaria en nro_prestamo
    CONSTRAINT fk_prestamo_empleado FOREIGN KEY (legajo) REFERENCES Empleado(legajo),  -- Relación con Empleado
    CONSTRAINT fk_prestamo_cliente FOREIGN KEY (nro_cliente) REFERENCES Cliente(nro_cliente)  -- Relación con Cliente
) ENGINE=InnoDB;

CREATE TABLE Pago ( -- PREGUNTAR YA QUE ES ENTIDAD DEBIL
    nro_prestamo BIGINT UNSIGNED NOT NULL,  -- Referencia a nro_prestamo en la tabla Prestamo
    nro_pago TINYINT UNSIGNED NOT NULL CHECK (nro_pago >= 1 AND nro_pago <= 99),  -- Natural de 2 cifras (1 a 99)
    fecha_venc DATE NOT NULL,  -- Fecha de vencimiento del pago
    fecha_pago DATE,  -- Fecha en que se realizó el pago (puede ser NULL si no se ha pagado)
    
    CONSTRAINT pk_pago PRIMARY KEY (nro_prestamo, nro_pago),  -- Clave primaria compuesta
    CONSTRAINT fk_pago_prestamo FOREIGN KEY (nro_prestamo) REFERENCES Prestamo(nro_prestamo)  -- Clave foránea hacia Prestamo
) ENGINE=InnoDB;

CREATE TABLE Tasa_Prestamo (
    periodo SMALLINT UNSIGNED NOT NULL,  -- Natural de 3 cifras
    monto_inf DECIMAL(10, 2) NOT NULL,  -- Real positivo con 2 decimales
    monto_sup DECIMAL(10, 2) NOT NULL,  -- ESTA OPERACION NO ES VALIDA EN SQL: (monto_sup > 0 AND monto_sup > monto_inf)
    tasa DECIMAL(5, 2) NOT NULL,  -- Real positivo con 2 decimales
    
    CONSTRAINT pk_tasa_prestamo PRIMARY KEY (periodo, monto_inf, monto_sup),  -- Clave primaria compuesta
    
    CONSTRAINT chk_monto_inf CHECK (monto_inf > 0),  -- Real positivo con 2 decimales
    CONSTRAINT chk_monto_sup CHECK (monto_sup > 0),  -- Real positivo
    CONSTRAINT chk_tasa CHECK (tasa > 0)  -- Real positivo con 2 decimales
) ENGINE=InnoDB;

CREATE TABLE Caja_Ahorro (
    nro_ca BIGINT UNSIGNED NOT NULL CHECK (nro_ca >= 10000000 AND nro_ca <= 99999999),  -- Natural de 8 cifras
    CBU BIGINT UNSIGNED NOT NULL CHECK (CBU >= 100000000000000000 AND CBU <= 999999999999999999),  -- Natural de 18 cifras
    saldo DECIMAL(15, 2) NOT NULL CHECK (saldo >= 0),  -- Real positivo con 2 decimales
    
    CONSTRAINT pk_caja_ahorro PRIMARY KEY (nro_ca)  -- Clave primaria
) ENGINE=InnoDB;

CREATE TABLE Cliente_CA ( -- RELACION  MUCHOS A MUCHOS
    nro_cliente BIGINT UNSIGNED NOT NULL,  -- Número de cliente positivo
    nro_ca BIGINT UNSIGNED NOT NULL,  -- Número de Caja de Ahorro, natural de 8 cifras, no se checkea por la restriccion heredada
    
    CONSTRAINT pk_cliente_ca PRIMARY KEY (nro_cliente, nro_ca),  -- Clave primaria compuesta
    CONSTRAINT fk_cliente_ca_caja FOREIGN KEY (nro_ca) REFERENCES Caja_Ahorro(nro_ca),  -- Relación con la tabla Caja_Ahorro
    CONSTRAINT fk_cliente_ca_cliente FOREIGN KEY (nro_cliente) REFERENCES Cliente(nro_cliente)  -- Relación con la tabla Cliente
) ENGINE=InnoDB;

CREATE TABLE Tarjeta (
    nro_tarjeta BIGINT UNSIGNED NOT NULL CHECK (nro_tarjeta BETWEEN 1000000000000000 AND 9999999999999999),  -- Número de tarjeta, natural de 16 cifras
    PIN CHAR(32) NOT NULL,  -- PIN almacenado como cadena de 32 caracteres
    CVT CHAR(32) NOT NULL,  -- CVT almacenado como cadena de 32 caracteres
    fecha_venc DATE NOT NULL,  -- Fecha de vencimiento
    nro_cliente BIGINT UNSIGNED NOT NULL,  -- Número de cliente
    nro_ca BIGINT UNSIGNED NOT NULL,  -- Número de Caja de Ahorro
    
    CONSTRAINT pk_tarjeta PRIMARY KEY (nro_tarjeta),  -- Clave primaria
    CONSTRAINT fk_tarjeta_cliente_ca FOREIGN KEY (nro_cliente, nro_ca) REFERENCES Cliente_CA(nro_cliente, nro_ca)  -- Relación con la tabla Cliente_CA
) ENGINE=InnoDB;

CREATE TABLE Caja (
    cod_caja SMALLINT UNSIGNED NOT NULL CHECK (cod_caja BETWEEN 10000 AND 99999),  -- Código de caja, natural de 5 cifras
    
    CONSTRAINT pk_caja PRIMARY KEY (cod_caja)  -- Clave primaria
) ENGINE=InnoDB;

CREATE TABLE Ventanilla (
    cod_caja SMALLINT UNSIGNED NOT NULL,  -- Código de caja, natural de 5 cifras
    nro_suc INT UNSIGNED NOT NULL ,  -- Número de sucursal, natural de 3 cifras
    
    CONSTRAINT pk_ventanilla PRIMARY KEY (cod_caja),  -- Clave primaria 
    CONSTRAINT fk_ventanilla_caja FOREIGN KEY (cod_caja) REFERENCES Caja(cod_caja),  -- Relación con la tabla Caja
    CONSTRAINT fk_ventanilla_sucursal FOREIGN KEY (nro_suc) REFERENCES Sucursal(nro_suc)  -- Relación con la tabla Sucursal
) ENGINE=InnoDB;

CREATE TABLE ATM (
    cod_caja SMALLINT UNSIGNED NOT NULL,  -- Código de caja, natural de 5 cifras
    cod_postal INT UNSIGNED NOT NULL,  -- Código postal
    direccion VARCHAR(255) NOT NULL,  -- Dirección del ATM
    
    CONSTRAINT pk_atm PRIMARY KEY (cod_caja),  -- Clave primaria
    CONSTRAINT fk_atm_cod_caja FOREIGN KEY (cod_caja) REFERENCES Caja(cod_caja),  -- Relación con la tabla Caja    
    CONSTRAINT fk_atm_cod_postal FOREIGN KEY (cod_postal) REFERENCES Ciudad(cod_postal)  -- Relación con la tabla Ciudad
) ENGINE=InnoDB;

CREATE TABLE Transaccion (
    nro_trans BIGINT UNSIGNED NOT NULL CHECK (nro_trans BETWEEN 1000000000 AND 9999999999),  -- Número de transacción, natural de 10 cifras
    fecha DATE NOT NULL,  -- Fecha de la transacción
    hora TIME NOT NULL,  -- Hora de la transacción
    monto DECIMAL(15, 2) NOT NULL CHECK (monto > 0),  -- Monto de la transacción, real positivo con 2 decimales
    
    CONSTRAINT pk_transaccion PRIMARY KEY (nro_trans)  -- Clave primaria
) ENGINE=InnoDB;

CREATE TABLE Debito (
    nro_trans BIGINT UNSIGNED NOT NULL,  -- Número de transacción, natural de 10 cifras
    descripcion VARCHAR(255) NOT NULL,  -- Descripción del débito
    nro_cliente BIGINT UNSIGNED NOT NULL,  -- Número de cliente
    nro_ca BIGINT UNSIGNED NOT NULL,  -- Número de Caja de Ahorro
    
    
    CONSTRAINT pk_debito PRIMARY KEY (nro_trans),  -- Clave primaria
    
    CONSTRAINT fk_debito_transaccion FOREIGN KEY (nro_trans) REFERENCES Transaccion(nro_trans),  -- Relación con la tabla Transaccion    
    CONSTRAINT fk_debito_cliente_ca FOREIGN KEY (nro_cliente, nro_ca) REFERENCES Cliente_CA(nro_cliente, nro_ca)  -- Relación con la tabla Cliente_CA
) ENGINE=InnoDB;

CREATE TABLE Transaccion_por_Caja (
    nro_trans BIGINT UNSIGNED NOT NULL,  -- Número de transacción, natural de 10 cifras
    cod_caja SMALLINT UNSIGNED NOT NULL,  -- Código de caja, natural de 5 cifras
    
    CONSTRAINT pk_transaccion_por_caja PRIMARY KEY (nro_trans),  -- Clave primaria
    
    CONSTRAINT fk_transaccion_por_caja_transaccion FOREIGN KEY (nro_trans) REFERENCES Transaccion(nro_trans),  -- Relación con la tabla Transaccion
    CONSTRAINT fk_transaccion_por_caja_caja FOREIGN KEY (cod_caja) REFERENCES Caja(cod_caja)  -- Relación con la tabla Caja
) ENGINE=InnoDB;

CREATE TABLE Deposito (
    nro_trans BIGINT UNSIGNED NOT NULL,  -- Número de transacción por caja, natural de 10 cifras
    nro_ca BIGINT UNSIGNED NOT NULL,  -- Número de Caja de Ahorro
    
    CONSTRAINT pk_deposito PRIMARY KEY (nro_trans),  -- Clave primaria
    
    CONSTRAINT fk_deposito_transaccion_por_caja FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_Caja(nro_trans),  -- Relación con la tabla Transaccion_por_Caja
    CONSTRAINT fk_deposito_caja_ahorro FOREIGN KEY (nro_ca) REFERENCES Caja_Ahorro(nro_ca)  -- Relación con la tabla Caja_Ahorro
) ENGINE=InnoDB;

CREATE TABLE Extraccion (
    nro_trans BIGINT UNSIGNED NOT NULL,  -- Número de transacción por caja, natural de 10 cifras
    nro_cliente BIGINT UNSIGNED NOT NULL,  -- Número de cliente
    nro_ca BIGINT UNSIGNED NOT NULL,  -- Número de Caja de Ahorro
    
    CONSTRAINT pk_extraccion PRIMARY KEY (nro_trans),  -- Clave primaria
    
    CONSTRAINT fk_extraccion_transaccion_por_caja FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_Caja(nro_trans),  -- Relación con la tabla Transaccion_por_Caja
    CONSTRAINT fk_extraccion_cliente_ca FOREIGN KEY (nro_cliente, nro_ca) REFERENCES Cliente_CA(nro_cliente, nro_ca)  -- Relación con la tabla Cliente_CA
) ENGINE=InnoDB;

CREATE TABLE Transferencia (
    nro_trans BIGINT UNSIGNED NOT NULL,  -- Número de transacción por caja, natural de 10 cifras
    nro_cliente BIGINT UNSIGNED NOT NULL,  -- Número de cliente
    origen BIGINT UNSIGNED NOT NULL,  -- Número de Caja de Ahorro de origen
    destino BIGINT UNSIGNED NOT NULL,  -- Número de Caja de Ahorro destino
    
    CONSTRAINT pk_transferencia PRIMARY KEY (nro_trans),  -- Clave primaria
    
    CONSTRAINT fk_transferencia_transaccion_por_caja FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_Caja(nro_trans),  -- Relación con la tabla Transaccion_por_Caja
    CONSTRAINT fk_transferencia_cliente_origen FOREIGN KEY (nro_cliente, origen) REFERENCES Cliente_CA(nro_cliente, nro_ca),  -- Relación con la tabla Cliente_CA
    CONSTRAINT fk_transferencia_caja_destino FOREIGN KEY (destino) REFERENCES Caja_Ahorro(nro_ca)  -- Relación con la tabla Caja_Ahorro
) ENGINE=InnoDB;

#-------------------------------------------------------------------------
# Creación de usuarios y otorgamiento de privilegios

# primero creo un usuario con CREATE USER

 CREATE USER 'admin'@'localhost'  IDENTIFIED BY 'admin';
 
# el usuario admin con password 'admin' puede conectarse solo 
# desde la desde la computadora donde se encuentra el servidor de MySQL (localhost)   

# luego le otorgo privilegios utilizando solo la sentencia GRANT

    GRANT ALL PRIVILEGES ON banco.* TO 'admin'@'localhost' WITH GRANT OPTION;

# El usuario 'admin' tiene acceso total a todas las tablas de 
# la B.D. banco y puede crear nuevos usuarios y otorgar privilegios.

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

-- DROP USER ''@'localhost'; no hace falta porque no hay en las versiones nuevas, asi que tira error si se deja.

CREATE VIEW vista_debito AS
SELECT 
    ca.nro_ca, ca.saldo, t.nro_trans, t.fecha, t.hora,  'deposito' AS tipo,
    t.monto, tpc.cod_caja, NULL AS nro_cliente,
		NULL AS tipo_doc, NULL AS nro_doc, NULL AS nombre, NULL AS apellido, NULL AS destino
FROM Transaccion AS t
JOIN Caja_Ahorro AS ca
JOIN Transaccion_por_caja AS tpc;

CREATE VIEW vista_extraccion AS
SELECT 
    ca.nro_ca, ca.saldo, t.nro_trans, t.fecha, t.hora,  'extraccion' AS tipo,
    t.monto, tpc.cod_caja, cc.nro_cliente,
    c.tipo_doc, c.nro_doc, c.nombre, c.apellido, NULL AS destino
FROM Transaccion AS t
JOIN Caja_Ahorro AS ca
JOIN Cliente_CA AS cc
JOIN Cliente AS c
JOIN Transaccion_por_caja AS tpc;

CREATE VIEW vista_transferencia AS
SELECT 
    ca.nro_ca, ca.saldo, t.nro_trans, t.fecha, t.hora,  'transferencia' AS tipo,
    t.monto, tpc.cod_caja, cc.nro_cliente,
    c.tipo_doc, c.nro_doc, c.nombre, c.apellido, tf.destino
FROM Transaccion AS t
JOIN Caja_Ahorro AS ca
JOIN Cliente_CA AS cc
JOIN Cliente AS c
JOIN Transaccion_por_caja AS tpc
JOIN Transferencia AS tf;


-- CREATE USER 'atm'@'%' IDENTIFIED BY 'atm';

-- GRANT SELECT ON banco.trans_cajas_ahorro TO 'atm'@'%';

-- GRANT SELECT, UPDATE ON banco.tarjeta TO 'atm'@'%';



	