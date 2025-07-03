# Script de inicio para SudBankCore con Docker (PowerShell)
Write-Host "==========================================" -ForegroundColor Green
Write-Host "Iniciando SudBankCore con Docker" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

# Verificar que Docker esté instalado
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Docker no está instalado" -ForegroundColor Red
    exit 1
}

# Verificar que Docker Compose esté instalado
if (-not (Get-Command docker-compose -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Docker Compose no está instalado" -ForegroundColor Red
    exit 1
}

# Crear directorio de logs si no existe
New-Item -ItemType Directory -Force -Path "logs/sqlserver-adapter" | Out-Null
New-Item -ItemType Directory -Force -Path "logs/regulatory-service" | Out-Null
New-Item -ItemType Directory -Force -Path "logs/frontend" | Out-Null

# Detener contenedores existentes
Write-Host "Deteniendo contenedores existentes..." -ForegroundColor Yellow
docker-compose -f docker-compose-complete.yml down

# Construir imágenes
Write-Host "Construyendo imágenes Docker..." -ForegroundColor Yellow
docker-compose -f docker-compose-complete.yml build --no-cache

# Iniciar servicios
Write-Host "Iniciando servicios..." -ForegroundColor Yellow
docker-compose -f docker-compose-complete.yml up -d

# Esperar a que los servicios estén listos
Write-Host "Esperando a que los servicios estén listos..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Verificar estado de los servicios
Write-Host "Verificando estado de los servicios..." -ForegroundColor Yellow
docker-compose -f docker-compose-complete.yml ps

Write-Host "==========================================" -ForegroundColor Green
Write-Host "Sistema iniciado correctamente" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host "Servicios disponibles:" -ForegroundColor White
Write-Host "- SQL Server Adapter: http://localhost:8080" -ForegroundColor Cyan
Write-Host "- Regulatory Service:  http://localhost:8085" -ForegroundColor Cyan
Write-Host "- Frontend:           http://localhost:4200" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para ver logs: docker-compose -f docker-compose-complete.yml logs -f" -ForegroundColor Gray
Write-Host "Para detener:  docker-compose -f docker-compose-complete.yml down" -ForegroundColor Gray 