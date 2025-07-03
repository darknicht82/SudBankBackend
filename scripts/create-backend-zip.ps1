# ========================================
# CREACIÓN DE ZIP DEL BACKEND SUDBANKCORE
# ========================================

param(
    [string]$OutputPath = ".",
    [switch]$IncludeLogs,
    [switch]$IncludeReports
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CREANDO ZIP DEL BACKEND SUDBANKCORE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ========================================
# 1. VERIFICAR PREREQUISITOS
# ========================================
Write-Host "1. Verificando prerrequisitos..." -ForegroundColor Yellow

# Verificar si estamos en el directorio correcto
if (-not (Test-Path "sqlserver-adapter") -or -not (Test-Path "backend")) {
    Write-Host "   ❌ No se encontraron directorios principales" -ForegroundColor Red
    Write-Host "   💡 Ejecuta este script desde el directorio raíz del proyecto" -ForegroundColor Yellow
    exit 1
}

Write-Host "   ✅ Directorio del proyecto verificado" -ForegroundColor Green

# Verificar PowerShell versión para Compress-Archive
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Host "   ❌ PowerShell 5.0 o superior requerido" -ForegroundColor Red
    Write-Host "   💡 Actualiza PowerShell o usa 7-Zip manualmente" -ForegroundColor Yellow
    exit 1
}

Write-Host "   ✅ PowerShell compatible" -ForegroundColor Green
Write-Host ""

# ========================================
# 2. PREPARAR DIRECTORIO TEMPORAL
# ========================================
Write-Host "2. Preparando directorio temporal..." -ForegroundColor Yellow

$tempDir = "temp-backend-delivery"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$zipName = "SudBankCore-Backend-$timestamp.zip"

# Crear directorio temporal
if (Test-Path $tempDir) {
    Remove-Item -Path $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $tempDir | Out-Null

Write-Host "   ✅ Directorio temporal creado: $tempDir" -ForegroundColor Green
Write-Host ""

# ========================================
# 3. COPIAR ARCHIVOS NECESARIOS
# ========================================
Write-Host "3. Copiando archivos necesarios..." -ForegroundColor Yellow

# Definir archivos y directorios a incluir
$includeItems = @(
    "sqlserver-adapter",
    "backend",
    "scripts",
    "docker-compose-backend.yml",
    "docker-compose-external-adapter.yml",
    "start-backend-local.bat",
    "README-BACKEND.md",
    "GUIA_BACKEND.md",
    "env.template",
    "COMPARACION_BACKEND_VS_COMPLETO.md"
)

# Copiar cada item
foreach ($item in $includeItems) {
    if (Test-Path $item) {
        if (Test-Path $item -PathType Container) {
            # Es un directorio
            Copy-Item -Path $item -Destination $tempDir -Recurse -Force
            Write-Host "   ✅ Copiado directorio: $item" -ForegroundColor Green
        } else {
            # Es un archivo
            Copy-Item -Path $item -Destination $tempDir -Force
            Write-Host "   ✅ Copiado archivo: $item" -ForegroundColor Green
        }
    } else {
        Write-Host "   ⚠️  No encontrado: $item" -ForegroundColor Yellow
    }
}

# Incluir logs si se solicita
if ($IncludeLogs -and (Test-Path "logs")) {
    Copy-Item -Path "logs" -Destination $tempDir -Recurse -Force
    Write-Host "   ✅ Copiado directorio: logs" -ForegroundColor Green
}

# Incluir reports si se solicita
if ($IncludeReports -and (Test-Path "reports")) {
    Copy-Item -Path "reports" -Destination $tempDir -Recurse -Force
    Write-Host "   ✅ Copiado directorio: reports" -ForegroundColor Green
}

Write-Host "   ✅ Archivos copiados" -ForegroundColor Green
Write-Host ""

# ========================================
# 4. LIMPIAR ARCHIVOS TEMPORALES
# ========================================
Write-Host "4. Limpiando archivos temporales..." -ForegroundColor Yellow

# Eliminar directorios de build
$buildDirs = @(
    "build",
    "bin",
    ".gradle",
    "out"
)

foreach ($buildDir in $buildDirs) {
    $buildPaths = Get-ChildItem -Path $tempDir -Name $buildDir -Recurse -Directory -ErrorAction SilentlyContinue
    foreach ($path in $buildPaths) {
        $fullPath = Join-Path $tempDir $path
        Remove-Item -Path $fullPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "   ✅ Eliminado: $path" -ForegroundColor Green
    }
}

# Eliminar archivos temporales
$tempFiles = @(
    "*.tmp",
    "*.log",
    "*.bak",
    ".DS_Store",
    "Thumbs.db"
)

foreach ($pattern in $tempFiles) {
    $files = Get-ChildItem -Path $tempDir -Filter $pattern -Recurse -ErrorAction SilentlyContinue
    foreach ($file in $files) {
        Remove-Item -Path $file.FullName -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "   ✅ Limpieza completada" -ForegroundColor Green
Write-Host ""

# ========================================
# 5. CREAR ARCHIVO DE INFORMACIÓN
# ========================================
Write-Host "5. Creando archivo de información..." -ForegroundColor Yellow

$infoContent = @"
# ========================================
# INFORMACIÓN DEL ZIP - BACKEND SUDBANKCORE
# ========================================

Fecha de creación: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Nombre del archivo: $zipName
Tamaño: [Se calculará después]

## 📦 CONTENIDO DEL ZIP

### Servicios Backend
- SQL Server Adapter (Puerto 8080) - Java 8
- Regulatory Service (Puerto 8085) - Java 17

### Configuraciones
- Docker Compose completo
- Docker Compose con adapter externo
- Scripts de gestión PowerShell
- Scripts de inicio batch
- Documentación completa

### Reportes Implementados
- L08 - Liquidez Estructural (Completamente funcional)

## 🚀 INSTRUCCIONES DE USO

### 1. Extraer el ZIP
```bash
# En Windows
Expand-Archive -Path "$zipName" -DestinationPath "SudBankCore-Backend"

# En Linux/Mac
unzip "$zipName"
```

### 2. Navegar al directorio
```bash
cd SudBankCore-Backend
```

### 3. Elegir opción de inicio

#### Opción A: Docker Completo (Recomendado)
```powershell
.\scripts\backend-start.ps1
```

#### Opción B: SQL Adapter Externo
```powershell
.\scripts\backend-external-adapter.ps1
```

#### Opción C: Todo Local
```cmd
start-backend-local.bat
```

### 4. Verificar servicios
```powershell
.\scripts\verify-backend.ps1
```

## 📊 PRUEBAS RÁPIDAS

### Health Checks
```bash
curl http://localhost:8080/actuator/health
curl http://localhost:8085/actuator/health
```

### API L08
```bash
curl -u admin:sudbank2025 http://localhost:8080/api/regulatory/l08
curl http://localhost:8085/api/regulatory/l08/validate
```

## 🔧 PREREQUISITOS

- Docker Desktop (para opciones Docker)
- Java 8 (para SQL Server Adapter local)
- Java 17 (para Regulatory Service local)
- PowerShell 5.0+ (para scripts)

## 📞 SOPORTE

Para soporte técnico, consulta la documentación incluida:
- README-BACKEND.md
- GUIA_BACKEND.md

## ✅ ESTADO

**EL BACKEND ESTÁ COMPLETAMENTE FUNCIONAL Y LISTO PARA USO**

"@

$infoContent | Out-File -FilePath (Join-Path $tempDir "INFORMACION_ZIP.md") -Encoding UTF8
Write-Host "   ✅ Archivo de información creado" -ForegroundColor Green
Write-Host ""

# ========================================
# 6. CREAR EL ZIP
# ========================================
Write-Host "6. Creando archivo ZIP..." -ForegroundColor Yellow

$zipPath = Join-Path $OutputPath $zipName

try {
    Compress-Archive -Path "$tempDir\*" -DestinationPath $zipPath -Force
    Write-Host "   ✅ ZIP creado exitosamente: $zipName" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Error creando ZIP: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# ========================================
# 7. VERIFICAR EL ZIP
# ========================================
Write-Host "7. Verificando archivo ZIP..." -ForegroundColor Yellow

if (Test-Path $zipPath) {
    $zipSize = (Get-Item $zipPath).Length / 1MB
    Write-Host "   ✅ ZIP verificado: $([math]::Round($zipSize, 2)) MB" -ForegroundColor Green
    
    # Contar archivos en el ZIP
    $zipContent = Get-ChildItem -Path $tempDir -Recurse | Measure-Object
    Write-Host "   📄 Archivos incluidos: $($zipContent.Count)" -ForegroundColor White
} else {
    Write-Host "   ❌ Error: ZIP no encontrado" -ForegroundColor Red
    exit 1
}

# ========================================
# 8. LIMPIAR DIRECTORIO TEMPORAL
# ========================================
Write-Host "8. Limpiando directorio temporal..." -ForegroundColor Yellow

Remove-Item -Path $tempDir -Recurse -Force
Write-Host "   ✅ Directorio temporal eliminado" -ForegroundColor Green

# ========================================
# RESUMEN FINAL
# ========================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "ZIP CREADO EXITOSAMENTE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "📦 Archivo creado:" -ForegroundColor Yellow
Write-Host "   $zipPath" -ForegroundColor White
Write-Host ""
Write-Host "📊 Información:" -ForegroundColor Yellow
Write-Host "   • Tamaño: $([math]::Round($zipSize, 2)) MB" -ForegroundColor White
Write-Host "   • Archivos: $($zipContent.Count)" -ForegroundColor White
Write-Host "   • Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")" -ForegroundColor White
Write-Host ""
Write-Host "🚀 El ZIP está listo para:" -ForegroundColor Yellow
Write-Host "   • Enviar por email" -ForegroundColor White
Write-Host "   • Subir a Google Drive/Dropbox" -ForegroundColor White
Write-Host "   • Compartir en GitHub Releases" -ForegroundColor White
Write-Host "   • Entregar al nuevo desarrollador" -ForegroundColor White
Write-Host ""
Write-Host "📋 Contenido incluido:" -ForegroundColor Yellow
Write-Host "   • Código fuente completo" -ForegroundColor White
Write-Host "   • Configuraciones Docker" -ForegroundColor White
Write-Host "   • Scripts de gestión" -ForegroundColor White
Write-Host "   • Documentación completa" -ForegroundColor White
Write-Host "   • Instrucciones de uso" -ForegroundColor White
Write-Host ""

Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 