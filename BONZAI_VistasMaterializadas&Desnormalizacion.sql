/*CREADO POR: Grupo 01
PROYECTO AVANCE 01: Parte 2: Administración y Optimización
FECHA: 24/04/2025

** SISTEMA DE GESTION DE BASE DE DATOS PARA EL CENTRO TERAPEUTICO BONZAI SRL **

Parte 03: Gestión administrativa
    • Diseñar y ejecutar un plan de respaldos y recuperación de datos.
    • Implementar vistas materializadas y desnormalización donde sea aplicable.*/

/*
================================================================================
================== PLAN DE RESPALDOS Y RECUPERACION DE DATOS ===================
================================================================================

*/

/*==============================================================================
============================= VISTAS MATERIALIZADAS ============================
==============================================================================*/
CREATE MATERIALIZED VIEW CONTEO_CITAS_CLIENTE_MV
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT
    c.id_cliente,
    c.nombre AS NombreCliente,
    c.apellidos AS ApellidosCliente,
    COUNT(ci.id_cita) AS TotalCitas
FROM
    CLIENTES c
JOIN
    CITAS ci ON c.id_cliente = ci.id_cliente
GROUP BY
    c.id_cliente, c.nombre, c.apellidos;

-- Consultar vista materializada
SELECT * FROM CONTEO_CITAS_CLIENTE_MV;


-- 2. Ingresos por terapeuta
CREATE MATERIALIZED VIEW INGRESOS_POR_TERAPEUTA_MV
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT
    t.id_terapeuta,
    t.nombre AS NombrTerapeuta,
    t.apellidos AS ApellidosTerapeuta,
    SUM(p.monto) AS IngresosTotales
FROM
    TERAPEUTAS t
JOIN
    CITAS c ON t.id_terapeuta = c.id_terapeuta
JOIN
    PAGOS p ON c.id_cliente = p.id_cliente
GROUP BY
    t.id_terapeuta, t.nombre, t.apellidos;

-- Consultar vista materializada
SELECT * FROM INGRESOS_POR_TERAPEUTA_MV;


-- 3. Resumen de expedientes por cliente
CREATE MATERIALIZED VIEW RESUMEN_EXPEDIENTES_CLIENTE_MV
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT
    c.id_cliente,
    c.nombre AS NombreCliente,
    c.apellidos AS ApellidosCliente,
    COUNT(e.id_expediente) AS TotalExpedientes
FROM
    CLIENTES c
LEFT JOIN
    EXPEDIENTES e ON c.id_cliente = e.id_cliente
GROUP BY
    c.id_cliente, c.nombre, c.apellidos;

-- Consultar vista materializada
SELECT * FROM RESUMEN_EXPEDIENTES_CLIENTE_MV;



/*==============================================================================
=============================== DESNORMALIZACION ===============================
==============================================================================*/
-- 1. Anadir nombre del cliente a la tabla Pagos
ALTER TABLE PAGOS
ADD (nombre_cliente VARCHAR2(100), apellidos_cliente VARCHAR2(100));

/* Se necesitará un trigger para mantener las columnas actualizadas cuando se 
insertan nuevos pagos o se modifican los clientes. */
CREATE OR REPLACE TRIGGER PAGOS_ACTUALIZAR_CLIENTE_TRG
BEFORE INSERT OR UPDATE ON PAGOS
FOR EACH ROW
DECLARE
    v_nombre_cliente CLIENTES.nombre%TYPE;
    v_apellidos_cliente CLIENTES.apellidos%TYPE;
BEGIN
    SELECT nombre, apellidos
    INTO v_nombre_cliente, v_apellidos_cliente
    FROM CLIENTES
    WHERE id_cliente = :NEW.id_cliente;

    :NEW.nombre_cliente := v_nombre_cliente;
    :NEW.apellidos_cliente := v_apellidos_cliente;
END;
/

-- Anadir nombre del terapeuta a la tabla citas
ALTER TABLE CITAS
ADD (nombre_terapeuta VARCHAR2(100), apellidos_terapeuta VARCHAR2(100));

-- Trigger para mantener estas columnas actualizadas:
CREATE OR REPLACE TRIGGER CITAS_ACTUALIZAR_TERAPEUTA_TRG
BEFORE INSERT OR UPDATE ON CITAS
FOR EACH ROW
DECLARE
    v_nombre_terapeuta TERAPEUTAS.nombre%TYPE;
    v_apellidos_terapeuta TERAPEUTAS.apellidos%TYPE;
BEGIN
    SELECT nombre, apellidos
    INTO v_nombre_terapeuta, v_apellidos_terapeuta
    FROM TERAPEUTAS
    WHERE id_terapeuta = :NEW.id_terapeuta;

    :NEW.nombre_terapeuta := v_nombre_terapeuta;
    :NEW.apellidos_terapeuta := v_apellidos_terapeuta;
END;
/