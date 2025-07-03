#!/bin/bash

echo "Iniciando servicios de SudBank..."

# 1. Detener todos los contenedores existentes
echo "Deteniendo contenedores existentes..."
docker-compose down

# 2. Limpiar recursos no utilizados
echo "Limpiando recursos Docker..."
docker system prune -f

# 3. Crear archivo .env si no existe
if [ ! -f .env ]; then
    echo "Creando archivo .env desde template..."
    cp env.example .env
fi

# 4. Levantar servicios de infraestructura primero
echo "Levantando servicios de infraestructura..."
docker-compose up -d postgres redis kafka zookeeper

# 5. Esperar a que PostgreSQL esté listo
echo "Esperando a que PostgreSQL esté listo..."
sleep 10

# 6. Levantar servicios de monitoreo
echo "Levantando servicios de monitoreo..."
docker-compose up -d prometheus grafana

# 7. Levantar Eureka Server
echo "Levantando Eureka Server..."
docker-compose up -d eureka-server
sleep 10

# 8. Levantar servicios core
echo "Levantando servicios core..."
docker-compose up -d api-gateway auth-service

# 9. Levantar servicios de negocio
echo "Levantando servicios de negocio..."
docker-compose up -d core-admin user-management risk-management regulatory-service financial-service notification-service

# 10. Levantar frontends
echo "Levantando frontends..."
docker-compose up -d admin-panel dashboard-riesgos

# 11. Verificar estado de los servicios
echo "Verificando estado de los servicios..."
docker-compose ps

echo "Mostrando logs de servicios críticos..."
docker-compose logs --tail=50 eureka-server api-gateway auth-service

echo "
Servicios disponibles en:
- Admin Panel: http://localhost:4200
- Dashboard Riesgos: http://localhost:4201
- Eureka Server: http://localhost:8761
- API Gateway: http://localhost:8080
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000
" 