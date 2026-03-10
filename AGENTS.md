# Repositório de Templates LKSFerreira

Este repositório contém os templates unificados para **Projetos** e **Estudos**.

## Como utilizar

Para inicializar um novo ambiente usando este template, execute o script:

```bash
./init.sh
```

O script perguntará qual contexto você deseja aplicar e configurará os arquivos `AGENTS.md` e `.agents/rules/workflow.md` corretamente.

## Estrutura de Contextos

As regras específicas de cada contexto estão localizadas em:
- [Projeto](.agents/rules/projeto/)
- [Estudo](.agents/rules/estudo/)

Todas as outras regras e skills são compartilhadas entre os contextos.
