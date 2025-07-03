-- Script SQL para ejecutar desde Java/Spring Boot
-- Crear tablas regulatorias L07-L14, L31

-- 1) Crear esquemas si no existen
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'regulatory_reports')
  EXEC('CREATE SCHEMA regulatory_reports');

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'audit_logs')
  EXEC('CREATE SCHEMA audit_logs');

-- 2) Crear tabla L08 (prioridad)
IF OBJECT_ID('regulatory_reports.l08_liquidez_estructural','U') IS NOT NULL
  DROP TABLE regulatory_reports.l08_liquidez_estructural;

CREATE TABLE regulatory_reports.l08_liquidez_estructural (
  id                      BIGINT IDENTITY(1,1) PRIMARY KEY,
  codigo_liquidez         NUMERIC(6,0) NOT NULL,
  tipo_identificacion     CHAR(1) NOT NULL CHECK (tipo_identificacion IN ('R','E')),
  identificacion_entidad  NUMERIC(13,0) NOT NULL,
  tipo_instrumento        NUMERIC(2,0) NOT NULL,
  calificacion_entidad    NUMERIC(2,0) NOT NULL,
  calificadora_riesgo     NUMERIC(2,0) NOT NULL,
  valor_lunes             DECIMAL(16,8) NOT NULL,
  valor_martes            DECIMAL(16,8) NOT NULL,
  valor_miercoles         DECIMAL(16,8) NOT NULL,
  valor_jueves            DECIMAL(16,8) NOT NULL,
  valor_viernes           DECIMAL(16,8) NOT NULL,
  fecha_reporte           DATE NOT NULL,
  entidad_codigo          CHAR(4) NOT NULL DEFAULT '0161',
  created_at              DATETIME2 NOT NULL DEFAULT GETDATE(),
  updated_at              DATETIME2 NOT NULL DEFAULT GETDATE(),
  CONSTRAINT uk_l08 UNIQUE (codigo_liquidez, identificacion_entidad, fecha_reporte)
);

-- 3) Crear tabla HIST L08
IF OBJECT_ID('audit_logs.l08_liquidez_estructural_hist','U') IS NOT NULL
  DROP TABLE audit_logs.l08_liquidez_estructural_hist;

CREATE TABLE audit_logs.l08_liquidez_estructural_hist (
  hist_id             BIGINT IDENTITY(1,1) PRIMARY KEY,
  id_orig             BIGINT NOT NULL,
  operation_type      CHAR(1) NOT NULL,
  operation_user      NVARCHAR(128) NOT NULL,
  operation_timestamp DATETIME2 NOT NULL DEFAULT GETDATE(),
  codigo_liquidez     NUMERIC(6,0) NOT NULL,
  tipo_identificacion CHAR(1) NOT NULL,
  identificacion_entidad NUMERIC(13,0) NOT NULL,
  tipo_instrumento    NUMERIC(2,0) NOT NULL,
  calificacion_entidad NUMERIC(2,0) NOT NULL,
  calificadora_riesgo NUMERIC(2,0) NOT NULL,
  valor_lunes         DECIMAL(16,8) NOT NULL,
  valor_martes        DECIMAL(16,8) NOT NULL,
  valor_miercoles     DECIMAL(16,8) NOT NULL,
  valor_jueves        DECIMAL(16,8) NOT NULL,
  valor_viernes       DECIMAL(16,8) NOT NULL,
  fecha_reporte       DATE NOT NULL,
  entidad_codigo      CHAR(4) NOT NULL,
  created_at          DATETIME2 NOT NULL,
  updated_at          DATETIME2 NOT NULL
);

-- 4) Crear trigger para L08
IF OBJECT_ID('trg_l08_hist','TR') IS NOT NULL
  DROP TRIGGER trg_l08_hist;

CREATE TRIGGER trg_l08_hist
ON regulatory_reports.l08_liquidez_estructural
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @op CHAR(1) = CASE WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted) THEN 'U'
                             WHEN EXISTS(SELECT * FROM inserted) THEN 'I' ELSE 'D' END;
  INSERT INTO audit_logs.l08_liquidez_estructural_hist
    (id_orig, operation_type, operation_user, operation_timestamp,
     codigo_liquidez, tipo_identificacion, identificacion_entidad, tipo_instrumento,
     calificacion_entidad, calificadora_riesgo,
     valor_lunes, valor_martes, valor_miercoles, valor_jueves, valor_viernes,
     fecha_reporte, entidad_codigo, created_at, updated_at)
  SELECT
    COALESCE(d.id,i.id),
    @op,
    SUSER_SNAME(),
    GETDATE(),
    COALESCE(i.codigo_liquidez,d.codigo_liquidez),
    COALESCE(i.tipo_identificacion,d.tipo_identificacion),
    COALESCE(i.identificacion_entidad,d.identificacion_entidad),
    COALESCE(i.tipo_instrumento,d.tipo_instrumento),
    COALESCE(i.calificacion_entidad,d.calificacion_entidad),
    COALESCE(i.calificadora_riesgo,d.calificadora_riesgo),
    COALESCE(i.valor_lunes,d.valor_lunes),
    COALESCE(i.valor_martes,d.valor_martes),
    COALESCE(i.valor_miercoles,d.valor_miercoles),
    COALESCE(i.valor_jueves,d.valor_jueves),
    COALESCE(i.valor_viernes,d.valor_viernes),
    COALESCE(i.fecha_reporte,d.fecha_reporte),
    COALESCE(i.entidad_codigo,d.entidad_codigo),
    COALESCE(i.created_at,d.created_at),
    COALESCE(i.updated_at,d.updated_at)
  FROM deleted d FULL JOIN inserted i ON d.id = i.id;
END;

-- 5) Insertar datos de prueba L08
INSERT INTO regulatory_reports.l08_liquidez_estructural (
    codigo_liquidez, tipo_identificacion, identificacion_entidad,
    tipo_instrumento, calificacion_entidad, calificadora_riesgo,
    valor_lunes, valor_martes, valor_miercoles, valor_jueves, valor_viernes,
    fecha_reporte, entidad_codigo
) VALUES
(100001, 'R', 1234567890123, 01, 01, 01, 15000000.00, 15200000.00, 14800000.00, 15500000.00, 15800000.00, '2025-01-20', '0161'),
(100002, 'R', 1234567890124, 01, 01, 01, 25000000.00, 25200000.00, 24800000.00, 25500000.00, 25800000.00, '2025-01-20', '0161'),
(100003, 'E', 9876543210987, 02, 02, 01, 35000000.00, 35200000.00, 34800000.00, 35500000.00, 35800000.00, '2025-01-20', '0161'),
(200001, 'R', 1234567890125, 03, 02, 02, 45000000.00, 45200000.00, 44800000.00, 45500000.00, 45800000.00, '2025-01-20', '0161'),
(200002, 'E', 9876543210988, 04, 03, 02, 55000000.00, 55200000.00, 54800000.00, 55500000.00, 55800000.00, '2025-01-20', '0161'),
(200003, 'R', 1234567890126, 05, 02, 01, 65000000.00, 65200000.00, 64800000.00, 65500000.00, 65800000.00, '2025-01-20', '0161'),
(300001, 'E', 9876543210989, 06, 04, 03, 75000000.00, 75200000.00, 74800000.00, 75500000.00, 75800000.00, '2025-01-20', '0161'),
(300002, 'R', 1234567890127, 07, 03, 02, 85000000.00, 85200000.00, 84800000.00, 85500000.00, 85800000.00, '2025-01-20', '0161'),
(300003, 'E', 9876543210990, 08, 05, 03, 95000000.00, 95200000.00, 94800000.00, 95500000.00, 95800000.00, '2025-01-20', '0161'),
(400001, 'R', 1234567890128, 09, 01, 01, 105000000.00, 105200000.00, 104800000.00, 105500000.00, 105800000.00, '2025-01-20', '0161'),
(400002, 'E', 9876543210991, 10, 02, 02, 115000000.00, 115200000.00, 114800000.00, 115500000.00, 115800000.00, '2025-01-20', '0161'),
(400003, 'R', 1234567890129, 11, 03, 01, 125000000.00, 125200000.00, 124800000.00, 125500000.00, 125800000.00, '2025-01-20', '0161');

-- 6) Verificar implementación
SELECT 'Tabla L08 creada' AS Resultado, COUNT(*) AS TotalRegistros FROM regulatory_reports.l08_liquidez_estructural;
SELECT 'Trigger L08 creado' AS Resultado, name AS NombreTrigger FROM sys.triggers WHERE name = 'trg_l08_hist'; 