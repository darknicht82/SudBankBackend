@echo off
echo ========================================
echo Ejecutando Scripts SQL - SudBankCore
echo ========================================
echo.

REM Configuración de conexión
set SERVER=localhost
set DATABASE=SudBankDB
set USERNAME=sa
set PASSWORD=SudBank2024!

echo Conectando a SQL Server...
echo Servidor: %SERVER%
echo Base de datos: %DATABASE%
echo.

REM Verificar conexión
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -Q "SELECT 'Conexion exitosa' AS Status" -t 30
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: No se pudo conectar a SQL Server
    echo Verifique que SQL Server esté ejecutándose
    pause
    exit /b 1
)

echo.
echo ========================================
echo 1. Creando tablas regulatorias...
echo ========================================
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "create-regulatory-tables.sql" -t 60
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Fallo al crear tablas regulatorias
    pause
    exit /b 1
)

echo.
echo ========================================
echo 2. Creando tablas de historial...
echo ========================================
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "create-hist-tables.sql" -t 60
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Fallo al crear tablas de historial
    pause
    exit /b 1
)

echo.
echo ========================================
echo 3. Insertando datos de prueba L08...
echo ========================================
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "insert-l08-test-data.sql" -t 60
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Fallo al insertar datos de prueba
    pause
    exit /b 1
)

echo.
echo ========================================
echo 4. Verificando implementación...
echo ========================================
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -Q "
SELECT 'Tablas creadas' AS Tipo, COUNT(*) AS Cantidad
FROM sys.tables 
WHERE schema_id = SCHEMA_ID('regulatory_reports')
UNION ALL
SELECT 'Triggers creados' AS Tipo, COUNT(*) AS Cantidad
FROM sys.triggers 
WHERE parent_class = 1 AND name LIKE '%hist%'
UNION ALL
SELECT 'Datos L08' AS Tipo, COUNT(*) AS Cantidad
FROM regulatory_reports.l08_liquidez_estructural;
" -t 30

echo.
echo ========================================
echo Scripts ejecutados exitosamente!
echo ========================================
echo.
echo Próximos pasos:
echo 1. Verificar que el frontend esté ejecutándose
echo 2. Probar navegación al menú L08
echo 3. Verificar que se muestren datos reales
echo.
pause 