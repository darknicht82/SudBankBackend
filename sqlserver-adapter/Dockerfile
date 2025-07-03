# SQL Server Adapter Dockerfile
FROM openjdk:8-jdk-alpine

# Instalar curl para health checks
RUN apk add --no-cache curl

# Crear directorio de trabajo
WORKDIR /app

# Copiar el JAR compilado
COPY build/libs/sqlserver-adapter-1.0.0.jar app.jar

# Exponer puerto
EXPOSE 8080

# Comando de inicio
CMD ["java", "-jar", "app.jar"]

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1 