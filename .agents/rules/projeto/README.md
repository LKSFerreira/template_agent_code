# Template de Projeto

Este ambiente foi inicializado a partir do template multiagente LKSFerreira no contexto **Projeto**.

## Como trabalhar

1. Leia `AGENTS.md`.
2. Use `.agents/rules/` como fonte de regras.
3. Use `.agents/skills/` para tarefas recorrentes.
4. Mantenha `.metadocs/roadmap.md` atualizado quando o escopo evoluir.

## Workflows úteis

- `/init`: detecta stack e prepara a documentação inicial.
- `/novo_chat`: sincroniza contexto e compara roadmap com o estado real.
- `/setup_docker`: ajusta ou reconstrói a infraestrutura Docker.
- `/commits`: prepara commits atômicos e padronizados.
- `/pull_requests`: gera texto de PR seguindo o template do repositório.
- `/walkthrough`: registra a conclusão de uma entrega.

## Docker

Quando habilitado no `init.sh`, o projeto já recebe `.docker/compose.yaml`, Dockerfile e `.env.example`. Use:

```bash
bash dev.sh
bash exec.sh <comando>
```

## Documentação

- `.metadocs/roadmap.md`: próximos passos e decisões de produto.
- `.metadocs/historico.md`: registros cronológicos de entregas.
- `.metadocs/feat/`: planos de features ainda abertas.
- `.metadocs/walkthrough/`: entregas concluídas e validadas.
