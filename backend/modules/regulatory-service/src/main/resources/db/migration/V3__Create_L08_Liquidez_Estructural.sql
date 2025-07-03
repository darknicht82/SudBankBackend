-- =====================================================
-- Migración V3: Crear Tabla L08 - Liquidez Estructural
-- Fecha: 2024-12-19
-- Descripción: Crear tabla para reporte L08 según especificaciones regulatorias
-- =====================================================

-- Crear tabla L08 - Liquidez Estructural
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[risk_reporting].[l08_liquidez_estructural]') AND type in (N'U'))
BEGIN
    CREATE TABLE [risk_reporting].[l08_liquidez_estructural] (
        [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
        [codigo_liquidez] VARCHAR(6) NOT NULL,
        [tipo_identificacion] VARCHAR(1) NOT NULL,
        [identificacion_emisor] VARCHAR(13) NOT NULL,
        [tipo_instrumento] VARCHAR(2) NOT NULL,
        [valor_lunes] DECIMAL(16,8) NOT NULL DEFAULT 0,
        [valor_martes] DECIMAL(16,8) NOT NULL DEFAULT 0,
        [valor_miercoles] DECIMAL(16,8) NOT NULL DEFAULT 0,
        [valor_jueves] DECIMAL(16,8) NOT NULL DEFAULT 0,
        [valor_viernes] DECIMAL(16,8) NOT NULL DEFAULT 0,
        [fecha_reporte] DATE NOT NULL,
        [entidad_codigo] VARCHAR(4) NOT NULL,
        [fecha_creacion] DATETIME2 DEFAULT GETDATE(),
        [fecha_modificacion] DATETIME2 DEFAULT GETDATE()
    );
    
    -- Crear índices para optimizar consultas
    CREATE INDEX [IX_L08_fecha_reporte] ON [risk_reporting].[l08_liquidez_estructural] ([fecha_reporte]);
    CREATE INDEX [IX_L08_entidad_codigo] ON [risk_reporting].[l08_liquidez_estructural] ([entidad_codigo]);
    CREATE INDEX [IX_L08_identificacion] ON [risk_reporting].[l08_liquidez_estructural] ([identificacion_emisor]);
    CREATE INDEX [IX_L08_codigo_liquidez] ON [risk_reporting].[l08_liquidez_estructural] ([codigo_liquidez]);
    
    -- Crear índice compuesto para consultas frecuentes
    CREATE INDEX [IX_L08_fecha_entidad] ON [risk_reporting].[l08_liquidez_estructural] ([fecha_reporte], [entidad_codigo]);
    
    PRINT 'Tabla risk_reporting.l08_liquidez_estructural creada exitosamente';
END
ELSE
BEGIN
    PRINT 'Tabla risk_reporting.l08_liquidez_estructural ya existe';
END

-- Crear tabla de configuración para L08
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[config].[l08_config]') AND type in (N'U'))
BEGIN
    CREATE TABLE [config].[l08_config] (
        [id] INT IDENTITY(1,1) PRIMARY KEY,
        [parametro] VARCHAR(50) NOT NULL UNIQUE,
        [valor] VARCHAR(255) NOT NULL,
        [descripcion] VARCHAR(500),
        [fecha_creacion] DATETIME2 DEFAULT GETDATE(),
        [fecha_modificacion] DATETIME2 DEFAULT GETDATE()
    );
    
    -- Insertar configuración por defecto
    INSERT INTO [config].[l08_config] ([parametro], [valor], [descripcion]) VALUES
    ('PERIODICIDAD', 'SEMANAL', 'Periodicidad del reporte L08'),
    ('PLAZO_ENTREGA', '72', 'Plazo de entrega en horas laborables'),
    ('FORMATO_ARCHIVO', 'TXT', 'Formato de archivo de salida'),
    ('ENCODING', 'ISO-8859-1', 'Encoding del archivo de salida'),
    ('ENTIDAD_CODIGO', 'SUDB', 'Código de la entidad bancaria');
    
    PRINT 'Tabla config.l08_config creada exitosamente';
END
ELSE
BEGIN
    PRINT 'Tabla config.l08_config ya existe';
END

PRINT 'Migración V3 completada exitosamente'; 