# Script para probar conexión a SQL Server 2008
# Configuración para permitir TLS 1.0

Write-Host "=== PRUEBA DE CONEXIÓN A SQL SERVER 2008 ===" -ForegroundColor Green
Write-Host ""

# Configurar propiedades de Java para permitir TLS 1.0
$env:JAVA_OPTS = "-Djdk.tls.client.protocols=TLSv1,TLSv1.1,TLSv1.2 -Dhttps.protocols=TLSv1,TLSv1.1,TLSv1.2"

# Parámetros de conexión
$server = "192.168.10.7"
$port = "1433"
$database = "sudbank_core"
$username = "sa"
$password = "ssm98"

# URL de conexión sin cifrado
$connectionString = "jdbc:sqlserver://${server}:${port};databaseName=${database};encrypt=false;trustServerCertificate=false;loginTimeout=30"

Write-Host "Configuración de conexión:" -ForegroundColor Yellow
Write-Host "  Servidor: $server" -ForegroundColor White
Write-Host "  Puerto: $port" -ForegroundColor White
Write-Host "  Base de datos: $database" -ForegroundColor White
Write-Host "  Usuario: $username" -ForegroundColor White
Write-Host "  Driver: com.microsoft.sqlserver.jdbc.SQLServerDriver" -ForegroundColor White
Write-Host "  URL: $connectionString" -ForegroundColor White
Write-Host "  Java Options: $env:JAVA_OPTS" -ForegroundColor White
Write-Host ""

# Verificar si el servidor está accesible
Write-Host "Verificando conectividad de red..." -ForegroundColor Yellow
try {
    $ping = Test-NetConnection -ComputerName $server -Port $port -InformationLevel Quiet
    if ($ping) {
        Write-Host "✓ Servidor accesible en puerto $port" -ForegroundColor Green
    } else {
        Write-Host "✗ No se puede conectar al servidor en puerto $port" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "✗ Error al verificar conectividad: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== PRUEBA COMPLETADA ===" -ForegroundColor Green
Write-Host "Si la conectividad es exitosa, el problema está en la configuración SSL/TLS." -ForegroundColor Yellow
Write-Host "Para resolver, usar las siguientes propiedades de Java:" -ForegroundColor Yellow
Write-Host "  -Djdk.tls.client.protocols=TLSv1,TLSv1.1,TLSv1.2" -ForegroundColor Cyan
Write-Host "  -Dhttps.protocols=TLSv1,TLSv1.1,TLSv1.2" -ForegroundColor Cyan
Write-Host ""
Write-Host "O cambiar la URL de conexión a:" -ForegroundColor Yellow
Write-Host "  jdbc:sqlserver://${server}:${port};databaseName=${database};encrypt=false;trustServerCertificate=false;loginTimeout=30" -ForegroundColor Cyan 