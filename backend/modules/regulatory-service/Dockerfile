# Regulatory Service Dockerfile
FROM openjdk:17-jdk-alpine

# Instalar curl para health checks
RUN apk add --no-cache curl

# Crear directorio de trabajo
WORKDIR /app

# Copiar el JAR compilado
COPY build/libs/regulatory-service-1.0.0.jar app.jar

# Exponer puerto
EXPOSE 8085

# Comando de inicio
CMD ["java", "-jar", "app.jar"]

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8085/actuator/health || exit 1 