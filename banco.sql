-- drop database BANCO;

CREATE DATABASE BANCO CHARACTER SET latin1 COLLATE latin1_spanish_ci;
USE BANCO;

-- Ciudad (cod postal, nombre)
CREATE TABLE Ciudad(
    cod_postal INT UNSIGNED NOT NULL,
    CHECK (cod_postal > 999 AND cod_postal <= 9999),
    -- PREGUNTAR SI ES ASÍ LO QUE PIDEN, 4 DÍGITOS O CHAR
    nombre VARCHAR(100) NOT NULL,
    PRIMARY KEY(cod_postal)
) ENGINE=InnoDB;

-- Sucursal (nro suc, nombre, direccion, telefono, horario, cod postal)
CREATE TABLE Sucursal(
    nro_suc INT UNSIGNED NOT NULL,
    CHECK (nro_suc > 99 AND nro_suc <= 999),  -- PREGUNTAR SI ESTO ESTÁ BIEN
    
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(12),
	horario VARCHAR(4),
    cod_postal INT UNSIGNED NOT NULL,
    
    PRIMARY KEY(nro_suc),
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
    nro_doc INT SIGNED NOT NULL, -- VER QUÉ ONDA CON EL RANGO
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(12),
	cargo VARCHAR(100),
    nro_suc INT UNSIGNED NOT NULL,
    
    password VARCHAR (32) NOT NULL,-- Ver qué onda con el hash
    

    
    
    PRIMARY KEY(legajo),
    FOREIGN KEY(nro_suc) REFERENCES Sucursal(nro_suc)
) ENGINE=InnoDB;

-- Cliente (nro cliente, apellido, nombre, tipo doc, nro doc, direccion, telefono, fecha nac)
CREATE TABLE Cliente(
	nro_cliente BIGINT UNSIGNED NOT NULL,
	CHECK (nro_cliente > 9999 AND nro_cliente <= 100000),

	nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    tipo_doc VARCHAR(10) NOT NULL,
	nro_doc INT SIGNED NOT NULL, -- VER QUÉ ONDA CON EL RANGO, 8 CIFRAS SEGÚN EL ENUNCIADO
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(12),
	fecha_nac VARCHAR(100), -- No especifica qué tipo de dato es
	nro_suc INT UNSIGNED NOT NULL,
    
    
    PRIMARY KEY(nro_cliente),
    FOREIGN KEY(nro_suc) REFERENCES Sucursal(nro_suc)
) ENGINE=InnoDB;

-- Plazo Fijo (nro plazo, capital, fecha inicio, fecha fin, tasa interes, interes, nro suc)
-- SIN TERMINAR 
CREATE TABLE Plazo_Fijo(
	
    nro_plazo BIGINT UNSIGNED NOT NULL CHECK (nro_plazo >= 10000000 AND nro_plazo <= 99999999),
    capital DECIMAL(10, 2) CHECK (capital > 0),
    fecha_inicio DATE,
    fecha_n DATE,
    tasa_interes DECIMAL(5, 2) CHECK (tasa_interes > 0), -- Real positivo con 2 decimales
    interes DECIMAL(10, 2) CHECK (interes > 0), -- Real positivo con 2 decimales
 
    
	
    nro_suc INT UNSIGNED NOT NULL,
    
    PRIMARY KEY(nro_plazo),
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
    
    PRIMARY KEY (periodo, monto_inf)
) ENGINE=InnoDB;

CREATE TABLE Plazo_Cliente (
    nro_plazo BIGINT UNSIGNED NOT NULL, 
    nro_cliente BIGINT UNSIGNED NOT NULL, 
    PRIMARY KEY (nro_plazo, nro_cliente),
    FOREIGN KEY (nro_plazo) REFERENCES Plazo_Fijo(nro_plazo), 
    FOREIGN KEY (nro_cliente) REFERENCES Cliente(nro_cliente) 
);


	