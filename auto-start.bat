@echo off
setlocal enabledelayedexpansion

echo ========================================
echo AUTO START - SUDBANKCORE BACKEND
echo ========================================
echo.

:: Variables
set "SERVICES_RUNNING="
set "DOCKER_AVAILABLE="
set "JAVA_AVAILABLE="

echo [INFO] Iniciando configuración automática...
echo.

:: ========================================
:: 1. VERIFICAR SI LOS SERVICIOS YA ESTÁN EJECUTÁNDOSE
:: ========================================
echo [1/4] Verificando servicios existentes...

:: Verificar SQL Server Adapter
curl -s http://localhost:8080/actuator/health >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] SQL Server Adapter ya está ejecutándose
    set "SERVICES_RUNNING=1"
) else (
    echo [INFO] SQL Server Adapter no está ejecutándose
)

:: Verificar Regulatory Service
curl -s http://localhost:8085/actuator/health >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Regulatory Service ya está ejecutándose
    set "SERVICES_RUNNING=1"
) else (
    echo [INFO] Regulatory Service no está ejecutándose
)

if defined SERVICES_RUNNING (
    echo.
    echo [SUCCESS] Los servicios ya están ejecutándose
    echo [INFO] Verificando estado completo...
    echo.
    call verify-services.bat
    goto :end
)

:: ========================================
:: 2. VERIFICAR PRERREQUISITOS
:: ========================================
echo.
echo [2/4] Verificando prerrequisitos...

:: Verificar Java
java -version >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Java disponible
    set "JAVA_AVAILABLE=1"
) else (
    echo [ERROR] Java no está instalado
    echo [INFO] Descarga: https://adoptium.net/temurin/releases/?version=8
    goto :error
)

:: Verificar Docker
docker --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Docker disponible
    set "DOCKER_AVAILABLE=1"
) else (
    echo [WARNING] Docker no está disponible
    echo [INFO] Intentando modo local...
)

:: ========================================
:: 3. CONFIGURAR PROYECTO
:: ========================================
echo.
echo [3/4] Configurando proyecto...

:: Crear .env si no existe
if not exist ".env" (
    echo [INFO] Creando archivo .env...
    copy env.template .env >nul
    echo [OK] Archivo .env creado
)

:: Verificar dependencias Gradle
if not exist "sqlserver-adapter\gradle\wrapper\gradle-wrapper.jar" (
    echo [ERROR] Gradle wrapper SQL Server Adapter faltante
    goto :error
)

if not exist "backend\modules\regulatory-service\gradle\wrapper\gradle-wrapper.jar" (
    echo [ERROR] Gradle wrapper Regulatory Service faltante
    goto :error
)

:: ========================================
:: 4. INICIAR SERVICIOS
:: ========================================
echo.
echo [4/4] Iniciando servicios...

if defined DOCKER_AVAILABLE (
    echo [INFO] Iniciando con Docker...
    
    :: Construir imágenes si no existen
    docker images | findstr sudbankbackend-sqlserver-adapter >nul
    if %errorlevel% neq 0 (
        echo [INFO] Construyendo imágenes Docker...
        docker-compose -f docker-compose-backend.yml build >nul 2>&1
        if %errorlevel% neq 0 (
            echo [ERROR] Error construyendo imágenes Docker
            goto :error
        )
    )
    
    :: Iniciar servicios
    echo [INFO] Iniciando contenedores...
    docker-compose -f docker-compose-backend.yml up -d >nul 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] Error iniciando contenedores Docker
        goto :error
    )
    
    echo [OK] Servicios iniciados con Docker
) else (
    echo [INFO] Iniciando modo local...
    
    :: Compilar proyectos
    echo [INFO] Compilando SQL Server Adapter...
    cd sqlserver-adapter
    call gradlew.bat build -x test >nul 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] Error compilando SQL Server Adapter
        cd ..
        goto :error
    )
    cd ..
    
    echo [INFO] Compilando Regulatory Service...
    cd backend\modules\regulatory-service
    call gradlew.bat build -x test >nul 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] Error compilando Regulatory Service
        cd ..\..\..
        goto :error
    )
    cd ..\..\..
    
    :: Iniciar servicios localmente
    echo [INFO] Iniciando servicios localmente...
    if exist "start-backend-complete.bat" (
        start "SQL Server Adapter" cmd /k "cd /d %CD% && call start-sqlserver-adapter.bat"
        timeout /t 10 /nobreak >nul
        start "Regulatory Service" cmd /k "cd /d %CD% && call start-regulatory-service.bat"
        echo [OK] Servicios iniciados localmente
    ) else (
        echo [ERROR] Script de inicio no encontrado
        goto :error
    )
)

:: ========================================
:: 5. VERIFICAR INICIO
:: ========================================
echo.
echo [INFO] Esperando a que los servicios se inicien...
timeout /t 30 /nobreak >nul

echo [INFO] Verificando servicios...
call verify-services.bat

goto :end

:: ========================================
:: MANEJO DE ERRORES
:: ========================================
:error
echo.
echo [ERROR] Ocurrió un error durante la configuración
echo [INFO] Revisa los mensajes anteriores para más detalles
echo [INFO] Puedes intentar ejecutar setup-and-run.bat para configuración manual
echo.
pause
exit /b 1

:: ========================================
:: FINALIZAR
:: ========================================
:end
echo.
echo ========================================
echo AUTO START COMPLETADO
echo ========================================
echo.
echo [SUCCESS] SudBankCore Backend está listo para usar
echo.
echo URLs de acceso:
echo   - SQL Server Adapter: http://localhost:8080
echo   - Regulatory Service: http://localhost:8085
echo   - Health Check: http://localhost:8080/actuator/health
echo.
echo Para detener los servicios:
echo   - Docker: .\start-docker.bat down
echo   - Local: Cierra las ventanas de comando
echo.
pause 