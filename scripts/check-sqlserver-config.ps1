# Script para verificar y configurar SQL Server 2008
param(
    [string]$Server = "192.168.10.7",
    [string]$Port = "1433",
    [string]$Username = "sa",
    [string]$Password = "ssm98",
    [string]$Database = "SudBank"
)

Write-Host "=== Verificación de SQL Server 2008 ===" -ForegroundColor Green
Write-Host "Servidor: $Server`:$Port" -ForegroundColor Yellow
Write-Host "Usuario: $Username" -ForegroundColor Yellow
Write-Host "Base de datos: $Database" -ForegroundColor Yellow
Write-Host ""

# Verificar si SQL Server está ejecutándose
Write-Host "1. Verificando si SQL Server está ejecutándose..." -ForegroundColor Cyan
try {
    $connectionString = "Server=$Server`:$Port;Database=master;User Id=$Username;Password=$Password;TrustServerCertificate=true;Encrypt=false;"
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $connection.Open()
    Write-Host "✅ Conexión exitosa a SQL Server" -ForegroundColor Green
    
    # Verificar versión
    $command = $connection.CreateCommand()
    $command.CommandText = "SELECT @@VERSION"
    $version = $command.ExecuteScalar()
    Write-Host "✅ Versión de SQL Server: $version" -ForegroundColor Green
    
    # Verificar si la base de datos existe
    Write-Host "2. Verificando si la base de datos '$Database' existe..." -ForegroundColor Cyan
    $command.CommandText = "SELECT name FROM sys.databases WHERE name = '$Database'"
    $result = $command.ExecuteScalar()
    
    if ($result) {
        Write-Host "✅ La base de datos '$Database' ya existe" -ForegroundColor Green
    } else {
        Write-Host "❌ La base de datos '$Database' no existe" -ForegroundColor Red
        Write-Host "3. Creando la base de datos '$Database'..." -ForegroundColor Cyan
        
        $command.CommandText = "CREATE DATABASE [$Database]"
        $command.ExecuteNonQuery()
        Write-Host "✅ Base de datos '$Database' creada exitosamente" -ForegroundColor Green
    }
    
    # Verificar permisos del usuario
    Write-Host "4. Verificando permisos del usuario '$Username'..." -ForegroundColor Cyan
    $command.CommandText = "SELECT IS_SRVROLEMEMBER('sysadmin') as IsSysAdmin"
    $isAdmin = $command.ExecuteScalar()
    
    if ($isAdmin -eq 1) {
        Write-Host "✅ El usuario '$Username' tiene permisos de administrador" -ForegroundColor Green
    } else {
        Write-Host "⚠️ El usuario '$Username' NO tiene permisos de administrador" -ForegroundColor Yellow
    }
    
    $connection.Close()
    
} catch {
    Write-Host "❌ Error conectando a SQL Server: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Verifica:" -ForegroundColor Yellow
    Write-Host "  - SQL Server está ejecutándose en $Server`:$Port" -ForegroundColor Yellow
    Write-Host "  - Las credenciales son correctas" -ForegroundColor Yellow
    Write-Host "  - El firewall permite conexiones" -ForegroundColor Yellow
    Write-Host "  - SQL Server permite autenticación SQL Server" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Fin de verificación ===" -ForegroundColor Green 