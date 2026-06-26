---
trigger: always_on
---

# Fluxo de Trabalho Obrigatório

## Princípios

- Entenda o contexto antes de alterar arquivos.
- Prefira mudanças pequenas, verificáveis e alinhadas às regras do repositório.
- Use skills em `.agents/skills/` quando a tarefa corresponder a uma automação existente.
- Não execute commits, push ou abertura de PR sem pedido explícito.
- Não simule execução: se precisar validar, execute o comando real ou declare que não foi possível.

## Etapas

1. **Descoberta:** leia regras, documentação e arquivos afetados.
2. **Plano:** defina a alteração mínima necessária e os riscos.
3. **Execução:** implemente apenas o escopo solicitado.
4. **Validação:** rode testes, checks ou auditoria estática compatíveis com o projeto.
5. **Resumo:** informe o que mudou, como foi validado e qualquer limitação.

## Gate de segurança

Pare e alinhe com o usuário quando:

- a alteração puder apagar dados ou sobrescrever trabalho externo;
- houver ambiguidade de produto que mude a solução;
- a validação exigir credenciais, serviços externos ou permissões indisponíveis.
