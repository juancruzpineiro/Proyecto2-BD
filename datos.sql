## -----     PROYECTO 1 - BASES DE DATOS     ----- ##
## -----      Dulce, Sahid (LU 139.656)      ----- ##
## -----    Piñeiro, Juan Cruz (LU 121.302)  ----- ##

INSERT INTO Ciudad VALUES (1001, 'Buenos Aires');
INSERT INTO Ciudad VALUES (5000, 'Córdoba');
INSERT INTO Ciudad VALUES (7600, 'Mar del Plata');
INSERT INTO Ciudad VALUES (8300, 'Neuquén');

INSERT INTO Sucursal VALUES (NULL, 'Sucursal Centro', 'Av. Corrientes 1234', '01145678900', '09:00', 1001);
INSERT INTO Sucursal VALUES (NULL, 'Sucursal Palermo', 'Calle Borges 5678', '01123456789', '10:00', 1001);
INSERT INTO Sucursal VALUES (NULL, 'Sucursal Nueva Córdoba', 'Bv. San Juan 123', '03511234567', '09:00', 5000);
INSERT INTO Sucursal VALUES (NULL, 'Sucursal Mar del Plata', 'Calle Güemes 4321', '02239876543', '09:30', 7600);
INSERT INTO Sucursal VALUES (NULL, 'Sucursal Neuquén', 'Av. Argentina 987', '02997654321', '08:00', 8300);
INSERT INTO Sucursal VALUES (NULL, 'Sucursal General Paz', 'Calle Olmos 678', '03518765432', '09:00', 5000);

INSERT INTO Empleado VALUES (NULL, 'Gomez', 'Juan', 'DNI', 12345678, 'San Martín 123', '155789012', 'Cajero', MD5('password1'), 2);
INSERT INTO Empleado VALUES (NULL, 'Rodriguez', 'Lucia', 'DNI', 87654321, 'Belgrano 456', '155234567', 'Gerente', MD5('password2'), 3);
INSERT INTO Empleado VALUES (NULL, 'Fernandez', 'Laura', 'DNI', 11223344, 'Alvear 789', '155345678', 'Estudiante', MD5('password3'), 4);
INSERT INTO Empleado VALUES (NULL, 'Lopez', 'Carlos', 'DNI', 44332211, 'Rivadavia 1010', '155456789', 'Supervisor', MD5('password4'), 5);
INSERT INTO Empleado VALUES (NULL, 'Martinez', 'Ana', 'DNI', 55667788, '9 de Julio 234', '155567890', 'Analista', MD5('password5'), 6);
INSERT INTO Empleado VALUES (NULL, 'Sanchez', 'Marta', 'DNI', 66778899, 'Mitre 345', '155678901', 'Estudiante', MD5('password6'), 1);
INSERT INTO Empleado VALUES (NULL, 'Diaz', 'Javier', 'DNI', 99887766, 'Santa Fe 678', '155789012', 'Cajero', MD5('password7'), 2);
INSERT INTO Empleado VALUES (NULL, 'Moreno', 'Sofia', 'DNI', 33445566, 'Cordoba 987', '155890123', 'Gerente', MD5('password8'), 3);
INSERT INTO Empleado VALUES (NULL, 'Silva', 'Pablo', 'DNI', 22334455, 'Sarmiento 432', '155901234', 'Supervisor', MD5('password9'), 4);

INSERT INTO Cliente VALUES (NULL, 'Gonzalez', 'Maria', 'DNI', 12345678, 'Calle Falsa 123', '01123456789', '1985-07-15');
INSERT INTO Cliente VALUES (NULL, 'Rodriguez', 'Carlos', 'DNI', 23456789, 'Avenida Siempre Viva 456', '01198765432', '1990-11-22');
INSERT INTO Cliente VALUES (NULL, 'Martinez', 'Ana', 'DNI', 34567890, 'Calle de la Luna 789', '01134567890', '1988-03-30');
INSERT INTO Cliente VALUES (NULL, 'Lopez', 'Juan', 'DNI', 45678901, 'Boulevard del Sol 1011', '01145678901', '1975-12-05');
INSERT INTO Cliente VALUES (NULL, 'Fernandez', 'Sofia', 'DNI', 56789012, 'Avenida del Libertador 1212', '01156789012', '1992-09-10');

INSERT INTO Caja VALUES (NULL);
INSERT INTO Caja VALUES (NULL);
INSERT INTO Caja VALUES (NULL);
INSERT INTO Caja VALUES (NULL);
INSERT INTO Caja VALUES (NULL);


INSERT INTO Caja_Ahorro VALUES (NULL, 123456789012345678, 1500.50);
INSERT INTO Caja_Ahorro VALUES (NULL, 234567890123456789, 2500.75);
INSERT INTO Caja_Ahorro VALUES (NULL, 345678901234567890, 3000.00);
INSERT INTO Caja_Ahorro VALUES (NULL, 456789012345678901, 1200.25);
INSERT INTO Caja_Ahorro VALUES (NULL, 567890123456789012, 1800.10);

INSERT INTO Transaccion VALUES (NULL, '2024-09-01', '08:30:00', 500.75);
INSERT INTO Transaccion VALUES (NULL, '2024-09-02', '09:45:00', 1500.20);
INSERT INTO Transaccion VALUES (NULL, '2024-09-03', '10:00:00', 275.50);
INSERT INTO Transaccion VALUES (NULL, '2024-09-04', '14:15:00', 1000.00);
INSERT INTO Transaccion VALUES (NULL, '2024-09-05', '16:30:00', 875.40);

INSERT INTO Cliente_CA VALUES (1, 2);
INSERT INTO Cliente_CA VALUES (2, 1);
INSERT INTO Cliente_CA VALUES (3, 4);
INSERT INTO Cliente_CA VALUES (4, 3);
INSERT INTO Cliente_CA VALUES (5, 5);

INSERT INTO Transaccion_por_caja VALUES (1, 1);
INSERT INTO Transaccion_por_caja VALUES (2, 2);
INSERT INTO Transaccion_por_caja VALUES (3, 3);
INSERT INTO Transaccion_por_caja VALUES (4, 4);
INSERT INTO Transaccion_por_caja VALUES (5, 5);


INSERT INTO Transferencia VALUES (1, 1, 2, 2);
INSERT INTO Transferencia VALUES (2, 3, 4, 4);
INSERT INTO Transferencia VALUES (3, 2, 1, 4);
INSERT INTO Transferencia VALUES (4, 4, 3, 5);
INSERT INTO Transferencia VALUES (5, 5, 5, 1);

INSERT INTO Debito VALUES (1, 'Compra en tienda', 1, 2);
INSERT INTO Debito VALUES (2, 'Pago de servicios', 2, 1);
INSERT INTO Debito VALUES (3, 'Retiro en cajero', 3, 4);
INSERT INTO Debito VALUES (4, 'Transferencia a cuenta', 4, 3);
INSERT INTO Debito VALUES (5, 'Compra en línea', 5, 5);

INSERT INTO Deposito VALUES (1, 1);
INSERT INTO Deposito VALUES (2, 2);
INSERT INTO Deposito VALUES (3, 3);
INSERT INTO Deposito VALUES (4, 4);
INSERT INTO Deposito VALUES (5, 5);

INSERT INTO Extraccion VALUES (1, 1, 2);
INSERT INTO Extraccion VALUES (2, 2, 1);
INSERT INTO Extraccion VALUES (3, 3, 4);
INSERT INTO Extraccion VALUES (4, 4, 3);
INSERT INTO Extraccion VALUES (5, 5, 5);
