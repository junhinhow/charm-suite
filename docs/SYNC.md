# Sincronização Forgejo ↔ GitHub

O índice e cada biblioteca podem ter dois remotos: `github` e `forgejo`. A URL
do Forgejo deve ser fornecida pelo mantenedor; este projeto não embute tokens,
senhas ou uma URL presumida.

## Configuração inicial

```bash
git remote add forgejo https://<host>/<usuario>/charm-suite.git
git fetch forgejo
git push -u forgejo main
```

Repita a configuração dentro de cada diretório `libs/charm-*` quando o Forgejo
hospedar os módulos separadamente. Use o Git Credential Manager ou SSH para
autenticação; nunca coloque credenciais em scripts ou URLs commitadas.

## Fluxo seguro

1. Execute `scripts/verify-suite.ps1 -RunTests` (ou a verificação equivalente).
2. Confirme `git status` limpo em cada repositório alterado.
3. Faça `git fetch` dos dois remotos.
4. Compare `main` antes do push.
5. Publique a branch normalmente, sem `--force`, salvo uma migração aprovada
   explicitamente e documentada.
6. Confirme o commit remoto e a tag/release, quando houver.

O script de verificação é somente leitura: ele não faz checkout, reset, push,
tag ou alteração de credenciais.
