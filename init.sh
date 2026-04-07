#!/bin/bash

# ==========================================
# Configurações Visuais (Cores)
# ==========================================
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # No Color (Reseta a cor)

# ==========================================
# Arquivos a serem copiados
# ==========================================
FILES_TO_COPY=(
    ".agents"
    ".editorconfig"
    ".gitattributes"
    ".gitignore"
    ".metadocs"
    ".vscode"
    "AGENTS.md"
    "README.md"
)

# Arquivos exclusivos do ambiente Docker
FILES_DOCKER=(
    "dev.sh"
    "exec.sh"
)

# ==========================================
# Funções do Script
# ==========================================

# Função para escolher o contexto
choose_context() {
    echo -e "\n${CYAN}🎯 Escolha o contexto de inicialização:${NC}"
    echo -e "  ${YELLOW}1${NC} - Projeto (Padrão corporativo/profissional)"
    echo -e "  ${YELLOW}2${NC} - Estudo (Foco em aprendizado e anotações)"
    read -p "Opção [1]: " context_option

    case $context_option in
        2)
            CONTEXT="estudo"
            ;;
        *)
            CONTEXT="projeto"
            ;;
    esac
    echo -e "${GREEN}✅ Contexto selecionado: ${YELLOW}$CONTEXT${NC}"
}

# Função para escolher se quer configurar Docker
choose_docker() {
    echo -e "\n${CYAN}🐳 Deseja criar a estrutura e ambiente Docker?${NC}"
    echo -e "   ${YELLOW}s${NC} / ${YELLOW}sim${NC}  — Copia dev.sh, exec.sh e a pasta .docker template"
    echo -e "   ${YELLOW}n${NC} / ${YELLOW}nao${NC}  — Pula toda a configuração Docker"
    read -p "$(echo -e "${CYAN}Opção [n]: ${NC}")" docker_option

    if [[ "$docker_option" =~ ^[Ss](im)?$ ]]; then
        USAR_DOCKER=true
        echo -e "${GREEN}✅ Docker habilitado para este projeto.${NC}"
    else
        USAR_DOCKER=false
        echo -e "${YELLOW}⏭️  Docker ignorado. Nenhum arquivo Docker será copiado.${NC}"
    fi
}

# Função para realizar a cópia dos arquivos
copy_files() {
    local dest="$1"
    choose_context
    choose_docker

    echo -e "\n${CYAN}🚀 Iniciando cópia para: ${YELLOW}$dest${NC}"
    echo "---------------------------------------------------"

    for item in "${FILES_TO_COPY[@]}"; do
        # Pulamos arquivos que serão tratados especificamente pelo contexto
        if [ "$item" == "AGENTS.md" ] || [ "$item" == "README.md" ]; then
            continue
        fi

        if [ -e "$item" ]; then
            cp -r "$item" "$dest/"
            echo -e "${GREEN}  ✅ Copiado:${NC} $item"
        else
            echo -e "${RED}  ⚠️ Ignorado:${NC} $item (não encontrado na origem)"
        fi
    done

    # Copia arquivos Docker apenas se o usuário escolheu
    if [ "$USAR_DOCKER" = true ]; then
        echo -e "${CYAN}🐳 Copiando arquivos Docker...${NC}"
        for item in "${FILES_DOCKER[@]}"; do
            if [ -e "$item" ]; then
                cp -r "$item" "$dest/"
                echo -e "${GREEN}  ✅ Copiado:${NC} $item"
            else
                echo -e "${RED}  ⚠️ Ignorado:${NC} $item (não encontrado na origem)"
            fi
        done

        local template_docker=".agents/templates/.docker"
        if [ -d "$template_docker" ]; then
            cp -r "$template_docker" "$dest/.docker"
            echo -e "${GREEN}  ✅ Copiado:${NC} .docker/ (templates de ambiente)"
        else
            echo -e "${RED}  ⚠️ Ignorado:${NC} .docker/ (template não encontrado em $template_docker)"
        fi
    fi

    # Cópia dos arquivos específicos de contexto
    echo -e "${CYAN}📦 Configurando arquivos específicos do contexto: ${YELLOW}$CONTEXT${NC}"
    
    # Move regras específicas para os locais corretos no destino
    cp ".agents/rules/$CONTEXT/AGENTS.md" "$dest/AGENTS.md"
    cp ".agents/rules/$CONTEXT/README.md" "$dest/README.md"
    cp ".agents/rules/$CONTEXT/workflow.md" "$dest/.agents/rules/workflow.md"
    
    # Limpeza: remove as pastas de contexto do destino para manter o workspace limpo
    rm -rf "$dest/.agents/rules/projeto"
    rm -rf "$dest/.agents/rules/estudo"

    echo -e "${GREEN}  ✅ Configurado:${NC} AGENTS.md ($CONTEXT)"
    echo -e "${GREEN}  ✅ Configurado:${NC} README.md ($CONTEXT)"
    echo -e "${GREEN}  ✅ Configurado:${NC} .agents/rules/workflow.md ($CONTEXT)"
    echo -e "${GREEN}  🧹 Workspace limpo (contextos residuais removidos)${NC}"

    echo "---------------------------------------------------"
    echo -e "${GREEN}🎉 Operação finalizada com sucesso!${NC}\n"
}

# Função do Fluxo: Digitar Caminho Manualmente (Opção 1 e Fallback)
handle_direct_path() {
    while true; do
        echo -e "\n${CYAN}📍 Digite o caminho completo do diretório destino:${NC}"
        echo -e "${YELLOW}(Pressione ENTER com o campo vazio para cancelar e sair)${NC}"
        read -r user_path

        # Se o usuário apenas apertar enter, sai do programa
        if [ -z "$user_path" ]; then
            echo -e "\n${RED}Operação cancelada. Saindo... 👋${NC}\n"
            exit 0
        fi

        # Verifica se o diretório existe
        if [ -d "$user_path" ]; then
            copy_files "$user_path"
            exit 0
        else
            echo -e "\n${YELLOW}⚠️ O diretório '$user_path' não existe.${NC}"
            read -p "Deseja criar este diretório agora? (s/n): " create_choice

            if [[ "$create_choice" =~ ^[Ss](im)?$ ]]; then
                mkdir -p "$user_path"
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}📁 Diretório criado com sucesso!${NC}"
                    copy_files "$user_path"
                    exit 0
                else
                    echo -e "${RED}❌ Erro ao criar o diretório. Verifique as permissões.${NC}"
                fi
            else
                echo -e "${RED}🔄 Caminho inválido. Vamos tentar novamente.${NC}"
            fi
        fi
    done
}

# Função do Fluxo: Procurar Diretório (Opção 2)
search_directory() {
    echo -e "\n${CYAN}🔍 Digite o nome do diretório que deseja procurar:${NC}"
    echo -e "${YELLOW}Exemplo: slidefly${NC}"
    read -r target_name

    if [ -z "$target_name" ]; then
        echo -e "${RED}Nome em branco. Retornando ao menu principal...${NC}"
        sleep 1
        return
    fi

    local current_dir="$PWD"
    local prompted_paths="" # Histórico para não perguntar da mesma pasta duas vezes
    local found_any=false

    echo -e "\n${CYAN}Buscando por '${target_name}' (recuando a partir de $PWD)...${NC}"

    # Loop que vai subindo as pastas até chegar na raiz (ex: /c/)
    while [ "$current_dir" != "/" ] && [ "$current_dir" != "$(dirname "$current_dir")" ]; do

        # Procura no nível atual descendo no máximo 2 níveis de profundidade (para ser muito rápido)
        # Oculta mensagens de erro de permissão (2>/dev/null)
        local found_paths=()
        while IFS=  read -r -d $'\0'; do
            found_paths+=("$REPLY")
        done < <(find "$current_dir" -maxdepth 2 -type d -iname "*$target_name*" 2>/dev/null -print0)

        for match in "${found_paths[@]}"; do
            # Verifica se achou algo e se já não perguntamos sobre essa pasta específica
            if [ -n "$match" ] && [[ "$prompted_paths" != *"$match"* ]]; then
                found_any=true
                prompted_paths="$prompted_paths|$match"

                echo -e "\n${GREEN}✨ O seguinte diretório foi encontrado:${NC}"
                echo -e "   📁 ${CYAN}Diretório:${NC} $target_name"
                echo -e "   🛤️  ${CYAN}Caminho:${NC}   $match\n"

                read -p "Deseja copiar os arquivos para o diretório acima? (s/sim para copiar | n/nao para continuar buscando): " confirm_copy

                if [[ "$confirm_copy" =~ ^[Ss](im)?$ ]]; then
                    copy_files "$match"
                    exit 0
                fi
            fi
        done

        # Sobe um nível (ex: de /c/Users/LUCAS para /c/Users)
        current_dir=$(dirname "$current_dir")
    done

    # Se sair do loop, significa que varreu até a raiz e não encontrou nada (ou o usuário recusou todas as opções)
    echo -e "\n${RED}⚠️ Nenhuma (outra) correspondência encontrada.${NC}"
    echo -e "${CYAN}Por favor, informe o caminho manualmente.${NC}"
    handle_direct_path
}

# ==========================================
# Menu Principal
# ==========================================
while true; do
    clear
    echo -e "${CYAN}=======================================================${NC}"
    echo -e "${GREEN}    🚀 LKSFerreira - MIGRAR ARQUIVOS DE CONFIGURAÇÃO   ${NC}"
    echo -e "${CYAN}=======================================================${NC}"
    echo ""
    echo "Escolha uma das opções abaixo:"
    echo ""
    echo -e "  ${YELLOW}1${NC} - Digitar o caminho do diretório destino"
    echo -e "  ${YELLOW}2${NC} - Procurar um diretório (Busca inteligente)"
    echo -e "  ${YELLOW}0${NC} - Sair"
    echo ""
    read -p "Opção: " main_option

    case $main_option in
        1)
            handle_direct_path
            ;;
        2)
            search_directory
            ;;
        0)
            echo -e "\n${GREEN}Saindo... Até a próxima! 👋${NC}\n"
            exit 0
            ;;
        *)
            echo -e "\n${RED}❌ Opção inválida. Tente novamente.${NC}"
            sleep 1.5
            ;;
    esac
done
