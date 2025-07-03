-- ================================================================
-- Script corregido para crear tablas HIST compatibles con SQL Server 2008 R2
-- Elimina objetos existentes y los recrea correctamente
-- ================================================================

-- 1) Eliminar triggers existentes
IF OBJECT_ID('trg_l07_hist','TR') IS NOT NULL
  DROP TRIGGER trg_l07_hist;
IF OBJECT_ID('trg_l08_hist','TR') IS NOT NULL
  DROP TRIGGER trg_l08_hist;
IF OBJECT_ID('trg_l09_hist','TR') IS NOT NULL
  DROP TRIGGER trg_l09_hist;
GO

-- 2) Eliminar tablas HIST existentes
IF OBJECT_ID('audit_logs.l07_emisores_custodios_hist','U') IS NOT NULL
  DROP TABLE audit_logs.l07_emisores_custodios_hist;
IF OBJECT_ID('audit_logs.l08_liquidez_estructural_hist','U') IS NOT NULL
  DROP TABLE audit_logs.l08_liquidez_estructural_hist;
IF OBJECT_ID('audit_logs.l09_detalle_productos_hist','U') IS NOT NULL
  DROP TABLE audit_logs.l09_detalle_productos_hist;
GO

-- 3) Crear esquema audit_logs si no existe
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'audit_logs')
  EXEC('CREATE SCHEMA audit_logs');
GO

-- 4) Crear tablas HIST simplificadas

-- L07 HIST
CREATE TABLE audit_logs.l07_emisores_custodios_hist (
    hist_id                BIGINT           IDENTITY(1,1) PRIMARY KEY,
    id_orig                BIGINT           NOT NULL,
    operation_type         CHAR(1)          NOT NULL CHECK (operation_type IN ('I','U','D')),
    operation_timestamp    DATETIME2        NOT NULL DEFAULT GETDATE(),
    operation_user         NVARCHAR(128)    NOT NULL,
    business_date          DATE             NOT NULL,
    regulatory_flag        BIT              NOT NULL DEFAULT 1,
    retention_date         DATE             NOT NULL,
    -- Campos L07
    tipo_identificacion    CHAR(1)          NOT NULL,
    identificacion_entidad CHAR(13)         NOT NULL,
    nacionalidad           CHAR(3)          NOT NULL,
    tipo_emisor_custodio   CHAR(1)          NOT NULL,
    fecha_reporte          DATE             NOT NULL,
    entidad_codigo         CHAR(4)          NOT NULL,
    created_at             DATETIME2        NOT NULL,
    updated_at             DATETIME2        NOT NULL
);
GO

CREATE TRIGGER trg_l07_hist
ON regulatory_reports.l07_emisores_custodios
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @operation_type CHAR(1);
    DECLARE @current_date DATE = CAST(GETDATE() AS DATE);
    DECLARE @retention_date DATE = DATEADD(YEAR, 7, @current_date);
    
    IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
        SET @operation_type = 'U'
    ELSE IF EXISTS(SELECT * FROM inserted)
        SET @operation_type = 'I'
    ELSE
        SET @operation_type = 'D'

    INSERT INTO audit_logs.l07_emisores_custodios_hist (
        id_orig, operation_type, operation_user, business_date, regulatory_flag, retention_date,
        tipo_identificacion, identificacion_entidad, nacionalidad, tipo_emisor_custodio,
        fecha_reporte, entidad_codigo, created_at, updated_at
    )
    SELECT
        COALESCE(d.id, i.id),
        @operation_type,
        SUSER_SNAME(),
        @current_date,
        1,
        @retention_date,
        COALESCE(d.tipo_identificacion, i.tipo_identificacion),
        COALESCE(d.identificacion_entidad, i.identificacion_entidad),
        COALESCE(d.nacionalidad, i.nacionalidad),
        COALESCE(d.tipo_emisor_custodio, i.tipo_emisor_custodio),
        COALESCE(d.fecha_reporte, i.fecha_reporte),
        COALESCE(d.entidad_codigo, i.entidad_codigo),
        COALESCE(d.created_at, i.created_at),
        COALESCE(d.updated_at, i.updated_at)
    FROM deleted d
    FULL OUTER JOIN inserted i ON d.id = i.id;
END;
GO

-- L08 HIST
CREATE TABLE audit_logs.l08_liquidez_estructural_hist (
    hist_id                BIGINT           IDENTITY(1,1) PRIMARY KEY,
    id_orig                BIGINT           NOT NULL,
    operation_type         CHAR(1)          NOT NULL CHECK (operation_type IN ('I','U','D')),
    operation_timestamp    DATETIME2        NOT NULL DEFAULT GETDATE(),
    operation_user         NVARCHAR(128)    NOT NULL,
    business_date          DATE             NOT NULL,
    regulatory_flag        BIT              NOT NULL DEFAULT 1,
    retention_date         DATE             NOT NULL,
    -- Campos L08
    codigo_liquidez        NUMERIC(6,0)     NOT NULL,
    tipo_identificacion    CHAR(1)          NOT NULL,
    identificacion_entidad NUMERIC(13,0)    NOT NULL,
    tipo_instrumento       NUMERIC(2,0)     NOT NULL,
    calificacion_entidad   NUMERIC(2,0)     NOT NULL,
    calificadora_riesgo    NUMERIC(2,0)     NOT NULL,
    valor_lunes            DECIMAL(16,8)    NOT NULL,
    valor_martes           DECIMAL(16,8)    NOT NULL,
    valor_miercoles        DECIMAL(16,8)    NOT NULL,
    valor_jueves           DECIMAL(16,8)    NOT NULL,
    valor_viernes          DECIMAL(16,8)    NOT NULL,
    fecha_reporte          DATE             NOT NULL,
    entidad_codigo         CHAR(4)          NOT NULL,
    created_at             DATETIME2        NOT NULL,
    updated_at             DATETIME2        NOT NULL
);
GO

CREATE TRIGGER trg_l08_hist
ON regulatory_reports.l08_liquidez_estructural
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @operation_type CHAR(1);
    DECLARE @current_date DATE = CAST(GETDATE() AS DATE);
    DECLARE @retention_date DATE = DATEADD(YEAR, 7, @current_date);
    
    IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
        SET @operation_type = 'U'
    ELSE IF EXISTS(SELECT * FROM inserted)
        SET @operation_type = 'I'
    ELSE
        SET @operation_type = 'D'

    INSERT INTO audit_logs.l08_liquidez_estructural_hist (
        id_orig, operation_type, operation_user, business_date, regulatory_flag, retention_date,
        codigo_liquidez, tipo_identificacion, identificacion_entidad,
        tipo_instrumento, calificacion_entidad, calificadora_riesgo,
        valor_lunes, valor_martes, valor_miercoles, valor_jueves, valor_viernes,
        fecha_reporte, entidad_codigo, created_at, updated_at
    )
    SELECT
        COALESCE(d.id, i.id),
        @operation_type,
        SUSER_SNAME(),
        @current_date,
        1,
        @retention_date,
        COALESCE(d.codigo_liquidez, i.codigo_liquidez),
        COALESCE(d.tipo_identificacion, i.tipo_identificacion),
        COALESCE(d.identificacion_entidad, i.identificacion_entidad),
        COALESCE(d.tipo_instrumento, i.tipo_instrumento),
        COALESCE(d.calificacion_entidad, i.calificacion_entidad),
        COALESCE(d.calificadora_riesgo, i.calificadora_riesgo),
        COALESCE(d.valor_lunes, i.valor_lunes),
        COALESCE(d.valor_martes, i.valor_martes),
        COALESCE(d.valor_miercoles, i.valor_miercoles),
        COALESCE(d.valor_jueves, i.valor_jueves),
        COALESCE(d.valor_viernes, i.valor_viernes),
        COALESCE(d.fecha_reporte, i.fecha_reporte),
        COALESCE(d.entidad_codigo, i.entidad_codigo),
        COALESCE(d.created_at, i.created_at),
        COALESCE(d.updated_at, i.updated_at)
    FROM deleted d
    FULL OUTER JOIN inserted i ON d.id = i.id;
END;
GO

-- L09 HIST
CREATE TABLE audit_logs.l09_detalle_productos_hist (
    hist_id                BIGINT           IDENTITY(1,1) PRIMARY KEY,
    id_orig                BIGINT           NOT NULL,
    operation_type         CHAR(1)          NOT NULL CHECK (operation_type IN ('I','U','D')),
    operation_timestamp    DATETIME2        NOT NULL DEFAULT GETDATE(),
    operation_user         NVARCHAR(128)    NOT NULL,
    business_date          DATE             NOT NULL,
    regulatory_flag        BIT              NOT NULL DEFAULT 1,
    retention_date         DATE             NOT NULL,
    -- Campos L09
    codigo_producto        CHAR(10)         NOT NULL,
    descripcion_producto   VARCHAR(250)     NOT NULL,
    codigo_fondo_inversion INT              NULL,
    estado_registro        CHAR(1)          NOT NULL,
    fecha_reporte          DATE             NOT NULL,
    entidad_codigo         CHAR(4)          NOT NULL,
    created_at             DATETIME2        NOT NULL,
    updated_at             DATETIME2        NOT NULL
);
GO

CREATE TRIGGER trg_l09_hist
ON regulatory_reports.l09_detalle_productos
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @operation_type CHAR(1);
    DECLARE @current_date DATE = CAST(GETDATE() AS DATE);
    DECLARE @retention_date DATE = DATEADD(YEAR, 7, @current_date);
    
    IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
        SET @operation_type = 'U'
    ELSE IF EXISTS(SELECT * FROM inserted)
        SET @operation_type = 'I'
    ELSE
        SET @operation_type = 'D'

    INSERT INTO audit_logs.l09_detalle_productos_hist (
        id_orig, operation_type, operation_user, business_date, regulatory_flag, retention_date,
        codigo_producto, descripcion_producto, codigo_fondo_inversion,
        estado_registro, fecha_reporte, entidad_codigo, created_at, updated_at
    )
    SELECT
        COALESCE(d.id, i.id),
        @operation_type,
        SUSER_SNAME(),
        @current_date,
        1,
        @retention_date,
        COALESCE(d.codigo_producto, i.codigo_producto),
        COALESCE(d.descripcion_producto, i.descripcion_producto),
        COALESCE(d.codigo_fondo_inversion, i.codigo_fondo_inversion),
        COALESCE(d.estado_registro, i.estado_registro),
        COALESCE(d.fecha_reporte, i.fecha_reporte),
        COALESCE(d.entidad_codigo, i.entidad_codigo),
        COALESCE(d.created_at, i.created_at),
        COALESCE(d.updated_at, i.updated_at)
    FROM deleted d
    FULL OUTER JOIN inserted i ON d.id = i.id;
END;
GO

-- 5) Verificar que todo se creó correctamente
SELECT 
    'Tabla HIST creada' AS Resultado,
    name AS NombreTabla
FROM sys.tables 
WHERE schema_id = SCHEMA_ID('audit_logs')
ORDER BY name;

SELECT 
    'Trigger creado' AS Resultado,
    name AS NombreTrigger
FROM sys.triggers 
WHERE parent_class = 1
AND name LIKE 'trg_%_hist'
ORDER BY name; 