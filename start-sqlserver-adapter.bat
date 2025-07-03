@echo off
echo ========================================
echo INICIANDO SQL SERVER ADAPTER (Java 8)
echo ========================================
echo.

cd /d "C:\Desarrollo\SudBankBackend\sqlserver-adapter"

echo Verificando Java 8...
"C:\Program Files\Java\jdk1.8.0_202\bin\java.exe" -version
if %errorlevel% neq 0 (
    echo ERROR: Java 8 no encontrado
    pause
    exit /b 1
)

echo.
echo Compilando SQL Server Adapter...
call gradlew.bat build -x test
if %errorlevel% neq 0 (
    echo ERROR: Fallo en la compilacion
    pause
    exit /b 1
)

echo.
echo Iniciando SQL Server Adapter en puerto 8080...
echo Presiona Ctrl+C para detener el servicio
echo.
"C:\Program Files\Java\jdk1.8.0_202\bin\java.exe" -jar build/libs/sqlserver-adapter-1.0.0.jar

pause 