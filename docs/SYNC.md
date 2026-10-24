# Sincronização Forgejo → GitHub

O Forgejo é a fonte canônica deste projeto. O GitHub é um espelho de
distribuição e descoberta; alterações devem nascer no Forgejo e depois ser
publicadas no GitHub.

O índice e cada biblioteca têm dois remotos: `forgejo` e `origin` (GitHub). A
URL do Forgejo não deve conter tokens, senhas ou outros segredos.

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
3. Faça `git fetch forgejo` e publique primeiro no Forgejo.
4. Confirme o commit remoto no Forgejo.
5. Faça `git fetch forgejo` e publique o mesmo commit no GitHub.
6. Confirme o commit e a tag/release nos dois remotos.

O script de verificação é somente leitura: ele não faz checkout, reset, push,
tag ou alteração de credenciais. Uma migração excepcional de `main` deve criar
um backup no Forgejo e usar `--force-with-lease`, nunca `--force` cego.
