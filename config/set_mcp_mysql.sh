#!/bin/bash

# Archivos a generar
open_code_file="./project/opencode.json"
vscode_code_file="./project/.vscode/mcp.json"
# windsurf_code_file="./project/.windsurf/mcp.json"

# Variables de entorno
db_user="$DB_USERNAME"
db_pass="$DB_PASSWORD"
db_name="$DB_DATABASE"
db_port="${DB_PORT:-3306}"

create_mcp_files() {
    # Crear archivo opencode si no existe
    [ ! -f "$open_code_file" ] && touch "$open_code_file"

    # Si estamos en WSL, crear archivos para VS Code
    if [ -n "$WSL_DISTRO_NAME" ]; then
        # Crear directorio .vscode si no existe
        mkdir -p "$(dirname "$vscode_code_file")"
        [ ! -f "$vscode_code_file" ] && touch "$vscode_code_file"
    # else
    #     # Crear directorio .windsurf si no existe
    #     mkdir -p "$(dirname "$windsurf_code_file")"
    #     [ ! -f "$windsurf_code_file" ] && touch "$windsurf_code_file"
        
    fi
}

content_opencode() {
    cat > "$open_code_file" <<EOL
{
  "\$schema": "https://opencode.ai/config.json",
    "mcp": {
        "mysql": {
            "type": "local",
            "command": ["npx", "-y", "@benborla29/mcp-server-mysql"],
            "environment": {
                "MYSQL_HOST": "127.0.0.1",
                "MYSQL_PORT": "$db_port",
                "MYSQL_USER": "$db_user",
                "MYSQL_PASS": "$db_pass",
                "MYSQL_DB": "$db_name",
                "ALLOW_INSERT_OPERATION": "false",
                "ALLOW_UPDATE_OPERATION": "false",
                "ALLOW_DELETE_OPERATION": "false"
            },
            "enabled": true
        }
    }
}
EOL
}

content_vscode() {
    cat > "$vscode_code_file" <<EOL
{
  "servers": {
    "mysql": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@benborla29/mcp-server-mysql"],
      "env": {
        "MYSQL_HOST": "127.0.0.1",
        "MYSQL_PORT": "$db_port",
        "MYSQL_USER": "$db_user",
        "MYSQL_PASS": "$db_pass",
        "MYSQL_DB": "$db_name",
        "ALLOW_INSERT_OPERATION": "false",
        "ALLOW_UPDATE_OPERATION": "false",
        "ALLOW_DELETE_OPERATION": "false"
      }
    }
  }
}
EOL
}

content_windsurf() {
    cat > "$windsurf_code_file" <<EOL
{
  "mcpServers": {
    "mysql": {
      "command": "npx",
      "args": ["-y", "@benborla29/mcp-server-mysql"],
      "env": {
        "MYSQL_HOST": "127.0.0.1",
        "MYSQL_PORT": "$db_port",
        "MYSQL_USER": "$db_user",
        "MYSQL_PASS": "$db_pass",
        "MYSQL_DB": "$db_name",
        "ALLOW_INSERT_OPERATION": "false",
        "ALLOW_UPDATE_OPERATION": "false",
        "ALLOW_DELETE_OPERATION": "false"
      }
    }
  }
}
EOL
}

add_files_gitignore() {
    # Agregar archivos a .gitignore
    if [ -f "./project/.gitignore" ]; then
        grep -qxF "opencode.json" "./project/.gitignore" || echo -e "\nopencode.json" >> "./project/.gitignore"
        if [ -n "$WSL_DISTRO_NAME" ]; then
            grep -qxF ".vscode/mcp.json" "./project/.gitignore" || echo -e "\n.vscode/mcp.json" >> "./project/.gitignore"
        # else
        #     grep -qxF ".windsurf/mcp.json" "./project/.gitignore" || echo -e "\n.windsurf/mcp.json" >> "./project/.gitignore"
        fi
    fi
}

set_mcp_mysql() {
    create_mcp_files
    content_opencode

    if [ -n "$WSL_DISTRO_NAME" ]; then
        content_vscode
    # else
    #     content_windsurf
    fi

    add_files_gitignore
}

set_mcp_mysql "$@"