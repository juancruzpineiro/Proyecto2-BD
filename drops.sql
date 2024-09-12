DROP DATABASE BANCO;
DROP USER 'admin'@'localhost';
DROP USER 'empleado'@'%';
DROP USER 'atm'@'%';

TRUNCATE TABLE Empleado;
TRUNCATE TABLE Sucursal;
TRUNCATE TABLE Ciudad;

