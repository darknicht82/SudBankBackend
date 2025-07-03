# ========================================
# VERIFICACIÓN COMPLETA DEL BACKEND SUDBANKCORE
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VERIFICACIÓN COMPLETA DEL BACKEND" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ========================================
# 1. VERIFICAR PREREQUISITOS
# ========================================
Write-Host "1. Verificando prerrequisitos..." -ForegroundColor Yellow

# Verificar Java
try {
    $javaVersion = java -version 2>&1 | Select-String "version"
    Write-Host "   ✅ Java: $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Java: NO ENCONTRADO" -ForegroundColor Red
}

# Verificar Docker
try {
    $dockerVersion = docker --version
    Write-Host "   ✅ Docker: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Docker: NO ENCONTRADO" -ForegroundColor Red
}

# Verificar curl
try {
    $curlVersion = curl --version | Select-Object -First 1
    Write-Host "   ✅ curl: Disponible" -ForegroundColor Green
} catch {
    Write-Host "   ❌ curl: NO ENCONTRADO" -ForegroundColor Red
}

Write-Host ""

# ========================================
# 2. VERIFICAR CONECTIVIDAD DE RED
# ========================================
Write-Host "2. Verificando conectividad de red..." -ForegroundColor Yellow

# Verificar SQL Server
try {
    $sqlServerTest = Test-NetConnection -ComputerName "192.168.10.7" -Port 1433 -InformationLevel Quiet
    if ($sqlServerTest) {
        Write-Host "   ✅ SQL Server (192.168.10.7:1433): ACCESIBLE" -ForegroundColor Green
    } else {
        Write-Host "   ❌ SQL Server (192.168.10.7:1433): NO ACCESIBLE" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ SQL Server (192.168.10.7:1433): ERROR DE CONECTIVIDAD" -ForegroundColor Red
}

Write-Host ""

# ========================================
# 3. VERIFICAR SERVICIOS BACKEND
# ========================================
Write-Host "3. Verificando servicios backend..." -ForegroundColor Yellow

# Verificar SQL Server Adapter
Write-Host "   Verificando SQL Server Adapter (Puerto 8080)..." -ForegroundColor Gray
try {
    $adapterResponse = Invoke-WebRequest -Uri "http://localhost:8080/actuator/health" -TimeoutSec 10 -ErrorAction Stop
    if ($adapterResponse.StatusCode -eq 200) {
        Write-Host "   ✅ SQL Server Adapter: ACTIVO" -ForegroundColor Green
        
        # Verificar endpoint con autenticación
        try {
            $authResponse = Invoke-WebRequest -Uri "http://localhost:8080/api/regulatory/l08" -Headers @{Authorization="Basic YWRtaW46c3VkYmFuazIwMjU="} -TimeoutSec 10 -ErrorAction Stop
            if ($authResponse.StatusCode -eq 200) {
                Write-Host "      ✅ Endpoint L08: FUNCIONAL" -ForegroundColor Green
            } else {
                Write-Host "      ⚠️  Endpoint L08: Error HTTP $($authResponse.StatusCode)" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "      ⚠️  Endpoint L08: Error de autenticación" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   ❌ SQL Server Adapter: Error HTTP $($adapterResponse.StatusCode)" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ SQL Server Adapter: NO RESPONDE" -ForegroundColor Red
}

# Verificar Regulatory Service
Write-Host "   Verificando Regulatory Service (Puerto 8085)..." -ForegroundColor Gray
try {
    $regulatoryResponse = Invoke-WebRequest -Uri "http://localhost:8085/actuator/health" -TimeoutSec 10 -ErrorAction Stop
    if ($regulatoryResponse.StatusCode -eq 200) {
        Write-Host "   ✅ Regulatory Service: ACTIVO" -ForegroundColor Green
        
        # Verificar endpoints del regulatory
        try {
            $validateResponse = Invoke-WebRequest -Uri "http://localhost:8085/api/regulatory/l08/validate" -TimeoutSec 10 -ErrorAction Stop
            if ($validateResponse.StatusCode -eq 200) {
                Write-Host "      ✅ Endpoint validate: FUNCIONAL" -ForegroundColor Green
            } else {
                Write-Host "      ⚠️  Endpoint validate: Error HTTP $($validateResponse.StatusCode)" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "      ⚠️  Endpoint validate: NO RESPONDE" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   ❌ Regulatory Service: Error HTTP $($regulatoryResponse.StatusCode)" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ Regulatory Service: NO RESPONDE" -ForegroundColor Red
}

Write-Host ""

# ========================================
# 4. VERIFICAR CONTENEDORES DOCKER
# ========================================
Write-Host "4. Verificando contenedores Docker..." -ForegroundColor Yellow

try {
    $containers = docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>$null
    if ($containers) {
        Write-Host "   Contenedores activos:" -ForegroundColor Gray
        $containers | ForEach-Object {
            if ($_ -match "sudbankcore") {
                Write-Host "   ✅ $_" -ForegroundColor Green
            } else {
                Write-Host "   $_" -ForegroundColor Gray
            }
        }
    } else {
        Write-Host "   ℹ️  No hay contenedores activos" -ForegroundColor Gray
    }
} catch {
    Write-Host "   ❌ Error verificando contenedores Docker" -ForegroundColor Red
}

Write-Host ""

# ========================================
# 5. VERIFICAR PROCESOS JAVA
# ========================================
Write-Host "5. Verificando procesos Java..." -ForegroundColor Yellow

$javaProcesses = Get-Process -Name "java" -ErrorAction SilentlyContinue
if ($javaProcesses) {
    Write-Host "   Procesos Java activos:" -ForegroundColor Gray
    $javaProcesses | ForEach-Object {
        $processInfo = Get-WmiObject -Class Win32_Process -Filter "ProcessId = $($_.Id)"
        Write-Host "   ✅ PID $($_.Id): $($processInfo.CommandLine)" -ForegroundColor Green
    }
} else {
    Write-Host "   ℹ️  No hay procesos Java activos" -ForegroundColor Gray
}

Write-Host ""

# ========================================
# 6. VERIFICAR PUERTOS
# ========================================
Write-Host "6. Verificando puertos..." -ForegroundColor Yellow

$ports = @(8080, 8085)
foreach ($port in $ports) {
    $connection = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($connection) {
        Write-Host "   ✅ Puerto $port: EN USO" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Puerto $port: LIBRE" -ForegroundColor Red
    }
}

Write-Host ""

# ========================================
# 7. VERIFICAR ARCHIVOS DE CONFIGURACIÓN
# ========================================
Write-Host "7. Verificando archivos de configuración..." -ForegroundColor Yellow

$configFiles = @(
    "sqlserver-adapter/src/main/resources/application.yml",
    "backend/modules/regulatory-service/src/main/resources/application.yml",
    "docker-compose-backend.yml",
    "docker-compose-external-adapter.yml"
)

foreach ($file in $configFiles) {
    if (Test-Path $file) {
        Write-Host "   ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $file" -ForegroundColor Red
    }
}

Write-Host ""

# ========================================
# RESUMEN FINAL
# ========================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "RESUMEN DE VERIFICACIÓN" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Contar servicios activos
$activeServices = 0
$totalServices = 2

try {
    $adapterHealth = Invoke-WebRequest -Uri "http://localhost:8080/actuator/health" -TimeoutSec 5 -ErrorAction Stop
    if ($adapterHealth.StatusCode -eq 200) { $activeServices++ }
} catch { }

try {
    $regulatoryHealth = Invoke-WebRequest -Uri "http://localhost:8085/actuator/health" -TimeoutSec 5 -ErrorAction Stop
    if ($regulatoryHealth.StatusCode -eq 200) { $activeServices++ }
} catch { }

Write-Host "📊 Estado del sistema:" -ForegroundColor Yellow
Write-Host "   • Servicios activos: $activeServices/$totalServices" -ForegroundColor White

if ($activeServices -eq $totalServices) {
    Write-Host "   ✅ SISTEMA COMPLETAMENTE FUNCIONAL" -ForegroundColor Green
} elseif ($activeServices -gt 0) {
    Write-Host "   ⚠️  SISTEMA PARCIALMENTE FUNCIONAL" -ForegroundColor Yellow
} else {
    Write-Host "   ❌ SISTEMA NO FUNCIONAL" -ForegroundColor Red
}

Write-Host ""
Write-Host "🔧 Próximos pasos recomendados:" -ForegroundColor Yellow
if ($activeServices -eq 0) {
    Write-Host "   1. Iniciar servicios con: .\scripts\backend-start.ps1" -ForegroundColor White
    Write-Host "   2. O usar adapter externo: .\scripts\backend-external-adapter.ps1" -ForegroundColor White
    Write-Host "   3. O todo local: start-backend-local.bat" -ForegroundColor White
} elseif ($activeServices -lt $totalServices) {
    Write-Host "   1. Verificar logs de servicios inactivos" -ForegroundColor White
    Write-Host "   2. Reiniciar servicios problemáticos" -ForegroundColor White
    Write-Host "   3. Verificar configuración de puertos" -ForegroundColor White
} else {
    Write-Host "   1. Probar APIs con Postman/curl" -ForegroundColor White
    Write-Host "   2. Generar reporte L08" -ForegroundColor White
    Write-Host "   3. Verificar conectividad con SQL Server" -ForegroundColor White
}

Write-Host ""
Write-Host "📝 Comandos útiles:" -ForegroundColor Yellow
Write-Host "   • Ver logs Docker: docker-compose -f docker-compose-backend.yml logs -f" -ForegroundColor White
Write-Host "   • Detener servicios: docker-compose -f docker-compose-backend.yml down" -ForegroundColor White
Write-Host "   • Probar API: curl -u admin:sudbank2025 http://localhost:8080/api/regulatory/l08" -ForegroundColor White

Write-Host ""
Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 