-- Tabla L08_LiquidezEstructural según manual oficial de la Superintendencia de Bancos
CREATE TABLE L08_LiquidezEstructural (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    codigo_liquidez INT NOT NULL,                    -- 6 dígitos - Tabla 59
    tipo_identificacion_entidad VARCHAR(1) NOT NULL, -- 1 carácter - Tabla 4 (R=RUC, E=Extranjero)
    identificacion_entidad VARCHAR(13) NOT NULL,     -- 13 dígitos
    tipo_instrumento INT NOT NULL,                   -- 2 dígitos - Tabla 62
    calificacion_entidad INT NOT NULL,               -- 2 dígitos - Tabla 65
    calificadora_riesgo INT NOT NULL,                -- 2 dígitos - Tabla 66
    valor_lunes DECIMAL(16,8) NOT NULL,              -- 16,8 - Valor numérico
    valor_martes DECIMAL(16,8) NOT NULL,             -- 16,8 - Valor numérico
    valor_miercoles DECIMAL(16,8) NOT NULL,          -- 16,8 - Valor numérico
    valor_jueves DECIMAL(16,8) NOT NULL,             -- 16,8 - Valor numérico
    valor_viernes DECIMAL(16,8) NOT NULL,            -- 16,8 - Valor numérico
    fecha_corte DATE NOT NULL,                       -- Fecha de corte
    fecha_creacion DATETIME DEFAULT GETDATE(),
    fecha_actualizacion DATETIME DEFAULT GETDATE()
);

-- Índices para optimizar consultas
CREATE INDEX idx_l08_codigo_liquidez ON L08_LiquidezEstructural(codigo_liquidez);
CREATE INDEX idx_l08_fecha_corte ON L08_LiquidezEstructural(fecha_corte);
CREATE INDEX idx_l08_identificacion ON L08_LiquidezEstructural(identificacion_entidad);

-- Datos de prueba según códigos de la Tabla 59 del manual oficial
INSERT INTO L08_LiquidezEstructural (
    codigo_liquidez, tipo_identificacion_entidad, identificacion_entidad, 
    tipo_instrumento, calificacion_entidad, calificadora_riesgo,
    valor_lunes, valor_martes, valor_miercoles, valor_jueves, valor_viernes, fecha_corte
) VALUES 
-- Inversiones mantenidas hasta el vencimiento de entidades del sector privado
(130505, 'R', '0001', 10, 1, 1, 1000000.00, 1050000.00, 1100000.00, 1150000.00, 1200000.00, '2025-06-30'),
(130510, 'R', '0001', 10, 1, 1, 2000000.00, 2100000.00, 2200000.00, 2300000.00, 2400000.00, '2025-06-30'),
(130515, 'R', '0001', 10, 1, 1, 3000000.00, 3150000.00, 3300000.00, 3450000.00, 3600000.00, '2025-06-30'),

-- Inversiones mantenidas hasta el vencimiento del estado o de entidades del sector público
(130605, 'R', '0001', 10, 1, 1, 5000000.00, 5250000.00, 5500000.00, 5750000.00, 6000000.00, '2025-06-30'),
(130610, 'R', '0001', 10, 1, 1, 4000000.00, 4200000.00, 4400000.00, 4600000.00, 4800000.00, '2025-06-30'),
(130615, 'R', '0001', 10, 1, 1, 6000000.00, 6300000.00, 6600000.00, 6900000.00, 7200000.00, '2025-06-30'),

-- Fondos disponibles (solo viernes)
(110305, 'R', '0001', 0, 1, 1, 0.00, 0.00, 0.00, 0.00, 15000000.00, '2025-06-30'),
(110310, 'R', '0001', 0, 1, 1, 0.00, 0.00, 0.00, 0.00, 20000000.00, '2025-06-30'),
(110315, 'R', '0001', 0, 1, 1, 0.00, 0.00, 0.00, 0.00, 25000000.00, '2025-06-30'),

-- Pasivos con cobertura real
(260001, 'R', '0001', 0, 1, 1, 80000000.00, 82000000.00, 84000000.00, 86000000.00, 88000000.00, '2025-06-30'),
(260002, 'R', '0001', 0, 1, 1, 60000000.00, 61500000.00, 63000000.00, 64500000.00, 66000000.00, '2025-06-30'),

-- Valores en circulación
(270001, 'R', '0001', 0, 1, 1, 40000000.00, 41000000.00, 42000000.00, 43000000.00, 44000000.00, '2025-06-30'),
(270002, 'R', '0001', 0, 1, 1, 30000000.00, 30750000.00, 31500000.00, 32250000.00, 33000000.00, '2025-06-30'),

-- Volatilidad diaria (código 888888)
(888888, 'R', '0001', 0, 1, 1, 0.035416, 0.034200, 0.036800, 0.033900, 0.037500, '2025-06-30');

-- Comentarios sobre la tabla
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Tabla L08 - Liquidez Estructural según manual oficial de la Superintendencia de Bancos', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'L08_LiquidezEstructural'; 