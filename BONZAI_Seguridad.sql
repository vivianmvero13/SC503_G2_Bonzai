/*CREADO POR: Grupo 01
PROYECTO AVANCE 01: Parte 1. Diseno y Configuracion Inicial
FECHA: 06/03/2025

** SISTEMA DE GESTION DE BASE DE DATOS PARA EL CENTRO TERAPEUTICO BONZAI SRL **/

--============================================================================--

-- Seguridad de los datos
--cifrado para proteger esta información.
--Procedimientos para encriptar y desencriptar

--- TABLA CLIENTES -------------------------------------------------------------
--Cifrado de datos
DECLARE
    l_key        RAW(32) := UTL_RAW.CAST_TO_RAW('1234567890ABCDEF1234567890ABCDEF'); -- Clave AES-256
    l_data       VARCHAR2(32767) := 'Contacto del cliente'; -- Dato sensible a cifrar
    l_encrypted  RAW(32767);
BEGIN
    l_encrypted := DBMS_CRYPTO.ENCRYPT(
        src => UTL_RAW.CAST_TO_RAW(l_data),
        typ => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
        key => l_key
    );

    UPDATE CLIENTES
    SET contacto = UTL_RAW.CAST_TO_VARCHAR2(l_encrypted)
    WHERE id_cliente = 1;

    COMMIT;
END;
/

--Descifrado de Datos
DECLARE
    l_key         RAW(32) := UTL_RAW.CAST_TO_RAW('1234567890ABCDEF1234567890ABCDEF'); -- La misma clave
    l_encrypted   RAW(32767);
    l_decrypted   RAW(32767);
    l_decrypted_v VARCHAR2(32767);
BEGIN
    SELECT UTL_RAW.CAST_TO_RAW(contacto)
    INTO l_encrypted
    FROM CLIENTES
    WHERE id_cliente = 1;

    l_decrypted := DBMS_CRYPTO.DECRYPT(
        src => l_encrypted,
        typ => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
        key => l_key
    );

    l_decrypted_v := UTL_RAW.CAST_TO_VARCHAR2(l_decrypted);

    DBMS_OUTPUT.PUT_LINE('Contacto descifrado: ' || l_decrypted_v);
END;
/
SELECT * FROM CLIENTES;

--- TABLA TERAPEUTAS -------------------------------------------------------------
--Cifrado de datos
DECLARE
    l_key        RAW(32) := UTL_RAW.CAST_TO_RAW('1234567890ABCDEF1234567890ABCDEF'); -- Clave AES-256
    l_data       VARCHAR2(32767) := 'Contacto del terapeuta'; -- Dato sensible a cifrar
    l_encrypted  RAW(32767);
BEGIN
    l_encrypted := DBMS_CRYPTO.ENCRYPT(
        src => UTL_RAW.CAST_TO_RAW(l_data),
        typ => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
        key => l_key
    );

    UPDATE TERAPEUTAS
    SET contacto = UTL_RAW.CAST_TO_VARCHAR2(l_encrypted)
    WHERE id_terapeuta = 5;

    COMMIT;
END;
/

--Descifrado de Datos
DECLARE
    l_key         RAW(32) := UTL_RAW.CAST_TO_RAW('1234567890ABCDEF1234567890ABCDEF'); -- La misma clave
    l_encrypted   RAW(32767);
    l_decrypted   RAW(32767);
    l_decrypted_v VARCHAR2(32767);
BEGIN
    SELECT UTL_RAW.CAST_TO_RAW(contacto)
    INTO l_encrypted
    FROM TERAPEUTAS
    WHERE id_terapeuta = 5;

    l_decrypted := DBMS_CRYPTO.DECRYPT(
        src => l_encrypted,
        typ => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
        key => l_key
    );

    l_decrypted_v := UTL_RAW.CAST_TO_VARCHAR2(l_decrypted);

    DBMS_OUTPUT.PUT_LINE('Contacto descifrado: ' || l_decrypted_v);
END;
/
SELECT * FROM TERAPEUTAS;

--- TABLA EXPEDIENTES -------------------------------------------------------------
--Cifrado de datos
DECLARE
    l_key        RAW(32) := UTL_RAW.CAST_TO_RAW('1234567890ABCDEF1234567890ABCDEF'); -- Clave AES-256
    l_data       VARCHAR2(32767) := 'Descripción del expediente'; -- Dato sensible a cifrar
    l_encrypted  RAW(32767);
BEGIN
    l_encrypted := DBMS_CRYPTO.ENCRYPT(
        src => UTL_RAW.CAST_TO_RAW(l_data),
        typ => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
        key => l_key
    );

    UPDATE EXPEDIENTES
    SET descripcion = UTL_RAW.CAST_TO_VARCHAR2(l_encrypted)
    WHERE id_expediente = 8;

    COMMIT;
END;
/

--Descifrado de Datos
DECLARE
    l_key         RAW(32) := UTL_RAW.CAST_TO_RAW('1234567890ABCDEF1234567890ABCDEF'); -- La misma clave
    l_encrypted   RAW(32767);
    l_decrypted   RAW(32767);
    l_decrypted_v VARCHAR2(32767);
BEGIN
    SELECT UTL_RAW.CAST_TO_RAW(descripcion)
    INTO l_encrypted
    FROM EXPEDIENTES
    WHERE id_expediente = 8;

    l_decrypted := DBMS_CRYPTO.DECRYPT(
        src => l_encrypted,
        typ => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
        key => l_key
    );

    l_decrypted_v := UTL_RAW.CAST_TO_VARCHAR2(l_decrypted);

    DBMS_OUTPUT.PUT_LINE('Descripción descifrada: ' || l_decrypted_v);
END;
/
SELECT * FROM EXPEDIENTES;

--- TABLA PAGOS -------------------------------------------------------------
--Cifrado de datos
DECLARE
    l_key        RAW(32) := UTL_RAW.CAST_TO_RAW('1234567890ABCDEF1234567890ABCDEF'); -- Clave AES-256
    l_data       VARCHAR2(32767) := 'Método de pago'; -- Dato sensible a cifrar
    l_encrypted  RAW(32767);
BEGIN
    l_encrypted := DBMS_CRYPTO.ENCRYPT(
        src => UTL_RAW.CAST_TO_RAW(l_data),
        typ => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
        key => l_key
    );

    UPDATE PAGOS
    SET metodo_pago = UTL_RAW.CAST_TO_VARCHAR2(l_encrypted)
    WHERE id_pago = 24;

    COMMIT;
END;
/

--Descifrado de Datos
DECLARE
    l_key         RAW(32) := UTL_RAW.CAST_TO_RAW('1234567890ABCDEF1234567890ABCDEF'); -- La misma clave
    l_encrypted   RAW(32767);
    l_decrypted   RAW(32767);
    l_decrypted_v VARCHAR2(32767);
BEGIN
    SELECT UTL_RAW.CAST_TO_RAW(metodo_pago)
    INTO l_encrypted
    FROM PAGOS
    WHERE id_pago = 24;

    l_decrypted := DBMS_CRYPTO.DECRYPT(
        src => l_encrypted,
        typ => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
        key => l_key
    );

    l_decrypted_v := UTL_RAW.CAST_TO_VARCHAR2(l_decrypted);

    DBMS_OUTPUT.PUT_LINE('Método de pago descifrado: ' || l_decrypted_v);
END;
/

SELECT * FROM PAGOS;