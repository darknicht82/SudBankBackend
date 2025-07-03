@echo off
echo ========================================
echo INICIANDO REGULATORY SERVICE (Java 17)
echo ========================================
echo.

cd /d "C:\Desarrollo\SudBankBackend\backend\modules\regulatory-service"

echo Verificando Java 17...
java -version
if %errorlevel% neq 0 (
    echo ERROR: Java 17 no encontrado
    pause
    exit /b 1
)

echo.
echo Compilando Regulatory Service...
call gradlew.bat build -x test
if %errorlevel% neq 0 (
    echo ERROR: Fallo en la compilacion
    pause
    exit /b 1
)

echo.
echo Iniciando Regulatory Service en puerto 8085...
echo Presiona Ctrl+C para detener el servicio
echo.
java -jar build/libs/regulatory-service-1.0.0.jar

pause 