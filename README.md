# EasyDecision

App to help people making decisions

## Padrão de nome das branches

`motivo` `/` `sprint` `/` `ID-tarefa`

### Motivos

- feature
- bug
- improvement

### Sprints

- sprint1
- sprint2
- sprint3
- sprint4

### ID-tarefa

- Número identificador da tarefa. Por exemplo, na tarefa abaixo, o identificador é #2
<img width="405" alt="image" src="https://user-images.githubusercontent.com/816290/119736502-2c9dc700-be54-11eb-81ac-7859899d8f59.png">

Exemplos:

- `feature/sprint1/2`
- `feature/sprint2/6`
- `bug/sprint2/9`

### Merge

Não pode fazer o merge direto na main quando terminar. Tem que abrir um **merge request** (chamado pelo GitHub de **pull request**) e marcar o cartão como Aguardando Revisão. Quem abre o merge request **não pode** concluir o merge, tem que passar por code review.