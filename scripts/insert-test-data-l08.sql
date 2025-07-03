-- Script para insertar datos de prueba L08 - Liquidez Estructural
-- Datos realistas según especificaciones de la Superintendencia de Bancos

-- Limpiar datos existentes
DELETE FROM regulatory_reports.l08_liquidez_estructural;
DELETE FROM regulatory_reports.l08_liquidez_estructural_hist;

-- Insertar datos de prueba para L08
-- Estructura: codigo_liquidez|tipo_identificacion|identificacion_entidad|tipo_instrumento|calificacion_entidad|calificadora_riesgo|valores_semana

INSERT INTO regulatory_reports.l08_liquidez_estructural (
    codigo_liquidez, tipo_identificacion, identificacion_entidad, 
    tipo_instrumento, calificacion_entidad, calificadora_riesgo,
    valor_lunes, valor_martes, valor_miercoles, valor_jueves, valor_viernes,
    fecha_reporte, entidad_codigo
) VALUES
-- Depósitos a la vista - Entidades financieras
(100001, 'R', 1234567890123, 01, 01, 01, 15000000.00, 15200000.00, 14800000.00, 15500000.00, 15800000.00, '2025-01-20', '0161'),
(100002, 'R', 1234567890124, 01, 01, 01, 25000000.00, 25200000.00, 24800000.00, 25500000.00, 25800000.00, '2025-01-20', '0161'),
(100003, 'R', 1234567890125, 01, 01, 01, 18000000.00, 18200000.00, 17800000.00, 18500000.00, 18800000.00, '2025-01-20', '0161'),

-- Depósitos a plazo - Entidades financieras
(200001, 'R', 1234567890126, 02, 01, 01, 45000000.00, 45200000.00, 44800000.00, 45500000.00, 45800000.00, '2025-01-20', '0161'),
(200002, 'R', 1234567890127, 02, 01, 01, 32000000.00, 32200000.00, 31800000.00, 32500000.00, 32800000.00, '2025-01-20', '0161'),

-- Inversiones en valores - Entidades financieras
(300001, 'R', 1234567890128, 03, 01, 01, 75000000.00, 75200000.00, 74800000.00, 75500000.00, 75800000.00, '2025-01-20', '0161'),
(300002, 'R', 1234567890129, 03, 01, 01, 55000000.00, 55200000.00, 54800000.00, 55500000.00, 55800000.00, '2025-01-20', '0161'),

-- Préstamos interbancarios - Entidades financieras
(400001, 'R', 1234567890130, 04, 01, 01, 28000000.00, 28200000.00, 27800000.00, 28500000.00, 28800000.00, '2025-01-20', '0161'),
(400002, 'R', 1234567890131, 04, 01, 01, 35000000.00, 35200000.00, 34800000.00, 35500000.00, 35800000.00, '2025-01-20', '0161'),

-- Depósitos a la vista - Empresas
(500001, 'E', 9876543210987, 01, 02, 01, 12000000.00, 12200000.00, 11800000.00, 12500000.00, 12800000.00, '2025-01-20', '0161'),
(500002, 'E', 9876543210988, 01, 02, 01, 8500000.00, 8700000.00, 8300000.00, 9000000.00, 9300000.00, '2025-01-20', '0161'),

-- Depósitos a plazo - Empresas
(600001, 'E', 9876543210989, 02, 02, 01, 22000000.00, 22200000.00, 21800000.00, 22500000.00, 22800000.00, '2025-01-20', '0161'),
(600002, 'E', 9876543210990, 02, 02, 01, 18000000.00, 18200000.00, 17800000.00, 18500000.00, 18800000.00, '2025-01-20', '0161'),

-- Inversiones en valores - Empresas
(700001, 'E', 9876543210991, 03, 02, 01, 42000000.00, 42200000.00, 41800000.00, 42500000.00, 42800000.00, '2025-01-20', '0161'),
(700002, 'E', 9876543210992, 03, 02, 01, 38000000.00, 38200000.00, 37800000.00, 38500000.00, 38800000.00, '2025-01-20', '0161'),

-- Préstamos interbancarios - Empresas
(800001, 'E', 9876543210993, 04, 02, 01, 15000000.00, 15200000.00, 14800000.00, 15500000.00, 15800000.00, '2025-01-20', '0161'),
(800002, 'E', 9876543210994, 04, 02, 01, 25000000.00, 25200000.00, 24800000.00, 25500000.00, 25800000.00, '2025-01-20', '0161'),

-- Entidades con calificación B
(900001, 'R', 1234567890132, 01, 02, 01, 9500000.00, 9700000.00, 9300000.00, 10000000.00, 10300000.00, '2025-01-20', '0161'),
(900002, 'E', 9876543210995, 02, 03, 01, 16000000.00, 16200000.00, 15800000.00, 16500000.00, 16800000.00, '2025-01-20', '0161'),

-- Entidades con calificación C
(1000001, 'R', 1234567890133, 03, 03, 01, 8500000.00, 8700000.00, 8300000.00, 9000000.00, 9300000.00, '2025-01-20', '0161'),
(1000002, 'E', 9876543210996, 04, 04, 01, 12000000.00, 12200000.00, 11800000.00, 12500000.00, 12800000.00, '2025-01-20', '0161');

-- Insertar registro en control de envíos
INSERT INTO regulatory_reports.control_envios (
    estructura, fecha_reporte, total_registros, fecha_generacion, 
    estado, usuario_generacion
) VALUES (
    'L08', '2025-01-20', 20, GETDATE(), 'PENDIENTE', 'SISTEMA'
);

-- Mostrar resumen
SELECT 
    'L08 - Liquidez Estructural' as Estructura,
    COUNT(*) as Total_Registros,
    SUM(valor_viernes) as Valor_Total_Viernes,
    AVG(valor_viernes) as Promedio_Viernes,
    MIN(fecha_reporte) as Fecha_Reporte
FROM regulatory_reports.l08_liquidez_estructural;

-- Mostrar distribución por tipo de instrumento
SELECT 
    tipo_instrumento,
    COUNT(*) as Cantidad_Registros,
    SUM(valor_viernes) as Valor_Total
FROM regulatory_reports.l08_liquidez_estructural
GROUP BY tipo_instrumento
ORDER BY tipo_instrumento;

-- Mostrar distribución por calificación
SELECT 
    calificacion_entidad,
    COUNT(*) as Cantidad_Registros,
    SUM(valor_viernes) as Valor_Total
FROM regulatory_reports.l08_liquidez_estructural
GROUP BY calificacion_entidad
ORDER BY calificacion_entidad;

PRINT 'Datos de prueba L08 insertados exitosamente.'
PRINT 'Total registros: 20'
PRINT 'Fecha de reporte: 2025-01-20'
PRINT 'Estructura: L08 - Liquidez Estructural' 