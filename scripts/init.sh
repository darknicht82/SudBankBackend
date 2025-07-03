#!/bin/bash

# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Función para imprimir mensajes
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Verificar si existe el archivo .env
if [ ! -f .env ]; then
    print_error "Archivo .env no encontrado"
    print_message "Por favor, copia .env.example a .env y configura las variables"
    exit 1
fi

# Cargar variables de entorno
source .env

# Verificar requisitos
print_message "Verificando requisitos..."

# Verificar Java
if ! command -v java &> /dev/null; then
    print_error "Java no está instalado"
    exit 1
fi

# Verificar Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker no está instalado"
    exit 1
fi

# Verificar Docker Compose
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose no está instalado"
    exit 1
fi

# Verificar PostgreSQL
if ! command -v psql &> /dev/null; then
    print_warning "PostgreSQL no está instalado localmente"
    print_message "Se usará la versión de Docker"
fi

# Iniciar servicios
print_message "Iniciando servicios..."

# Iniciar Docker Compose
docker-compose up -d

# Esperar a que PostgreSQL esté listo
print_message "Esperando a que PostgreSQL esté listo..."
sleep 10

# Ejecutar scripts SQL
print_message "Ejecutando scripts de base de datos..."

# Obtener la contraseña de PostgreSQL del archivo .env
PGPASSWORD=$POSTGRES_PASSWORD

# Ejecutar scripts en orden
for script in backend/modules/auth-service/src/main/resources/db/*.sql; do
    print_message "Ejecutando $script..."
    psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB -f $script
done

# Verificar servicios
print_message "Verificando servicios..."

# Verificar API Gateway
if curl -s http://localhost:$API_GATEWAY_PORT/actuator/health | grep -q "UP"; then
    print_message "API Gateway está funcionando"
else
    print_error "API Gateway no está funcionando"
fi

# Verificar Auth Service
if curl -s http://localhost:$AUTH_SERVICE_PORT/actuator/health | grep -q "UP"; then
    print_message "Auth Service está funcionando"
else
    print_error "Auth Service no está funcionando"
fi

# Verificar Eureka Server
if curl -s http://localhost:$EUREKA_SERVER_PORT/actuator/health | grep -q "UP"; then
    print_message "Eureka Server está funcionando"
else
    print_error "Eureka Server no está funcionando"
fi

print_message "Inicialización completada"
print_message "Puedes acceder a los servicios en:"
print_message "API Gateway: http://localhost:$API_GATEWAY_PORT"
print_message "Auth Service: http://localhost:$AUTH_SERVICE_PORT"
print_message "Eureka Server: http://localhost:$EUREKA_SERVER_PORT" 