# ========================================
# INICIO DE REGULATORY SERVICE CON ADAPTER EXTERNO
# SudBankCore - SQL Server Adapter externo
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "INICIANDO REGULATORY SERVICE" -ForegroundColor Cyan
Write-Host "SQL Server Adapter: EXTERNO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ========================================
# 1. VERIFICAR SQL SERVER ADAPTER EXTERNO
# ========================================
Write-Host "1. Verificando SQL Server Adapter externo..." -ForegroundColor Yellow

try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/actuator/health" -TimeoutSec 10 -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-Host "   ✅ SQL Server Adapter externo: ACTIVO" -ForegroundColor Green
    } else {
        Write-Host "   ❌ SQL Server Adapter externo: Error HTTP $($response.StatusCode)" -ForegroundColor Red
        Write-Host "   ⚠️  Asegúrate de que el SQL Server Adapter esté ejecutándose en puerto 8080" -ForegroundColor Yellow
        Write-Host "   💡 Puedes iniciarlo con: cd C:\Desarrollo\sqlserver-adapter && start-java8.bat" -ForegroundColor Gray
        exit 1
    }
} catch {
    Write-Host "   ❌ SQL Server Adapter externo: NO RESPONDE" -ForegroundColor Red
    Write-Host "   ⚠️  El SQL Server Adapter debe estar ejecutándose en puerto 8080" -ForegroundColor Yellow
    Write-Host "   💡 Opciones para iniciarlo:" -ForegroundColor Gray
    Write-Host "      • cd C:\Desarrollo\sqlserver-adapter && start-java8.bat" -ForegroundColor Gray
    Write-Host "      • cd C:\Desarrollo\sqlserver-adapter && gradlew bootRun" -ForegroundColor Gray
    Write-Host "      • O usar el adapter existente si ya está corriendo" -ForegroundColor Gray
    exit 1
}

# ========================================
# 2. DETENER CONTENEDORES EXISTENTES
# ========================================
Write-Host "2. Deteniendo contenedores existentes..." -ForegroundColor Yellow
docker-compose -f docker-compose-external-adapter.yml down 2>$null
Write-Host "   ✅ Contenedores detenidos" -ForegroundColor Green

# ========================================
# 3. CONSTRUIR IMAGEN REGULATORY SERVICE
# ========================================
Write-Host "3. Construyendo imagen Regulatory Service..." -ForegroundColor Yellow
docker-compose -f docker-compose-external-adapter.yml build --no-cache
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Imagen construida correctamente" -ForegroundColor Green
} else {
    Write-Host "   ❌ Error construyendo imagen" -ForegroundColor Red
    exit 1
}

# ========================================
# 4. INICIAR REGULATORY SERVICE
# ========================================
Write-Host "4. Iniciando Regulatory Service..." -ForegroundColor Yellow
docker-compose -f docker-compose-external-adapter.yml up -d
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Regulatory Service iniciado" -ForegroundColor Green
} else {
    Write-Host "   ❌ Error iniciando Regulatory Service" -ForegroundColor Red
    exit 1
}

# ========================================
# 5. ESPERAR A QUE EL SERVICIO ESTÉ LISTO
# ========================================
Write-Host "5. Esperando a que el Regulatory Service esté listo..." -ForegroundColor Yellow
$maxAttempts = 30
$attempt = 0

do {
    $attempt++
    Write-Host "   Intento $attempt/$maxAttempts..." -ForegroundColor Gray
    
    # Verificar Regulatory Service
    $regulatoryHealth = curl -s http://localhost:8085/actuator/health 2>$null
    $regulatoryOk = $LASTEXITCODE -eq 0
    
    if ($regulatoryOk) {
        Write-Host "   ✅ Regulatory Service está respondiendo" -ForegroundColor Green
        break
    }
    
    if ($attempt -lt $maxAttempts) {
        Start-Sleep -Seconds 10
    }
} while ($attempt -lt $maxAttempts)

if ($attempt -eq $maxAttempts) {
    Write-Host "   ⚠️  Regulatory Service puede no estar completamente listo" -ForegroundColor Yellow
}

# ========================================
# 6. VERIFICAR ESTADO FINAL
# ========================================
Write-Host "6. Verificando estado final..." -ForegroundColor Yellow

# Verificar SQL Server Adapter (externo)
Write-Host "   Verificando SQL Server Adapter (externo)..." -ForegroundColor Gray
$sqlAdapterStatus = curl -s http://localhost:8080/actuator/health 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ SQL Server Adapter: ACTIVO (Puerto 8080) - EXTERNO" -ForegroundColor Green
} else {
    Write-Host "   ❌ SQL Server Adapter: NO RESPONDE" -ForegroundColor Red
}

# Verificar Regulatory Service (Docker)
Write-Host "   Verificando Regulatory Service (Docker)..." -ForegroundColor Gray
$regulatoryStatus = curl -s http://localhost:8085/actuator/health 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Regulatory Service: ACTIVO (Puerto 8085) - DOCKER" -ForegroundColor Green
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
Write-Host "   • SQL Server Adapter: http://localhost:8080 (EXTERNO)" -ForegroundColor White
Write-Host "   • Regulatory Service:  http://localhost:8085 (DOCKER)" -ForegroundColor White
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
Write-Host "   • Ver logs: docker-compose -f docker-compose-external-adapter.yml logs -f" -ForegroundColor White
Write-Host "   • Detener:   docker-compose -f docker-compose-external-adapter.yml down" -ForegroundColor White
Write-Host "   • Reiniciar: docker-compose -f docker-compose-external-adapter.yml restart" -ForegroundColor White
Write-Host ""
Write-Host "📝 Prueba rápida:" -ForegroundColor Yellow
Write-Host "   curl -u admin:sudbank2025 http://localhost:8080/api/regulatory/l08" -ForegroundColor White
Write-Host "   curl http://localhost:8085/api/regulatory/l08/validate" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  IMPORTANTE:" -ForegroundColor Yellow
Write-Host "   • El SQL Server Adapter corre externamente (no en Docker)" -ForegroundColor White
Write-Host "   • Solo el Regulatory Service está en Docker" -ForegroundColor White
Write-Host "   • Si detienes el adapter externo, el sistema dejará de funcionar" -ForegroundColor White
Write-Host ""

Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 