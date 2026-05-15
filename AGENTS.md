# Repositório de Templates LKSFerreira

Este repositório contém o template multiagente usado para inicializar **projetos** e **estudos**.

> LINGUAGEM_PROJETO: template

## Fonte oficial

- Regras: `.agents/rules/`
- Skills: `.agents/skills/`
- Workflows: `.agents/workflows/`
- Templates: `.agents/templates/`
- Metadocs: `.metadocs/`

## Como utilizar

Para inicializar um novo ambiente usando este template, execute:

```bash
./init.sh
```

O script perguntará qual contexto aplicar e configurará `AGENTS.md`, `README.md`, `.agents/rules/workflow.md` e a estrutura documental mínima no destino.

## Contextos

- Projeto: `.agents/rules/projeto/`
- Estudo: `.agents/rules/estudo/`

Todas as outras regras, skills e templates são compartilhados entre os contextos.

## Regra de versionamento

Commits, push e PRs só devem ser executados quando solicitados explicitamente pelo usuário.
