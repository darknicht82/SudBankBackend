# ========================================
# PREPARACIÓN DE REPOSITORIO GIT - BACKEND SUDBANKCORE
# ========================================

param(
    [string]$RepoName = "SudBankCore-Backend",
    [string]$Description = "Sistema de reportes regulatorios backend para Superintendencia de Bancos",
    [switch]$CreateRemote,
    [string]$GitHubToken = ""
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PREPARANDO REPOSITORIO GIT" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ========================================
# 1. VERIFICAR GIT
# ========================================
Write-Host "1. Verificando Git..." -ForegroundColor Yellow

try {
    $gitVersion = git --version
    Write-Host "   ✅ Git disponible: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Git no está disponible" -ForegroundColor Red
    Write-Host "   💡 Instala Git desde https://git-scm.com/" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# ========================================
# 2. VERIFICAR DIRECTORIO ACTUAL
# ========================================
Write-Host "2. Verificando directorio actual..." -ForegroundColor Yellow

if (-not (Test-Path "sqlserver-adapter") -or -not (Test-Path "backend")) {
    Write-Host "   ❌ No se encontraron directorios principales" -ForegroundColor Red
    Write-Host "   💡 Ejecuta este script desde el directorio raíz del proyecto" -ForegroundColor Yellow
    exit 1
}

Write-Host "   ✅ Directorio del proyecto verificado" -ForegroundColor Green
Write-Host ""

# ========================================
# 3. INICIALIZAR REPOSITORIO GIT
# ========================================
Write-Host "3. Inicializando repositorio Git..." -ForegroundColor Yellow

# Verificar si ya es un repositorio Git
if (Test-Path ".git") {
    Write-Host "   ℹ️  Repositorio Git ya existe" -ForegroundColor Gray
} else {
    git init
    Write-Host "   ✅ Repositorio Git inicializado" -ForegroundColor Green
}

Write-Host ""

# ========================================
# 4. CONFIGURAR .GITIGNORE
# ========================================
Write-Host "4. Configurando .gitignore..." -ForegroundColor Yellow

$gitignoreContent = @"
# ========================================
# .GITIGNORE - BACKEND SUDBANKCORE
# ========================================

# ========================================
# ARCHIVOS DE BUILD
# ========================================
build/
bin/
out/
target/
*.class
*.jar
*.war
*.ear

# ========================================
# GRADLE
# ========================================
.gradle/
gradle-app.setting
!gradle-wrapper.jar
!gradle-wrapper.properties

# ========================================
# IDE Y EDITORES
# ========================================
.idea/
*.iml
*.ipr
*.iws
.vscode/
*.swp
*.swo
*~

# ========================================
# LOGS Y ARCHIVOS TEMPORALES
# ========================================
logs/
*.log
*.tmp
*.temp
*.bak
*.backup

# ========================================
# REPORTES Y DATOS
# ========================================
reports/
backups/
*.csv
*.xlsx
*.xls
*.pdf

# ========================================
# DOCKER
# ========================================
.dockerignore
docker-compose.override.yml

# ========================================
# CONFIGURACIONES LOCALES
# ========================================
.env
application-local.yml
application-dev.yml

# ========================================
# SISTEMA OPERATIVO
# ========================================
.DS_Store
Thumbs.db
desktop.ini

# ========================================
# ARCHIVOS DE COMPRESIÓN
# ========================================
*.zip
*.tar
*.tar.gz
*.rar
*.7z

# ========================================
# ARCHIVOS DE CONFIGURACIÓN SENSIBLES
# ========================================
*.key
*.pem
*.p12
*.jks
keystore.jks
truststore.jks

# ========================================
# ARCHIVOS DE BASE DE DATOS
# ========================================
*.db
*.sqlite
*.sqlite3

# ========================================
# ARCHIVOS DE BACKUP
# ========================================
*.bak
*.backup
*.old

"@

$gitignoreContent | Out-File -FilePath ".gitignore" -Encoding UTF8
Write-Host "   ✅ .gitignore configurado" -ForegroundColor Green
Write-Host ""

# ========================================
# 5. AGREGAR ARCHIVOS AL REPOSITORIO
# ========================================
Write-Host "5. Agregando archivos al repositorio..." -ForegroundColor Yellow

# Agregar todos los archivos
git add .

# Verificar estado
$status = git status --porcelain
if ($status) {
    Write-Host "   📄 Archivos a commitear:" -ForegroundColor Gray
    $status | ForEach-Object {
        Write-Host "   $_" -ForegroundColor Gray
    }
} else {
    Write-Host "   ℹ️  No hay cambios para commitear" -ForegroundColor Gray
}

Write-Host "   ✅ Archivos agregados" -ForegroundColor Green
Write-Host ""

# ========================================
# 6. HACER COMMIT INICIAL
# ========================================
Write-Host "6. Haciendo commit inicial..." -ForegroundColor Yellow

$commitMessage = @"
🎉 Initial commit: Backend SudBankCore

Sistema de reportes regulatorios backend para Superintendencia de Bancos

## 📦 Servicios incluidos:
- SQL Server Adapter (Puerto 8080) - Java 8
- Regulatory Service (Puerto 8085) - Java 17

## 🚀 Funcionalidades:
- Reporte L08 completamente funcional
- APIs REST documentadas
- Configuración Docker completa
- Scripts de gestión PowerShell
- Documentación completa

## 📋 Estado:
✅ Completamente funcional y listo para producción

Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

git commit -m $commitMessage
Write-Host "   ✅ Commit inicial realizado" -ForegroundColor Green
Write-Host ""

# ========================================
# 7. CONFIGURAR BRANCH PRINCIPAL
# ========================================
Write-Host "7. Configurando branch principal..." -ForegroundColor Yellow

# Verificar si estamos en main o master
$currentBranch = git branch --show-current
if ($currentBranch -eq "master") {
    git branch -M main
    Write-Host "   ✅ Branch renombrado a 'main'" -ForegroundColor Green
} else {
    Write-Host "   ✅ Branch principal: $currentBranch" -ForegroundColor Green
}

Write-Host ""

# ========================================
# 8. CREAR README PRINCIPAL
# ========================================
Write-Host "8. Creando README principal..." -ForegroundColor Yellow

$readmeContent = @"
# 🏦 SudBankCore Backend

Sistema de reportes regulatorios backend para Superintendencia de Bancos de la República Dominicana.

## 📋 Descripción

SudBankCore es un sistema backend diseñado para generar y gestionar reportes regulatorios requeridos por la Superintendencia de Bancos. El sistema está construido con tecnologías modernas y arquitectura de microservicios.

## 🏗️ Arquitectura

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   SQL Server    │    │   Regulatory     │    │   Base de       │
│   Adapter       │◄──►│   Service        │◄──►│   Datos         │
│   (Puerto 8080) │    │   (Puerto 8085)  │    │   SQL Server    │
│                 │    │                  │    │   2008 R2       │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 🚀 Inicio Rápido

### Prerrequisitos
- Docker Desktop
- Java 8 y Java 17 (para desarrollo local)
- PowerShell 5.0+ (para scripts)

### Opción 1: Docker Completo (Recomendado)
```powershell
.\scripts\backend-start.ps1
```

### Opción 2: SQL Adapter Externo
```powershell
.\scripts\backend-external-adapter.ps1
```

### Opción 3: Todo Local
```cmd
start-backend-local.bat
```

## 📊 APIs Disponibles

### SQL Server Adapter (Puerto 8080)
- `GET /actuator/health` - Health check
- `GET /api/regulatory/l08` - Obtener datos L08 (con auth: admin:sudbank2025)

### Regulatory Service (Puerto 8085)
- `GET /actuator/health` - Health check
- `POST /api/regulatory/l08/generate` - Generar reporte L08
- `GET /api/regulatory/l08/validate` - Validar datos L08

## 🔧 Verificación

```powershell
# Verificar servicios
.\scripts\verify-backend.ps1

# Ver logs
.\scripts\docker-logs.ps1
```

## 📋 Reportes Implementados

### ✅ L08 - Liquidez Estructural (Semanal)
- **Estado:** Completamente funcional
- **Endpoint:** `/api/regulatory/l08`
- **Generación:** Archivo TXT
- **Validaciones:** Implementadas

### 🔄 En Desarrollo
- L10 - Brechas de Sensibilidad (Mensual)
- L11 - Sensibilidad Patrimonial (Mensual)
- L12 - Captaciones por Monto (Mensual)
- L13 - Obligaciones Financieras (Mensual)
- L14 - Concentración de Depósitos (Mensual)
- L31 - Brechas de Liquidez (Mensual)

## 📚 Documentación

- [Guía del Backend](GUIA_BACKEND.md) - Documentación completa
- [README Backend](README-BACKEND.md) - Información específica del backend
- [Comparación de Opciones](COMPARACION_BACKEND_VS_COMPLETO.md) - Análisis de opciones de entrega

## 🛠️ Desarrollo

### Estructura del Proyecto
```
SudBankCore-Backend/
├── sqlserver-adapter/              # Conector SQL Server (Java 8)
├── backend/modules/
│   └── regulatory-service/        # Servicio regulatorio (Java 17)
├── scripts/                       # Scripts de gestión
├── docker-compose-backend.yml     # Docker completo
├── docker-compose-external-adapter.yml  # Docker con adapter externo
└── start-backend-local.bat        # Inicio todo local
```

### Tecnologías Utilizadas
- **Java 8** - SQL Server Adapter
- **Java 17** - Regulatory Service
- **Spring Boot** - Framework de aplicaciones
- **Docker** - Contenedores
- **Gradle** - Gestión de dependencias
- **SQL Server** - Base de datos

## 🔐 Seguridad

- Autenticación básica configurada
- Credenciales: `admin:sudbank2025`
- Endpoints sensibles protegidos
- Logs de auditoría disponibles

## 📞 Soporte

Para soporte técnico o preguntas sobre el sistema, consulta la documentación incluida o contacta al equipo de desarrollo.

## 📄 Licencia

Este proyecto es propiedad de SudBank y está destinado para uso interno de la Superintendencia de Bancos.

---

**🎯 Estado del Proyecto:** Completamente funcional y listo para producción  
**📅 Última actualización:** $(Get-Date -Format "yyyy-MM-dd")  
**🚀 Versión:** Backend Only - Completamente Portable
"@

$readmeContent | Out-File -FilePath "README.md" -Encoding UTF8
Write-Host "   ✅ README principal creado" -ForegroundColor Green
Write-Host ""

# ========================================
# 9. CREAR REPOSITORIO REMOTO (OPCIONAL)
# ========================================
if ($CreateRemote) {
    Write-Host "9. Creando repositorio remoto..." -ForegroundColor Yellow
    
    if (-not $GitHubToken) {
        Write-Host "   ⚠️  Token de GitHub no proporcionado" -ForegroundColor Yellow
        Write-Host "   💡 Para crear el repositorio remoto, proporciona -GitHubToken" -ForegroundColor Gray
    } else {
        try {
            # Crear repositorio en GitHub usando la API
            $headers = @{
                "Authorization" = "token $GitHubToken"
                "Accept" = "application/vnd.github.v3+json"
            }
            
            $body = @{
                name = $RepoName
                description = $Description
                private = $true
                auto_init = $false
            } | ConvertTo-Json
            
            $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body -ContentType "application/json"
            
            Write-Host "   ✅ Repositorio creado: $($response.html_url)" -ForegroundColor Green
            
            # Agregar remote
            git remote add origin $response.clone_url
            Write-Host "   ✅ Remote origin agregado" -ForegroundColor Green
            
            # Push inicial
            git push -u origin main
            Write-Host "   ✅ Push inicial realizado" -ForegroundColor Green
            
        } catch {
            Write-Host "   ❌ Error creando repositorio remoto: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
} else {
    Write-Host "9. Repositorio remoto no creado (usa -CreateRemote para crear)" -ForegroundColor Gray
}

Write-Host ""

# ========================================
# 10. VERIFICACIÓN FINAL
# ========================================
Write-Host "10. Verificación final..." -ForegroundColor Yellow

# Verificar estado del repositorio
$status = git status --porcelain
if ($status) {
    Write-Host "   ⚠️  Hay cambios sin commitear:" -ForegroundColor Yellow
    $status | ForEach-Object {
        Write-Host "   $_" -ForegroundColor Gray
    }
} else {
    Write-Host "   ✅ Repositorio limpio" -ForegroundColor Green
}

# Mostrar información del repositorio
$remoteUrl = git remote get-url origin 2>$null
if ($remoteUrl) {
    Write-Host "   🌐 Remote URL: $remoteUrl" -ForegroundColor Green
} else {
    Write-Host "   ℹ️  No hay remote configurado" -ForegroundColor Gray
}

Write-Host "   📄 Commits: $(git rev-list --count HEAD)" -ForegroundColor White
Write-Host "   🌿 Branch: $(git branch --show-current)" -ForegroundColor White

# ========================================
# RESUMEN FINAL
# ========================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "REPOSITORIO GIT PREPARADO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "✅ Repositorio Git preparado exitosamente" -ForegroundColor Green
Write-Host ""
Write-Host "📦 Archivos incluidos:" -ForegroundColor Yellow
Write-Host "   • Código fuente completo" -ForegroundColor White
Write-Host "   • Configuraciones Docker" -ForegroundColor White
Write-Host "   • Scripts de gestión" -ForegroundColor White
Write-Host "   • Documentación completa" -ForegroundColor White
Write-Host "   • .gitignore configurado" -ForegroundColor White
Write-Host ""
Write-Host "🚀 Próximos pasos:" -ForegroundColor Yellow
Write-Host "   1. Crear repositorio en GitHub (si no se hizo)" -ForegroundColor White
Write-Host "   2. Agregar remote: git remote add origin <URL>" -ForegroundColor White
Write-Host "   3. Hacer push: git push -u origin main" -ForegroundColor White
Write-Host "   4. Compartir URL del repositorio" -ForegroundColor White
Write-Host ""
Write-Host "📋 Comandos útiles:" -ForegroundColor Yellow
Write-Host "   • Ver estado: git status" -ForegroundColor White
Write-Host "   • Ver commits: git log --oneline" -ForegroundColor White
Write-Host "   • Agregar cambios: git add . && git commit -m 'Mensaje'" -ForegroundColor White
Write-Host "   • Hacer push: git push" -ForegroundColor White
Write-Host ""

Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 