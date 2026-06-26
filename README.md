# LKSFerreira - Template Multiagente

Este repositório é a fonte oficial dos meus templates de desenvolvimento. Ele reúne regras para agentes IA, skills reutilizáveis e templates de infraestrutura para iniciar projetos e estudos com menos atrito.

## Objetivo

- Manter uma base multiagente **universal**, independente de plataforma ou modelo de LLM.
- Centralizar regras e automações em `.agents/`.
- Gerar novos ambientes com documentação mínima, contexto de agente e Docker opcional pronto para uso.
- Garantir portabilidade total entre agentes: Copilot CLI, Codex, Claude Code, Gemini, Kilo Code e qualquer outro.

## Arquitetura Universal

O template gera **adapters** para cada plataforma de agente. Todos apontam para a mesma fonte de verdade (`.agents/`):

```
projeto-destino/
├── .agents/                          ← Fonte de verdade (rules, skills, workflows)
├── AGENTS.md                         ← Adapter: Copilot CLI, Codex, genérico
├── CLAUDE.md                         ← Adapter: Claude Code (Anthropic)
├── GEMINI.md                         ← Adapter: Gemini / Antigravity IDE
├── .github/copilot-instructions.md   ← Adapter: GitHub Copilot (editor)
└── README.md
```

**Princípio:** troque de agente a qualquer momento sem reconfigurar nada. Skills como `/commit`, `/novo_chat`, `/pr` funcionam em qualquer plataforma.

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

Ao final, o destino recebe todos os adapters universais, `.agents/`, `ROADMAP.md`, `HISTORY.md`, `.metadocs/`, configurações básicas e, se escolhido, `.docker/compose.yaml`, Dockerfile e `.env.example`.

## Estrutura

- `.agents/rules/`: regras estáveis de comportamento, código, Git, Docker e linguagens.
- `.agents/skills/`: automações reutilizáveis que explicam como executar tarefas recorrentes.
- `.agents/templates/`: templates de Docker, skills e contextos de plataforma.
- `.agents/templates/contexto/`: adapters e configurações por contexto (projeto/estudo) para cada plataforma de agente.
- `.metadocs/`: planos de implementação (`implementation_plan/`) e registros de entrega (`implemented/`).

## Contextos

- `projeto`: foco em produção, arquitetura, segurança e manutenção.
- `estudo`: foco em aprendizado, explicação técnica e registro didático.

Os contextos ficam em `.agents/templates/contexto/projeto/` e `.agents/templates/contexto/estudo/`. Durante a inicialização, o contexto escolhido é copiado para os arquivos raiz do projeto de destino.

## Convenções

- `.agents/` é a fonte oficial de regras e skills.
- Adapters na raiz (`CLAUDE.md`, `GEMINI.md`, etc.) são **gerados** e apontam para `.agents/`.
- Conteúdos específicos de projetos reais devem ficar fora do fluxo copiado pelo `init.sh`.
- Commits, push e PRs só devem ser feitos quando solicitados explicitamente.
