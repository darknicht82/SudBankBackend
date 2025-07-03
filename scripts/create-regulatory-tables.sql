-- Script para crear las tablas regulatorias L08 y L14
-- Ejecutar en la base de datos sudbank

-- Crear tabla L08_EMISORES_CUSTODIOS_DETALLE
CREATE TABLE IF NOT EXISTS L08_EMISORES_CUSTODIOS_DETALLE (
    id SERIAL PRIMARY KEY,
    codigo_emisor VARCHAR(50) NOT NULL,
    nombre_emisor VARCHAR(200) NOT NULL,
    tipo_instrumento VARCHAR(100),
    valor_nominal DECIMAL(15,2),
    valor_mercado DECIMAL(15,2),
    fecha_emision DATE,
    fecha_vencimiento DATE,
    tasa_cupon DECIMAL(5,4),
    calificacion_riesgo VARCHAR(10),
    entidad_custodia VARCHAR(100),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_registro VARCHAR(50) DEFAULT 'system'
);

-- Crear tabla L14_EMISORES_CUSTODIOS_RIESGO_MERCADO_DETALLE
CREATE TABLE IF NOT EXISTS L14_EMISORES_CUSTODIOS_RIESGO_MERCADO_DETALLE (
    id SERIAL PRIMARY KEY,
    codigo_emisor VARCHAR(50) NOT NULL,
    nombre_emisor VARCHAR(200) NOT NULL,
    tipo_riesgo VARCHAR(100),
    valor_exposicion DECIMAL(15,2),
    limite_riesgo DECIMAL(15,2),
    utilizacion_limite DECIMAL(5,4),
    duracion DECIMAL(5,2),
    convexidad DECIMAL(5,2),
    var DECIMAL(15,2),
    stress_test DECIMAL(15,2),
    fecha_calculo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_registro VARCHAR(50) DEFAULT 'system'
);

-- Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_l08_codigo_emisor ON L08_EMISORES_CUSTODIOS_DETALLE(codigo_emisor);
CREATE INDEX IF NOT EXISTS idx_l08_nombre_emisor ON L08_EMISORES_CUSTODIOS_DETALLE(nombre_emisor);
CREATE INDEX IF NOT EXISTS idx_l14_codigo_emisor ON L14_EMISORES_CUSTODIOS_RIESGO_MERCADO_DETALLE(codigo_emisor);
CREATE INDEX IF NOT EXISTS idx_l14_nombre_emisor ON L14_EMISORES_CUSTODIOS_RIESGO_MERCADO_DETALLE(nombre_emisor);

-- Verificar que las tablas se crearon correctamente
SELECT 'L08_EMISORES_CUSTODIOS_DETALLE' as tabla, COUNT(*) as registros FROM L08_EMISORES_CUSTODIOS_DETALLE
UNION ALL
SELECT 'L14_EMISORES_CUSTODIOS_RIESGO_MERCADO_DETALLE' as tabla, COUNT(*) as registros FROM L14_EMISORES_CUSTODIOS_RIESGO_MERCADO_DETALLE;

-- =====================================================
-- SCRIPT DE CREACIÓN DE TABLAS REGULATORIAS
-- Dashboard L08 - Reporte de Liquidez Estructural
-- =====================================================

-- Crear base de datos si no existe (SQL Server)
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'SudBankRegulatory')
BEGIN
    CREATE DATABASE SudBankRegulatory;
END
GO

USE SudBankRegulatory;
GO

-- =====================================================
-- TABLA PRINCIPAL: L08_LIQUIDEZ_ESTRUCTURAL
-- =====================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[L08_LIQUIDEZ_ESTRUCTURAL]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[L08_LIQUIDEZ_ESTRUCTURAL] (
        [ID] INT IDENTITY(1,1) PRIMARY KEY,
        [CODIGO_LIQUIDEZ] INT NOT NULL,
        [TIPO_IDENTIFICACION] CHAR(1) NOT NULL CHECK ([TIPO_IDENTIFICACION] IN ('R', 'E')),
        [IDENTIFICACION_ENTIDAD] BIGINT NOT NULL,
        [TIPO_INSTRUMENTO] INT NOT NULL,
        [CALIFICACION_ENTIDAD] INT NOT NULL,
        [CALIFICADORA_RIESGO] INT NOT NULL,
        [VALOR_LUNES] DECIMAL(18,2) NOT NULL DEFAULT 0,
        [VALOR_MARTES] DECIMAL(18,2) NOT NULL DEFAULT 0,
        [VALOR_MIERCOLES] DECIMAL(18,2) NOT NULL DEFAULT 0,
        [VALOR_JUEVES] DECIMAL(18,2) NOT NULL DEFAULT 0,
        [VALOR_VIERNES] DECIMAL(18,2) NOT NULL DEFAULT 0,
        [FECHA_REPORTE] DATE NOT NULL,
        [ENTIDAD_CODIGO] VARCHAR(10) NOT NULL,
        [CREATED_AT] DATETIME2 DEFAULT GETDATE(),
        [UPDATED_AT] DATETIME2 DEFAULT GETDATE(),
        [ESTADO] VARCHAR(20) DEFAULT 'ACTIVO',
        [VERSION] INT DEFAULT 1
    );
    
    PRINT 'Tabla L08_LIQUIDEZ_ESTRUCTURAL creada exitosamente';
END
ELSE
BEGIN
    PRINT 'Tabla L08_LIQUIDEZ_ESTRUCTURAL ya existe';
END
GO

-- =====================================================
-- TABLA HISTÓRICA: L08_LIQUIDEZ_ESTRUCTURAL_HIST
-- =====================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[L08_LIQUIDEZ_ESTRUCTURAL_HIST]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[L08_LIQUIDEZ_ESTRUCTURAL_HIST] (
        [ID] INT IDENTITY(1,1) PRIMARY KEY,
        [L08_ID] INT NOT NULL,
        [CODIGO_LIQUIDEZ] INT NOT NULL,
        [TIPO_IDENTIFICACION] CHAR(1) NOT NULL,
        [IDENTIFICACION_ENTIDAD] BIGINT NOT NULL,
        [TIPO_INSTRUMENTO] INT NOT NULL,
        [CALIFICACION_ENTIDAD] INT NOT NULL,
        [CALIFICADORA_RIESGO] INT NOT NULL,
        [VALOR_LUNES] DECIMAL(18,2) NOT NULL,
        [VALOR_MARTES] DECIMAL(18,2) NOT NULL,
        [VALOR_MIERCOLES] DECIMAL(18,2) NOT NULL,
        [VALOR_JUEVES] DECIMAL(18,2) NOT NULL,
        [VALOR_VIERNES] DECIMAL(18,2) NOT NULL,
        [FECHA_REPORTE] DATE NOT NULL,
        [ENTIDAD_CODIGO] VARCHAR(10) NOT NULL,
        [FECHA_MODIFICACION] DATETIME2 DEFAULT GETDATE(),
        [USUARIO_MODIFICACION] VARCHAR(50),
        [TIPO_CAMBIO] VARCHAR(20) NOT NULL, -- INSERT, UPDATE, DELETE
        [VALORES_ANTERIORES] NVARCHAR(MAX), -- JSON con valores anteriores
        [MOTIVO_CAMBIO] VARCHAR(200)
    );
    
    PRINT 'Tabla L08_LIQUIDEZ_ESTRUCTURAL_HIST creada exitosamente';
END
ELSE
BEGIN
    PRINT 'Tabla L08_LIQUIDEZ_ESTRUCTURAL_HIST ya existe';
END
GO

-- =====================================================
-- TABLA DE CONFIGURACIÓN: L08_CONFIGURACION
-- =====================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[L08_CONFIGURACION]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[L08_CONFIGURACION] (
        [ID] INT IDENTITY(1,1) PRIMARY KEY,
        [CLAVE] VARCHAR(50) NOT NULL UNIQUE,
        [VALOR] NVARCHAR(MAX) NOT NULL,
        [DESCRIPCION] VARCHAR(200),
        [TIPO_DATO] VARCHAR(20) DEFAULT 'STRING',
        [ACTIVO] BIT DEFAULT 1,
        [CREATED_AT] DATETIME2 DEFAULT GETDATE(),
        [UPDATED_AT] DATETIME2 DEFAULT GETDATE()
    );
    
    PRINT 'Tabla L08_CONFIGURACION creada exitosamente';
END
ELSE
BEGIN
    PRINT 'Tabla L08_CONFIGURACION ya existe';
END
GO

-- =====================================================
-- TABLA DE AUDITORÍA: L08_AUDITORIA
-- =====================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[L08_AUDITORIA]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[L08_AUDITORIA] (
        [ID] INT IDENTITY(1,1) PRIMARY KEY,
        [FECHA_ACCION] DATETIME2 DEFAULT GETDATE(),
        [USUARIO] VARCHAR(50) NOT NULL,
        [ACCION] VARCHAR(20) NOT NULL, -- LOGIN, LOGOUT, GENERAR_REPORTE, VALIDAR_DATOS, etc.
        [TABLA_AFECTADA] VARCHAR(50),
        [REGISTRO_ID] INT,
        [DETALLES] NVARCHAR(MAX),
        [IP_ADDRESS] VARCHAR(45),
        [USER_AGENT] VARCHAR(500),
        [ESTADO] VARCHAR(20) DEFAULT 'EXITOSO'
    );
    
    PRINT 'Tabla L08_AUDITORIA creada exitosamente';
END
ELSE
BEGIN
    PRINT 'Tabla L08_AUDITORIA ya existe';
END
GO

-- =====================================================
-- TABLA DE REPORTES: L08_REPORTES
-- =====================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[L08_REPORTES]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[L08_REPORTES] (
        [ID] INT IDENTITY(1,1) PRIMARY KEY,
        [NOMBRE_REPORTE] VARCHAR(100) NOT NULL,
        [FECHA_GENERACION] DATETIME2 DEFAULT GETDATE(),
        [FECHA_INICIO] DATE NOT NULL,
        [FECHA_FIN] DATE NOT NULL,
        [USUARIO_GENERADOR] VARCHAR(50) NOT NULL,
        [ESTADO] VARCHAR(20) DEFAULT 'GENERADO',
        [TOTAL_REGISTROS] INT DEFAULT 0,
        [ARCHIVO_RUTA] VARCHAR(500),
        [PARAMETROS] NVARCHAR(MAX), -- JSON con parámetros del reporte
        [NOTAS] VARCHAR(500)
    );
    
    PRINT 'Tabla L08_REPORTES creada exitosamente';
END
ELSE
BEGIN
    PRINT 'Tabla L08_REPORTES ya existe';
END
GO

-- =====================================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =====================================================

-- Índices para L08_LIQUIDEZ_ESTRUCTURAL
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_L08_FECHA_REPORTE')
BEGIN
    CREATE INDEX IX_L08_FECHA_REPORTE ON [dbo].[L08_LIQUIDEZ_ESTRUCTURAL] ([FECHA_REPORTE]);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_L08_ENTIDAD_CODIGO')
BEGIN
    CREATE INDEX IX_L08_ENTIDAD_CODIGO ON [dbo].[L08_LIQUIDEZ_ESTRUCTURAL] ([ENTIDAD_CODIGO]);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_L08_TIPO_INSTRUMENTO')
BEGIN
    CREATE INDEX IX_L08_TIPO_INSTRUMENTO ON [dbo].[L08_LIQUIDEZ_ESTRUCTURAL] ([TIPO_INSTRUMENTO]);
END

-- Índices para L08_LIQUIDEZ_ESTRUCTURAL_HIST
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_L08_HIST_L08_ID')
BEGIN
    CREATE INDEX IX_L08_HIST_L08_ID ON [dbo].[L08_LIQUIDEZ_ESTRUCTURAL_HIST] ([L08_ID]);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_L08_HIST_FECHA_MODIFICACION')
BEGIN
    CREATE INDEX IX_L08_HIST_FECHA_MODIFICACION ON [dbo].[L08_LIQUIDEZ_ESTRUCTURAL_HIST] ([FECHA_MODIFICACION]);
END

-- Índices para L08_AUDITORIA
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_L08_AUDITORIA_FECHA')
BEGIN
    CREATE INDEX IX_L08_AUDITORIA_FECHA ON [dbo].[L08_AUDITORIA] ([FECHA_ACCION]);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_L08_AUDITORIA_USUARIO')
BEGIN
    CREATE INDEX IX_L08_AUDITORIA_USUARIO ON [dbo].[L08_AUDITORIA] ([USUARIO]);
END

-- =====================================================
-- DATOS DE CONFIGURACIÓN INICIAL
-- =====================================================

-- Insertar configuraciones por defecto
IF NOT EXISTS (SELECT * FROM [dbo].[L08_CONFIGURACION] WHERE [CLAVE] = 'REPORTE_DEFAULT_FECHA_INICIO')
BEGIN
    INSERT INTO [dbo].[L08_CONFIGURACION] ([CLAVE], [VALOR], [DESCRIPCION], [TIPO_DATO])
    VALUES ('REPORTE_DEFAULT_FECHA_INICIO', '2025-01-01', 'Fecha de inicio por defecto para reportes', 'DATE');
END

IF NOT EXISTS (SELECT * FROM [dbo].[L08_CONFIGURACION] WHERE [CLAVE] = 'REPORTE_DEFAULT_FECHA_FIN')
BEGIN
    INSERT INTO [dbo].[L08_CONFIGURACION] ([CLAVE], [VALOR], [DESCRIPCION], [TIPO_DATO])
    VALUES ('REPORTE_DEFAULT_FECHA_FIN', '2025-12-31', 'Fecha de fin por defecto para reportes', 'DATE');
END

IF NOT EXISTS (SELECT * FROM [dbo].[L08_CONFIGURACION] WHERE [CLAVE] = 'ENTIDAD_CODIGO_DEFAULT')
BEGIN
    INSERT INTO [dbo].[L08_CONFIGURACION] ([CLAVE], [VALOR], [DESCRIPCION], [TIPO_DATO])
    VALUES ('ENTIDAD_CODIGO_DEFAULT', '0161', 'Código de entidad por defecto', 'STRING');
END

IF NOT EXISTS (SELECT * FROM [dbo].[L08_CONFIGURACION] WHERE [CLAVE] = 'MAX_REGISTROS_POR_REPORTE')
BEGIN
    INSERT INTO [dbo].[L08_CONFIGURACION] ([CLAVE], [VALOR], [DESCRIPCION], [TIPO_DATO])
    VALUES ('MAX_REGISTROS_POR_REPORTE', '10000', 'Máximo número de registros por reporte', 'INTEGER');
END

-- =====================================================
-- DATOS DE PRUEBA (OPCIONAL)
-- =====================================================

-- Insertar algunos registros de prueba
IF NOT EXISTS (SELECT * FROM [dbo].[L08_LIQUIDEZ_ESTRUCTURAL] WHERE [CODIGO_LIQUIDEZ] = 1001)
BEGIN
    INSERT INTO [dbo].[L08_LIQUIDEZ_ESTRUCTURAL] (
        [CODIGO_LIQUIDEZ], [TIPO_IDENTIFICACION], [IDENTIFICACION_ENTIDAD], 
        [TIPO_INSTRUMENTO], [CALIFICACION_ENTIDAD], [CALIFICADORA_RIESGO],
        [VALOR_LUNES], [VALOR_MARTES], [VALOR_MIERCOLES], [VALOR_JUEVES], [VALOR_VIERNES],
        [FECHA_REPORTE], [ENTIDAD_CODIGO]
    ) VALUES 
    (1001, 'R', 1234567890123, 1, 1, 1, 1500000.50, 1520000.75, 1480000.25, 1550000.00, 1535000.80, '2025-01-15', '0161'),
    (1002, 'E', 9876543210987, 2, 2, 1, 2500000.00, 2480000.50, 2520000.25, 2490000.75, 2510000.00, '2025-01-15', '0161'),
    (1003, 'R', 4567890123456, 1, 3, 2, 800000.25, 820000.50, 780000.75, 850000.00, 830000.25, '2025-01-15', '0161');
    
    PRINT 'Datos de prueba insertados en L08_LIQUIDEZ_ESTRUCTURAL';
END

-- =====================================================
-- PROCEDIMIENTOS ALMACENADOS ÚTILES
-- =====================================================

-- Procedimiento para obtener resumen de L08
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_L08_OBTENER_RESUMEN]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[SP_L08_OBTENER_RESUMEN]
GO

CREATE PROCEDURE [dbo].[SP_L08_OBTENER_RESUMEN]
    @FechaInicio DATE = NULL,
    @FechaFin DATE = NULL,
    @EntidadCodigo VARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @FechaInicio IS NULL
        SET @FechaInicio = DATEADD(DAY, -30, GETDATE());
    
    IF @FechaFin IS NULL
        SET @FechaFin = GETDATE();
    
    SELECT 
        COUNT(*) AS TotalRegistros,
        SUM(VALOR_LUNES) AS ValorTotalLunes,
        SUM(VALOR_MARTES) AS ValorTotalMartes,
        SUM(VALOR_MIERCOLES) AS ValorTotalMiercoles,
        SUM(VALOR_JUEVES) AS ValorTotalJueves,
        SUM(VALOR_VIERNES) AS ValorTotalViernes,
        AVG(VALOR_VIERNES - VALOR_LUNES) AS VariacionPromedio,
        COUNT(DISTINCT ENTIDAD_CODIGO) AS TotalEntidades
    FROM [dbo].[L08_LIQUIDEZ_ESTRUCTURAL]
    WHERE FECHA_REPORTE BETWEEN @FechaInicio AND @FechaFin
    AND (@EntidadCodigo IS NULL OR ENTIDAD_CODIGO = @EntidadCodigo)
    AND ESTADO = 'ACTIVO';
END
GO

PRINT 'Procedimiento SP_L08_OBTENER_RESUMEN creado exitosamente';

-- =====================================================
-- TRIGGERS PARA AUDITORÍA AUTOMÁTICA
-- =====================================================

-- Trigger para auditar cambios en L08_LIQUIDEZ_ESTRUCTURAL
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_L08_AUDITAR_CAMBIOS]') AND type in (N'TR'))
    DROP TRIGGER [dbo].[TR_L08_AUDITAR_CAMBIOS]
GO

CREATE TRIGGER [dbo].[TR_L08_AUDITAR_CAMBIOS]
ON [dbo].[L08_LIQUIDEZ_ESTRUCTURAL]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TipoCambio VARCHAR(20);
    DECLARE @Usuario VARCHAR(50) = SYSTEM_USER;
    
    IF EXISTS (SELECT * FROM INSERTED) AND EXISTS (SELECT * FROM DELETED)
        SET @TipoCambio = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM INSERTED)
        SET @TipoCambio = 'INSERT';
    ELSE
        SET @TipoCambio = 'DELETE';
    
    -- Insertar en tabla histórica para UPDATE y DELETE
    IF @TipoCambio IN ('UPDATE', 'DELETE')
    BEGIN
        INSERT INTO [dbo].[L08_LIQUIDEZ_ESTRUCTURAL_HIST] (
            [L08_ID], [CODIGO_LIQUIDEZ], [TIPO_IDENTIFICACION], [IDENTIFICACION_ENTIDAD],
            [TIPO_INSTRUMENTO], [CALIFICACION_ENTIDAD], [CALIFICADORA_RIESGO],
            [VALOR_LUNES], [VALOR_MARTES], [VALOR_MIERCOLES], [VALOR_JUEVES], [VALOR_VIERNES],
            [FECHA_REPORTE], [ENTIDAD_CODIGO], [TIPO_CAMBIO], [USUARIO_MODIFICACION]
        )
        SELECT 
            [ID], [CODIGO_LIQUIDEZ], [TIPO_IDENTIFICACION], [IDENTIFICACION_ENTIDAD],
            [TIPO_INSTRUMENTO], [CALIFICACION_ENTIDAD], [CALIFICADORA_RIESGO],
            [VALOR_LUNES], [VALOR_MARTES], [VALOR_MIERCOLES], [VALOR_JUEVES], [VALOR_VIERNES],
            [FECHA_REPORTE], [ENTIDAD_CODIGO], @TipoCambio, @Usuario
        FROM DELETED;
    END
    
    -- Registrar en auditoría
    INSERT INTO [dbo].[L08_AUDITORIA] (
        [USUARIO], [ACCION], [TABLA_AFECTADA], [REGISTRO_ID], [DETALLES]
    )
    SELECT 
        @Usuario, 
        @TipoCambio, 
        'L08_LIQUIDEZ_ESTRUCTURAL',
        ISNULL(i.ID, d.ID),
        'Registro ' + @TipoCambio + ' - Código: ' + CAST(ISNULL(i.CODIGO_LIQUIDEZ, d.CODIGO_LIQUIDEZ) AS VARCHAR(10))
    FROM INSERTED i
    FULL OUTER JOIN DELETED d ON i.ID = d.ID;
END
GO

PRINT 'Trigger TR_L08_AUDITAR_CAMBIOS creado exitosamente';

-- =====================================================
-- VISTAS ÚTILES
-- =====================================================

-- Vista para resumen diario
IF EXISTS (SELECT * FROM sys.views WHERE name = 'V_L08_RESUMEN_DIARIO')
    DROP VIEW [dbo].[V_L08_RESUMEN_DIARIO]
GO

CREATE VIEW [dbo].[V_L08_RESUMEN_DIARIO] AS
SELECT 
    FECHA_REPORTE,
    COUNT(*) AS TotalRegistros,
    SUM(VALOR_LUNES) AS TotalLunes,
    SUM(VALOR_MARTES) AS TotalMartes,
    SUM(VALOR_MIERCOLES) AS TotalMiercoles,
    SUM(VALOR_JUEVES) AS TotalJueves,
    SUM(VALOR_VIERNES) AS TotalViernes,
    AVG(VALOR_VIERNES - VALOR_LUNES) AS VariacionSemanal,
    COUNT(DISTINCT ENTIDAD_CODIGO) AS TotalEntidades
FROM [dbo].[L08_LIQUIDEZ_ESTRUCTURAL]
WHERE ESTADO = 'ACTIVO'
GROUP BY FECHA_REPORTE;
GO

PRINT 'Vista V_L08_RESUMEN_DIARIO creada exitosamente';

-- =====================================================
-- FINALIZACIÓN
-- =====================================================

PRINT '=====================================================';
PRINT 'SCRIPT DE CREACIÓN DE TABLAS COMPLETADO EXITOSAMENTE';
PRINT '=====================================================';
PRINT 'Tablas creadas:';
PRINT '- L08_LIQUIDEZ_ESTRUCTURAL (tabla principal)';
PRINT '- L08_LIQUIDEZ_ESTRUCTURAL_HIST (histórico)';
PRINT '- L08_CONFIGURACION (configuraciones)';
PRINT '- L08_AUDITORIA (auditoría)';
PRINT '- L08_REPORTES (reportes generados)';
PRINT '';
PRINT 'Índices, procedimientos, triggers y vistas creados';
PRINT 'Datos de configuración inicial insertados';
PRINT 'Datos de prueba insertados (opcional)';
PRINT '====================================================='; 