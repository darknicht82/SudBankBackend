# Script de verificación completa del sistema SudBankCore Docker
Write-Host "==========================================" -ForegroundColor Green
Write-Host "Verificación Completa del Sistema Docker" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

# Verificar Docker
Write-Host "1. Verificando Docker..." -ForegroundColor Yellow
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker no está instalado" -ForegroundColor Red
    exit 1
} else {
    Write-Host "✅ Docker instalado: $(docker --version)" -ForegroundColor Green
}

# Verificar Docker Compose
Write-Host "2. Verificando Docker Compose..." -ForegroundColor Yellow
if (-not (Get-Command docker-compose -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker Compose no está instalado" -ForegroundColor Red
    exit 1
} else {
    Write-Host "✅ Docker Compose instalado: $(docker-compose --version)" -ForegroundColor Green
}

# Verificar estado de contenedores
Write-Host "3. Verificando estado de contenedores..." -ForegroundColor Yellow
$containers = docker-compose -f docker-compose-complete.yml ps --format json | ConvertFrom-Json
if ($containers) {
    foreach ($container in $containers) {
        $status = if ($container.State -eq "running") { "✅" } else { "❌" }
        Write-Host "$status $($container.Service): $($container.State)" -ForegroundColor $(if ($container.State -eq "running") { "Green" } else { "Red" })
    }
} else {
    Write-Host "❌ No hay contenedores corriendo" -ForegroundColor Red
}

# Verificar conectividad de servicios
Write-Host "4. Verificando conectividad de servicios..." -ForegroundColor Yellow

# SQL Server Adapter
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/actuator/health" -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ SQL Server Adapter (8080): Funcionando" -ForegroundColor Green
    } else {
        Write-Host "❌ SQL Server Adapter (8080): Error $($response.StatusCode)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ SQL Server Adapter (8080): No responde" -ForegroundColor Red
}

# Regulatory Service
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8085/actuator/health" -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Regulatory Service (8085): Funcionando" -ForegroundColor Green
    } else {
        Write-Host "❌ Regulatory Service (8085): Error $($response.StatusCode)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Regulatory Service (8085): No responde" -ForegroundColor Red
}

# Frontend
try {
    $response = Invoke-WebRequest -Uri "http://localhost:4200" -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Frontend (4200): Funcionando" -ForegroundColor Green
    } else {
        Write-Host "❌ Frontend (4200): Error $($response.StatusCode)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Frontend (4200): No responde" -ForegroundColor Red
}

# Verificar endpoints específicos
Write-Host "5. Verificando endpoints específicos..." -ForegroundColor Yellow

# Endpoint de health del SQL Server Adapter
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/regulatory/health" -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ /api/regulatory/health: Accesible" -ForegroundColor Green
    } else {
        Write-Host "❌ /api/regulatory/health: Error $($response.StatusCode)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ /api/regulatory/health: No accesible" -ForegroundColor Red
}

# Endpoint de test del Regulatory Service
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8085/api/l08/test" -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ /api/l08/test: Funcionando" -ForegroundColor Green
    } else {
        Write-Host "❌ /api/l08/test: Error $($response.StatusCode)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ /api/l08/test: No responde" -ForegroundColor Red
}

# Verificar uso de recursos
Write-Host "6. Verificando uso de recursos..." -ForegroundColor Yellow
$stats = docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"
Write-Host $stats -ForegroundColor Cyan

Write-Host "==========================================" -ForegroundColor Green
Write-Host "Verificación completada" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

Write-Host "Para ver logs en tiempo real: .\scripts\docker-logs.ps1" -ForegroundColor Gray
Write-Host "Para detener servicios: .\scripts\docker-stop.ps1" -ForegroundColor Gray 