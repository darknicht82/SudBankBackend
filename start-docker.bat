@echo off
echo ========================================
echo GESTION DOCKER - BACKEND SUDBANKCORE
echo ========================================
echo.

if "%1"=="build" goto :build
if "%1"=="up" goto :up
if "%1"=="down" goto :down
if "%1"=="logs" goto :logs
if "%1"=="status" goto :status
if "%1"=="restart" goto :restart

echo Uso: %0 [comando]
echo.
echo Comandos disponibles:
echo   build   - Construir las imágenes Docker
echo   up      - Iniciar los servicios
echo   down    - Detener los servicios
echo   logs    - Mostrar logs
echo   status  - Estado de los contenedores
echo   restart - Reiniciar los servicios
echo.
pause
exit /b 1

:build
echo Construyendo imágenes Docker...
docker-compose -f docker-compose-backend.yml build
goto :end

:up
echo Iniciando servicios Docker...
docker-compose -f docker-compose-backend.yml up -d
echo.
echo Esperando a que los servicios se inicien...
timeout /t 30 /nobreak >nul
echo.
echo Verificando servicios...
curl -s http://localhost:8080/actuator/health >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ SQL Server Adapter: FUNCIONANDO
) else (
    echo ❌ SQL Server Adapter: NO RESPONDE
)

curl -s http://localhost:8085/actuator/health >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Regulatory Service: FUNCIONANDO
) else (
    echo ❌ Regulatory Service: NO RESPONDE
)
goto :end

:down
echo Deteniendo servicios Docker...
docker-compose -f docker-compose-backend.yml down
goto :end

:logs
echo Mostrando logs de los servicios...
echo.
echo === SQL Server Adapter ===
docker logs sudbankcore-sqlserver-adapter
echo.
echo === Regulatory Service ===
docker logs sudbankcore-regulatory-service
goto :end

:status
echo Estado de los contenedores:
docker-compose -f docker-compose-backend.yml ps
goto :end

:restart
echo Reiniciando servicios Docker...
docker-compose -f docker-compose-backend.yml restart
goto :end

:end
echo.
echo Presiona cualquier tecla para continuar...
pause >nul 