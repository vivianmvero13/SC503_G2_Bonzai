-- Encontrar el path de archivos tablespace --
SELECT * FROM dba_data_files;

-- Creacion del tablespace --
-- Tama�o inicial de 100M --
-- Incrementa de 10M en 10M segun necesidad --
-- Tama�o maximo de 500M --
CREATE TABLESPACE tbl_Bonzai
        DATAFILE 'C:/ORACLE/ORADATA/XE/tbl_Bonzai.DBF'
        SIZE 100M
        AUTOEXTEND ON
        NEXT 10M
        MAXSIZE 500M;
        COMMIT;