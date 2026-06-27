# LKSFerreira - Template Multiagente

Template universal para desenvolvimento assistido por IA. Funciona com **qualquer agente** (Copilot CLI, Gemini, Codex, Claude Code) sem reconfiguração.

## Quick Start — Repositório Novo

```bash
# 1. Crie o repositório
mkdir meu-projeto && cd meu-projeto && git init

# 2. Rode o inicializador (a partir deste template)
cd ~/Documents/GitHub/template_agent_code
./init.sh
# → Informe o caminho do meu-projeto/
# → Escolha: projeto ou estudo
# → Escolha: com ou sem Docker

# 3. Pronto. Abra no agente de sua preferência e trabalhe.
```

### O que é gerado

```
meu-projeto/
├── AGENTS.md                         ← Adapter: Copilot CLI / Codex
├── CLAUDE.md                         ← Adapter: Claude Code
├── GEMINI.md                         ← Adapter: Gemini / Antigravity IDE
├── .github/copilot-instructions.md   ← Adapter: GitHub Copilot (editor)
├── README.md
├── ROADMAP.md                        ← Planejamento
├── HISTORY.md                        ← Entregas concluídas
├── .agents/
│   ├── rules/                        ← Regras de comportamento
│   ├── skills/                       ← 16 skills executáveis
│   └── templates/                    ← Docker (se escolhido)
├── .metadocs/
│   ├── implementation_plan/          ← Planos ativos
│   └── implemented/                  ← Registros de entrega
└── .docker/                          ← (opcional)
```

### Compatibilidade automática

| Agente | Arquivo que lê | Ação necessária |
|---|---|---|
| GitHub Copilot CLI | `AGENTS.md` | Nenhuma |
| Antigravity IDE (Gemini) | `GEMINI.md` | Nenhuma |
| OpenAI Codex | `AGENTS.md` | Nenhuma |
| Claude Code | `CLAUDE.md` | Nenhuma |
| GitHub Copilot (editor) | `.github/copilot-instructions.md` | Nenhuma |

Troque de agente a qualquer momento. Skills como `/commit`, `/sync`, `/pr` funcionam em qualquer plataforma.

## Pipeline de documentação

```
Ideia → cria em .metadocs/implementation_plan/ → trabalha → /feat move para implemented/
                                                                  ↓
                                                     atualiza HISTORY.md + ROADMAP.md
```

## Skills disponíveis (16)

| Comando | Descrição |
|---|---|
| `/commit` | Commits atômicos padronizados |
| `/pr` | Texto de Pull Request |
| `/sync` | Sincronização de contexto |
| `/init` | Inicialização de projeto |
| `/docker` | Setup Docker |
| `/tests` | Planejamento de testes |
| `/review` | Revisão de código |
| `/deps` | Gerenciar dependências |
| `/db` | Mudanças de banco |
| `/env` | Variáveis de ambiente |
| `/diag` | Diagnóstico de erros |
| `/feat` | Finalizar feature |
| `/front` | Frontend JS/TS |
| `/create-skill` | Criar nova skill |
| `/find` | Buscar skills no marketplace (skills.sh) |
| `/web` | Pesquisa web |

Não precisa decorar — o agente sabe qual skill usar pela intenção do que você pede.

## Estrutura interna

- `.agents/rules/`: regras de comportamento, código, Git, Docker e linguagens.
- `.agents/skills/`: 16 skills com `tags` e `triggers` para discovery automático.
- `.agents/templates/contexto/`: adapters por contexto (projeto/estudo).
- `.agents/templates/.docker/`: Dockerfiles para 13 stacks.
- `.agents/templates/skills/`: templates para criar novas skills.

## Contextos

- **Projeto**: Arquiteto de Software Sênior + DevOps. Foco em produção.
- **Estudo**: Mentor Técnico + Professor. Foco em aprendizado.

## Convenções

- `.agents/` é a fonte de verdade. Adapters na raiz são gerados.
- Diretórios e frontmatter em inglês. Conteúdo em pt-BR.
- Commits, push e PRs só quando solicitados explicitamente.
