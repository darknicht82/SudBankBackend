-- Script para insertar datos de prueba en las estructuras regulatorias
-- Ejecutar después de crear las tablas

-- Datos de prueba para L08_EMISORES_CUSTODIOS_DETALLE
INSERT INTO L08_EMISORES_CUSTODIOS_DETALLE (
    codigo_emisor, nombre_emisor, tipo_instrumento, valor_nominal, 
    valor_mercado, fecha_emision, fecha_vencimiento, tasa_cupon, 
    calificacion_riesgo, entidad_custodia, fecha_registro, usuario_registro
) VALUES 
('EM001', 'Banco Central de Reserva', 'Bono Gubernamental', 1000000.00, 1025000.00, '2024-01-15', '2029-01-15', 0.045, 'A', 'Custodia Central', CURRENT_TIMESTAMP, 'admin'),
('EM002', 'Corporación Financiera Nacional', 'Bono Corporativo', 500000.00, 487500.00, '2024-02-01', '2027-02-01', 0.055, 'B', 'Custodia Privada', CURRENT_TIMESTAMP, 'admin'),
('EM003', 'Empresa de Servicios Públicos', 'Bono Municipal', 750000.00, 780000.00, '2024-01-20', '2028-01-20', 0.052, 'A', 'Custodia Central', CURRENT_TIMESTAMP, 'admin'),
('EM004', 'Banco Comercial Internacional', 'Certificado de Depósito', 2000000.00, 1980000.00, '2024-03-01', '2026-03-01', 0.038, 'A', 'Custodia Privada', CURRENT_TIMESTAMP, 'admin'),
('EM005', 'Compañía de Seguros Nacional', 'Bono Corporativo', 300000.00, 285000.00, '2024-02-15', '2025-02-15', 0.065, 'C', 'Custodia Privada', CURRENT_TIMESTAMP, 'admin'),
('EM006', 'Fondo de Pensiones Estatal', 'Bono Gubernamental', 1500000.00, 1530000.00, '2024-01-10', '2030-01-10', 0.042, 'A', 'Custodia Central', CURRENT_TIMESTAMP, 'admin'),
('EM007', 'Empresa Minera Nacional', 'Bono Corporativo', 800000.00, 760000.00, '2024-02-28', '2028-02-28', 0.058, 'B', 'Custodia Privada', CURRENT_TIMESTAMP, 'admin'),
('EM008', 'Instituto de Desarrollo Rural', 'Bono de Desarrollo', 600000.00, 630000.00, '2024-01-25', '2027-01-25', 0.048, 'A', 'Custodia Central', CURRENT_TIMESTAMP, 'admin');

-- Datos de prueba para L14_EMISORES_CUSTODIOS_RIESGO_MERCADO_DETALLE
INSERT INTO L14_EMISORES_CUSTODIOS_RIESGO_MERCADO_DETALLE (
    codigo_emisor, nombre_emisor, tipo_riesgo, valor_exposicion, 
    limite_riesgo, utilizacion_limite, duracion, convexidad, 
    var, stress_test, fecha_calculo, fecha_registro, usuario_registro
) VALUES 
('EM001', 'Banco Central de Reserva', 'Riesgo de Tasa de Interés', 1025000.00, 2000000.00, 0.5125, 4.5, 0.25, 45000.00, 85000.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'admin'),
('EM002', 'Corporación Financiera Nacional', 'Riesgo de Crédito', 487500.00, 1000000.00, 0.4875, 3.2, 0.18, 25000.00, 50000.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'admin'),
('EM003', 'Empresa de Servicios Públicos', 'Riesgo de Liquidez', 780000.00, 1500000.00, 0.5200, 3.8, 0.22, 35000.00, 65000.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'admin'),
('EM004', 'Banco Comercial Internacional', 'Riesgo de Mercado', 1980000.00, 3000000.00, 0.6600, 2.1, 0.15, 75000.00, 120000.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'admin'),
('EM005', 'Compañía de Seguros Nacional', 'Riesgo de Crédito', 285000.00, 500000.00, 0.5700, 1.5, 0.12, 15000.00, 30000.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'admin'),
('EM006', 'Fondo de Pensiones Estatal', 'Riesgo de Tasa de Interés', 1530000.00, 2500000.00, 0.6120, 5.2, 0.30, 55000.00, 95000.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'admin'),
('EM007', 'Empresa Minera Nacional', 'Riesgo de Mercado', 760000.00, 1200000.00, 0.6333, 3.5, 0.20, 40000.00, 70000.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'admin'),
('EM008', 'Instituto de Desarrollo Rural', 'Riesgo de Liquidez', 630000.00, 1000000.00, 0.6300, 2.8, 0.16, 28000.00, 45000.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'admin');

-- Verificar los datos insertados
SELECT 'L08 - Total registros:' as tabla, COUNT(*) as total FROM L08_EMISORES_CUSTODIOS_DETALLE
UNION ALL
SELECT 'L14 - Total registros:' as tabla, COUNT(*) as total FROM L14_EMISORES_CUSTODIOS_RIESGO_MERCADO_DETALLE; 