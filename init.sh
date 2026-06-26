#!/usr/bin/env bash

# =============================================================================
# LKSFerreira - Inicializador de Template Multiagente
# =============================================================================

GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

FILES_TO_COPY=(
    ".agents"
    ".editorconfig"
    ".gitattributes"
    ".gitignore"
    ".metadocs"
    ".vscode"
    "AGENTS.md"
    "README.md"
    "ROADMAP.md"
    "HISTORY.md"
)

FILES_DOCKER=(
    "dev.sh"
    "exec.sh"
)

CONTEXT="projeto"
USAR_DOCKER=false
DOCKER_STACK="node"
USAR_POSTGRES=false

show_header() {
    clear
    echo -e "${CYAN}=======================================================${NC}"
    echo -e "${GREEN}    LKSFerreira - MIGRAR TEMPLATE MULTIAGENTE          ${NC}"
    echo -e "${CYAN}=======================================================${NC}"
    echo ""
}

choose_context() {
    echo -e "\n${CYAN}Escolha o contexto de inicialização:${NC}"
    echo -e "  ${YELLOW}1${NC} - Projeto (produção, arquitetura e qualidade)"
    echo -e "  ${YELLOW}2${NC} - Estudo (aprendizado, didática e registro)"
    read -r -p "Opção [1]: " context_option

    case "$context_option" in
        2) CONTEXT="estudo" ;;
        *) CONTEXT="projeto" ;;
    esac

    echo -e "${GREEN}Contexto selecionado:${NC} ${YELLOW}$CONTEXT${NC}"
}

choose_docker_stack() {
    echo -e "\n${CYAN}Escolha a stack Docker:${NC}"
    echo -e "  ${YELLOW}1${NC}  - node (fullstack Node/Vite/Express)"
    echo -e "  ${YELLOW}2${NC}  - javascript-vite"
    echo -e "  ${YELLOW}3${NC}  - javascript-express"
    echo -e "  ${YELLOW}4${NC}  - python"
    echo -e "  ${YELLOW}5${NC}  - python-fastapi"
    echo -e "  ${YELLOW}6${NC}  - python-django"
    echo -e "  ${YELLOW}7${NC}  - java"
    echo -e "  ${YELLOW}8${NC}  - java-spring"
    echo -e "  ${YELLOW}9${NC}  - go"
    echo -e "  ${YELLOW}10${NC} - rust"
    echo -e "  ${YELLOW}11${NC} - php-laravel"
    echo -e "  ${YELLOW}12${NC} - cpp"
    echo -e "  ${YELLOW}13${NC} - postgres (somente banco)"
    read -r -p "Stack [1]: " stack_option

    case "$stack_option" in
        2) DOCKER_STACK="javascript-vite" ;;
        3) DOCKER_STACK="javascript-express" ;;
        4) DOCKER_STACK="python" ;;
        5) DOCKER_STACK="python-fastapi" ;;
        6) DOCKER_STACK="python-django" ;;
        7) DOCKER_STACK="java" ;;
        8) DOCKER_STACK="java-spring" ;;
        9) DOCKER_STACK="go" ;;
        10) DOCKER_STACK="rust" ;;
        11) DOCKER_STACK="php-laravel" ;;
        12) DOCKER_STACK="cpp" ;;
        13) DOCKER_STACK="postgres" ;;
        *) DOCKER_STACK="node" ;;
    esac

    if [ "$DOCKER_STACK" = "postgres" ]; then
        USAR_POSTGRES=true
    else
        echo -e "\n${CYAN}Deseja incluir PostgreSQL no Compose?${NC}"
        echo -e "   ${YELLOW}s${NC} / ${YELLOW}sim${NC} - adiciona serviço database"
        echo -e "   ${YELLOW}n${NC} / ${YELLOW}nao${NC} - somente aplicação"
        read -r -p "Opção [n]: " postgres_option
        if [[ "$postgres_option" =~ ^[Ss](im)?$ ]]; then
            USAR_POSTGRES=true
        else
            USAR_POSTGRES=false
        fi
    fi

    echo -e "${GREEN}Stack Docker:${NC} ${YELLOW}$DOCKER_STACK${NC}"
}

choose_docker() {
    echo -e "\n${CYAN}Deseja criar estrutura Docker pronta para uso?${NC}"
    echo -e "   ${YELLOW}s${NC} / ${YELLOW}sim${NC} - cria .docker, compose.yaml, Dockerfile e envs"
    echo -e "   ${YELLOW}n${NC} / ${YELLOW}nao${NC} - pula configuração Docker"
    read -r -p "Opção [n]: " docker_option

    if [[ "$docker_option" =~ ^[Ss](im)?$ ]]; then
        USAR_DOCKER=true
        choose_docker_stack
    else
        USAR_DOCKER=false
        echo -e "${YELLOW}Docker ignorado.${NC}"
    fi
}

dockerfile_for_stack() {
    case "$1" in
        node|javascript-vite|javascript-express) echo "Dockerfile.node" ;;
        python|python-fastapi|python-django) echo "Dockerfile.python" ;;
        java|java-spring) echo "Dockerfile.java" ;;
        go) echo "Dockerfile.go" ;;
        rust) echo "Dockerfile.rust" ;;
        php-laravel) echo "Dockerfile.php" ;;
        cpp) echo "Dockerfile.cpp" ;;
        postgres) echo "Dockerfile.postgres" ;;
        *) echo "" ;;
    esac
}

slugify_project_name() {
    local raw_name
    raw_name="$(basename "$1")"
    local slug
    slug="$(echo "$raw_name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/_/g; s/^_+//; s/_+$//')"
    if [ -z "$slug" ]; then
        slug="app"
    fi
    echo "$slug"
}

write_node_service() {
    local compose_file="$1"
    local stack="$2"

    local ports=""
    case "$stack" in
        node)
            ports='    ports:
      - "5173:5173"
      - "3000:3000"'
            ;;
        javascript-vite)
            ports='    ports:
      - "5173:5173"'
            ;;
        javascript-express)
            ports='    ports:
      - "3000:3000"'
            ;;
    esac

    cat >> "$compose_file" <<EOF
  app:
    build:
      context: ../
      dockerfile: .docker/Dockerfile.node
      target: dev
$ports
    volumes:
      - ../:/app
      - /app/node_modules
    working_dir: /app
    stdin_open: true
    tty: true
    env_file:
      - ../.env
    environment:
      - NODE_ENV=development
      - APP_ENV=development
      - WATCHPACK_POLLING=true
      - HOST_IP=\${HOST_IP:-}
EOF

    if [ "$USAR_POSTGRES" = true ]; then
        cat >> "$compose_file" <<'EOF'
    depends_on:
      - database
EOF
    fi
}

write_python_service() {
    local compose_file="$1"
    local stack="$2"

    local ports=""
    if [ "$stack" = "python-fastapi" ] || [ "$stack" = "python-django" ]; then
        ports='    ports:
      - "8000:8000"'
    fi

    cat >> "$compose_file" <<EOF
  app:
    build:
      context: ../
      dockerfile: .docker/Dockerfile.python
      target: dev
$ports
    volumes:
      - ../:/app
    working_dir: /app
    stdin_open: true
    tty: true
    env_file:
      - ../.env
    environment:
      - PYTHON_ENV=development
      - APP_ENV=development
EOF

    if [ "$USAR_POSTGRES" = true ]; then
        cat >> "$compose_file" <<'EOF'
    depends_on:
      - database
EOF
    fi
}

write_generic_service() {
    local compose_file="$1"
    local stack="$2"
    local dockerfile="$3"
    local working_dir="/app"
    local ports=""
    local extra_volumes=""
    local environment_name="APP_ENV"
    local environment_value="development"

    case "$stack" in
        java)
            environment_name="JAVA_ENV"
            ;;
        java-spring)
            ports='    ports:
      - "8080:8080"'
            environment_name="SPRING_PROFILES_ACTIVE"
            environment_value="dev"
            ;;
        go)
            ports='    ports:
      - "8080:8080"'
            environment_name="GO_ENV"
            ;;
        rust)
            ports='    ports:
      - "8080:8080"'
            environment_name="RUST_ENV"
            extra_volumes='      - cargo-cache:/usr/local/cargo/registry
      - target-cache:/app/target'
            ;;
        php-laravel)
            ports='    ports:
      - "8000:8000"'
            working_dir="/var/www/html"
            environment_name="APP_ENV"
            environment_value="local"
            ;;
        cpp)
            environment_name="CPP_ENV"
            ;;
    esac

    cat >> "$compose_file" <<EOF
  app:
    build:
      context: ../
      dockerfile: .docker/$dockerfile
      target: dev
$ports
    volumes:
      - ../:$working_dir
$extra_volumes
    working_dir: $working_dir
    stdin_open: true
    tty: true
    env_file:
      - ../.env
    environment:
      - $environment_name=$environment_value
EOF

    if [ "$USAR_POSTGRES" = true ]; then
        cat >> "$compose_file" <<'EOF'
    depends_on:
      - database
EOF
    fi
}

write_database_service() {
    local compose_file="$1"

    cat >> "$compose_file" <<'EOF'
  database:
    build:
      context: ../
      dockerfile: .docker/Dockerfile.postgres
      target: dev
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
    env_file:
      - ../.env
    environment:
      - POSTGRES_USER=${POSTGRES_USER:-postgres}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-postgres}
      - POSTGRES_DB=${POSTGRES_DB:-app_db}
EOF
}

write_compose_file() {
    local dest="$1"
    local compose_file="$dest/.docker/compose.yaml"
    local dockerfile
    dockerfile="$(dockerfile_for_stack "$DOCKER_STACK")"

    printf "services:\n" > "$compose_file"

    if [ "$DOCKER_STACK" != "postgres" ]; then
        case "$DOCKER_STACK" in
            node|javascript-vite|javascript-express)
                write_node_service "$compose_file" "$DOCKER_STACK"
                ;;
            python|python-fastapi|python-django)
                write_python_service "$compose_file" "$DOCKER_STACK"
                ;;
            *)
                write_generic_service "$compose_file" "$DOCKER_STACK" "$dockerfile"
                ;;
        esac
    fi

    if [ "$USAR_POSTGRES" = true ]; then
        if [ "$DOCKER_STACK" != "postgres" ]; then
            printf "\n" >> "$compose_file"
        fi
        write_database_service "$compose_file"
    fi

    if [ "$USAR_POSTGRES" = true ] || [ "$DOCKER_STACK" = "rust" ]; then
        cat >> "$compose_file" <<EOF

volumes:
EOF
        if [ "$USAR_POSTGRES" = true ]; then
            printf "  postgres-data:\n" >> "$compose_file"
        fi
        if [ "$DOCKER_STACK" = "rust" ]; then
            printf "  cargo-cache:\n  target-cache:\n" >> "$compose_file"
        fi
    fi
}

copy_docker_files() {
    local dest="$1"
    local project_slug
    project_slug="$(slugify_project_name "$dest")"

    mkdir -p "$dest/.docker"

    for item in "${FILES_DOCKER[@]}"; do
        if [ -e "$item" ]; then
            cp "$item" "$dest/"
            echo -e "${GREEN}  Copiado:${NC} $item"
        else
            echo -e "${RED}  Ignorado:${NC} $item (não encontrado)"
        fi
    done

    if [ "$DOCKER_STACK" != "postgres" ]; then
        local dockerfile
        dockerfile="$(dockerfile_for_stack "$DOCKER_STACK")"
        cp ".agents/templates/.docker/$DOCKER_STACK/$dockerfile" "$dest/.docker/$dockerfile"
        echo -e "${GREEN}  Dockerfile:${NC} $dockerfile"
    fi

    if [ "$USAR_POSTGRES" = true ]; then
        cp ".agents/templates/.docker/postgres/Dockerfile.postgres" "$dest/.docker/Dockerfile.postgres"
        echo -e "${GREEN}  Dockerfile:${NC} Dockerfile.postgres"
    fi

    write_compose_file "$dest"
    echo -e "${GREEN}  Configurado:${NC} .docker/compose.yaml"

    sed "s/app_db/${project_slug}_db/g" ".agents/templates/.docker/.env.example" > "$dest/.env.example"
    if [ ! -f "$dest/.env" ]; then
        cp "$dest/.env.example" "$dest/.env"
    fi
    echo -e "${GREEN}  Configurado:${NC} .env.example e .env local"
}

copy_adapters() {
    local dest="$1"
    local ctx_dir=".agents/templates/contexto/$CONTEXT"

    cp "$ctx_dir/AGENTS.md" "$dest/AGENTS.md"
    echo -e "${GREEN}  Adapter:${NC} AGENTS.md (Copilot CLI / Codex)"

    cp "$ctx_dir/CLAUDE.md" "$dest/CLAUDE.md"
    echo -e "${GREEN}  Adapter:${NC} CLAUDE.md (Claude Code)"

    cp "$ctx_dir/GEMINI.md" "$dest/GEMINI.md"
    echo -e "${GREEN}  Adapter:${NC} GEMINI.md (Gemini / Antigravity)"

    mkdir -p "$dest/.github"
    cp "$ctx_dir/copilot-instructions.md" "$dest/.github/copilot-instructions.md"
    echo -e "${GREEN}  Adapter:${NC} .github/copilot-instructions.md (Copilot editor)"

    cp "$ctx_dir/README.md" "$dest/README.md"
    echo -e "${GREEN}  Configurado:${NC} README.md"

    cp "$ctx_dir/workflow.md" "$dest/.agents/rules/workflow.md"
    echo -e "${GREEN}  Configurado:${NC} .agents/rules/workflow.md"

    rm -rf "$dest/.agents/templates/contexto"
}

copy_files() {
    local dest="$1"

    choose_context
    choose_docker

    echo -e "\n${CYAN}Iniciando cópia para:${NC} ${YELLOW}$dest${NC}"
    echo "---------------------------------------------------"

    for item in "${FILES_TO_COPY[@]}"; do
        if [ "$item" = "AGENTS.md" ] || [ "$item" = "README.md" ]; then
            continue
        fi

        if [ -e "$item" ]; then
            cp -r "$item" "$dest/"
            echo -e "${GREEN}  Copiado:${NC} $item"
        else
            echo -e "${RED}  Ignorado:${NC} $item (não encontrado)"
        fi
    done

    echo -e "${CYAN}Configurando contexto:${NC} ${YELLOW}$CONTEXT${NC}"
    copy_adapters "$dest"

    if [ "$USAR_DOCKER" = true ]; then
        echo -e "${CYAN}Configurando Docker:${NC}"
        copy_docker_files "$dest"
    else
        echo -e "${CYAN}Removendo referências de Docker do destino...${NC}"
        rm -f "$dest/.agents/rules/docker.md"
        rm -rf "$dest/.agents/skills/docker"
        rm -rf "$dest/.agents/templates/.docker"
    fi

    echo "---------------------------------------------------"
    echo -e "${GREEN}Operação finalizada com sucesso.${NC}\n"
}

handle_direct_path() {
    while true; do
        echo -e "\n${CYAN}Digite o caminho completo do diretório destino:${NC}"
        echo -e "${YELLOW}(ENTER vazio cancela a operação)${NC}"
        read -r user_path

        if [ -z "$user_path" ]; then
            echo -e "\n${RED}Operação cancelada.${NC}\n"
            exit 0
        fi

        if [ -d "$user_path" ]; then
            copy_files "$user_path"
            exit 0
        fi

        echo -e "\n${YELLOW}O diretório '$user_path' não existe.${NC}"
        read -r -p "Deseja criar este diretório agora? (s/n): " create_choice

        if [[ "$create_choice" =~ ^[Ss](im)?$ ]]; then
            mkdir -p "$user_path"
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Diretório criado.${NC}"
                copy_files "$user_path"
                exit 0
            fi
            echo -e "${RED}Erro ao criar o diretório. Verifique permissões.${NC}"
        else
            echo -e "${RED}Caminho inválido. Vamos tentar novamente.${NC}"
        fi
    done
}

search_directory() {
    echo -e "\n${CYAN}Digite o nome do diretório que deseja procurar:${NC}"
    echo -e "${YELLOW}Exemplo: meu-projeto${NC}"
    read -r target_name

    if [ -z "$target_name" ]; then
        echo -e "${RED}Nome em branco. Retornando ao menu principal...${NC}"
        sleep 1
        return
    fi

    local current_dir="$PWD"
    local prompted_paths=""
    local found_any=false

    echo -e "\n${CYAN}Buscando por '${target_name}' a partir de $PWD...${NC}"

    while [ "$current_dir" != "/" ] && [ "$current_dir" != "$(dirname "$current_dir")" ]; do
        local found_paths=()
        while IFS= read -r -d $'\0'; do
            found_paths+=("$REPLY")
        done < <(find "$current_dir" -maxdepth 2 -type d -iname "*$target_name*" 2>/dev/null -print0)

        for match in "${found_paths[@]}"; do
            if [ -n "$match" ] && [[ "$prompted_paths" != *"$match"* ]]; then
                found_any=true
                prompted_paths="$prompted_paths|$match"

                echo -e "\n${GREEN}Diretório encontrado:${NC}"
                echo -e "   ${CYAN}Nome:${NC}    $target_name"
                echo -e "   ${CYAN}Caminho:${NC} $match\n"

                read -r -p "Copiar arquivos para este diretório? (s/sim para copiar | n/nao para continuar): " confirm_copy

                if [[ "$confirm_copy" =~ ^[Ss](im)?$ ]]; then
                    copy_files "$match"
                    exit 0
                fi
            fi
        done

        current_dir="$(dirname "$current_dir")"
    done

    if [ "$found_any" = false ]; then
        echo -e "\n${RED}Nenhuma correspondência encontrada.${NC}"
    else
        echo -e "\n${YELLOW}Nenhuma outra correspondência encontrada.${NC}"
    fi
    echo -e "${CYAN}Informe o caminho manualmente.${NC}"
    handle_direct_path
}

while true; do
    show_header
    echo "Escolha uma opção:"
    echo ""
    echo -e "  ${YELLOW}1${NC} - Digitar caminho do diretório destino"
    echo -e "  ${YELLOW}2${NC} - Procurar diretório"
    echo -e "  ${YELLOW}0${NC} - Sair"
    echo ""
    read -r -p "Opção: " main_option

    case "$main_option" in
        1) handle_direct_path ;;
        2) search_directory ;;
        0)
            echo -e "\n${GREEN}Saindo.${NC}\n"
            exit 0
            ;;
        *)
            echo -e "\n${RED}Opção inválida. Tente novamente.${NC}"
            sleep 1.5
            ;;
    esac
done
