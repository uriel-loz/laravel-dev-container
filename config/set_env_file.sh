#!/bin/bash

env_file="./project/.env"
# Variables de entorno
db_host="$DB_HOST"
db_user="$DB_USERNAME"
db_pass="$DB_PASSWORD"
db_name="$DB_DATABASE"
db_port="${DB_PORT:-3306}"

create_env_file() {
    local env_file_base="./project/.env.example"

    if [ ! -f "$env_file" ]; then
        cp "$env_file_base" "$env_file"
        echo "Created $env_file"
    fi
}

update_env() {
    local key=$1
    local value=$2
    local file=${3:-"$env_file"}
    
    # Si es DB_PASSWORD, agregar comillas simples
    if [ "$key" = "DB_PASSWORD" ]; then
        value="'$value'"
    fi
    
    awk -v key="$key" -v value="$value" '
    BEGIN { found=0 }
    $0 ~ "^" key "=" { print key "=" value; found=1; next }
    { print }
    END { if (!found) print key "=" value }
    ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
}

set_env() {
    update_env "APP_URL" "http://localhost:8000"
    update_env "DB_HOST" "$db_host"
    update_env "DB_PORT" "$db_port"
    update_env "DB_DATABASE" "$db_name"
    update_env "DB_USERNAME" "$db_user"
    update_env "DB_PASSWORD" "$db_pass"
}

main() {
    create_env_file
    set_env
}

main "$@"