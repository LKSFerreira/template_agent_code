# LKSFerreira - Template Multiagente

Este repositório é a fonte oficial dos meus templates de desenvolvimento. Ele reúne regras para agentes IA, skills reutilizáveis, workflows operacionais, metadocs e templates de infraestrutura para iniciar projetos e estudos com menos atrito.

## Objetivo

- Manter uma base multiagente, independente de uma plataforma específica.
- Centralizar regras e automações em `.agents/`.
- Gerar novos ambientes com documentação mínima, contexto de agente e Docker opcional pronto para uso.
- Separar conteúdo reutilizável de exemplos ou anotações específicas de projetos antigos.

## Uso

Execute o inicializador a partir deste repositório:

```bash
./init.sh
```

O script solicita:

1. O diretório de destino.
2. O contexto do ambiente: `projeto` ou `estudo`.
3. Se a estrutura Docker deve ser criada.
4. A stack Docker quando a opção Docker for habilitada.

Ao final, o destino recebe `AGENTS.md`, `README.md`, `.agents/`, `.metadocs/`, configurações básicas e, se escolhido, `.docker/compose.yaml`, Dockerfile e `.env.example` prontos para ajuste fino.

## Estrutura

- `.agents/rules/`: regras estáveis de comportamento, código, Git, Docker e linguagens.
- `.agents/skills/`: automações reutilizáveis que explicam como executar tarefas recorrentes.
- `.agents/workflows/`: runbooks acionáveis por comandos ou intenção do usuário.
- `.agents/templates/`: templates de Docker, skills e documentos auxiliares.
- `.metadocs/`: estrutura documental neutra para roadmap, histórico, features planejadas e walkthroughs.

## Contextos

- `projeto`: foco em produção, arquitetura, segurança e manutenção.
- `estudo`: foco em aprendizado, explicação técnica e registro didático.

Os contextos ficam em `.agents/rules/projeto/` e `.agents/rules/estudo/`. Durante a inicialização, o contexto escolhido é copiado para os arquivos raiz do projeto de destino.

## Convenções

- `.agents/` é a fonte oficial de regras e skills.
- A pasta raiz `skills/` não é usada neste template.
- Conteúdos específicos de projetos reais devem ficar fora do fluxo copiado pelo `init.sh`.
- Commits, push e PRs só devem ser feitos quando solicitados explicitamente.
