/*CREADO POR: Grupo 01
PROYECTO AVANCE 01: Parte 1. Diseno y Configuracion Inicial
FECHA: 06/03/2025

** SISTEMA DE GESTION DE BASE DE DATOS PARA EL CENTRO TERAPEUTICO BONZAI SRL **

Parte 05: Implementacion Inicial*/

--============================================================================--

-- Creacion de tablas con claves primarias, foraneas y restricciones de integridad

--- TABLA DIRECCIONES -------------------------------------------------------------
CREATE TABLE DIRECCIONES (
    cod_direccion NUMBER CONSTRAINT DIRECCIONES_ID_PK PRIMARY KEY,
    provincia VARCHAR2 (100) NOT NULL,
    canton VARCHAR2 (100) NOT NULL,
    distrito VARCHAR2 (100) NOT NULL,
    otros_detalles VARCHAR2 (500)              
);

--- TABLA CLIENTES -------------------------------------------------------------
CREATE TABLE CLIENTES (
    id_cliente NUMBER CONSTRAINT CLIENTES_ID_PK PRIMARY KEY,
    nombre VARCHAR2 (100) NOT NULL, -- Realizar concatenacion de nombre y apellidos como nombre completo
    apellidos VARCHAR2 (100) NOT NULL, -- Apellido 1 y Apellido 2
    fecha_nacimiento DATE,
    contacto VARCHAR2 (250)
                CONSTRAINT CLIENTES_contacto_Unique_IDX UNIQUE
                CONSTRAINT CLIENTES_contacto_Not_Null NOT NULL,
    cod_direccion NUMBER (5) REFERENCES DIRECCIONES (cod_direccion),
    valoracion VARCHAR2 (1000)
);

COMMENT ON COLUMN CLIENTES.id_cliente IS 'Identificador unico del cliente';
COMMENT ON COLUMN CLIENTES.nombre IS 'Nombre del cliente';
COMMENT ON COLUMN CLIENTES.apellidos IS 'Apellido del cliente';
COMMENT ON COLUMN CLIENTES.fecha_nacimiento IS 'Fecha de nacimiento del cliente';
COMMENT ON COLUMN CLIENTES.contacto IS 'Contacto del cliente (Email / Telefono)';
COMMENT ON COLUMN CLIENTES.cod_direccion IS 'Direccion del cliente';
COMMENT ON COLUMN CLIENTES.valoracion IS 'Valoracion del cliente';

COMMIT;

-- TABLA ESPECIALIDAD ------------------------------------------------------------
CREATE TABLE ESPECIALIDADES (
    cod_especialidad NUMBER CONSTRAINT ESPECIALIDADES_ID_PK PRIMARY KEY,
    nombre VARCHAR2 (100) NOT NULL               
);

-- TABLA TERAPEUTAS ------------------------------------------------------------
CREATE TABLE TERAPEUTAS (
    id_terapeuta NUMBER CONSTRAINT TERAPEUTAS_ID_PK PRIMARY KEY,
    codigo_terapeuta NUMBER NOT NULL,
    nombre VARCHAR2 (100) NOT NULL,
    apellidos VARCHAR2 (100) NOT NULL,
    cod_especialidad NUMBER(5) REFERENCES ESPECIALIDADES (cod_especialidad),
    contacto VARCHAR2 (250)
                CONSTRAINT TERAPEUTAS_contacto_Unique_IDX UNIQUE
                CONSTRAINT TERAPEUTAS_contacto_Not_Null NOT NULL
);

COMMENT ON COLUMN TERAPEUTAS.id_terapeuta IS 'Identificador unico del terapeuta';
COMMENT ON COLUMN TERAPEUTAS.codigo_terapeuta IS 'Codigo del terapeuta';
COMMENT ON COLUMN TERAPEUTAS.nombre IS 'Nombre del terapeuta';
COMMENT ON COLUMN TERAPEUTAS.apellidos IS 'Apellido del terapeuta';
COMMENT ON COLUMN TERAPEUTAS.cod_especialidad IS 'Especialidad del terapeuta';
COMMENT ON COLUMN TERAPEUTAS.contacto IS 'Contacto del terapeuta (Email / Telefono)';

COMMIT;

-- TABLA TERAPIAS ------------------------------------------------------------
CREATE TABLE TERAPIAS (
    id_terapia NUMBER CONSTRAINT TERAPIAS_ID_PK PRIMARY KEY,
    tipo_terapia VARCHAR2 (100),
    sesion VARCHAR2 (100) NOT NULL,
    costo VARCHAR2 (50) NOT NULL
);

COMMENT ON COLUMN TERAPIAS.id_terapia IS 'Identificador unico de la terapia';
COMMENT ON COLUMN TERAPIAS.tipo_terapia IS 'Nombre o tipo de terapia';
COMMENT ON COLUMN TERAPIAS.sesion IS 'Numero de sesion';
COMMENT ON COLUMN TERAPIAS.costo IS 'Costo de la terapia';

COMMIT;

-- TABLA CITAS ------------------------------------------------------------
CREATE TABLE CITAS (
    id_cita NUMBER CONSTRAINT CITAS_ID_PK PRIMARY KEY,
    id_cliente NUMBER(5),
    id_terapeuta NUMBER(5),
    id_terapia NUMBER(5),
    fecha_hora TIMESTAMP,
    estado VARCHAR2 (50),
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES (id_cliente),
    FOREIGN KEY (id_terapeuta) REFERENCES TERAPEUTAS (id_terapeuta),
    FOREIGN KEY (id_terapia) REFERENCES TERAPIAS (id_terapia)
);

COMMENT ON COLUMN CITAS.id_cita IS 'Identificador unico de la cita';
COMMENT ON COLUMN CITAS.fecha IS 'Fecha y hora de la cita';
COMMENT ON COLUMN CITAS.estado IS 'Estado de la cita (Pendiente / En progreso / Atendido)';
COMMENT ON COLUMN CITAS.id_cliente IS 'Datos del cliente';
COMMENT ON COLUMN CITAS.id_terapeuta IS 'Datos del terapeuta';
COMMENT ON COLUMN CITAS.id_terapia IS 'Terapia que se realiza';

COMMIT;

-- TABLA EXPEDIENTES ------------------------------------------------------------
CREATE TABLE EXPEDIENTES (
    id_expediente NUMBER CONSTRAINT EXPEDIENTES_ID_PK PRIMARY KEY,
    id_cliente NUMBER(5),
    fecha DATE,
    descripcion VARCHAR2 (4000),
    progreso VARCHAR2 (4000),
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES (id_cliente)
);

COMMENT ON COLUMN EXPEDIENTES.id_expediente IS 'Identificador unico del expediente';
COMMENT ON COLUMN EXPEDIENTES.fecha IS 'Fecha del expediente';
COMMENT ON COLUMN EXPEDIENTES.descripcion IS 'Descripcion';
COMMENT ON COLUMN EXPEDIENTES.progreso IS 'Progreso';
COMMENT ON COLUMN EXPEDIENTES.id_cliente IS 'Datos del cliente';

COMMIT;

-- TABLA PAGOS ------------------------------------------------------------
CREATE TABLE PAGOS (
    id_pago NUMBER CONSTRAINT PAGOS_ID_PK PRIMARY KEY,
    id_cliente NUMBER(5),
    monto NUMBER,
    metodo_pago VARCHAR2 (50),
    fecha_hora_pago TIMESTAMP,
    estado_pago VARCHAR2 (50),
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES (id_cliente)
);

COMMENT ON COLUMN PAGOS.id_pago IS 'Identificador unico del pago';
COMMENT ON COLUMN PAGOS.monto IS 'Monto a pagar';
COMMENT ON COLUMN PAGOS.metodo_pago IS 'Metodo de pago (Efectivo / Tarjeta / Sinpe)';
COMMENT ON COLUMN PAGOS.fecha_hora_pago IS 'Fecha y hora del pago';
COMMENT ON COLUMN PAGOS.estado_pago IS 'Estado del pago (Pendiente / Realizado)';
COMMENT ON COLUMN PAGOS.id_cliente IS 'Datos del cliente';

COMMIT;


------ PROCEDIMIENTO PARA INSERTAR DATOS RANDOM EN LAS TABLAS ------

-- PROCEDIMIENTO PARA INSERTAR DATOS RANDOM EN LA TABLA DIRECCIONES
CREATE OR REPLACE PROCEDURE insertar_direcciones_random(p_cantidad IN NUMBER) AS
BEGIN
    FOR i IN 1..p_cantidad LOOP
        INSERT INTO DIRECCIONES (cod_direccion, provincia, canton, distrito, otros_detalles)
        VALUES (
            i,
            DBMS_RANDOM.STRING('U', 10), -- Genera una cadena de 10 caracteres
            DBMS_RANDOM.STRING('U', 10),
            DBMS_RANDOM.STRING('U', 10),
            DBMS_RANDOM.STRING('U', 20)
        );
    END LOOP;
    COMMIT;
END insertar_direcciones_random;
/

-- PROCEDIMIENTO PARA INSERTAR DATOS RANDOM EN LA TABLA CLIENTES
CREATE OR REPLACE PROCEDURE insertar_clientes_random(p_cantidad IN NUMBER) AS
BEGIN
    FOR i IN 1..p_cantidad LOOP
        INSERT INTO CLIENTES (id_cliente, nombre, apellidos, fecha_nacimiento, contacto, cod_direccion, valoracion)
        VALUES (
            i,
            DBMS_RANDOM.STRING('U', 8), -- Genera un nombre aleatorio
            DBMS_RANDOM.STRING('U', 12), -- Genera un apellido aleatorio
            SYSDATE - TRUNC(DBMS_RANDOM.VALUE(6570, 18250)), -- Fecha entre 18 y 50 años atrás
            DBMS_RANDOM.STRING('U', 15), -- Contacto aleatorio
            TRUNC(DBMS_RANDOM.VALUE(1, p_cantidad)), -- Relaciona con direcciones existentes
            DBMS_RANDOM.STRING('U', 50) -- Valoración aleatoria
        );
    END LOOP;
    COMMIT;
END insertar_clientes_random;
/

-- PROCEDIMIENTO PARA INSERTAR DATOS RANDOM EN LA TABLA ESPECIALIDADES
CREATE OR REPLACE PROCEDURE insertar_especialidades_random(p_cantidad IN NUMBER) AS
BEGIN
    FOR i IN 1..p_cantidad LOOP
        INSERT INTO ESPECIALIDADES (cod_especialidad, nombre)
        VALUES (
            i,
            DBMS_RANDOM.STRING('U', 15) -- Genera un nombre de especialidad aleatorio
        );
    END LOOP;
    COMMIT;
END insertar_especialidades_random;
/

-- PROCEDIMIENTO PARA INSERTAR DATOS RANDOM EN LA TABLA TERAPEUTAS
CREATE OR REPLACE PROCEDURE insertar_terapeutas_random(p_cantidad IN NUMBER) AS
BEGIN
    FOR i IN 1..p_cantidad LOOP
        INSERT INTO TERAPEUTAS (id_terapeuta, codigo_terapeuta, nombre, apellidos, cod_especialidad, contacto)
        VALUES (
            i,
            TRUNC(DBMS_RANDOM.VALUE(1000, 9999)), -- Código aleatorio
            DBMS_RANDOM.STRING('U', 8), -- Nombre aleatorio
            DBMS_RANDOM.STRING('U', 12), -- Apellido aleatorio
            TRUNC(DBMS_RANDOM.VALUE(1, p_cantidad)), -- Relaciona con especialidades
            DBMS_RANDOM.STRING('U', 15) -- Contacto aleatorio
        );
    END LOOP;
    COMMIT;
END insertar_terapeutas_random;
/


-- PROCEDIMIENTO PARA INSERTAR DATOS RANDOM EN LA TABLA TERAPIAS
CREATE OR REPLACE PROCEDURE insertar_terapias_random(p_cantidad IN NUMBER) AS
BEGIN
    FOR i IN 1..p_cantidad LOOP
        INSERT INTO TERAPIAS (id_terapia, tipo_terapia, sesion, costo)
        VALUES (
            i,
            DBMS_RANDOM.STRING('U', 10), -- Tipo de terapia aleatorio
            DBMS_RANDOM.STRING('U', 5), -- Sesión aleatoria
            TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(20000, 80000))) -- Costo entre 20k y 80k
        );
    END LOOP;
    COMMIT;
END insertar_terapias_random;
/

-- PROCEDIMIENTO PARA INSERTAR DATOS RANDOM EN LA TABLA CITAS
CREATE OR REPLACE PROCEDURE insertar_citas_random(p_cantidad IN NUMBER) AS
BEGIN
    FOR i IN 1..p_cantidad LOOP
        INSERT INTO CITAS (id_cita, id_cliente, id_terapeuta, id_terapia, fecha_hora, estado)
        VALUES (
            i,
            TRUNC(DBMS_RANDOM.VALUE(1, 101)),   -- Para CLIENTES: valores de 1 a 100
            TRUNC(DBMS_RANDOM.VALUE(1, 71)),    -- Para TERAPEUTAS: valores de 1 a 70
            TRUNC(DBMS_RANDOM.VALUE(1, 101)),   -- Para TERAPIAS: valores de 1 a 100
            SYSTIMESTAMP - INTERVAL '1' DAY * TRUNC(DBMS_RANDOM.VALUE(0, 365)), -- Fecha aleatoria del último año
            CASE TRUNC(DBMS_RANDOM.VALUE(1, 4))  -- Estado aleatorio
                WHEN 1 THEN 'Pendiente'
                WHEN 2 THEN 'En progreso'
                ELSE 'Atendido'
            END
        );
    END LOOP;
    COMMIT;
END insertar_citas_random;
/

-- PROCEDIMIENTO PARA INSERTAR DATOS RANDOM EN LA TABLA EXPEDIENTES
CREATE OR REPLACE PROCEDURE insertar_expedientes_random(p_cantidad IN NUMBER) AS
BEGIN
    FOR i IN 1..p_cantidad LOOP
        INSERT INTO EXPEDIENTES (id_expediente, id_cliente, fecha, descripcion, progreso)
        VALUES (
            i,
            TRUNC(DBMS_RANDOM.VALUE(1, p_cantidad)), -- Relaciona con clientes
            SYSDATE - TRUNC(DBMS_RANDOM.VALUE(0, 1000)), -- Fecha aleatoria de los últimos 1000 días
            DBMS_RANDOM.STRING('U', 50), -- Descripción aleatoria
            DBMS_RANDOM.STRING('U', 50) -- Progreso aleatorio
        );
    END LOOP;
    COMMIT;
END insertar_expedientes_random;
/

-- PROCEDIMIENTO PARA INSERTAR DATOS RANDOM EN LA TABLA PAGOS
CREATE OR REPLACE PROCEDURE insertar_pagos_random(p_cantidad IN NUMBER) AS
BEGIN
    FOR i IN 1..p_cantidad LOOP
        INSERT INTO PAGOS (id_pago, id_cliente, monto, metodo_pago, fecha_hora_pago, estado_pago)
        VALUES (
            i,
            TRUNC(DBMS_RANDOM.VALUE(1, p_cantidad)), -- Relaciona con clientes
            ROUND(DBMS_RANDOM.VALUE(10000, 100000), 2), -- Monto aleatorio entre 10k y 100k
            CASE TRUNC(DBMS_RANDOM.VALUE(1, 4)) -- Método aleatorio
                WHEN 1 THEN 'Efectivo'
                WHEN 2 THEN 'Tarjeta'
                ELSE 'Sinpe'
            END,
            SYSTIMESTAMP - INTERVAL '1' DAY * TRUNC(DBMS_RANDOM.VALUE(0, 365)), -- Fecha aleatoria del último año
            CASE TRUNC(DBMS_RANDOM.VALUE(1, 3)) -- Estado aleatorio
                WHEN 1 THEN 'Pendiente'
                ELSE 'Realizado'
            END
        );
    END LOOP;
    COMMIT;
END insertar_pagos_random;
/

-- LLAMADO GENERAL
BEGIN
    insertar_direcciones_random(100);
END;
/

BEGIN
     insertar_especialidades_random(100);
END;
/

BEGIN
    insertar_clientes_random(100);
END;
/

BEGIN
      insertar_terapeutas_random(70);
END;
/

BEGIN
      insertar_terapias_random(100);
END;
/

BEGIN
      insertar_citas_random(100);
END;
/

BEGIN
      insertar_expedientes_random(100);
END;
/

BEGIN
      insertar_pagos_random(100);
END;
/

-- VALIDAR DATOS
SELECT * FROM DIRECCIONES;
SELECT * FROM CLIENTES;
SELECT * FROM ESPECIALIDADES;
SELECT * FROM TERAPEUTAS;
SELECT * FROM TERAPIAS;
SELECT * FROM CITAS; 
SELECT * FROM EXPEDIENTES;
SELECT * FROM PAGOS;
