# ========================================
# INICIO DE SERVICIOS BACKEND SUDBANKCORE
# Solo SQL Server Adapter + Regulatory Service
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "INICIANDO SERVICIOS BACKEND SUDBANKCORE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ========================================
# 1. DETENER CONTENEDORES EXISTENTES
# ========================================
Write-Host "1. Deteniendo contenedores existentes..." -ForegroundColor Yellow
docker-compose -f docker-compose-backend.yml down 2>$null
Write-Host "   ✅ Contenedores detenidos" -ForegroundColor Green

# ========================================
# 2. CONSTRUIR IMÁGENES DOCKER
# ========================================
Write-Host "2. Construyendo imágenes Docker..." -ForegroundColor Yellow
docker-compose -f docker-compose-backend.yml build --no-cache
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Imágenes construidas correctamente" -ForegroundColor Green
} else {
    Write-Host "   ❌ Error construyendo imágenes" -ForegroundColor Red
    exit 1
}

# ========================================
# 3. INICIAR SERVICIOS
# ========================================
Write-Host "3. Iniciando servicios backend..." -ForegroundColor Yellow
docker-compose -f docker-compose-backend.yml up -d
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Servicios iniciados" -ForegroundColor Green
} else {
    Write-Host "   ❌ Error iniciando servicios" -ForegroundColor Red
    exit 1
}

# ========================================
# 4. ESPERAR A QUE LOS SERVICIOS ESTÉN LISTOS
# ========================================
Write-Host "4. Esperando a que los servicios estén listos..." -ForegroundColor Yellow
$maxAttempts = 30
$attempt = 0

do {
    $attempt++
    Write-Host "   Intento $attempt/$maxAttempts..." -ForegroundColor Gray
    
    # Verificar SQL Server Adapter
    $sqlAdapterHealth = curl -s http://localhost:8080/actuator/health 2>$null
    $sqlAdapterOk = $LASTEXITCODE -eq 0
    
    # Verificar Regulatory Service
    $regulatoryHealth = curl -s http://localhost:8085/actuator/health 2>$null
    $regulatoryOk = $LASTEXITCODE -eq 0
    
    if ($sqlAdapterOk -and $regulatoryOk) {
        Write-Host "   ✅ Todos los servicios están respondiendo" -ForegroundColor Green
        break
    }
    
    if ($attempt -lt $maxAttempts) {
        Start-Sleep -Seconds 10
    }
} while ($attempt -lt $maxAttempts)

if ($attempt -eq $maxAttempts) {
    Write-Host "   ⚠️  Algunos servicios pueden no estar completamente listos" -ForegroundColor Yellow
}

# ========================================
# 5. VERIFICAR ESTADO FINAL
# ========================================
Write-Host "5. Verificando estado final de los servicios..." -ForegroundColor Yellow

# Verificar SQL Server Adapter
Write-Host "   Verificando SQL Server Adapter..." -ForegroundColor Gray
$sqlAdapterStatus = curl -s http://localhost:8080/actuator/health 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ SQL Server Adapter: ACTIVO (Puerto 8080)" -ForegroundColor Green
} else {
    Write-Host "   ❌ SQL Server Adapter: NO RESPONDE" -ForegroundColor Red
}

# Verificar Regulatory Service
Write-Host "   Verificando Regulatory Service..." -ForegroundColor Gray
$regulatoryStatus = curl -s http://localhost:8085/actuator/health 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Regulatory Service: ACTIVO (Puerto 8085)" -ForegroundColor Green
} else {
    Write-Host "   ❌ Regulatory Service: NO RESPONDE" -ForegroundColor Red
}

# ========================================
# RESUMEN FINAL
# ========================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SERVICIOS BACKEND INICIADOS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🌐 Servicios disponibles:" -ForegroundColor Yellow
Write-Host "   • SQL Server Adapter: http://localhost:8080" -ForegroundColor White
Write-Host "   • Regulatory Service:  http://localhost:8085" -ForegroundColor White
Write-Host ""
Write-Host "🔍 Endpoints de verificación:" -ForegroundColor Yellow
Write-Host "   • SQL Server Adapter: http://localhost:8080/actuator/health" -ForegroundColor White
Write-Host "   • Regulatory Service:  http://localhost:8085/actuator/health" -ForegroundColor White
Write-Host ""
Write-Host "📊 APIs disponibles:" -ForegroundColor Yellow
Write-Host "   • GET /api/regulatory/l08 (con auth: admin:sudbank2025)" -ForegroundColor White
Write-Host "   • POST /api/regulatory/l08/generate" -ForegroundColor White
Write-Host "   • GET /api/regulatory/l08/validate" -ForegroundColor White
Write-Host ""
Write-Host "🔧 Comandos útiles:" -ForegroundColor Yellow
Write-Host "   • Ver logs: docker-compose -f docker-compose-backend.yml logs -f" -ForegroundColor White
Write-Host "   • Detener:   docker-compose -f docker-compose-backend.yml down" -ForegroundColor White
Write-Host "   • Reiniciar: docker-compose -f docker-compose-backend.yml restart" -ForegroundColor White
Write-Host ""
Write-Host "📝 Prueba rápida:" -ForegroundColor Yellow
Write-Host "   curl -u admin:sudbank2025 http://localhost:8080/api/regulatory/l08" -ForegroundColor White
Write-Host ""

Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 