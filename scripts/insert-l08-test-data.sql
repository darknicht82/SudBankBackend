-- ================================================================
-- Script para insertar datos de prueba en L08 - Liquidez Estructural
-- Datos realistas para desarrollo y demostración
-- ================================================================

-- Limpiar datos existentes
DELETE FROM regulatory_reports.l08_liquidez_estructural;
GO

-- Insertar datos de prueba L08
INSERT INTO regulatory_reports.l08_liquidez_estructural (
    codigo_liquidez, tipo_identificacion, identificacion_entidad,
    tipo_instrumento, calificacion_entidad, calificadora_riesgo,
    valor_lunes, valor_martes, valor_miercoles, valor_jueves, valor_viernes,
    fecha_reporte, entidad_codigo
) VALUES
-- Instrumentos de alta liquidez (códigos 100000-199999)
(100001, 'R', 1234567890123, 01, 01, 01, 15000000.00, 15200000.00, 14800000.00, 15500000.00, 15800000.00, '2025-01-20', '0161'),
(100002, 'R', 1234567890124, 01, 01, 01, 25000000.00, 25200000.00, 24800000.00, 25500000.00, 25800000.00, '2025-01-20', '0161'),
(100003, 'E', 9876543210987, 02, 02, 01, 35000000.00, 35200000.00, 34800000.00, 35500000.00, 35800000.00, '2025-01-20', '0161'),

-- Instrumentos de liquidez media (códigos 200000-299999)
(200001, 'R', 1234567890125, 03, 02, 02, 45000000.00, 45200000.00, 44800000.00, 45500000.00, 45800000.00, '2025-01-20', '0161'),
(200002, 'E', 9876543210988, 04, 03, 02, 55000000.00, 55200000.00, 54800000.00, 55500000.00, 55800000.00, '2025-01-20', '0161'),
(200003, 'R', 1234567890126, 05, 02, 01, 65000000.00, 65200000.00, 64800000.00, 65500000.00, 65800000.00, '2025-01-20', '0161'),

-- Instrumentos de liquidez baja (códigos 300000-399999)
(300001, 'E', 9876543210989, 06, 04, 03, 75000000.00, 75200000.00, 74800000.00, 75500000.00, 75800000.00, '2025-01-20', '0161'),
(300002, 'R', 1234567890127, 07, 03, 02, 85000000.00, 85200000.00, 84800000.00, 85500000.00, 85800000.00, '2025-01-20', '0161'),
(300003, 'E', 9876543210990, 08, 05, 03, 95000000.00, 95200000.00, 94800000.00, 95500000.00, 95800000.00, '2025-01-20', '0161'),

-- Instrumentos especializados (códigos 400000-499999)
(400001, 'R', 1234567890128, 09, 01, 01, 105000000.00, 105200000.00, 104800000.00, 105500000.00, 105800000.00, '2025-01-20', '0161'),
(400002, 'E', 9876543210991, 10, 02, 02, 115000000.00, 115200000.00, 114800000.00, 115500000.00, 115800000.00, '2025-01-20', '0161'),
(400003, 'R', 1234567890129, 11, 03, 01, 125000000.00, 125200000.00, 124800000.00, 125500000.00, 125800000.00, '2025-01-20', '0161'),

-- Datos históricos (semana anterior)
(100001, 'R', 1234567890123, 01, 01, 01, 14500000.00, 14700000.00, 14300000.00, 15000000.00, 15300000.00, '2025-01-13', '0161'),
(100002, 'R', 1234567890124, 01, 01, 01, 24500000.00, 24700000.00, 24300000.00, 25000000.00, 25300000.00, '2025-01-13', '0161'),
(200001, 'R', 1234567890125, 03, 02, 02, 44500000.00, 44700000.00, 44300000.00, 45000000.00, 45300000.00, '2025-01-13', '0161'),

-- Datos históricos (dos semanas atrás)
(100001, 'R', 1234567890123, 01, 01, 01, 14000000.00, 14200000.00, 13800000.00, 14500000.00, 14800000.00, '2025-01-06', '0161'),
(100002, 'R', 1234567890124, 01, 01, 01, 24000000.00, 24200000.00, 23800000.00, 24500000.00, 24800000.00, '2025-01-06', '0161'),
(200001, 'R', 1234567890125, 03, 02, 02, 44000000.00, 44200000.00, 43800000.00, 44500000.00, 44800000.00, '2025-01-06', '0161');
GO

-- Verificar datos insertados
SELECT 
    'Datos L08 insertados' AS Resultado,
    COUNT(*) AS TotalRegistros,
    MIN(fecha_reporte) AS FechaMinima,
    MAX(fecha_reporte) AS FechaMaxima
FROM regulatory_reports.l08_liquidez_estructural;

-- Mostrar resumen por fecha
SELECT 
    fecha_reporte,
    COUNT(*) AS TotalRegistros,
    SUM(valor_lunes + valor_martes + valor_miercoles + valor_jueves + valor_viernes) / 5 AS PromedioSemanal
FROM regulatory_reports.l08_liquidez_estructural
GROUP BY fecha_reporte
ORDER BY fecha_reporte DESC;

-- Mostrar resumen por tipo de instrumento
SELECT 
    tipo_instrumento,
    COUNT(*) AS TotalRegistros,
    AVG(valor_viernes) AS PromedioValorViernes
FROM regulatory_reports.l08_liquidez_estructural
GROUP BY tipo_instrumento
ORDER BY tipo_instrumento; 