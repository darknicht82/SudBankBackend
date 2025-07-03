#!/bin/bash

echo "🚀 Iniciando SudBankCore - Servicios Funcionales"
echo "=================================================="

# Verificar que estamos en el directorio correcto
if [ ! -f "docker-compose-simple.yml" ]; then
    echo "❌ Error: No se encuentra docker-compose-simple.yml"
    echo "   Ejecuta este script desde el directorio raíz de SudBankCore"
    exit 1
fi

# Función para verificar si un puerto está en uso
check_port() {
    local port=$1
    local service=$2
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null ; then
        echo "⚠️  Puerto $port ya está en uso. Deteniendo proceso..."
        lsof -ti:$port | xargs kill -9
        sleep 2
    fi
}

# Verificar y liberar puertos si es necesario
echo "🔍 Verificando puertos..."
check_port 8080 "SQL Server Adapter"
check_port 8085 "Regulatory Service"
check_port 4200 "Frontend Angular"

# Opción 1: Docker Compose (Recomendado)
echo ""
echo "📦 Opción 1: Levantar con Docker Compose"
echo "   docker-compose -f docker-compose-simple.yml up -d"
echo ""

# Opción 2: Servicios individuales
echo "🔧 Opción 2: Levantar servicios individuales"
echo ""
echo "1. SQL Server Adapter:"
echo "   cd sqlserver-adapter"
echo "   ./start-java8-optimized.bat"
echo ""
echo "2. Regulatory Service:"
echo "   cd backend/modules/regulatory-service"
echo "   ./start-java17.bat"
echo ""
echo "3. Frontend Angular:"
echo "   cd frontend/risk-dashboard"
echo "   npm install"
echo "   ng serve"
echo ""

# Verificar servicios
echo "🔍 Verificar servicios:"
echo "   - SQL Server Adapter: http://localhost:8080/actuator/health"
echo "   - Regulatory Service: http://localhost:8085/actuator/health"
echo "   - Frontend Angular: http://localhost:4200"
echo ""

echo "✅ Script completado. Elige una opción para continuar." 