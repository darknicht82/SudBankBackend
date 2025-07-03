@echo off
echo ========================================
echo LIMPIEZA PARA GITHUB - SUDBANKCORE
echo ========================================
echo.

echo Limpiando archivos compilados...
if exist "sqlserver-adapter\build" (
    rmdir /s /q "sqlserver-adapter\build"
    echo ✅ Eliminado: sqlserver-adapter\build
)

if exist "backend\modules\regulatory-service\build" (
    rmdir /s /q "backend\modules\regulatory-service\build"
    echo ✅ Eliminado: backend\modules\regulatory-service\build
)

echo.
echo Limpiando cache de Gradle...
if exist "sqlserver-adapter\.gradle" (
    rmdir /s /q "sqlserver-adapter\.gradle"
    echo ✅ Eliminado: sqlserver-adapter\.gradle
)

if exist "backend\modules\regulatory-service\.gradle" (
    rmdir /s /q "backend\modules\regulatory-service\.gradle"
    echo ✅ Eliminado: backend\modules\regulatory-service\.gradle
)

echo.
echo Limpiando logs y reportes...
if exist "logs" (
    rmdir /s /q "logs"
    echo ✅ Eliminado: logs
)

if exist "reports" (
    rmdir /s /q "reports"
    echo ✅ Eliminado: reports
)

echo.
echo Limpiando archivos de IDE...
if exist ".idea" (
    rmdir /s /q ".idea"
    echo ✅ Eliminado: .idea
)

if exist ".vscode" (
    rmdir /s /q ".vscode"
    echo ✅ Eliminado: .vscode
)

if exist "*.iws" (
    del /q *.iws
    echo ✅ Eliminado: archivos .iws
)

if exist "*.iml" (
    del /q *.iml
    echo ✅ Eliminado: archivos .iml
)

echo.
echo Limpiando archivos temporales...
if exist "*.tmp" (
    del /q *.tmp
    echo ✅ Eliminado: archivos .tmp
)

if exist "*.temp" (
    del /q *.temp
    echo ✅ Eliminado: archivos .temp
)

echo.
echo Verificando archivos sensibles...
if exist ".env" (
    echo ⚠️  ADVERTENCIA: Archivo .env encontrado
    echo    Este archivo contiene datos sensibles y NO debe subirse a GitHub
    echo    Asegúrate de que esté en .gitignore
    pause
)

echo.
echo Verificando estructura esencial...
echo.
echo Archivos esenciales que deben estar presentes:
if exist "README.md" (
    echo ✅ README.md
) else (
    echo ❌ README.md - FALTANTE
)

if exist "REQUIREMENTS.md" (
    echo ✅ REQUIREMENTS.md
) else (
    echo ❌ REQUIREMENTS.md - FALTANTE
)

if exist ".gitignore" (
    echo ✅ .gitignore
) else (
    echo ❌ .gitignore - FALTANTE
)

if exist "sqlserver-adapter\src" (
    echo ✅ sqlserver-adapter\src
) else (
    echo ❌ sqlserver-adapter\src - FALTANTE
)

if exist "backend\modules\regulatory-service\src" (
    echo ✅ backend\modules\regulatory-service\src
) else (
    echo ❌ backend\modules\regulatory-service\src - FALTANTE
)

if exist "docker-compose-backend.yml" (
    echo ✅ docker-compose-backend.yml
) else (
    echo ❌ docker-compose-backend.yml - FALTANTE
)

echo.
echo ========================================
echo LIMPIEZA COMPLETADA
echo ========================================
echo.
echo El proyecto está listo para subir a GitHub.
echo.
echo Comandos recomendados:
echo   git add .
echo   git commit -m "Clean project for GitHub"
echo   git push origin main
echo.
echo Presiona cualquier tecla para continuar...
pause >nul 