-- =====================================================
-- Migración V4: Crear Tabla L14 - Concentración de Depósitos
-- Fecha: 2024-12-19
-- Descripción: Crear tabla para reporte L14 según especificaciones regulatorias
-- =====================================================

-- Crear tabla L14 - Concentración de Depósitos
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[risk_reporting].[l14_concentracion_depositos]') AND type in (N'U'))
BEGIN
    CREATE TABLE [risk_reporting].[l14_concentracion_depositos] (
        [id] BIGINT IDENTITY(1,1) PRIMARY KEY,
        [cuenta_contable] VARCHAR(6) NOT NULL,
        [tipo_cliente] VARCHAR(1) NOT NULL,
        [identificacion] VARCHAR(13) NOT NULL,
        [actividad_economica] VARCHAR(7) NOT NULL,
        [saldo_inicial] DECIMAL(16,2) NOT NULL DEFAULT 0,
        [retiros] DECIMAL(16,2) NOT NULL DEFAULT 0,
        [nuevos_depositos] DECIMAL(16,2) NOT NULL DEFAULT 0,
        [fecha_reporte] DATE NOT NULL,
        [entidad_codigo] VARCHAR(4) NOT NULL,
        [fecha_creacion] DATETIME2 DEFAULT GETDATE(),
        [fecha_modificacion] DATETIME2 DEFAULT GETDATE()
    );
    
    -- Crear índices para optimizar consultas
    CREATE INDEX [IX_L14_fecha_reporte] ON [risk_reporting].[l14_concentracion_depositos] ([fecha_reporte]);
    CREATE INDEX [IX_L14_entidad_codigo] ON [risk_reporting].[l14_concentracion_depositos] ([entidad_codigo]);
    CREATE INDEX [IX_L14_identificacion] ON [risk_reporting].[l14_concentracion_depositos] ([identificacion]);
    CREATE INDEX [IX_L14_cuenta_contable] ON [risk_reporting].[l14_concentracion_depositos] ([cuenta_contable]);
    CREATE INDEX [IX_L14_actividad_economica] ON [risk_reporting].[l14_concentracion_depositos] ([actividad_economica]);
    
    -- Crear índice compuesto para consultas frecuentes
    CREATE INDEX [IX_L14_fecha_entidad] ON [risk_reporting].[l14_concentracion_depositos] ([fecha_reporte], [entidad_codigo]);
    
    PRINT 'Tabla risk_reporting.l14_concentracion_depositos creada exitosamente';
END
ELSE
BEGIN
    PRINT 'Tabla risk_reporting.l14_concentracion_depositos ya existe';
END

-- Crear tabla de configuración para L14
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[config].[l14_config]') AND type in (N'U'))
BEGIN
    CREATE TABLE [config].[l14_config] (
        [id] INT IDENTITY(1,1) PRIMARY KEY,
        [parametro] VARCHAR(50) NOT NULL UNIQUE,
        [valor] VARCHAR(255) NOT NULL,
        [descripcion] VARCHAR(500),
        [fecha_creacion] DATETIME2 DEFAULT GETDATE(),
        [fecha_modificacion] DATETIME2 DEFAULT GETDATE()
    );
    
    -- Insertar configuración por defecto
    INSERT INTO [config].[l14_config] ([parametro], [valor], [descripcion]) VALUES
    ('PERIODICIDAD', 'QUINCENAL', 'Periodicidad del reporte L14'),
    ('PLAZO_ENTREGA', '5', 'Plazo de entrega en días hábiles'),
    ('FORMATO_ARCHIVO', 'TXT', 'Formato de archivo de salida'),
    ('ENCODING', 'ISO-8859-1', 'Encoding del archivo de salida'),
    ('ENTIDAD_CODIGO', 'SUDB', 'Código de la entidad bancaria');
    
    PRINT 'Tabla config.l14_config creada exitosamente';
END
ELSE
BEGIN
    PRINT 'Tabla config.l14_config ya existe';
END

PRINT 'Migración V4 completada exitosamente'; 