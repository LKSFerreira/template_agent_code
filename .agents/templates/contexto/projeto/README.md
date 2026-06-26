# Template de Projeto

Este ambiente foi inicializado a partir do template multiagente LKSFerreira no contexto **Projeto**.

## Como trabalhar

1. Leia `AGENTS.md`.
2. Use `.agents/rules/` como fonte de regras.
3. Use `.agents/skills/` para tarefas recorrentes.
4. Mantenha `ROADMAP.md` atualizado quando o escopo evoluir.

## Skills disponíveis

- `/init`: detecta stack e prepara a documentação inicial.
- `/novo_chat`: sincroniza contexto e compara roadmap com o estado real.
- `/docker`: ajusta ou reconstrói a infraestrutura Docker.
- `/commit`: prepara commits atômicos e padronizados.
- `/pr`: gera texto de PR seguindo o template do repositório.
- `/feat`: registra a conclusão de uma entrega.

## Docker

Quando habilitado no `init.sh`, o projeto já recebe `.docker/compose.yaml`, Dockerfile e `.env.example`. Use:

```bash
bash dev.sh
bash exec.sh <comando>
```

## Documentação

- `ROADMAP.md`: próximos passos e decisões de produto.
- `HISTORY.md`: registros cronológicos de entregas.
- `.metadocs/implementation_plan/`: planos de implementação ativos.
- `.metadocs/implemented/`: entregas concluídas e validadas.
