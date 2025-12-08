wait_for_mysql() {
    echo -e "${YELLOW}⏳ Esperando que MySQL esté listo...${NC}"
    
    local max_attempts=30
    local attempt=1
    local sleep_time=2
    
    while [ $attempt -le $max_attempts ]; do
        if docker exec mysql mysqladmin ping -h localhost -u root -p${DB_PASSWORD} --silent 2>/dev/null; then
            if docker exec mysql mysql -h localhost -u root -p${DB_PASSWORD} -e "SELECT 1 as test;" 2>/dev/null | grep -q "test"; then
                echo -e "${GREEN}✅ MySQL está listo para recibir conexiones y ejecutar consultas${NC}"
                return 0
            else
                echo -e "${YELLOW}⏳ Intento $attempt/$max_attempts - MySQL responde pero no puede ejecutar consultas...${NC}"
            fi
        else
            echo -e "${YELLOW}⏳ Intento $attempt/$max_attempts - MySQL aún no responde...${NC}"
        fi
        
        sleep $sleep_time
        attempt=$((attempt + 1))
    done
    
    echo -e "${RED}❌ MySQL no estuvo listo después de $max_attempts intentos ($(($max_attempts * $sleep_time)) segundos)${NC}"
    return 1
}

wait_for_mysql