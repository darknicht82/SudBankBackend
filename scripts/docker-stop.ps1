# Script para detener SudBankCore con Docker (PowerShell)
Write-Host "==========================================" -ForegroundColor Yellow
Write-Host "Deteniendo SudBankCore con Docker" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Yellow

# Detener contenedores
Write-Host "Deteniendo contenedores..." -ForegroundColor Yellow
docker-compose -f docker-compose-complete.yml down

# Eliminar contenedores y redes
Write-Host "Limpiando contenedores y redes..." -ForegroundColor Yellow
docker-compose -f docker-compose-complete.yml down --remove-orphans

Write-Host "==========================================" -ForegroundColor Green
Write-Host "Sistema detenido correctamente" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green 