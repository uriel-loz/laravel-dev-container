# 🚀 Laravel Local Development Environment

Entorno de desarrollo local para proyectos Laravel utilizando Docker Compose. Esta herramienta simplifica la configuración y ejecución de aplicaciones Laravel con MySQL, PHP y Composer de forma containerizada.

## 📋 Descripción

Este proyecto proporciona un entorno Docker completo y listo para usar que incluye:

- **PHP**: Servidor de desarrollo con todas las extensiones necesarias para Laravel
- **MySQL 8.0**: Base de datos relacional
- **Composer**: Gestor de dependencias de PHP
- **Scripts automatizados**: Para inicialización y configuración del proyecto

El sistema está diseñado para ser intuitivo y rápido de configurar, permitiéndote enfocarte en desarrollar tu aplicación Laravel sin preocuparte por la infraestructura local.

## 🛠️ Características

- ✅ Configuración automatizada del entorno Laravel
- ✅ Instalación automática de dependencias con Composer
- ✅ Generación de claves de aplicación
- ✅ Ejecución automática de migraciones
- ✅ Verificación de disponibilidad de MySQL antes de ejecutar comandos
- ✅ Configuración de permisos de usuario para evitar problemas con archivos generados
- ✅ Scripts con indicadores visuales de progreso

## 📦 Requisitos

- Docker
- Docker Compose
- Un proyecto Laravel en la carpeta `project/`

## ⚙️ Instalación y Configuración

### 1. Configurar el archivo .env

**⚠️ IMPORTANTE**: Antes de ejecutar cualquier comando, debes configurar correctamente el archivo `.env` en la raíz del proyecto.

1. Copia el archivo de ejemplo:
   ```bash
   cp .env.example .env
   ```

2. Edita el archivo `.env` y configura las siguientes variables:

   ```env
   # Database Configuration
   DB_HOST=mysql
   DB_PORT=3306
   DB_DATABASE=nombre_de_tu_base_de_datos
   DB_USERNAME=tu_usuario
   DB_PASSWORD=tu_contraseña_segura

   # Port Configuration
   PHP_PORT=8000
   MYSQL_PORT=3306

   # User Configuration (for Composer)
   UID=1000
   GID=1000
   ```

   **Notas importantes:**
   - `DB_HOST` debe ser `mysql` (nombre del contenedor)
   - `DB_PORT` debe ser `3306` (puerto interno de MySQL)
   - `PHP_PORT` es el puerto donde se expondrá tu aplicación Laravel (por defecto 8000)
   - `UID` y `GID` deben coincidir con tu usuario del sistema (usa `id -u` y `id -g` para obtenerlos)

### 2. Colocar tu proyecto Laravel

Coloca tu proyecto Laravel en la carpeta `project/`. Si es un proyecto nuevo, asegúrate de que contenga un archivo `.env.example` válido.

### 3. Ejecutar el script de inicialización

Una vez configurado el archivo `.env`, ejecuta el script principal:

```bash
bash init.sh
```

Este script realizará automáticamente las siguientes acciones:

1. ✅ Validar que existe el archivo `.env`
2. ✅ Cargar las variables de entorno
3. ✅ Configurar el archivo `.env` del proyecto Laravel
4. ✅ Instalar dependencias de Composer (si no existe `vendor/`)
5. ✅ Iniciar los contenedores de MySQL y PHP
6. ✅ Generar la clave de aplicación de Laravel
7. ✅ Esperar a que MySQL esté completamente disponible
8. ✅ Ejecutar las migraciones de la base de datos

## 🎯 Uso

### Iniciar el entorno

```bash
bash init.sh
```

### Acceder a la aplicación

Una vez iniciado, tu aplicación Laravel estará disponible en:

```
http://localhost:8000
```

(O el puerto que hayas configurado en `PHP_PORT`)

### Detener los servicios

```bash
docker compose down
```

### Ver logs de los contenedores

```bash
docker compose logs -f php
docker compose logs -f mysql
```

### Ejecutar comandos de Artisan

```bash
docker exec -it php php artisan <comando>
```

Ejemplos:
```bash
docker exec -it php php artisan migrate
docker exec -it php php artisan tinker
docker exec -it php php artisan make:model NombreModelo
```

### Acceder al contenedor PHP

```bash
docker exec -it php bash
```

### Acceder a MySQL

```bash
docker exec -it mysql mysql -u root -p
```

## 📁 Estructura del Proyecto

```
.
├── config/
│   └── set_env_file.sh          # Script para configurar .env del proyecto Laravel
├── mysql/
│   └── wait_service.sh          # Script para esperar disponibilidad de MySQL
├── php/
│   └── Dockerfile               # Imagen PHP con extensiones necesarias
├── project/                     # Tu proyecto Laravel va aquí
├── docker-compose.yml           # Configuración de servicios Docker
├── .env                         # Variables de entorno (NO INCLUIR EN GIT)
├── .env.example                 # Plantilla de variables de entorno
└── init.sh                      # Script principal de inicialización
```

## 🔧 Servicios Docker

### PHP
- Basado en `php:latest`
- Incluye extensiones: pdo_mysql, mbstring, exif, pcntl, bcmath, gd, zip
- Expone el puerto configurado en `PHP_PORT` (por defecto 8000)
- Ejecuta `php artisan serve`

### MySQL
- Versión 8.0
- Puerto interno: 3306
- Datos persistentes en volumen Docker
- Credenciales configurables via `.env`

### Composer
- Se ejecuta bajo demanda para instalar dependencias
- Usa el UID/GID del usuario para evitar problemas de permisos

## 🐛 Solución de Problemas

### El script init.sh falla con "No se encontró el archivo .env"

**Solución**: Asegúrate de crear y configurar el archivo `.env` antes de ejecutar el script.

### Problemas de permisos con archivos generados

**Solución**: Verifica que `UID` y `GID` en el archivo `.env` coincidan con tu usuario:
```bash
id -u  # Obtiene tu UID
id -g  # Obtiene tu GID
```

### MySQL no está listo

**Solución**: El script espera automáticamente hasta 60 segundos. Si persiste el problema, verifica que el puerto 3306 no esté ocupado:
```bash
sudo netstat -tlnp | grep 3306
```

### No puedo acceder a la aplicación en localhost:8000

**Solución**: 
1. Verifica que el contenedor PHP esté corriendo: `docker ps`
2. Verifica que el puerto no esté ocupado: `sudo netstat -tlnp | grep 8000`
3. Revisa los logs: `docker compose logs php`

## 📝 Notas Adicionales

- El archivo `.env` en la raíz del proyecto NO debe incluirse en el control de versiones (Git)
- Las dependencias de Composer se instalan automáticamente la primera vez
- El script detecta si ya existen las dependencias para no reinstalarlas innecesariamente
- Se incluyen scripts comentados para Laravel Passport si lo necesitas en el futuro

## 🤝 Contribuciones

Si encuentras algún problema o tienes sugerencias de mejora, no dudes en crear un issue o pull request.

## 📄 Licencia

Este proyecto es de código abierto y está disponible para uso libre en proyectos de desarrollo local.
