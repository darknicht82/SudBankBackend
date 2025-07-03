#!/bin/bash

echo "🚀 Iniciando SudBank Core - Sistema Simple"
echo "=========================================="

# Verificar que Docker esté funcionando
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker no está funcionando. Por favor, inicia Docker Desktop."
    exit 1
fi

# Construir el backend
echo "📦 Construyendo backend..."
cd backend/simple-api
./gradlew build -x test
cd ../..

# Levantar servicios con Docker Compose
echo "🐳 Levantando servicios con Docker Compose..."
docker-compose -f docker-compose-simple.yml up -d

# Esperar a que los servicios estén listos
echo "⏳ Esperando a que los servicios estén listos..."
sleep 30

# Verificar estado de los servicios
echo "🔍 Verificando estado de los servicios..."

# Verificar API
if curl -f http://localhost:8080/api/health > /dev/null 2>&1; then
    echo "✅ API Backend: http://localhost:8080"
else
    echo "❌ API Backend: No responde"
fi

# Verificar Admin Panel
if curl -f http://localhost:4200 > /dev/null 2>&1; then
    echo "✅ Admin Panel: http://localhost:4200"
else
    echo "❌ Admin Panel: No responde"
fi

# Verificar Dashboard Riesgos
if curl -f http://localhost:4201 > /dev/null 2>&1; then
    echo "✅ Dashboard Riesgos: http://localhost:4201"
else
    echo "❌ Dashboard Riesgos: No responde"
fi

# Verificar Nginx
if curl -f http://localhost:80 > /dev/null 2>&1; then
    echo "✅ Nginx Proxy: http://localhost:80"
else
    echo "❌ Nginx Proxy: No responde"
fi

echo ""
echo "🎉 Sistema iniciado correctamente!"
echo ""
echo "📱 URLs de acceso:"
echo "   Admin Panel: http://localhost:4200"
echo "   Dashboard Riesgos: http://localhost:4201"
echo "   API Backend: http://localhost:8080"
echo "   Nginx Proxy: http://localhost:80"
echo ""
echo "🔑 Credenciales de prueba:"
echo "   Usuario: admin"
echo "   Contraseña: admin123"
echo ""
echo "🛑 Para detener: docker-compose -f docker-compose-simple.yml down" 