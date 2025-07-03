@echo off
setlocal enabledelayedexpansion

echo ========================================
echo SETUP INTELIGENTE - SUDBANKCORE BACKEND
echo ========================================
echo.

:: Variables globales
set "PROJECT_ROOT=%~dp0"
set "MISSING_DEPS="
set "MISSING_CONFIG="

echo [INFO] Analizando estructura del proyecto...
echo.

:: ========================================
:: 1. VERIFICAR ESTRUCTURA DEL PROYECTO
:: ========================================
echo [1/5] Verificando estructura del proyecto...

if not exist "sqlserver-adapter\src" (
    echo [ERROR] sqlserver-adapter\src - FALTANTE
    set "MISSING_DEPS=1"
) else (
    echo [OK] sqlserver-adapter\src
)

if not exist "backend\modules\regulatory-service\src" (
    echo [ERROR] backend\modules\regulatory-service\src - FALTANTE
    set "MISSING_DEPS=1"
) else (
    echo [OK] backend\modules\regulatory-service\src
)

if not exist "docker-compose-backend.yml" (
    echo [ERROR] docker-compose-backend.yml - FALTANTE
    set "MISSING_DEPS=1"
) else (
    echo [OK] docker-compose-backend.yml
)

:: ========================================
:: 2. VERIFICAR PRERREQUISITOS DEL SISTEMA
:: ========================================
echo.
echo [2/5] Verificando prerrequisitos del sistema...

:: Verificar Java 8
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Java 8 - NO INSTALADO
    echo [INFO] Descarga: https://adoptium.net/temurin/releases/?version=8
    set "MISSING_DEPS=1"
) else (
    for /f "tokens=3" %%i in ('java -version 2^>^&1 ^| findstr /i "version"') do (
        set "JAVA_VERSION=%%i"
        set "JAVA_VERSION=!JAVA_VERSION:"=!"
    )
    echo [OK] Java !JAVA_VERSION!
)

:: Verificar Java 17
java17 -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Java 17 - NO INSTALADO
    echo [INFO] Descarga: https://adoptium.net/temurin/releases/?version=17
    set "MISSING_DEPS=1"
) else (
    for /f "tokens=3" %%i in ('java17 -version 2^>^&1 ^| findstr /i "version"') do (
        set "JAVA17_VERSION=%%i"
        set "JAVA17_VERSION=!JAVA17_VERSION:"=!"
    )
    echo [OK] Java 17 !JAVA17_VERSION!
)

:: Verificar Docker
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker - NO INSTALADO
    echo [INFO] Descarga: https://www.docker.com/products/docker-desktop
    set "MISSING_DEPS=1"
) else (
    for /f "tokens=3" %%i in ('docker --version') do (
        set "DOCKER_VERSION=%%i"
    )
    echo [OK] Docker !DOCKER_VERSION!
)

:: Verificar Git
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Git - NO INSTALADO
    echo [INFO] Descarga: https://git-scm.com/downloads
    set "MISSING_DEPS=1"
) else (
    for /f "tokens=3" %%i in ('git --version') do (
        set "GIT_VERSION=%%i"
    )
    echo [OK] Git !GIT_VERSION!
)

:: ========================================
:: 3. VERIFICAR CONFIGURACIÓN
:: ========================================
echo.
echo [3/5] Verificando configuración...

if not exist ".env" (
    echo [ERROR] Archivo .env - FALTANTE
    set "MISSING_CONFIG=1"
) else (
    echo [OK] Archivo .env
)

if not exist "env.template" (
    echo [ERROR] env.template - FALTANTE
    set "MISSING_CONFIG=1"
) else (
    echo [OK] env.template
)

:: ========================================
:: 4. VERIFICAR DEPENDENCIAS GRADLE
:: ========================================
echo.
echo [4/5] Verificando dependencias Gradle...

if not exist "sqlserver-adapter\gradle\wrapper\gradle-wrapper.jar" (
    echo [ERROR] Gradle wrapper SQL Server Adapter - FALTANTE
    set "MISSING_DEPS=1"
) else (
    echo [OK] Gradle wrapper SQL Server Adapter
)

if not exist "backend\modules\regulatory-service\gradle\wrapper\gradle-wrapper.jar" (
    echo [ERROR] Gradle wrapper Regulatory Service - FALTANTE
    set "MISSING_DEPS=1"
) else (
    echo [OK] Gradle wrapper Regulatory Service
)

:: ========================================
:: 5. VERIFICAR PUERTOS
:: ========================================
echo.
echo [5/5] Verificando puertos disponibles...

netstat -ano | findstr :8080 >nul
if %errorlevel% equ 0 (
    echo [ERROR] Puerto 8080 - OCUPADO
    set "MISSING_DEPS=1"
) else (
    echo [OK] Puerto 8080 - DISPONIBLE
)

netstat -ano | findstr :8085 >nul
if %errorlevel% equ 0 (
    echo [ERROR] Puerto 8085 - OCUPADO
    set "MISSING_DEPS=1"
) else (
    echo [OK] Puerto 8085 - DISPONIBLE
)

:: ========================================
:: 6. MENÚ DE ACCIONES
:: ========================================
echo.
echo ========================================
echo RESULTADO DEL ANÁLISIS
echo ========================================

if defined MISSING_DEPS (
    echo [ERROR] Se encontraron problemas que requieren atención
    echo.
    echo Problemas detectados:
    echo   - Dependencias faltantes
    echo   - Prerrequisitos no instalados
    echo   - Puertos ocupados
    echo.
) else if defined MISSING_CONFIG (
    echo [WARNING] Configuración incompleta
    echo.
    echo Problemas detectados:
    echo   - Archivo .env faltante
    echo.
) else (
    echo [SUCCESS] Todo está listo para ejecutar
    echo.
)

echo Opciones disponibles:
echo.
echo 1. Configurar automáticamente (recomendado)
echo 2. Crear archivo .env desde template
echo 3. Descargar dependencias faltantes
echo 4. Iniciar servicios (Docker)
echo 5. Iniciar servicios (Local)
echo 6. Verificar servicios
echo 7. Limpiar archivos temporales
echo 8. Salir
echo.

set /p choice="Selecciona una opción (1-8): "

if "%choice%"=="1" goto :auto_setup
if "%choice%"=="2" goto :create_env
if "%choice%"=="3" goto :download_deps
if "%choice%"=="4" goto :start_docker
if "%choice%"=="5" goto :start_local
if "%choice%"=="6" goto :verify_services
if "%choice%"=="7" goto :clean_temp
if "%choice%"=="8" goto :end

echo Opción inválida
goto :end

:: ========================================
:: CONFIGURACIÓN AUTOMÁTICA
:: ========================================
:auto_setup
echo.
echo [INFO] Configuración automática iniciada...
echo.

:: Crear .env si no existe
if not exist ".env" (
    echo [INFO] Creando archivo .env...
    copy env.template .env >nul
    echo [OK] Archivo .env creado
)

:: Descargar dependencias Gradle
echo [INFO] Descargando dependencias Gradle...
cd sqlserver-adapter
call gradlew.bat --refresh-dependencies >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Dependencias SQL Server Adapter descargadas
) else (
    echo [ERROR] Error descargando dependencias SQL Server Adapter
)
cd ..

cd backend\modules\regulatory-service
call gradlew.bat --refresh-dependencies >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Dependencias Regulatory Service descargadas
) else (
    echo [ERROR] Error descargando dependencias Regulatory Service
)
cd ..\..\..

:: Construir proyectos
echo [INFO] Construyendo proyectos...
cd sqlserver-adapter
call gradlew.bat build -x test >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] SQL Server Adapter compilado
) else (
    echo [ERROR] Error compilando SQL Server Adapter
)
cd ..

cd backend\modules\regulatory-service
call gradlew.bat build -x test >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Regulatory Service compilado
) else (
    echo [ERROR] Error compilando Regulatory Service
)
cd ..\..\..

:: Construir Docker si está disponible
docker --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [INFO] Construyendo imágenes Docker...
    docker-compose -f docker-compose-backend.yml build >nul 2>&1
    if %errorlevel% equ 0 (
        echo [OK] Imágenes Docker construidas
    ) else (
        echo [ERROR] Error construyendo imágenes Docker
    )
)

echo.
echo [SUCCESS] Configuración automática completada
echo.
echo ¿Deseas iniciar los servicios ahora?
set /p start_choice="(s/n): "
if /i "%start_choice%"=="s" goto :start_docker
goto :end

:: ========================================
:: CREAR ARCHIVO .ENV
:: ========================================
:create_env
echo.
echo [INFO] Creando archivo .env desde template...
if exist "env.template" (
    copy env.template .env >nul
    echo [OK] Archivo .env creado
    echo [INFO] Edita el archivo .env con tu configuración
    echo [INFO] Luego ejecuta la opción 1 para configuración automática
) else (
    echo [ERROR] Template env.template no encontrado
)
goto :end

:: ========================================
:: DESCARGAR DEPENDENCIAS
:: ========================================
:download_deps
echo.
echo [INFO] Descargando dependencias...
echo.

cd sqlserver-adapter
echo [INFO] SQL Server Adapter...
call gradlew.bat --refresh-dependencies
cd ..

cd backend\modules\regulatory-service
echo [INFO] Regulatory Service...
call gradlew.bat --refresh-dependencies
cd ..\..\..

echo.
echo [OK] Dependencias descargadas
goto :end

:: ========================================
:: INICIAR DOCKER
:: ========================================
:start_docker
echo.
echo [INFO] Iniciando servicios con Docker...
if exist "start-docker.bat" (
    call start-docker.bat up
) else (
    echo [ERROR] Script start-docker.bat no encontrado
)
goto :end

:: ========================================
:: INICIAR LOCAL
:: ========================================
:start_local
echo.
echo [INFO] Iniciando servicios localmente...
if exist "start-backend-complete.bat" (
    call start-backend-complete.bat
) else (
    echo [ERROR] Script start-backend-complete.bat no encontrado
)
goto :end

:: ========================================
:: VERIFICAR SERVICIOS
:: ========================================
:verify_services
echo.
echo [INFO] Verificando servicios...
if exist "verify-services.bat" (
    call verify-services.bat
) else (
    echo [ERROR] Script verify-services.bat no encontrado
)
goto :end

:: ========================================
:: LIMPIAR TEMPORALES
:: ========================================
:clean_temp
echo.
echo [INFO] Limpiando archivos temporales...
if exist "clean-for-github.bat" (
    call clean-for-github.bat
) else (
    echo [ERROR] Script clean-for-github.bat no encontrado
)
goto :end

:: ========================================
:: FINALIZAR
:: ========================================
:end
echo.
echo ========================================
echo SETUP COMPLETADO
echo ========================================
echo.
echo Para más información:
echo   - README.md - Documentación principal
echo   - REQUIREMENTS.md - Prerrequisitos detallados
echo   - GITHUB_STRUCTURE.md - Estructura del proyecto
echo.
echo ¡Gracias por usar SudBankCore Backend!
echo.
pause 