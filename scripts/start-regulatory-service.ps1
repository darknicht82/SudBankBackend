# Script para arrancar el regulatory-service con configuración TLS 1.0 para SQL Server 2008

Write-Host "=== ARRANCANDO REGULATORY SERVICE ===" -ForegroundColor Green
Write-Host ""

# Configurar propiedades de Java para permitir TLS 1.0
$env:JAVA_OPTS = "-Djdk.tls.client.protocols=TLSv1,TLSv1.1,TLSv1.2 -Dhttps.protocols=TLSv1,TLSv1.1,TLSv1.2"

Write-Host "Configuración Java:" -ForegroundColor Yellow
Write-Host "  JAVA_OPTS: $env:JAVA_OPTS" -ForegroundColor White
Write-Host ""

# Verificar que estamos en el directorio correcto
if (-not (Test-Path "build.gradle")) {
    Write-Host "✗ Error: No se encontró build.gradle. Ejecutar desde el directorio raíz del proyecto." -ForegroundColor Red
    exit 1
}

Write-Host "Arrancando regulatory-service..." -ForegroundColor Yellow
Write-Host ""

# Arrancar el servicio con las propiedades de Java configuradas
try {
    ./gradlew :regulatory-service:bootRun
} catch {
    Write-Host "✗ Error al arrancar el servicio: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
} 