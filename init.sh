#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar si existe el archivo .env
if [ ! -f ".env" ]; then
    echo -e "${RED}❌ Error: No se encontró el archivo .env${NC}"
    echo -e "${YELLOW}💡 Crea un archivo .env con las variables necesarias${NC}"
    exit 1
fi

# Cargar variables de entorno desde .env
echo -e "${GREEN}📋 Cargando variables de entorno desde .env...${NC}"
set -a  # Exportar automáticamente todas las variables
source .env
set +a  # Desactivar exportación automática

bash config/set_env_file.sh

echo -e "${GREEN}🚀 Iniciando servicios de Laravel con Docker...${NC}"

# Verificar si la carpeta vendor existe
if [ ! -d "project/vendor" ]; then
    echo -e "${YELLOW}📦 Carpeta vendor no encontrada. Ejecutando Composer...${NC}"
    
    # Obtener UID y GID del usuario actual
    export readonly UID=$(id -u)
    export readonly GID=$(id -g)

    # Ejecutar composer con el perfil específico
    docker compose run --rm composer
    
    echo -e "${GREEN}✅ Dependencias de Composer instaladas${NC}"
else
    echo -e "${GREEN}✅ Carpeta vendor ya existe, omitiendo Composer${NC}"
fi

echo -e "${GREEN}✅ Configuración de MCP para MySQL${NC}"
bash config/set_mcp_mysql.sh

echo -e "${GREEN}✅ Configuración de MCP para MySQL generada correctamente${NC}"

echo -e "${GREEN}✅ Iniciando servicios mysql y php...${NC}"
docker compose up -d mysql php

echo -e "${GREEN}✅ Generando nueva llave de aplicacion${NC}"
docker exec -it php php artisan key:generate

bash mysql/wait_service.sh

echo -e "${GREEN}✅ Ejecutando migraciones: ${NC}" 
docker exec -it php php artisan migrate --seed

# echo -e "${GREEN}✅ Estableciendo nuevas claves de passport: ${NC}"
# docker exec -it php php artisan passport:client --password
# docker exec -it php php artisan passport:keys --force
# echo -e "${RED}✅ Claves de passport generadas no olvides copiar el cliente \
# y la clave en el archivo .env en la carpeta project${NC}"