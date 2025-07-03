# 🏦 SudBankCore Backend

Sistema backend completo para reportes regulatorios bancarios con arquitectura de microservicios.

## 📋 Descripción

SudBankCore Backend es una solución completa para la generación y validación de reportes regulatorios bancarios, implementando el reporte L08 - Liquidez Estructural con arquitectura de microservicios.

## 🏗️ Arquitectura

### Servicios
- **SQL Server Adapter** (Puerto 8080) - Java 8
  - Conecta con SQL Server 2008
  - Maneja la lógica de negocio de reportes
  - Autenticación básica

- **Regulatory Service** (Puerto 8085) - Java 17
  - Servicio de validación y procesamiento
  - Integración con SQL Server Adapter
  - APIs REST para reportes regulatorios

## 🚀 Inicio Rápido

### 📋 Pre-requisitos
Ver archivo `REQUIREMENTS.md` para detalles completos.

**Software Requerido:**
- Java 8 (para SQL Server Adapter)
- Java 17 (para Regulatory Service)
- Docker Desktop (opcional, para contenedores)
- SQL Server 2008+ (configurado)

### 🎯 Scripts Inteligentes (Recomendados)

#### `auto-start.bat` - Inicio Completamente Automático
- ✅ Detecta si los servicios ya están ejecutándose
- ✅ Verifica prerrequisitos automáticamente
- ✅ Descarga dependencias si es necesario
- ✅ Elige entre Docker y modo local
- ✅ Configura todo automáticamente

#### `setup-and-run.bat` - Setup Inteligente con Menú
- 🔍 Analiza la estructura del proyecto
- 🔍 Verifica prerrequisitos del sistema
- 🔍 Detecta problemas y sugiere soluciones
- 🔍 Menú interactivo para diferentes opciones

### Opción 1: Inicio Completo (Manual)
```bash
# Ejecutar script principal
.\start-backend-complete.bat
```

### Opción 2: Servicios Individuales
```bash
# SQL Server Adapter
.\start-sqlserver-adapter.bat

# Regulatory Service
.\start-regulatory-service.bat
```

### Opción 3: Docker
```bash
# Inicio completo con Docker
docker-compose -f docker-compose-backend.yml up -d

# Con adapter externo
docker-compose -f docker-compose-external-adapter.yml up -d
```

## 🔍 Verificación

### Health Checks
```bash
# Verificar ambos servicios
.\verify-services.bat

# Verificación manual
curl http://localhost:8080/actuator/health
curl http://localhost:8085/actuator/health
```

### APIs Disponibles
```bash
# Reporte L08 (con autenticación)
curl -u admin:sudbank2025 http://localhost:8080/api/regulatory/l08

# Validación L08
curl http://localhost:8085/api/regulatory/l08/validate

# Generación de reporte
curl -X POST http://localhost:8085/api/regulatory/l08/generate
```

## 📁 Estructura del Proyecto

```
SudBankBackend/
├── sqlserver-adapter/          # Servicio Java 8 (Puerto 8080)
│   ├── src/                    # Código fuente
│   ├── build.gradle           # Configuración Gradle
│   └── Dockerfile             # Imagen Docker
├── backend/
│   └── modules/
│       └── regulatory-service/ # Servicio Java 17 (Puerto 8085)
│           ├── src/            # Código fuente
│           ├── build.gradle    # Configuración Gradle
│           └── Dockerfile      # Imagen Docker
├── scripts/                    # Scripts de gestión
├── docker-compose-backend.yml  # Docker Compose completo
├── docker-compose-external-adapter.yml # Docker con adapter externo
├── env.template               # Template de variables de entorno
└── README.md                  # Este archivo
```

## ⚙️ Configuración

### Variables de Entorno
Copia `env.template` a `.env` y configura:

```bash
# Base de datos
DB_HOST=
DB_PORT=
DB_NAME=
DB_USERNAME=
DB_PASSWORD=

# Servicios
SQLSERVER_ADAPTER_PORT=8080
REGULATORY_SERVICE_PORT=8085

# Seguridad
SPRING_SECURITY_USER_NAME=
SPRING_SECURITY_USER_PASSWORD=
```

### Configuración de Base de Datos
- **Servidor**: SQL Server 2008+
- **Base de datos**: SBESTRUCTURASCONTROLDB
- **Autenticación**: SQL Server Authentication
- **SSL**: Configurado para compatibilidad con Java 8

## 🔧 Desarrollo

### Compilación
```bash
# SQL Server Adapter
cd sqlserver-adapter
.\gradlew.bat build -x test

# Regulatory Service
cd backend/modules/regulatory-service
.\gradlew.bat build -x test
```

### Logs
Los logs se encuentran en:
- SQL Server Adapter: `sqlserver-adapter/logs/`
- Regulatory Service: `backend/modules/regulatory-service/logs/`

## 🐳 Docker

### Gestión Simplificada con Scripts
```bash
# Construir imágenes
.\start-docker.bat build

# Iniciar servicios
.\start-docker.bat up

# Verificar estado
.\start-docker.bat status

# Ver logs
.\start-docker.bat logs

# Detener servicios
.\start-docker.bat down

# Reiniciar servicios
.\start-docker.bat restart
```

### Comandos Docker Directos
```bash
# Construir imágenes
docker-compose -f docker-compose-backend.yml build

# Iniciar contenedores
docker-compose -f docker-compose-backend.yml up -d

# Verificar contenedores
docker-compose -f docker-compose-backend.yml ps

# Ver logs
docker logs sudbankcore-sqlserver-adapter
docker logs sudbankcore-regulatory-service

# Detener contenedores
docker-compose -f docker-compose-backend.yml down
```

### Configuración Docker
- **SQL Server Adapter**: Puerto 8080, Java 8
- **Regulatory Service**: Puerto 8085, Java 17
- **Red**: `sudbankcore-network`
- **Volúmenes**: `./logs` y `./reports`
- **Health Checks**: Configurados para ambos servicios

## 📊 Reportes Implementados

### L08 - Liquidez Estructural
- ✅ **Generación**: Completamente funcional
- ✅ **Validación**: Implementada
- ✅ **Autenticación**: Configurada
- ✅ **Base de datos**: Conectada

## 🛠️ Solución de Problemas

### Error de SSL con SQL Server
Si hay problemas de conexión SSL:
1. Verificar que se use Java 8 para SQL Server Adapter
2. Revisar configuración de `java.security`
3. Verificar configuración de SQL Server

### Servicios no responden
1. Verificar que los puertos 8080 y 8085 estén libres
2. Revisar logs en las ventanas de comando
3. Ejecutar `.\verify-services.bat`

### Problemas de compilación
1. Verificar versiones de Java (8 y 17)
2. Limpiar cache: `.\gradlew.bat clean`
3. Actualizar dependencias: `.\gradlew.bat --refresh-dependencies`

## 📞 Soporte

Para soporte técnico:
1. Revisar logs de los servicios
2. Verificar configuración de base de datos
3. Ejecutar scripts de verificación
4. Consultar documentación técnica incluida

## 🐙 GitHub

### Preparación para GitHub
```bash
# Limpiar archivos no necesarios
.\clean-for-github.bat

# Verificar estructura
# Ver archivo GITHUB_STRUCTURE.md para detalles
```

### Archivos Importantes
- `REQUIREMENTS.md` - Prerrequisitos completos del sistema
- `GITHUB_STRUCTURE.md` - Estructura recomendada para GitHub
- `clean-for-github.bat` - Script de limpieza automática
- `.gitignore` - Archivos excluidos del repositorio

### Tamaño del Repositorio
- **Estimado**: ~4 MB (solo código fuente y configuración)
- **Excluidos**: Archivos compilados, logs, cache (~100-500 MB)

## ✅ Estado del Sistema

**🟢 COMPLETAMENTE FUNCIONAL**

- ✅ SQL Server Adapter: Operativo
- ✅ Regulatory Service: Operativo
- ✅ Base de datos: Conectada
- ✅ APIs: Respondiendo
- ✅ Docker: Configurado
- ✅ Scripts: Funcionando

---

**Última actualización**: 2025-07-03
**Versión**: 1.0.0
**Estado**: Listo para producción
**Creado por** Christian Aguirre

## 📚 Documentación Extendida

Toda la documentación técnica, requisitos, estructura y estado del sistema se encuentra en la carpeta [`wiki/`](./wiki/).

- [Índice de la Wiki](./wiki/INDEX.md)
- [Requisitos del sistema](./wiki/REQUISITOS.md)
- [Estructura para GitHub](./wiki/ESTRUCTURA_GITHUB.md)
- [Estado completo del sistema](./wiki/ESTADO_COMPLETO.md)

Para dudas rápidas, consulta este README. Para detalles técnicos, revisa la wiki.
