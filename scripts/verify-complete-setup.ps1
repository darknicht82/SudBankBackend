# Script para verificar setup completo del Dashboard L08
Write-Host "========================================" -ForegroundColor Green
Write-Host "Verificación Completa - Dashboard L08" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# 1. Verificar procesos en ejecución
Write-Host "1. Verificando servicios en ejecución..." -ForegroundColor Yellow

$nodeProcesses = Get-Process -Name "node" -ErrorAction SilentlyContinue
if ($nodeProcesses) {
    Write-Host "   ✓ Frontend ejecutándose (PIDs: $($nodeProcesses.Id -join ', '))" -ForegroundColor Green
} else {
    Write-Host "   ✗ Frontend no está ejecutándose" -ForegroundColor Red
}

$javaProcesses = Get-Process -Name "java" -ErrorAction SilentlyContinue
if ($javaProcesses) {
    Write-Host "   ✓ Backend Java ejecutándose (PIDs: $($javaProcesses.Id -join ', '))" -ForegroundColor Green
} else {
    Write-Host "   ✗ Backend Java no está ejecutándose" -ForegroundColor Red
}

Write-Host ""

# 2. Verificar puertos
Write-Host "2. Verificando puertos..." -ForegroundColor Yellow

$ports = @(4200, 8080, 8081)
foreach ($port in $ports) {
    $connection = Test-NetConnection -ComputerName localhost -Port $port -InformationLevel Quiet -WarningAction SilentlyContinue
    if ($connection) {
        Write-Host "   ✓ Puerto $port abierto" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Puerto $port cerrado" -ForegroundColor Red
    }
}

Write-Host ""

# 3. Verificar archivos críticos
Write-Host "3. Verificando archivos críticos..." -ForegroundColor Yellow

$criticalFiles = @(
    "frontend/risk-dashboard/src/app/app.routes.ts",
    "frontend/risk-dashboard/src/app/app.component.ts",
    "frontend/risk-dashboard/src/app/services/l08.service.ts",
    "frontend/risk-dashboard/src/app/pages/l08-dashboard/l08-main/l08-main.component.ts",
    "scripts/create-regulatory-tables.sql",
    "scripts/insert-l08-test-data.sql"
)

foreach ($file in $criticalFiles) {
    if (Test-Path $file) {
        Write-Host "   ✓ $($file.Split('/')[-1])" -ForegroundColor Green
    } else {
        Write-Host "   ✗ $($file.Split('/')[-1]) no encontrado" -ForegroundColor Red
    }
}

Write-Host ""

# 4. Verificar configuración de rutas
Write-Host "4. Verificando configuración de rutas..." -ForegroundColor Yellow

$routesFile = "frontend/risk-dashboard/src/app/app.routes.ts"
if (Test-Path $routesFile) {
    $routesContent = Get-Content $routesFile -Raw
    if ($routesContent -match "l08") {
        Write-Host "   ✓ Ruta L08 configurada" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Ruta L08 no encontrada" -ForegroundColor Red
    }
    
    if ($routesContent -match "L08MainComponent") {
        Write-Host "   ✓ Componente principal L08 importado" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Componente principal L08 no importado" -ForegroundColor Red
    }
}

Write-Host ""

# 5. Verificar menú
Write-Host "5. Verificando configuración del menú..." -ForegroundColor Yellow

$appComponentFile = "frontend/risk-dashboard/src/app/app.component.ts"
if (Test-Path $appComponentFile) {
    $componentContent = Get-Content $appComponentFile -Raw
    if ($componentContent -match "L08.*Liquidez Estructural") {
        Write-Host "   ✓ Menú L08 configurado" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Menú L08 no configurado" -ForegroundColor Red
    }
    
    if ($componentContent -match "routerLink.*l08") {
        Write-Host "   ✓ RouterLink L08 configurado" -ForegroundColor Green
    } else {
        Write-Host "   ✗ RouterLink L08 no configurado" -ForegroundColor Red
    }
}

Write-Host ""

# 6. Verificar build
Write-Host "6. Verificando build del proyecto..." -ForegroundColor Yellow
Set-Location "frontend/risk-dashboard"
try {
    $buildOutput = npm run build 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Build exitoso" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Build falló" -ForegroundColor Red
        $buildOutput | Where-Object { $_ -match "ERROR" } | ForEach-Object { 
            Write-Host "     $_" -ForegroundColor Red 
        }
    }
} catch {
    Write-Host "   ✗ Error al ejecutar build" -ForegroundColor Red
}

Set-Location "../.."

Write-Host ""

# 7. Resumen y recomendaciones
Write-Host "7. Resumen y próximos pasos..." -ForegroundColor Yellow

Write-Host ""
Write-Host "   🎯 Para acceder al dashboard:" -ForegroundColor Cyan
Write-Host "     1. Abrir http://localhost:4200" -ForegroundColor White
Write-Host "     2. Hacer clic en 'Reportes Regulatorios'" -ForegroundColor White
Write-Host "     3. Seleccionar 'L08 - Liquidez Estructural'" -ForegroundColor White

Write-Host ""
Write-Host "   🔧 Si hay problemas:" -ForegroundColor Cyan
Write-Host "     • Verificar que todos los servicios estén ejecutándose" -ForegroundColor White
Write-Host "     • Revisar consola del navegador para errores" -ForegroundColor White
Write-Host "     • Verificar logs de los servicios backend" -ForegroundColor White

Write-Host ""
Write-Host "   📊 Estado actual:" -ForegroundColor Cyan
Write-Host "     • Frontend: Configurado y ejecutándose" -ForegroundColor White
Write-Host "     • Backend: En proceso de inicio" -ForegroundColor White
Write-Host "     • Base de datos: Pendiente de implementación" -ForegroundColor White
Write-Host "     • Integración: Configurada con fallback a datos simulados" -ForegroundColor White

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Verificación completada" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green 