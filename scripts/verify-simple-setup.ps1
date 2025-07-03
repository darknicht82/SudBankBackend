# Verificación Simple de SudBankCore - Servicios Funcionales
# ===========================================================

Write-Host "🔍 Verificando SudBankCore - Servicios Funcionales" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

# Verificar estructura de directorios
Write-Host "`n📁 Verificando estructura de directorios..." -ForegroundColor Yellow

$requiredDirs = @(
    "backend/modules/regulatory-service",
    "backend/modules/sqlserver-adapter", 
    "frontend/risk-dashboard",
    "sqlserver-adapter"
)

foreach ($dir in $requiredDirs) {
    if (Test-Path $dir) {
        Write-Host "✅ $dir" -ForegroundColor Green
    } else {
        Write-Host "❌ $dir" -ForegroundColor Red
    }
}

# Verificar archivos de configuración
Write-Host "`n📄 Verificando archivos de configuración..." -ForegroundColor Yellow

$requiredFiles = @(
    "docker-compose-simple.yml",
    "backend/modules/regulatory-service/src/main/resources/application.yml",
    "sqlserver-adapter/src/main/resources/application.yml",
    "frontend/risk-dashboard/package.json"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file" -ForegroundColor Green
    } else {
        Write-Host "❌ $file" -ForegroundColor Red
    }
}

# Verificar puertos
Write-Host "`n🔌 Verificando puertos..." -ForegroundColor Yellow

$ports = @(8080, 8085, 4200)
foreach ($port in $ports) {
    $connection = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($connection) {
        Write-Host "⚠️  Puerto $port está en uso por PID: $($connection.OwningProcess)" -ForegroundColor Yellow
    } else {
        Write-Host "✅ Puerto $port está libre" -ForegroundColor Green
    }
}

# Verificar servicios
Write-Host "`n🚀 Verificando servicios..." -ForegroundColor Yellow

$services = @{
    "SQL Server Adapter" = "http://localhost:8080/actuator/health"
    "Regulatory Service" = "http://localhost:8085/actuator/health"
    "Frontend Angular" = "http://localhost:4200"
}

foreach ($service in $services.GetEnumerator()) {
    try {
        $response = Invoke-WebRequest -Uri $service.Value -TimeoutSec 5 -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ $($service.Key) está ejecutándose" -ForegroundColor Green
        } else {
            Write-Host "⚠️  $($service.Key) responde con código: $($response.StatusCode)" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ $($service.Key) no está ejecutándose" -ForegroundColor Red
    }
}

# Instrucciones de levantamiento
Write-Host "`n📋 Instrucciones de levantamiento:" -ForegroundColor Cyan
Write-Host "1. SQL Server Adapter:" -ForegroundColor White
Write-Host "   cd sqlserver-adapter" -ForegroundColor Gray
Write-Host "   ./start-java8-optimized.bat" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Regulatory Service:" -ForegroundColor White
Write-Host "   cd backend/modules/regulatory-service" -ForegroundColor Gray
Write-Host "   ./start-java17.bat" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Frontend Angular:" -ForegroundColor White
Write-Host "   cd frontend/risk-dashboard" -ForegroundColor Gray
Write-Host "   npm install" -ForegroundColor Gray
Write-Host "   ng serve" -ForegroundColor Gray
Write-Host ""
Write-Host "O usar Docker Compose:" -ForegroundColor White
Write-Host "   docker-compose -f docker-compose-simple.yml up -d" -ForegroundColor Gray

Write-Host "`n✅ Verificación completada" -ForegroundColor Green 