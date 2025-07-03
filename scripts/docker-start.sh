#!/bin/bash

# Script de inicio para SudBankCore con Docker
echo "=========================================="
echo "Iniciando SudBankCore con Docker"
echo "=========================================="

# Verificar que Docker esté instalado
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker no está instalado"
    exit 1
fi

# Verificar que Docker Compose esté instalado
if ! command -v docker-compose &> /dev/null; then
    echo "ERROR: Docker Compose no está instalado"
    exit 1
fi

# Crear directorio de logs si no existe
mkdir -p logs/sqlserver-adapter
mkdir -p logs/regulatory-service
mkdir -p logs/frontend

# Detener contenedores existentes
echo "Deteniendo contenedores existentes..."
docker-compose -f docker-compose-complete.yml down

# Construir imágenes
echo "Construyendo imágenes Docker..."
docker-compose -f docker-compose-complete.yml build --no-cache

# Iniciar servicios
echo "Iniciando servicios..."
docker-compose -f docker-compose-complete.yml up -d

# Esperar a que los servicios estén listos
echo "Esperando a que los servicios estén listos..."
sleep 30

# Verificar estado de los servicios
echo "Verificando estado de los servicios..."
docker-compose -f docker-compose-complete.yml ps

echo "=========================================="
echo "Sistema iniciado correctamente"
echo "=========================================="
echo "Servicios disponibles:"
echo "- SQL Server Adapter: http://localhost:8080"
echo "- Regulatory Service:  http://localhost:8085"
echo "- Frontend:           http://localhost:4200"
echo ""
echo "Para ver logs: docker-compose -f docker-compose-complete.yml logs -f"
echo "Para detener:  docker-compose -f docker-compose-complete.yml down" 