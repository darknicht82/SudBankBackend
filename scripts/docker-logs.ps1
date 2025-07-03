# ========================================
# GESTIÓN DE LOGS DOCKER - BACKEND SUDBANKCORE
# ========================================

param(
    [string]$Service = "all",
    [switch]$Follow,
    [int]$Lines = 100
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GESTIÓN DE LOGS DOCKER" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ========================================
# FUNCIONES AUXILIARES
# ========================================
function Show-LogOptions {
    Write-Host "Opciones disponibles:" -ForegroundColor Yellow
    Write-Host "   • all          - Todos los servicios" -ForegroundColor White
    Write-Host "   • sqlserver-adapter - Solo SQL Server Adapter" -ForegroundColor White
    Write-Host "   • regulatory-service - Solo Regulatory Service" -ForegroundColor White
    Write-Host ""
    Write-Host "Parámetros:" -ForegroundColor Yellow
    Write-Host "   • -Follow      - Seguir logs en tiempo real" -ForegroundColor White
    Write-Host "   • -Lines N     - Mostrar últimas N líneas (default: 100)" -ForegroundColor White
    Write-Host ""
    Write-Host "Ejemplos:" -ForegroundColor Yellow
    Write-Host "   .\docker-logs.ps1" -ForegroundColor White
    Write-Host "   .\docker-logs.ps1 -Service regulatory-service -Follow" -ForegroundColor White
    Write-Host "   .\docker-logs.ps1 -Service sqlserver-adapter -Lines 50" -ForegroundColor White
}

# ========================================
# VERIFICAR DOCKER
# ========================================
try {
    $dockerVersion = docker --version
    Write-Host "✅ Docker disponible: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker no está disponible" -ForegroundColor Red
    Write-Host "💡 Instala Docker Desktop y vuelve a intentar" -ForegroundColor Yellow
    exit 1
}

# ========================================
# VERIFICAR CONTENEDORES ACTIVOS
# ========================================
Write-Host "Verificando contenedores activos..." -ForegroundColor Yellow

$activeContainers = docker ps --format "{{.Names}}" --filter "name=sudbankcore" 2>$null
if (-not $activeContainers) {
    Write-Host "❌ No hay contenedores SudBankCore activos" -ForegroundColor Red
    Write-Host "💡 Inicia los servicios primero con: .\scripts\backend-start.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Contenedores activos:" -ForegroundColor Green
$activeContainers | ForEach-Object {
    Write-Host "   • $_" -ForegroundColor White
}

Write-Host ""

# ========================================
# PROCESAR PARÁMETROS
# ========================================
$composeFile = "docker-compose-backend.yml"

# Verificar si existe el archivo de compose
if (-not (Test-Path $composeFile)) {
    Write-Host "❌ No se encontró $composeFile" -ForegroundColor Red
    Write-Host "💡 Verifica que estés en el directorio correcto" -ForegroundColor Yellow
    exit 1
}

# ========================================
# MOSTRAR LOGS
# ========================================
Write-Host "Mostrando logs..." -ForegroundColor Yellow

$logParams = @("--tail", $Lines.ToString())

if ($Follow) {
    $logParams += "-f"
}

switch ($Service.ToLower()) {
    "all" {
        Write-Host "📋 Mostrando logs de todos los servicios..." -ForegroundColor Cyan
        docker-compose -f $composeFile logs $logParams
    }
    "sqlserver-adapter" {
        Write-Host "📋 Mostrando logs de SQL Server Adapter..." -ForegroundColor Cyan
        docker-compose -f $composeFile logs $logParams sqlserver-adapter
    }
    "regulatory-service" {
        Write-Host "📋 Mostrando logs de Regulatory Service..." -ForegroundColor Cyan
        docker-compose -f $composeFile logs $logParams regulatory-service
    }
    default {
        Write-Host "❌ Servicio '$Service' no reconocido" -ForegroundColor Red
        Show-LogOptions
        exit 1
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "FIN DE LOGS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ========================================
# COMANDOS ADICIONALES ÚTILES
# ========================================
Write-Host "🔧 Comandos adicionales útiles:" -ForegroundColor Yellow
Write-Host "   • Ver logs de un contenedor específico:" -ForegroundColor White
Write-Host "     docker logs sudbankcore-sqlserver-adapter" -ForegroundColor Gray
Write-Host "     docker logs sudbankcore-regulatory-service" -ForegroundColor Gray
Write-Host ""
Write-Host "   • Ver logs con timestamps:" -ForegroundColor White
Write-Host "     docker-compose -f $composeFile logs -t" -ForegroundColor Gray
Write-Host ""
Write-Host "   • Ver logs desde una fecha:" -ForegroundColor White
Write-Host "     docker-compose -f $composeFile logs --since='2025-01-15T10:00:00'" -ForegroundColor Gray
Write-Host ""
Write-Host "   • Exportar logs a archivo:" -ForegroundColor White
Write-Host "     docker-compose -f $composeFile logs > logs.txt" -ForegroundColor Gray
Write-Host ""

if (-not $Follow) {
    Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
} 