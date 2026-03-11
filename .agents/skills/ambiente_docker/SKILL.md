---
name: ambiente_docker
description: Gerencia dependências e a integridade do ambiente Docker Compose do projeto usando os utilitários corretos (dev.sh e exec).
---

# 🎯 Propósito

Atue como Especialista em DevOps. Use esta skill SEMPRE que solicitado para configurar o ambiente Docker do zero (`/setup_docker`) ou para gerenciar dependências e a vida útil dos containers.

# 📋 Pré-requisitos

- Identificar a stack via `AGENTS.md` (`LINGUAGEM_PROJETO`).
- O terminal do ambiente Host deve estar disponível para executar scripts bash.

# 🛠️ Instruções de Execução (Workflow)

## 1: Configuração Inicial (Setup)

1. **Diretório**: Crie `.docker/` na raiz do projeto se ainda não existir.

2. **Templates — Dockerfiles**:
   - Acesse `.agents/templates/.docker/` e liste os subdiretórios disponíveis.
   - Identifique os serviços da stack do projeto (ex: `node`, `postgress`, `python`, etc.).
   - Para cada serviço identificado, copie o `Dockerfile.*` do subdiretório correspondente para `.docker/`.
   - **PROIBIDO** renomear os arquivos: mantenha exatamente o nome original do template (ex: `Dockerfile.node`, `Dockerfile.postgress`).
   - **PROIBIDO** criar Dockerfiles do zero.

3. **Templates — compose.yaml**:
   - Cada subdiretório de template possui seu próprio `compose.yaml`.
   - **NÃO crie o compose.yaml do zero.** Mescle os `compose.yaml` de cada serviço utilizado em um único arquivo em `.docker/compose.yaml`.
   - Após mesclar, ajuste apenas: nomes dos containers, portas, variáveis específicas do projeto e caminhos de contexto (`./` → `../`).
   - Atualize os campos `dockerfile:` para apontar para `.docker/Dockerfile.<serviço>`.

4. **Variáveis de Ambiente**:
   - Use `.agents/templates/.docker/.env.example` como base.
   - Copie para a raiz como `.env.example` e preencha com os valores do projeto.
   - Crie também o `.env` local com os valores funcionais para desenvolvimento.

5. **Script**: Se `dev.sh` e `exec.sh` ainda não existirem na raiz, crie-os conforme a skill. Se já existirem, **não os sobrescreva**.

## 2: Manutenção e Dependências

- **Subir/Build**: `bash dev.sh` (adicione `--build` se houver mudanças no Dockerfile).
- **Node.js**: Use `bash exec.sh npm install <pacote>` para instalar dentro do container `app`.
- **Python**: Use `docker compose -f .docker/compose.yaml exec backend uv pip install --system <pacotes>`.

# ⚠️ Regras e Restrições (Guardrails)

- **PROIBIDO** instalar dependências no host.
- **PROIBIDO** usar `docker compose` sem o parâmetro `-f .docker/compose.yaml`.
- **Limpeza**: Após o setup, remova diretórios de templates temporários.
