# Repositório de Templates LKSFerreira

Este repositório contém o template multiagente usado para inicializar **projetos** e **estudos**.

> LINGUAGEM_PROJETO: template

## Arquitetura Universal de Agentes

Este template gera projetos compatíveis com **qualquer agente de LLM**, independente da plataforma:

| Arquivo | Plataforma alvo |
|---|---|
| `AGENTS.md` | GitHub Copilot CLI, OpenAI Codex, genérico |
| `CLAUDE.md` | Claude Code (Anthropic) |
| `GEMINI.md` | Gemini / Antigravity IDE |
| `.github/copilot-instructions.md` | GitHub Copilot (editor) |

Todos apontam para a mesma fonte de verdade: `.agents/`.

## Fonte oficial

- Regras: `.agents/rules/`
- Skills: `.agents/skills/`
- Templates: `.agents/templates/`
- Contextos: `.agents/templates/contexto/`
- Metadocs: `.metadocs/`

## Como utilizar

Para inicializar um novo ambiente usando este template, execute:

```bash
./init.sh
```

O script perguntará qual contexto aplicar e configurará:
- `AGENTS.md`, `CLAUDE.md`, `GEMINI.md` (adapters universais)
- `.github/copilot-instructions.md` (adapter GitHub Copilot editor)
- `README.md` e `.agents/rules/workflow.md` (contexto)
- Estrutura Docker (opcional)

## Contextos

- Projeto: `.agents/templates/contexto/projeto/`
- Estudo: `.agents/templates/contexto/estudo/`

Todas as outras regras, skills e templates são compartilhados entre os contextos.

## Regra de versionamento

Commits, push e PRs só devem ser executados quando solicitados explicitamente pelo usuário.
