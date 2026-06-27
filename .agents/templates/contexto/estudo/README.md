# Template de Estudo

Este ambiente foi inicializado a partir do template multiagente LKSFerreira no contexto **Estudo**.

## Como estudar

1. Leia `AGENTS.md`.
2. Use `.agents/rules/` como fonte de regras.
3. Registre objetivos e progresso em `ROADMAP.md`.
4. Peça explicações de conceitos e trade-offs quando algo novo aparecer.

## Skills disponíveis

- `/init`: detecta stack e prepara a documentação inicial.
- `/sync`: sincroniza contexto e retoma o ponto de parada.
- `/docker`: ajusta ou reconstrói a infraestrutura Docker.
- `/commit`: prepara commits pequenos e rastreáveis.
- `/pr`: gera texto de PR com resumo didático do aprendizado.
- `/feat`: registra uma conclusão ou experimento validado.

## Docker

Quando habilitado no `init.sh`, o estudo já recebe `.docker/compose.yaml`, Dockerfile e `.env.example`. Use:

```bash
bash dev.sh
bash exec.sh <comando>
```

## Documentação

- `ROADMAP.md`: trilha de estudo, objetivos e próximos passos.
- `HISTORY.md`: linha do tempo do aprendizado.
- `.metadocs/implementation_plan/`: experimentos planejados.
- `.metadocs/implemented/`: experimentos concluídos e explicados.
