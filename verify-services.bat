@echo off
echo ========================================
echo VERIFICANDO SERVICIOS BACKEND
echo ========================================
echo.

echo Verificando SQL Server Adapter (puerto 8080)...
curl -s http://localhost:8080/actuator/health
if %errorlevel% equ 0 (
    echo.
    echo ✅ SQL Server Adapter: FUNCIONANDO
) else (
    echo.
    echo ❌ SQL Server Adapter: NO RESPONDE
)

echo.
echo Verificando Regulatory Service (puerto 8085)...
curl -s http://localhost:8085/actuator/health
if %errorlevel% equ 0 (
    echo.
    echo ✅ Regulatory Service: FUNCIONANDO
) else (
    echo.
    echo ❌ Regulatory Service: NO RESPONDE
)

echo.
echo ========================================
echo VERIFICACION COMPLETADA
echo ========================================
pause 