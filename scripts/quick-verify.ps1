# Script rápido de verificación del sistema
Write-Host "========================================" -ForegroundColor Green
Write-Host "Verificación Rápida - Dashboard L08" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# 1. Verificar procesos
Write-Host "1. Procesos en ejecución:" -ForegroundColor Yellow
$nodeProcesses = Get-Process -Name "node" -ErrorAction SilentlyContinue
if ($nodeProcesses) {
    Write-Host "   ✓ Frontend (Node.js): $($nodeProcesses.Count) procesos" -ForegroundColor Green
} else {
    Write-Host "   ✗ Frontend no está ejecutándose" -ForegroundColor Red
}

$javaProcesses = Get-Process -Name "java" -ErrorAction SilentlyContinue
if ($javaProcesses) {
    Write-Host "   ✓ Backend (Java): $($javaProcesses.Count) procesos" -ForegroundColor Green
} else {
    Write-Host "   ✗ Backend no está ejecutándose" -ForegroundColor Red
}

Write-Host ""

# 2. Verificar puertos
Write-Host "2. Puertos abiertos:" -ForegroundColor Yellow
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
Write-Host "3. Archivos críticos:" -ForegroundColor Yellow
$criticalFiles = @(
    "frontend/risk-dashboard/src/app/app.routes.ts",
    "frontend/risk-dashboard/src/app/app.component.ts",
    "frontend/risk-dashboard/src/app/pages/l08-dashboard/l08-main/l08-main.component.ts"
)

foreach ($file in $criticalFiles) {
    if (Test-Path $file) {
        Write-Host "   ✓ $($file.Split('/')[-1])" -ForegroundColor Green
    } else {
        Write-Host "   ✗ $($file.Split('/')[-1]) no encontrado" -ForegroundColor Red
    }
}

Write-Host ""

# 4. Verificar configuración L08
Write-Host "4. Configuración L08:" -ForegroundColor Yellow
$routesFile = "frontend/risk-dashboard/src/app/app.routes.ts"
if (Test-Path $routesFile) {
    $routesContent = Get-Content $routesFile -Raw
    if ($routesContent -match "l08.*component") {
        Write-Host "   ✓ Rutas L08 configuradas" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Rutas L08 no encontradas" -ForegroundColor Red
    }
}

$appComponentFile = "frontend/risk-dashboard/src/app/app.component.ts"
if (Test-Path $appComponentFile) {
    $componentContent = Get-Content $appComponentFile -Raw
    if ($componentContent -match "L08.*Liquidez Estructural") {
        Write-Host "   ✓ Menú L08 configurado" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Menú L08 no configurado" -ForegroundColor Red
    }
}

Write-Host ""

# 5. Instrucciones
Write-Host "5. Instrucciones de acceso:" -ForegroundColor Yellow
Write-Host "   • Abrir navegador: http://localhost:4200" -ForegroundColor Cyan
Write-Host "   • Navegar a: Reportes Regulatorios > L08" -ForegroundColor Cyan
Write-Host "   • O ir directamente a: http://localhost:4200/l08" -ForegroundColor Cyan

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Verificación completada" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green 