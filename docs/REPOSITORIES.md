# Topologia dos repositórios

## Estrutura

`charm-suite` é um índice e workspace; cada diretório em `libs/` é um
repositório Git e um módulo Go independente. Os módulos não são submodules do
índice, portanto alterações em uma biblioteca devem ser commitadas no próprio
repositório e referenciadas aqui apenas por documentação, `go.work` e scripts.

O workspace contém 37 módulos:

- 35 bibliotecas reutilizáveis;
- `charm-cli`, o scaffolder `charm-suite`;
- `charm-gallery`, a galeria/showcase.

## Verificação reproduzível

No Windows:

```powershell
./scripts/verify-suite.ps1
./scripts/verify-suite.ps1 -RunTests
```

No Linux, macOS ou WSL, a verificação equivalente pode ser executada módulo a
módulo com `go build ./...`, `go vet ./...` e `go test -race ./...`, usando
`GOWORK=off` para evitar que o workspace masque dependências ausentes.

## Política de histórico

- Um commit deve representar uma mudança real e verificável.
- Datas e autores devem refletir a execução efetiva, exceto correções
  comprováveis de fuso ou importação.
- Não se reescreve histórico publicado para simular atividade retroativa.
- Commits pequenos e Conventional Commits são preferíveis a commits artificiais
  ou vazios.

## Estado publicado

Na verificação de 23/10/2026, os módulos estavam publicados no GitHub com tags
`v0.1.1`, exceto `charm-cli` e `charm-gallery`, que estavam em `v0.1.0`.
Consulte o próprio repositório antes de publicar uma nova versão.
