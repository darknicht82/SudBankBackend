# 📁 Estructura para GitHub - SudBankCore Backend

## 🎯 Carpetas y Archivos a Subir

### ✅ **OBLIGATORIOS** (Siempre incluir)

```
SudBankCore-Backend/
├── 📁 sqlserver-adapter/           # Servicio Java 8
│   ├── 📁 src/                     # Código fuente
│   ├── 📁 gradle/                  # Gradle wrapper
│   ├── 📄 build.gradle            # Configuración Gradle
│   ├── 📄 settings.gradle         # Configuración Gradle
│   ├── 📄 gradlew                 # Gradle wrapper (Linux/Mac)
│   ├── 📄 gradlew.bat             # Gradle wrapper (Windows)
│   ├── 📄 Dockerfile              # Imagen Docker
│   └── 📄 java.security           # Configuración SSL Java 8
│
├── 📁 backend/
│   └── 📁 modules/
│       └── 📁 regulatory-service/  # Servicio Java 17
│           ├── 📁 src/             # Código fuente
│           ├── 📁 gradle/          # Gradle wrapper
│           ├── 📄 build.gradle     # Configuración Gradle
│           ├── 📄 settings.gradle  # Configuración Gradle
│           ├── 📄 gradlew          # Gradle wrapper (Linux/Mac)
│           ├── 📄 gradlew.bat      # Gradle wrapper (Windows)
│           └── 📄 Dockerfile       # Imagen Docker
│
├── 📁 scripts/                     # Scripts de gestión
│   ├── 📄 backend-start.ps1       # Script PowerShell
│   ├── 📄 check-sqlserver-config.ps1
│   └── 📄 [otros scripts .ps1]
│
├── 📄 README.md                    # Documentación principal
├── 📄 REQUIREMENTS.md             # Requisitos del sistema
├── 📄 .gitignore                  # Archivos a ignorar
├── 📄 env.template                # Template de variables
├── 📄 docker-compose-backend.yml  # Docker Compose principal
├── 📄 docker-compose-external-adapter.yml # Docker con adapter externo
├── 📄 start-docker.bat            # Script Docker
├── 📄 start-backend-complete.bat  # Script inicio completo
├── 📄 start-sqlserver-adapter.bat # Script SQL Server Adapter
├── 📄 start-regulatory-service.bat # Script Regulatory Service
└── 📄 verify-services.bat         # Script verificación
```

### ❌ **NO SUBIR** (Excluidos por .gitignore)

```
❌ .gradle/                         # Cache de Gradle
❌ build/                          # Archivos compilados
❌ logs/                           # Logs de ejecución
❌ reports/                        # Reportes generados
❌ .settings/                      # Configuración IDE
❌ .idea/                          # Configuración IntelliJ
❌ .vscode/                        # Configuración VS Code
❌ .env                            # Variables de entorno (sensible)
❌ *.log                           # Archivos de log
❌ *.jar                           # Archivos JAR compilados
❌ *.zip                           # Archivos ZIP
❌ backup-*/                       # Carpetas de backup
```

## 🚀 Comandos para Preparar GitHub

### 1. Limpiar Archivos No Necesarios
```bash
# Eliminar archivos compilados
Remove-Item -Recurse -Force sqlserver-adapter\build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force backend\modules\regulatory-service\build -ErrorAction SilentlyContinue

# Eliminar logs
Remove-Item -Recurse -Force logs -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force reports -ErrorAction SilentlyContinue

# Eliminar cache de Gradle
Remove-Item -Recurse -Force sqlserver-adapter\.gradle -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force backend\modules\regulatory-service\.gradle -ErrorAction SilentlyContinue
```

### 2. Verificar Estructura
```bash
# Verificar que los archivos esenciales estén presentes
Get-ChildItem -Recurse -File | Where-Object {
    $_.Name -match "\.(gradle|java|yml|yaml|bat|ps1|md|gitignore|Dockerfile)$"
} | Select-Object FullName
```

### 3. Inicializar Git (si no existe)
```bash
# Inicializar repositorio
git init

# Agregar archivos
git add .

# Commit inicial
git commit -m "Initial commit: SudBankCore Backend v1.0.0"

# Agregar remoto
git remote add origin https://github.com/tu-usuario/SudBankCore-Backend.git

# Subir a GitHub
git push -u origin main
```

## 📋 Checklist Pre-GitHub

### ✅ Archivos de Configuración
- [ ] `.gitignore` configurado correctamente
- [ ] `README.md` actualizado y completo
- [ ] `REQUIREMENTS.md` incluido
- [ ] `env.template` presente (sin datos sensibles)

### ✅ Código Fuente
- [ ] `sqlserver-adapter/src/` completo
- [ ] `backend/modules/regulatory-service/src/` completo
- [ ] `build.gradle` y `settings.gradle` en ambos servicios
- [ ] `gradlew` y `gradlew.bat` en ambos servicios

### ✅ Scripts y Docker
- [ ] Todos los scripts `.bat` presentes
- [ ] `Dockerfile` en ambos servicios
- [ ] `docker-compose-backend.yml` configurado
- [ ] `start-docker.bat` funcional

### ✅ Documentación
- [ ] `README.md` con instrucciones claras
- [ ] `REQUIREMENTS.md` con todos los prerrequisitos
- [ ] Comentarios en código importantes
- [ ] Configuración de seguridad documentada

### ❌ Archivos Excluidos
- [ ] No hay archivos `.env` con datos sensibles
- [ ] No hay archivos `build/` o `.gradle/`
- [ ] No hay archivos `logs/` o `reports/`
- [ ] No hay archivos de configuración IDE

## 🔧 Configuración Post-Clone

### Para Nuevos Usuarios
```bash
# 1. Clonar repositorio
git clone https://github.com/tu-usuario/SudBankCore-Backend.git
cd SudBankCore-Backend

# 2. Configurar variables de entorno
copy env.template .env
# Editar .env con configuración local

# 3. Verificar prerrequisitos
java -version
java17 -version
docker --version

# 4. Iniciar servicios
.\start-docker.bat up
# o
.\start-backend-complete.bat
```

## 📊 Tamaño Estimado del Repositorio

### Archivos Incluidos
- **Código fuente**: ~2 MB
- **Configuración**: ~1 MB
- **Scripts**: ~500 KB
- **Documentación**: ~300 KB
- **Gradle wrapper**: ~100 KB
- **Total estimado**: ~4 MB

### Archivos Excluidos
- **Archivos compilados**: ~50-100 MB
- **Logs**: Variable
- **Cache**: ~200-500 MB
- **Reportes**: Variable

## 🎯 Beneficios de Esta Estructura

1. **Ligero**: Solo código fuente y configuración
2. **Seguro**: Sin datos sensibles
3. **Portable**: Funciona en cualquier sistema
4. **Mantenible**: Estructura clara y organizada
5. **Escalable**: Fácil de extender

---
**Versión**: 1.0.0  
**Última actualización**: 3 de Julio, 2025  
**Creado por**: Christian Aguirre 