# Template de Estudo

Este ambiente foi inicializado a partir do template multiagente LKSFerreira no contexto **Estudo**.

## Como estudar

1. Leia `AGENTS.md`.
2. Use `.agents/rules/` como fonte de regras.
3. Registre objetivos e progresso em `.metadocs/roadmap.md`.
4. Peça explicações de conceitos e trade-offs quando algo novo aparecer.

## Workflows úteis

- `/init`: detecta stack e prepara a documentação inicial.
- `/novo_chat`: sincroniza contexto e retoma o ponto de parada.
- `/setup_docker`: ajusta ou reconstrói a infraestrutura Docker.
- `/commits`: prepara commits pequenos e rastreáveis.
- `/pull_requests`: gera texto de PR com resumo didático do aprendizado.
- `/walkthrough`: registra uma conclusão ou experimento validado.

## Docker

Quando habilitado no `init.sh`, o estudo já recebe `.docker/compose.yaml`, Dockerfile e `.env.example`. Use:

```bash
bash dev.sh
bash exec.sh <comando>
```

## Documentação

- `.metadocs/roadmap.md`: trilha de estudo, objetivos e próximos passos.
- `.metadocs/historico.md`: linha do tempo do aprendizado.
- `.metadocs/feat/`: experimentos planejados.
- `.metadocs/walkthrough/`: experimentos concluídos e explicados.
