# ========================================
# VERIFICACIÓN RÁPIDA DE CONFIGURACIÓN
# SudBankCore - Sistema de Reportes Regulatorios
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VERIFICACIÓN RÁPIDA DE CONFIGURACIÓN" -ForegroundColor Cyan
Write-Host "SudBankCore - Sistema de Reportes Regulatorios" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$allChecksPassed = $true

# ========================================
# 1. VERIFICAR JAVA
# ========================================
Write-Host "1. Verificando Java..." -ForegroundColor Yellow

try {
    $javaVersion = java -version 2>&1 | Select-String "version"
    if ($javaVersion -match "1\.8") {
        Write-Host "   ✅ Java 8 encontrado" -ForegroundColor Green
    } elseif ($javaVersion -match "17") {
        Write-Host "   ✅ Java 17 encontrado" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Java encontrado pero versión no verificada" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ❌ Java no encontrado" -ForegroundColor Red
    $allChecksPassed = $false
}

# ========================================
# 2. VERIFICAR NODE.JS
# ========================================
Write-Host "2. Verificando Node.js..." -ForegroundColor Yellow

try {
    $nodeVersion = node --version
    Write-Host "   ✅ Node.js encontrado: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Node.js no encontrado" -ForegroundColor Red
    $allChecksPassed = $false
}

# ========================================
# 3. VERIFICAR DOCKER
# ========================================
Write-Host "3. Verificando Docker..." -ForegroundColor Yellow

try {
    $dockerVersion = docker --version
    Write-Host "   ✅ Docker encontrado: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "   ⚠️  Docker no encontrado (se usará scripts batch)" -ForegroundColor Yellow
}

# ========================================
# 4. VERIFICAR SQL SERVER ADAPTER
# ========================================
Write-Host "4. Verificando SQL Server Adapter..." -ForegroundColor Yellow

if (Test-Path "C:\Desarrollo\sqlserver-adapter") {
    Write-Host "   ✅ SQL Server Adapter encontrado" -ForegroundColor Green
} else {
    Write-Host "   ❌ SQL Server Adapter no encontrado en C:\Desarrollo\sqlserver-adapter" -ForegroundColor Red
    $allChecksPassed = $false
}

# ========================================
# 5. VERIFICAR ESTRUCTURA DEL PROYECTO
# ========================================
Write-Host "5. Verificando estructura del proyecto..." -ForegroundColor Yellow

$requiredPaths = @(
    "backend\modules\regulatory-service",
    "frontend\risk-dashboard",
    "scripts",
    "docker-compose-complete.yml"
)

foreach ($path in $requiredPaths) {
    if (Test-Path $path) {
        Write-Host "   ✅ $path" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $path" -ForegroundColor Red
        $allChecksPassed = $false
    }
}

# ========================================
# 6. VERIFICAR CONECTIVIDAD SQL SERVER
# ========================================
Write-Host "6. Verificando conectividad SQL Server..." -ForegroundColor Yellow

try {
    $connection = Test-NetConnection -ComputerName "192.168.10.7" -Port 1433 -InformationLevel Quiet -WarningAction SilentlyContinue
    if ($connection.TcpTestSucceeded) {
        Write-Host "   ✅ SQL Server accesible en 192.168.10.7:1433" -ForegroundColor Green
    } else {
        Write-Host "   ❌ SQL Server no accesible en 192.168.10.7:1433" -ForegroundColor Red
        $allChecksPassed = $false
    }
} catch {
    Write-Host "   ❌ Error verificando conectividad SQL Server" -ForegroundColor Red
    $allChecksPassed = $false
}

# ========================================
# 7. VERIFICAR PUERTOS DISPONIBLES
# ========================================
Write-Host "7. Verificando puertos disponibles..." -ForegroundColor Yellow

$ports = @(8080, 8085, 4200)
foreach ($port in $ports) {
    $portInUse = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($portInUse) {
        Write-Host "   ⚠️  Puerto $port está en uso" -ForegroundColor Yellow
    } else {
        Write-Host "   ✅ Puerto $port disponible" -ForegroundColor Green
    }
}

# ========================================
# RESUMEN
# ========================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "RESUMEN DE VERIFICACIÓN" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if ($allChecksPassed) {
    Write-Host "✅ TODAS LAS VERIFICACIONES PASARON" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎯 PRÓXIMOS PASOS:" -ForegroundColor Yellow
    Write-Host "1. Leer GUIA_DESARROLLADOR.md" -ForegroundColor White
    Write-Host "2. Probar inicio con Docker: .\scripts\docker-start.ps1" -ForegroundColor White
    Write-Host "3. O probar con scripts batch: start-services-correct.bat" -ForegroundColor White
    Write-Host "4. Verificar en http://localhost:4200" -ForegroundColor White
} else {
    Write-Host "❌ ALGUNAS VERIFICACIONES FALLARON" -ForegroundColor Red
    Write-Host ""
    Write-Host "🔧 ACCIONES REQUERIDAS:" -ForegroundColor Yellow
    Write-Host "1. Instalar dependencias faltantes" -ForegroundColor White
    Write-Host "2. Verificar configuración de red" -ForegroundColor White
    Write-Host "3. Revisar GUIA_DESARROLLADOR.md para detalles" -ForegroundColor White
}

Write-Host ""
Write-Host "📚 DOCUMENTACIÓN DISPONIBLE:" -ForegroundColor Cyan
Write-Host "- GUIA_DESARROLLADOR.md (Guía completa)" -ForegroundColor White
Write-Host "- OPCIONES_INICIO_SISTEMA.md (Opciones de inicio)" -ForegroundColor White
Write-Host "- README.md (Información general)" -ForegroundColor White
Write-Host ""

Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 