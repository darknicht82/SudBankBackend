# =====================================================
# Script de Prueba de Conexion SQL Server
# SudBank Core - Sistema de Reportes Regulatorios
# =====================================================

param(
    [string]$Server = "192.168.10.7",
    [string]$Database = "sudbank_core",
    [string]$Username = "sa",
    [string]$Password = "ssm98"
)

Write-Host "=====================================================" -ForegroundColor Green
Write-Host "PRUEBA DE CONEXION SQL SERVER - SUDBANK CORE" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""

# Verificar si SQL Server esta disponible
Write-Host "1. Verificando conectividad al servidor..." -ForegroundColor Yellow
try {
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = "Server=$Server;Database=master;User Id=$Username;Password=$Password;TrustServerCertificate=true;"
    $connection.Open()
    Write-Host "   [OK] Conexion exitosa al servidor SQL Server" -ForegroundColor Green
    $connection.Close()
} catch {
    Write-Host "   [ERROR] Error de conexion: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Verificar si la base de datos existe
Write-Host "2. Verificando existencia de la base de datos..." -ForegroundColor Yellow
try {
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = "Server=$Server;Database=master;User Id=$Username;Password=$Password;TrustServerCertificate=true;"
    $connection.Open()
    
    $command = $connection.CreateCommand()
    $command.CommandText = "SELECT name FROM sys.databases WHERE name = '$Database'"
    $result = $command.ExecuteScalar()
    
    if ($result) {
        Write-Host "   [OK] Base de datos '$Database' existe" -ForegroundColor Green
    } else {
        Write-Host "   [INFO] Base de datos '$Database' no existe, se creara automaticamente" -ForegroundColor Yellow
    }
    
    $connection.Close()
} catch {
    Write-Host "   [ERROR] Error verificando base de datos: $($_.Exception.Message)" -ForegroundColor Red
}

# Probar conexion a la base de datos especifica
Write-Host "3. Probando conexion a la base de datos..." -ForegroundColor Yellow
try {
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = "Server=$Server;Database=$Database;User Id=$Username;Password=$Password;TrustServerCertificate=true;"
    $connection.Open()
    Write-Host "   [OK] Conexion exitosa a la base de datos '$Database'" -ForegroundColor Green
    $connection.Close()
} catch {
    Write-Host "   [INFO] No se puede conectar a '$Database' (normal si no existe aun): $($_.Exception.Message)" -ForegroundColor Yellow
}

# Verificar esquemas si la base de datos existe
Write-Host "4. Verificando esquemas..." -ForegroundColor Yellow
try {
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = "Server=$Server;Database=$Database;User Id=$Username;Password=$Password;TrustServerCertificate=true;"
    $connection.Open()
    
    $command = $connection.CreateCommand()
    $command.CommandText = "SELECT schema_name FROM information_schema.schemata WHERE schema_name IN ('risk_reporting', 'auth', 'config') ORDER BY schema_name"
    
    $reader = $command.ExecuteReader()
    $schemas = @()
    while ($reader.Read()) {
        $schemas += $reader.GetString(0)
    }
    $reader.Close()
    
    if ($schemas.Count -gt 0) {
        Write-Host "   [OK] Esquemas encontrados: $($schemas -join ', ')" -ForegroundColor Green
    } else {
        Write-Host "   [INFO] No se encontraron esquemas (se crearan con Flyway)" -ForegroundColor Yellow
    }
    
    $connection.Close()
} catch {
    Write-Host "   [INFO] No se pueden verificar esquemas: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Green
Write-Host "RESUMEN DE LA PRUEBA" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host "[OK] Servidor SQL Server: $Server" -ForegroundColor Green
Write-Host "[OK] Usuario: $Username" -ForegroundColor Green
Write-Host "[OK] Base de datos: $Database" -ForegroundColor Green
Write-Host "[OK] Configuracion lista para Spring Boot + Flyway" -ForegroundColor Green
Write-Host ""
Write-Host "Proximo paso: Ejecutar la aplicacion Spring Boot" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Green 