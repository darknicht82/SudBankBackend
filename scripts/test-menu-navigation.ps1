# Script para verificar navegación del menú L08
Write-Host "========================================" -ForegroundColor Green
Write-Host "Diagnóstico de Navegación - Dashboard L08" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Verificar que el frontend esté ejecutándose
Write-Host "1. Verificando estado del frontend..." -ForegroundColor Yellow
$frontendProcess = Get-Process -Name "node" -ErrorAction SilentlyContinue
if ($frontendProcess) {
    Write-Host "   ✓ Frontend ejecutándose (PID: $($frontendProcess.Id))" -ForegroundColor Green
} else {
    Write-Host "   ✗ Frontend no está ejecutándose" -ForegroundColor Red
    Write-Host "   Ejecute: cd frontend/risk-dashboard; npm start" -ForegroundColor Cyan
}

Write-Host ""

# Verificar archivos de configuración
Write-Host "2. Verificando archivos de configuración..." -ForegroundColor Yellow

$routesFile = "frontend/risk-dashboard/src/app/app.routes.ts"
if (Test-Path $routesFile) {
    Write-Host "   ✓ Archivo de rutas encontrado" -ForegroundColor Green
    
    # Verificar contenido del archivo de rutas
    $routesContent = Get-Content $routesFile -Raw
    if ($routesContent -match "l08") {
        Write-Host "   ✓ Ruta L08 configurada" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Ruta L08 no encontrada en app.routes.ts" -ForegroundColor Red
    }
} else {
    Write-Host "   ✗ Archivo de rutas no encontrado" -ForegroundColor Red
}

$appComponentFile = "frontend/risk-dashboard/src/app/app.component.ts"
if (Test-Path $appComponentFile) {
    Write-Host "   ✓ Componente principal encontrado" -ForegroundColor Green
    
    # Verificar menú en el componente
    $componentContent = Get-Content $appComponentFile -Raw
    if ($componentContent -match "L08.*Liquidez Estructural") {
        Write-Host "   ✓ Menú L08 configurado en componente" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Menú L08 no encontrado en componente" -ForegroundColor Red
    }
} else {
    Write-Host "   ✗ Componente principal no encontrado" -ForegroundColor Red
}

Write-Host ""

# Verificar componentes L08
Write-Host "3. Verificando componentes L08..." -ForegroundColor Yellow

$l08Components = @(
    "frontend/risk-dashboard/src/app/pages/l08-dashboard/l08-main/l08-main.component.ts",
    "frontend/risk-dashboard/src/app/pages/l08-dashboard/l08-historico/l08-historico.component.ts",
    "frontend/risk-dashboard/src/app/pages/l08-dashboard/l08-comparar/l08-comparar.component.ts",
    "frontend/risk-dashboard/src/app/pages/l08-dashboard/l08-auditoria/l08-auditoria.component.ts"
)

foreach ($component in $l08Components) {
    if (Test-Path $component) {
        Write-Host "   ✓ $($component.Split('/')[-1])" -ForegroundColor Green
    } else {
        Write-Host "   ✗ $($component.Split('/')[-1]) no encontrado" -ForegroundColor Red
    }
}

Write-Host ""

# Verificar build del proyecto
Write-Host "4. Verificando build del proyecto..." -ForegroundColor Yellow
Set-Location "frontend/risk-dashboard"
try {
    $buildOutput = npm run build 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Build exitoso" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Build falló" -ForegroundColor Red
        Write-Host "   Errores:" -ForegroundColor Red
        $buildOutput | Where-Object { $_ -match "ERROR" } | ForEach-Object { Write-Host "     $_" -ForegroundColor Red }
    }
} catch {
    Write-Host "   ✗ Error al ejecutar build" -ForegroundColor Red
}

Set-Location "../.."

Write-Host ""

# Recomendaciones
Write-Host "5. Recomendaciones..." -ForegroundColor Yellow

Write-Host "   • Si el menú no aparece:" -ForegroundColor Cyan
Write-Host "     - Verificar que PrimeNG esté instalado" -ForegroundColor White
Write-Host "     - Revisar imports en app.component.ts" -ForegroundColor White
Write-Host "     - Verificar CSS del menú" -ForegroundColor White

Write-Host "   • Si la navegación no funciona:" -ForegroundColor Cyan
Write-Host "     - Verificar configuración de rutas" -ForegroundColor White
Write-Host "     - Revisar imports de componentes" -ForegroundColor White
Write-Host "     - Verificar que el servidor esté ejecutándose" -ForegroundColor White

Write-Host "   • Para probar manualmente:" -ForegroundColor Cyan
Write-Host "     - Abrir http://localhost:4200" -ForegroundColor White
Write-Host "     - Hacer clic en 'Reportes Regulatorios' > 'L08'" -ForegroundColor White
Write-Host "     - Verificar en la consola del navegador" -ForegroundColor White

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Diagnóstico completado" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green 