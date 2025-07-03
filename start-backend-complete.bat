@echo off
echo ========================================
echo INICIANDO BACKEND SUDBANKCORE COMPLETO
echo ========================================
echo.

echo Deteniendo procesos Java existentes...
taskkill /f /im java.exe 2>nul

echo.
echo Iniciando SQL Server Adapter en nueva ventana...
start "SQL Server Adapter" cmd /k "C:\Desarrollo\SudBankBackend\start-sqlserver-adapter.bat"

echo Esperando 10 segundos para que el SQL Server Adapter se inicie...
timeout /t 10 /nobreak >nul

echo.
echo Iniciando Regulatory Service en nueva ventana...
start "Regulatory Service" cmd /k "C:\Desarrollo\SudBankBackend\start-regulatory-service.bat"

echo.
echo ========================================
echo SERVICIOS INICIADOS
echo ========================================
echo SQL Server Adapter: http://localhost:8080
echo Regulatory Service: http://localhost:8085
echo.
echo Para verificar el estado:
echo - SQL Server Adapter: curl http://localhost:8080/actuator/health
echo - Regulatory Service: curl http://localhost:8085/actuator/health
echo.
echo Presiona cualquier tecla para salir...
pause >nul 