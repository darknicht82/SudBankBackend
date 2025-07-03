# 📋 Requirements - SudBankCore Backend

## 🖥️ Requisitos del Sistema

### Sistema Operativo
- **Windows 10/11** (Recomendado)
- **Linux** (Ubuntu 20.04+, CentOS 7+)
- **macOS** (10.15+)

### Hardware Mínimo
- **RAM**: 4 GB (8 GB recomendado)
- **CPU**: 2 cores (4 cores recomendado)
- **Disco**: 10 GB de espacio libre
- **Red**: Conexión a internet para descargar dependencias

## 🔧 Software Requerido

### 1. Java Development Kit (JDK)

#### Para SQL Server Adapter
- **Java 8** (JDK 1.8.0_xxx)
- **Descarga**: [Oracle JDK 8](https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html) o [OpenJDK 8](https://adoptium.net/temurin/releases/?version=8)

#### Para Regulatory Service
- **Java 17** (JDK 17.x.x)
- **Descarga**: [Oracle JDK 17](https://www.oracle.com/java/technologies/downloads/#java17) o [OpenJDK 17](https://adoptium.net/temurin/releases/?version=17)

#### Verificación de Instalación
```bash
# Verificar Java 8
java -version
# Debe mostrar: java version "1.8.0_xxx"

# Verificar Java 17
java17 -version
# Debe mostrar: openjdk version "17.x.x"
```

### 2. Docker Desktop (Opcional - Para contenedores)

#### Windows
- **Docker Desktop for Windows**
- **Descarga**: [Docker Desktop](https://www.docker.com/products/docker-desktop)
- **Requisitos**: WSL 2 habilitado, Hyper-V habilitado

#### Linux
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install docker.io docker-compose

# CentOS/RHEL
sudo yum install docker docker-compose
sudo systemctl start docker
sudo systemctl enable docker
```

#### macOS
- **Docker Desktop for Mac**
- **Descarga**: [Docker Desktop](https://www.docker.com/products/docker-desktop)

#### Verificación de Docker
```bash
docker --version
docker-compose --version
```

### 3. SQL Server

#### Requisitos de Base de Datos
- **SQL Server 2008** o superior
- **Puerto**: 1433 (por defecto)
- **Base de datos**: SBESTRUCTURASCONTROLDB
- **Autenticación**: SQL Server Authentication
- **Usuario**: sa (o usuario con permisos)
- **SSL**: Habilitado para compatibilidad con Java 8

#### Configuración SSL
```sql
-- Habilitar SSL en SQL Server
sp_configure 'show advanced options', 1;
RECONFIGURE;
sp_configure 'force encryption', 1;
RECONFIGURE;
```

### 4. Herramientas Adicionales

#### Git
- **Descarga**: [Git](https://git-scm.com/downloads)
- **Verificación**: `git --version`

#### PowerShell (Windows)
- **Incluido en Windows 10/11**
- **Versión mínima**: 5.1

#### cURL
- **Windows**: Incluido en Windows 10/11
- **Linux**: `sudo apt-get install curl`
- **macOS**: Incluido por defecto

## 📦 Dependencias del Proyecto

### Gradle Wrapper
- **Incluido en el proyecto**
- **Versión**: 8.14.2
- **No requiere instalación adicional**

### Dependencias Java
- **Spring Boot 2.7.18** (SQL Server Adapter)
- **Spring Boot 3.2.6** (Regulatory Service)
- **Spring Security**
- **Spring Data JPA**
- **Hibernate**
- **SQL Server JDBC Driver**

## 🔐 Configuración de Seguridad

### Certificados SSL
- **SQL Server**: Certificado SSL válido
- **Java 8**: Configuración de `java.security` incluida

### Variables de Entorno
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

## 🚀 Instalación Rápida

### 1. Clonar Repositorio
```bash
git clone https://github.com/tu-usuario/SudBankCore-Backend.git
cd SudBankCore-Backend
```

### 2. Configurar Variables de Entorno
```bash
# Copiar template
cp env.template .env

# Editar configuración
notepad .env
```

### 3. Verificar Prerrequisitos
```bash
# Verificar Java
java -version
java17 -version

# Verificar Docker (opcional)
docker --version
```

### 4. Iniciar Servicios

#### Opción A: Docker (Recomendado)
```bash
.\start-docker.bat build
.\start-docker.bat up
```

#### Opción B: Local
```bash
.\start-backend-complete.bat
```

## 🔍 Verificación de Instalación

### Health Checks
```bash
# Verificar servicios
.\verify-services.bat

# Verificación manual
curl http://localhost:8080/actuator/health
curl http://localhost:8085/actuator/health
```

### APIs de Prueba
```bash
# SQL Server Adapter
curl -u admin:sudbank2025 http://localhost:8080/api/regulatory/l08

# Regulatory Service
curl http://localhost:8085/api/regulatory/l08/validate
```

## 🛠️ Solución de Problemas

### Java no encontrado
```bash
# Verificar PATH
echo $env:JAVA_HOME
echo $env:PATH

# Configurar JAVA_HOME
setx JAVA_HOME "C:\Program Files\Java\jdk1.8.0_xxx"
setx JAVA_HOME_17 "C:\Program Files\Java\jdk-17.x.x"
```

### Docker no inicia
```bash
# Verificar Docker Desktop
docker info

# Reiniciar Docker Desktop
# En Windows: Reiniciar desde el menú de sistema
```

### SQL Server no conecta
```bash
# Verificar conectividad
telnet 192.168.10.7 1433

# Verificar configuración SSL
# Revisar logs del SQL Server Adapter
```

### Puertos ocupados
```bash
# Verificar puertos
netstat -ano | findstr :8080
netstat -ano | findstr :8085

# Terminar procesos
taskkill /f /pid <PID>
```

## 📞 Soporte

### Logs de Diagnóstico
```bash
# Ver logs Docker
.\start-docker.bat logs

# Ver logs locales
type sqlserver-adapter\logs\*.log
type backend\modules\regulatory-service\logs\*.log
```

### Información del Sistema
```bash
# Información completa
.\diagnostico-sistema.bat
```

---
**Versión**: 1.0.0  
**Última actualización**: 3 de Julio, 2025  
**Creado por**: Christian Aguirre 
