-- Script para crear todas las tablas regulatorias según especificaciones SB
-- Superintendencia de Bancos del Ecuador - Estructuras L

-- Crear esquema para reportes regulatorios
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'regulatory_reports')
BEGIN
    EXEC('CREATE SCHEMA regulatory_reports')
END
GO

-- =============================================
-- L08 - LIQUIDEZ ESTRUCTURAL (SEMANAL)
-- =============================================

-- Tabla principal L08
CREATE TABLE regulatory_reports.l08_liquidez_estructural (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    codigo_liquidez NUMERIC(6,0) NOT NULL,
    tipo_identificacion CHAR(1) NOT NULL CHECK (tipo_identificacion IN ('R','E')),
    identificacion_entidad NUMERIC(13,0) NOT NULL,
    tipo_instrumento NUMERIC(2,0) NOT NULL,
    calificacion_entidad NUMERIC(2,0) NOT NULL,
    calificadora_riesgo NUMERIC(2,0) NOT NULL,
    valor_lunes DECIMAL(16,8) NOT NULL,
    valor_martes DECIMAL(16,8) NOT NULL,
    valor_miercoles DECIMAL(16,8) NOT NULL,
    valor_jueves DECIMAL(16,8) NOT NULL,
    valor_viernes DECIMAL(16,8) NOT NULL,
    fecha_reporte DATE NOT NULL,
    entidad_codigo CHAR(4) NOT NULL DEFAULT '0161',
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT uk_l08 UNIQUE (codigo_liquidez, identificacion_entidad, fecha_reporte)
);

-- Tabla histórica L08
CREATE TABLE regulatory_reports.l08_liquidez_estructural_hist (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_original BIGINT NOT NULL,
    codigo_liquidez NUMERIC(6,0) NOT NULL,
    tipo_identificacion CHAR(1) NOT NULL,
    identificacion_entidad NUMERIC(13,0) NOT NULL,
    tipo_instrumento NUMERIC(2,0) NOT NULL,
    calificacion_entidad NUMERIC(2,0) NOT NULL,
    calificadora_riesgo NUMERIC(2,0) NOT NULL,
    valor_lunes DECIMAL(16,8) NOT NULL,
    valor_martes DECIMAL(16,8) NOT NULL,
    valor_miercoles DECIMAL(16,8) NOT NULL,
    valor_jueves DECIMAL(16,8) NOT NULL,
    valor_viernes DECIMAL(16,8) NOT NULL,
    fecha_reporte DATE NOT NULL,
    entidad_codigo CHAR(4) NOT NULL,
    fecha_envio DATETIME2 NOT NULL,
    estado_envio VARCHAR(20) NOT NULL,
    archivo_generado VARCHAR(255),
    errores_validacion TEXT,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

-- =============================================
-- L10 - BRECHAS DE SENSIBILIDAD (MENSUAL)
-- =============================================

CREATE TABLE regulatory_reports.l10_brechas_sensibilidad (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    codigo_producto CHAR(10) NOT NULL,
    codigo_banda INT NOT NULL,
    valor_producto_banda DECIMAL(15,4) NOT NULL,
    fecha_reporte DATE NOT NULL,
    entidad_codigo CHAR(4) NOT NULL DEFAULT '0161',
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT uk_l10 UNIQUE (codigo_producto, codigo_banda, fecha_reporte)
);

CREATE TABLE regulatory_reports.l10_brechas_sensibilidad_hist (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_original BIGINT NOT NULL,
    codigo_producto CHAR(10) NOT NULL,
    codigo_banda INT NOT NULL,
    valor_producto_banda DECIMAL(15,4) NOT NULL,
    fecha_reporte DATE NOT NULL,
    entidad_codigo CHAR(4) NOT NULL,
    fecha_envio DATETIME2 NOT NULL,
    estado_envio VARCHAR(20) NOT NULL,
    archivo_generado VARCHAR(255),
    errores_validacion TEXT,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

-- =============================================
-- L11 - SENSIBILIDAD PATRIMONIAL (MENSUAL)
-- =============================================

CREATE TABLE regulatory_reports.l11_sensibilidad_patrimonial (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    gap_duracion_mf DECIMAL(15,2) NOT NULL,
    sensibilidad_var_pos DECIMAL(15,2) NOT NULL,
    sensibilidad_var_neg DECIMAL(15,2) NOT NULL,
    fecha_reporte DATE NOT NULL,
    entidad_codigo CHAR(4) NOT NULL DEFAULT '0161',
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT uk_l11 UNIQUE (fecha_reporte, entidad_codigo)
);

CREATE TABLE regulatory_reports.l11_sensibilidad_patrimonial_hist (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_original BIGINT NOT NULL,
    gap_duracion_mf DECIMAL(15,2) NOT NULL,
    sensibilidad_var_pos DECIMAL(15,2) NOT NULL,
    sensibilidad_var_neg DECIMAL(15,2) NOT NULL,
    fecha_reporte DATE NOT NULL,
    entidad_codigo CHAR(4) NOT NULL,
    fecha_envio DATETIME2 NOT NULL,
    estado_envio VARCHAR(20) NOT NULL,
    archivo_generado VARCHAR(255),
    errores_validacion TEXT,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

-- =============================================
-- L12 - CAPTACIONES POR MONTO (MENSUAL)
-- =============================================

CREATE TABLE regulatory_reports.l12_captaciones_monto (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    codigo_cuenta_contable VARCHAR(6) NOT NULL,
    tipo_cliente CHAR(1) NOT NULL,
    codigo_rango INT NOT NULL,
    codigo_banda_tiempo INT NOT NULL,
    numero_clientes INT NOT NULL,
    saldo_contable DECIMAL(15,2) NOT NULL,
    fecha_reporte DATE NOT NULL,
    entidad_codigo CHAR(4) NOT NULL DEFAULT '0161',
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT uk_l12 UNIQUE (codigo_cuenta_contable, tipo_cliente, codigo_rango, codigo_banda_tiempo, fecha_reporte)
);

CREATE TABLE regulatory_reports.l12_captaciones_monto_hist (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_original BIGINT NOT NULL,
    codigo_cuenta_contable VARCHAR(6) NOT NULL,
    tipo_cliente CHAR(1) NOT NULL,
    codigo_rango INT NOT NULL,
    codigo_banda_tiempo INT NOT NULL,
    numero_clientes INT NOT NULL,
    saldo_contable DECIMAL(15,2) NOT NULL,
    fecha_reporte DATE NOT NULL,
    entidad_codigo CHAR(4) NOT NULL,
    fecha_envio DATETIME2 NOT NULL,
    estado_envio VARCHAR(20) NOT NULL,
    archivo_generado VARCHAR(255),
    errores_validacion TEXT,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

-- =============================================
-- L13 - OBLIGACIONES FINANCIERAS (MENSUAL)
-- =============================================

CREATE TABLE regulatory_reports.l13_obligaciones_financieras (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    codigo_cuenta_contable VARCHAR(4) NOT NULL,
    tipo_identificacion_entidad CHAR(1) NOT NULL,
    identificacion_entidad VARCHAR(13) NOT NULL,
    codigo_linea_autorizada VARCHAR(20) NOT NULL,
    monto_linea_autorizada DECIMAL(15,2) NOT NULL,
    valor_adeudado DECIMAL(15,2) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    monto_por_utilizar DECIMAL(15,2) NOT NULL,
    tasa_interes DECIMAL(15,2) NOT NULL,
    fecha_reporte DATE NOT NULL,
    entidad_codigo CHAR(4) NOT NULL DEFAULT '0161',
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT uk_l13 UNIQUE (codigo_cuenta_contable, tipo_identificacion_entidad, identificacion_entidad, codigo_linea_autorizada, fecha_vencimiento, fecha_reporte)
);

CREATE TABLE regulatory_reports.l13_obligaciones_financieras_hist (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_original BIGINT NOT NULL,
    codigo_cuenta_contable VARCHAR(4) NOT NULL,
    tipo_identificacion_entidad CHAR(1) NOT NULL,
    identificacion_entidad VARCHAR(13) NOT NULL,
    codigo_linea_autorizada VARCHAR(20) NOT NULL,
    monto_linea_autorizada DECIMAL(15,2) NOT NULL,
    valor_adeudado DECIMAL(15,2) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    monto_por_utilizar DECIMAL(15,2) NOT NULL,
    tasa_interes DECIMAL(15,2) NOT NULL,
    fecha_reporte DATE NOT NULL,
    entidad_codigo CHAR(4) NOT NULL,
    fecha_envio DATETIME2 NOT NULL,
    estado_envio VARCHAR(20) NOT NULL,
    archivo_generado VARCHAR(255),
    errores_validacion TEXT,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

-- =============================================
-- L14 - CONCENTRACIÓN DE DEPÓSITOS (QUINCENAL)
-- =============================================

CREATE TABLE regulatory_reports.l14_concentracion_depositos (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    cuenta_contable VARCHAR(6) NOT NULL,
    tipo_cliente CHAR(1) NOT NULL,
    tipo_identificacion CHAR(1) NOT NULL,
    identificacion_cliente VARCHAR(13) NOT NULL,
    actividad_economica CHAR(7) NOT NULL,
    pais_origen CHAR(2) NOT NULL,
    saldo_inicial DECIMAL(15,2) NOT NULL,
    retiros DECIMAL(15,2) NOT NULL,
    nuevos_depositos DECIMAL(15,2) NOT NULL,
    fecha_reporte DATE NOT NULL,
    entidad_codigo CHAR(4) NOT NULL DEFAULT '0161',
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT uk_l14 UNIQUE (cuenta_contable, identificacion_cliente, fecha_reporte)
);

CREATE TABLE regulatory_reports.l14_concentracion_depositos_hist (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_original BIGINT NOT NULL,
    cuenta_contable VARCHAR(6) NOT NULL,
    tipo_cliente CHAR(1) NOT NULL,
    tipo_identificacion CHAR(1) NOT NULL,
    identificacion_cliente VARCHAR(13) NOT NULL,
    actividad_economica CHAR(7) NOT NULL,
    pais_origen CHAR(2) NOT NULL,
    saldo_inicial DECIMAL(15,2) NOT NULL,
    retiros DECIMAL(15,2) NOT NULL,
    nuevos_depositos DECIMAL(15,2) NOT NULL,
    fecha_reporte DATE NOT NULL,
    entidad_codigo CHAR(4) NOT NULL,
    fecha_envio DATETIME2 NOT NULL,
    estado_envio VARCHAR(20) NOT NULL,
    archivo_generado VARCHAR(255),
    errores_validacion TEXT,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

-- =============================================
-- L31 - BRECHAS DE LIQUIDEZ (MENSUAL)
-- =============================================

CREATE TABLE regulatory_reports.l31_brechas_liquidez (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    volatilidad_promedio DECIMAL(5,4) NOT NULL,
    activos_liquidos_netos DECIMAL(15,2) NOT NULL,
    total_inversiones_a DECIMAL(15,2) NOT NULL,
    fecha_reporte DATE NOT NULL,
    entidad_codigo CHAR(4) NOT NULL DEFAULT '0161',
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT uk_l31 UNIQUE (fecha_reporte, entidad_codigo)
);

CREATE TABLE regulatory_reports.l31_brechas_detalle (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    l31_cabecera_id BIGINT NOT NULL REFERENCES regulatory_reports.l31_brechas_liquidez(id),
    codigo_escenario CHAR(1) NOT NULL,
    codigo_producto CHAR(10) NOT NULL,
    codigo_banda INT NOT NULL,
    valor_capital_banda DECIMAL(15,2) NOT NULL,
    valor_intereses_banda DECIMAL(15,2) NOT NULL,
    movimientos_proj_pos DECIMAL(15,2) NULL,
    movimientos_proj_neg DECIMAL(15,2) NULL,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT uk_l31_det UNIQUE (l31_cabecera_id, codigo_escenario, codigo_producto, codigo_banda)
);

CREATE TABLE regulatory_reports.l31_brechas_liquidez_hist (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_original BIGINT NOT NULL,
    volatilidad_promedio DECIMAL(5,4) NOT NULL,
    activos_liquidos_netos DECIMAL(15,2) NOT NULL,
    total_inversiones_a DECIMAL(15,2) NOT NULL,
    fecha_reporte DATE NOT NULL,
    entidad_codigo CHAR(4) NOT NULL,
    fecha_envio DATETIME2 NOT NULL,
    estado_envio VARCHAR(20) NOT NULL,
    archivo_generado VARCHAR(255),
    errores_validacion TEXT,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

-- =============================================
-- TABLA DE CONTROL DE ENVÍOS
-- =============================================

CREATE TABLE regulatory_reports.control_envios (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    estructura VARCHAR(3) NOT NULL,
    fecha_reporte DATE NOT NULL,
    total_registros INT NOT NULL,
    fecha_generacion DATETIME2 NOT NULL,
    fecha_envio DATETIME2 NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    archivo_txt VARCHAR(255) NULL,
    respuesta_sb TEXT NULL,
    errores_validacion TEXT NULL,
    usuario_generacion VARCHAR(50) NOT NULL,
    usuario_aprobacion VARCHAR(50) NULL,
    usuario_envio VARCHAR(50) NULL,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT uk_control_envios UNIQUE (estructura, fecha_reporte)
);

-- =============================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =============================================

-- Índices para L08
CREATE INDEX idx_l08_fecha ON regulatory_reports.l08_liquidez_estructural(fecha_reporte);
CREATE INDEX idx_l08_entidad ON regulatory_reports.l08_liquidez_estructural(identificacion_entidad);

-- Índices para L10
CREATE INDEX idx_l10_fecha ON regulatory_reports.l10_brechas_sensibilidad(fecha_reporte);
CREATE INDEX idx_l10_producto ON regulatory_reports.l10_brechas_sensibilidad(codigo_producto);

-- Índices para L11
CREATE INDEX idx_l11_fecha ON regulatory_reports.l11_sensibilidad_patrimonial(fecha_reporte);

-- Índices para L12
CREATE INDEX idx_l12_fecha ON regulatory_reports.l12_captaciones_monto(fecha_reporte);
CREATE INDEX idx_l12_cuenta ON regulatory_reports.l12_captaciones_monto(codigo_cuenta_contable);

-- Índices para L13
CREATE INDEX idx_l13_fecha ON regulatory_reports.l13_obligaciones_financieras(fecha_reporte);
CREATE INDEX idx_l13_entidad ON regulatory_reports.l13_obligaciones_financieras(identificacion_entidad);

-- Índices para L14
CREATE INDEX idx_l14_fecha ON regulatory_reports.l14_concentracion_depositos(fecha_reporte);
CREATE INDEX idx_l14_cliente ON regulatory_reports.l14_concentracion_depositos(identificacion_cliente);

-- Índices para L31
CREATE INDEX idx_l31_fecha ON regulatory_reports.l31_brechas_liquidez(fecha_reporte);

-- Índices para control de envíos
CREATE INDEX idx_control_estructura ON regulatory_reports.control_envios(estructura);
CREATE INDEX idx_control_fecha ON regulatory_reports.control_envios(fecha_reporte);
CREATE INDEX idx_control_estado ON regulatory_reports.control_envios(estado);

PRINT 'Todas las tablas regulatorias han sido creadas exitosamente.'
PRINT 'Estructuras implementadas: L08, L10, L11, L12, L13, L14, L31'
PRINT 'Tablas históricas creadas para trazabilidad'
PRINT 'Índices optimizados para consultas' 