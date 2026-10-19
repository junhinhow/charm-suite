# STATUS: TODOS OS ACHADOS RESOLVIDOS (2026-10-22)

> Este documento foi gerado como auditoria inicial. Após a rodada de correções,
> **todos os achados P0 (críticos) e P1 (altos) foram resolvidos**, com testes de
> regressão que falham no código original e passam no código corrigido.
>
> Verificação final (18 repos): go build ./... ✓ · go vet ./... ✓ ·
> go test ./... ✓ · go test -race ./... ✓ · gofmt -l . vazio ✓.
>
> Detalhes por repo nas mensagens de commit de cada libs/<repo> (commits locais,
> nenhum push). A seção original abaixo é mantida como registro histórico.

---
# Auditoria Charm Suite â€” Achados Verificados

Todos os achados marcados como **[CONFIRMADO]** abaixo foram **reproduzidos executando cÃ³digo**
(pseudor-), nÃ£o apenas por leitura. Nenhum deles Ã© especulativo.

Contexto tÃ©cnico do ecossistema:
- Stack alvo: `charm.land/lipgloss/v2` (exige Go >= 1.25.0), `charm.land/bubbletea/v2` (exige Go >= 1.24.2).
- Todos os 18 repos compilam e passam `go vet` no estado atual. Os problemas sÃ£o de **correÃ§Ã£o**,
  **robustez**, **cobertura de teste** e **divergÃªncia entre README e implementaÃ§Ã£o**.
- ConvenÃ§Ãµes do projeto: comentÃ¡rios e mensagens de erro em **portuguÃªs do Brasil**, README bilÃ­ngue
  (`README.md` em inglÃªs + `README.pt-br.md` em pt-BR), MIT License.

---

## ConvenÃ§Ãµes obrigatÃ³rias para todos os repos

1. **Nunca fazer push.** Trabalhe e commite localmente apenas.
2. NÃ£o altere a API pÃºblica de forma incompatÃ­vel sem justificar no relatÃ³rio final.
3. Toda correÃ§Ã£o de bug precisa de **teste de regressÃ£o** que falhe antes do fix e passe depois.
4. Erros devem usar `%w` quando envolverem outro erro. Use `errors.New` quando nÃ£o houver wrapping.
5. Use `lipgloss.Width` / `ansi.StringWidth` (nunca `len()`) para medir **largura de exibiÃ§Ã£o**.
   `len()` mede bytes â€” quebra com acentos, CJK e emoji.
6. ComentÃ¡rios, doc comments e mensagens de erro em **pt-BR**.
7. README.md (en) e README.pt-br.md (pt) devem continuar **sincronizados** entre si.
8. Ao final, `go build ./... && go vet ./... && go test ./...` deve passar limpo.

---

## Ãndice

| Repo | Achados confirmados | Criticidade |
|---|---|---|
| charm-table-cli | 8 | ðŸ”´ CRÃTICO |
| charm-diff | 7 | ðŸ”´ CRÃTICO |
| charm-test | 9 | ðŸ”´ CRÃTICO |
| charm-devtools | 8 | ðŸ”´ CRÃTICO |
| charm-layout | 6 | ðŸ”´ CRÃTICO |
| charm-color | 6 | ðŸŸ  ALTO |
| charm-nav | 5 | ðŸŸ  ALTO |
| charm-i18n | 6 | ðŸŸ  ALTO |
| charm-palette | 6 | ðŸŸ  ALTO |
| charm-wizard | 6 | ðŸŸ  ALTO |
| charm-banner | 5 | ðŸŸ  ALTO |
| charm-charts | 8 | ðŸŸ  ALTO |
| charm-toast | 7 | ðŸŸ  ALTO |
| charm-themes | 5 | ðŸŸ  ALTO |
| charm-notify | 5 | ðŸŸ  ALTO |
| charm-dialog | 5 | ðŸŸ  ALTO |
| charm-form | 6 | ðŸ”´ CRÃTICO (funcional) |
| charm-spinner | 4 | ðŸŸ¡ MÃ‰DIO |

---

## charm-table-cli â€” ðŸ”´ CRÃTICO

Arquivo principal: `main.go` (pacote `main`).

1. **[CONFIRMADO] Toda tabela renderiza quebrada.** Em lipgloss v2, `Width(n)` Ã© a largura **total**
   do bloco (conteÃºdo + padding). O cÃ³digo passa a largura do conteÃºdo, entÃ£o a cÃ©lula mais larga
   sempre quebra em 2 linhas.
   ```
   $ echo "name,age,city
   Alice,30,NYC" | charm-table-cli
   â•­â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â•®
   â”‚ nam â”‚ age â”‚ city â”‚
   â”‚ Ali â”‚ 30 â”‚ NYC â”‚
   ```
   Causa: `main.go:328` e `main.go:357` â€” `style.Width(colWidths[i]).Render(content)` com
   `Padding(0,1)`. CorreÃ§Ã£o: `Width(colWidths[i]+2)` (a borda jÃ¡ usa `w+2`).

2. **[CONFIRMADO] Ordem das colunas em JSON Ã© aleatÃ³ria.** `extractKeys` itera
   `map[string]interface{}` â†’ ordem muda a cada execuÃ§Ã£o (10 execuÃ§Ãµes â†’ 10 ordens).
   `main.go:226-233`. O comentÃ¡rio na linha 226 afirma "mantendo ordem de insercao" â€” Ã© falso.
   Fix: coletar chaves em slice preservando a ordem de apariÃ§Ã£o e ordenar deterministicamente
   (preferencialmente: ordem de apariÃ§Ã£o no primeiro registro que as contÃ©m, com as demais
   adicionadas depois em ordem alfabÃ©tica).

3. **[CONFIRMADO] Colunas presentes sÃ³ em registros posteriores sÃ£o descartadas em silÃªncio.**
   `main.go:142` e `main.go:177` chamam `extractKeys(records[0])` â€” sÃ³ o primeiro registro.
   `[{"a":1,"b":2},{"a":3,"c":9}]` â†’ a coluna `c` nÃ£o existe na saÃ­da.
   Fix: unir as chaves de **todos** os registros.

4. **[CONFIRMADO] `os.Stdin.Stat()` com erro descartado â†’ nil dereference.**
   `main.go:93-95`: `stat, _ := os.Stdin.Stat()`; se falhar, `stat == nil` e `stat.Mode()` causa
   `panic: invalid memory address or nil pointer dereference`.
   Fix: checar o erro.

5. **[CONFIRMADO] CSV com apenas uma linha (sÃ³ cabeÃ§alho) descarta o cabeÃ§alho real.**
   `main.go:210`: `if useHeader && len(allRows) > 1` â€” com 1 linha o cabeÃ§alho Ã© substituÃ­do por
   `Col1..ColN` e a linha vira dado.

6. **[CONFIRMADO] CSV com colunas irregulares aborta o programa.**
   `main.go:198-201`: `csv.Reader` com `FieldsPerRecord` implÃ­cito â†’
   `record on line 3: wrong number of fields`. Fix: `FieldsPerRecord = -1` e normalizar as linhas.

7. **[CONFIRMADO] `--style ascii` produz borda Unicode.**
   `main.go:19-22`: em lipgloss v2, `NormalBorder()` Ã© a borda **Unicode** (`â”Œâ”€â”¬â”€â”`); a ASCII Ã©
   `lipgloss.ASCIIBorder()` (`+---+`).

8. **[CONFIRMADO] `parseJSONL` nunca verifica `scanner.Err()`.**
   `main.go:161-171`: linha > 64 KB (limite default do `bufio.Scanner`) â†’ falha com mensagem
   enganosa "nenhum registro JSONL encontrado".

9. **[MÃ‰DIO] `--header=false` Ã© ignorado em JSON/JSONL.** `parseJSONArray`/`parseJSONL` nÃ£o recebem
   `useHeader`. O README documenta o flag como "Use first row as header" sem ressalva.

10. **[MÃ‰DIO] Larguras calculadas por `utf8.RuneCountInString` em vez de largura de exibiÃ§Ã£o.**
    `main.go:269` e `:274`. CJK (`æ—¥æœ¬èªž` = 3 runes / 6 cÃ©lulas) e emoji desalinham a tabela.
    Use `ansi.StringWidth` / `lipgloss.Width` (jÃ¡ disponÃ­veis via `github.com/charmbracelet/x/ansi`).

11. **[MÃ‰DIO] `--max-width` trunca dados silenciosamente** ("Alice" â†’ "A...") e pode exceder o
    limite pedido. `main.go:283-298`.

12. **[MÃ‰DIO] `formatValue` usa `interface{}` em vez de `any`** (`main.go:236`) â€” inconsistente com o
    resto do ecossistema.

13. **[BAIXO] Separador entre colunas usa `border.Left` (`â”‚`) em vez de `border.Middle` (`â”¼`)**
    (`main.go:331`, `:360`) â€” as junÃ§Ãµes nÃ£o se conectam com as bordas horizontais.

14. **[BAIXO] `trim`/`truncate` contam runes mas o lipgloss posiciona por largura de display**
    (`main.go:381-392`) â€” com CJK o corte cai no meio do glifo.

15. **[BAIXO] DetecÃ§Ã£o de TSV olha sÃ³ a primeira linha** (`main.go:122`) â€” CSV com TAB dentro de campo
    citado Ã© interpretado como TSV.

16. **[BAIXO] `csv.Reader` com `TrimLeadingSpace = true`** (`main.go:195-196`) remove espaÃ§os
    iniciais legÃ­timos dos valores.

---

## charm-diff â€” ðŸ”´ CRÃTICO

Arquivos: `diff.go`, `styles.go`.

1. **[CONFIRMADO] Hunks sobrepostos + cabeÃ§alho invÃ¡lido.** `buildHunks` (`diff.go:257-332`).
   Comparado com `git diff -U3` em 1022 casos: **593 divergem**.
   ```
   entrada: old="o00\no01\no02\no03\n"  new="n00\no01\no02\nn03\n"
   charm-diff: @@ -1,4 +1,3 @@  ...  @@ -2,3 +1,4 @@   <- hunk sobreposto, repete 4 linhas
   git:       @@ -1,4 +1,4 @@                              <- um hunk sÃ³
   ```
   Causa raiz: a janela do hunk Ã© indexada por **posiÃ§Ã£o da operaÃ§Ã£o**, mas a fusÃ£o
   (`diff.go:293-323`) compara **nÃºmeros de linha** (`OldLine`) e exige `firstOp.OldLine >= 0`
   (`diff.go:303`). Quando a janela comeÃ§a por uma **inserÃ§Ã£o** (`OldLine == -1`) a fusÃ£o Ã© pulada e
   os dois hunks se sobrepÃµem.

2. **[CONFIRMADO] `ContextLines` negativo â†’ panic.** `diff.go:284-288`:
   ```go
   charmdiff.UnifiedDiffWithOptions("a\nb\nc\n", "a\nX\nc\n", charmdiff.Options{ContextLines: -3})
   // panic: runtime error: slice bounds out of range [4:0]
   ```
   Com `ContextLines: -1` nÃ£o hÃ¡ panic, mas o diff sai **vazio** â€” as mudanÃ§as somem sem aviso.
   Fix: validar `ContextLines >= 0` (retornar erro ou normalizar para 0).

3. **[CONFIRMADO] CabeÃ§alho de hunk errado em hunk sÃ³ de inserÃ§Ã£o.** `diff.go:66-67` + `recalculateHunk`
   (`diff.go:338`): `UnifiedDiff("", "a\nb\n")` â†’ `@@ -1,0 +1,2 @@`, git produz `@@ -0,0 +1,2 @@`.
   `oldStart` deve ser a posiÃ§Ã£o **anterior** Ã  inserÃ§Ã£o. O diff resultante Ã© rejeitado por
   `git apply`.

4. **[CONFIRMADO] LCS O(nÂ·m) em memÃ³ria.** `diff.go:375-399`: 4000 linhas â†’ **127 MB** alocados
   (medido); 10.000 linhas â†’ ~800 MB (OOM). Git usa Myers. Fix: implementar Myers ou limitar o
   tamanho com fallback.

5. **[MÃ‰DIO] Truncagem/padding por bytes.** `padOrTruncate` (`diff.go:224-232`): `s[:width-3]` corta
   no meio de um rune multibyte â†’ UTF-8 invÃ¡lido. Usar `ansi.Truncate` / `lipgloss.Width`.

6. **[MÃ‰DIO] CÃ¡lculo da largura ignora os 2 espaÃ§os apÃ³s os nÃºmeros de linha.** `diff.go:111-116`:
   a saÃ­da side-by-side Ã© sempre 1-2 colunas mais larga que `width` pedido.

7. **[MÃ‰DIO] `splitLines` nÃ£o normaliza `\r\n`.** `diff.go:235-245`: o `\r` fica dentro do texto
   estilizado e no terminal o CR devolve o cursor Ã  coluna 0.

8. **[BAIXO] `Options.Style` nÃ£o Ã© validado** (`diff.go:66`): `Options{ContextLines:3}` sem Style
   renderiza sem cor nenhuma, silenciosamente.

9. **[BAIXO] Formato do cabeÃ§alho difere do git** (git omite `,1` quando a contagem Ã© 1).

10. **TESTES:** `diff_test.go` sÃ³ verifica `strings.Contains(result, "+line2")` e que o side-by-side
    "nÃ£o Ã© vazio". **Nenhum** teste compara estrutura de hunks, contagens do cabeÃ§alho, nÃºmero de
    hunks ou ordem das linhas.

---

## charm-test â€” ðŸ”´ CRÃTICO

Arquivos: `charmtest.go`, `keys.go`, `snapshot.go`, `assert.go`.

1. **[CONFIRMADO] `tea.Sequence` â†’ `fatal error: stack overflow`.**
   `processCmd` (`charmtest.go:135-159`) sÃ³ expande `tea.BatchMsg`. `tea.Sequence` com 2+ comandos
   produz `tea.sequenceMsg` (tipo **nÃ£o exportado** no Bubble Tea v2) â†’ cai em `s.Send(msg)` â†’ o
   modelo devolve outra Sequence â†’ recursÃ£o infinita.
   ```
   fatal error: stack overflow
   charm.land/bubbletea/v2.compactCmds[...](...)  commands.go:42
   ```
   Fix: reconhecer e expandir `tea.Sequence`. Como o tipo Ã© nÃ£o exportado, use `reflect` para
   detectar o tipo cujo nome Ã© `sequenceMsg` e extrair os `Cmd`s (slice de `tea.Cmd`), ou expanda
   via type assertion em `tea.BatchMsg` + tratamento do caso `sequenceMsg` por reflect.

2. **[CONFIRMADO] `Init()` retornando `tea.Tick` â†’ loop infinito (teste trava para sempre).**
   ```
   panic: test timed out after 15s
   	running tests:
   		TestTick (15s)
   ```
   `cmd()` Ã© executado **sincronamente e bloqueante** (`charmtest.go:140`) e `processCmd` reentra em
   `Send` (`charmtest.go:158`). O padrÃ£o canÃ´nico do Bubble Tea (devolver um tick a cada tick)
   nunca termina. ConsequÃªncia: **qualquer app com spinner/relÃ³gio Ã© intestÃ¡vel** â€” exatamente o
   que o framework deveria suportar.
   Fix: (a) executar comandos assÃ­ncronos de forma determinÃ­stica (tick/timeout devem ser
   *injetados*/simulados, nÃ£o dormidos de verdade); (b) impor **limite de profundidade** de recursÃ£o
   e **timeout** mÃ¡ximo de simulaÃ§Ã£o; (c) expor `Simulator.Advance(duration)` para avanÃ§ar o relÃ³gio
   virtual.

3. **[CONFIRMADO] `tea.Tick` roda de verdade â€” o README afirma "Deterministic: No goroutines, no
   timers".** Falso: `New()` com `Init` devolvendo `tea.Tick(300ms)` levou **300,58 ms** medidos.

4. **[CONFIRMADO] Ordem invertida vs. Bubble Tea real.** `charmtest.go:64-70`: `New()` entrega
   `WindowSizeMsg` ao `Update` **antes** de chamar `Init()`. No Bubble Tea v2 real, `Init()` Ã©
   chamado primeiro (`tea.go:1099`) e o `WindowSizeMsg` sÃ³ Ã© entregue quando o event loop inicia.
   Modelos que montam estado em `Init()` se comportam diferente no teste e em produÃ§Ã£o.

5. **[CONFIRMADO] `tea.ColorProfileMsg` e `tea.EnvMsg` nunca sÃ£o entregues.** O Bubble Tea real envia
   os dois (`tea.go:1070`/`tea.go:1077`). Modelos que decidem "aqui tem cor?" divergem entre teste
   e produÃ§Ã£o.

6. **[CONFIRMADO] `sim.Model().(*MyModel)` entra em pÃ¢nico para modelos com receptor por valor** â€”
   o estilo mais comum (o prÃ³prio `examples/counter` usa `Model` por valor).
   ```
   panic: interface conversion: tea.Model is main.Model, not *main.Model
   ```
   O README (`README.md:87`) documenta exatamente esse uso.
   Fix: helper genÃ©rico `ModelAs[T tea.Model](s *Simulator) (T, bool)` ou `Simulator[T]`.

7. **[MÃ‰DIO] `keyMsg` conta bytes.** `keys.go:59-63`: `if len(key) == 1` â†’ qualquer caractere
   multibyte ("Ã©", "Ã§", "æ¼¢") cai no `default` e vira `tea.KeyPressMsg{Text: key}` com `Code == 0`
   (cÃ³digo de tecla invÃ¡lido). Modelos que casam por `msg.Key().Code` nÃ£o casam.

8. **[MÃ‰DIO] `Code` de maiÃºsculas diverge do terminal real.** `keys.go:59-61`: `keyMsg("H")` â†’
   `Code='H'`, mas num terminal real Shift+H chega como `Code='h', Text="H", Mod=ModShift`.

9. **[MÃ‰DIO] Faltam teclas:** `f1`â€“`f12`, `alt+â€¦`, `cmd+â€¦`, `shift+enter`. Qualquer nome
   desconhecido vira `KeyPressMsg{Text: "f1"}` â€” texto arbitrÃ¡rio entregue ao modelo.

10. **[MÃ‰DIO] Snapshot inexistente Ã© criado e o teste passa sem comparar nada.**
    `snapshot.go:57-70` â€” em CI todo snapshot novo Ã© aceito sem validaÃ§Ã£o.
    `snapshot.go:54` â€” `CHARM_TEST_UPDATE=1` sobrescreve goldens sem confirmaÃ§Ã£o.

11. **[MÃ‰DIO] `s.messages` cresce sem limite** e `Messages()` (`charmtest.go:116`) devolve o slice
    interno (mutÃ¡vel externamente).

12. **[BAIXO] `s.model.View().Content` descarta o resto de `tea.View`** (`charmtest.go:104`):
    `AltScreen`, `Cursor`, `BackgroundColor`, `ProgressBar`, `WindowTitle`. O snapshot nÃ£o cobre
    cursor, altscreen, barra de progresso nem tÃ­tulo.

13. **[BAIXO] `RequireView` compara `TrimSpace` vs `TrimSpace` sem normalizar `\r\n`** â†’
    falha espÃºria em Windows.

14. **[BAIXO] `WithSize` nÃ£o valida `width/height > 0`**; `New` nÃ£o valida `model == nil`.

15. **[BAIXO] README sugere `assert.Equal` (testify), que nÃ£o Ã© dependÃªncia do mÃ³dulo** â€” o snippet
    do README nÃ£o compila.

16. **[NOTA] `charm-test` depende de `github.com/charmbracelet/x/exp/golden`** â€” pacote experimental
    e nÃ£o-oficial, com dependÃªncias antigas (`go-udiff`, `golang.org/x/exp` de 2022). Avalie
    substituÃ­-lo por um golden prÃ³prio (~100 linhas) para eliminar 3 dependÃªncias transitivas.

17. **TESTES:** o framework **nÃ£o tem testes prÃ³prios** (`go test ./...` â†’ "no test files" no pacote
    `charmtest`; sÃ³ `examples/counter` tem).

---

## charm-devtools â€” ðŸ”´ CRÃTICO

Arquivos: `devtools.go`, `inspector.go`.

1. **[CONFIRMADO] Ciclo de componentes â†’ `fatal error: stack overflow`.**
   `buildComponentNode` (`devtools.go:103-138`) recursiona via reflection sem detectar ciclos.
   ```
   fatal error: stack overflow
   github.com/junhinhow/charm-devtools.buildComponentNode  devtools.go:132
   ```
   ReproduÃ§Ã£o: modelo `A{B *B}` / `B{A *A}`, ambos implementando `tea.Model`; `devtools.Middleware(a)`
   mata o app **na inicializaÃ§Ã£o** (`devtools.go:156`). O ciclo sÃ³ nÃ£o dispara quando os campos sÃ£o
   nÃ£o exportados, porque `field.CanInterface()` (`devtools.go:128`) filtra â€” ou seja, o bug depende
   do estilo do usuÃ¡rio.
   Fix: manter um `map[uintptr]bool` (ou `map[reflect.Type]int` com contador de profundidade) de
   tipos/ponteiros jÃ¡ visitados e cortar a recursÃ£o; limitar a profundidade mÃ¡xima.

2. **[CONFIRMADO] `record(nil)` â†’ panic** (`devtools.go:74-78`): `reflect.TypeOf(nil).String()` com
   `msg == nil`. `Middleware(nil)` tambÃ©m entra em panic (`devtools.go:104-105`).

3. **[MÃ‰DIO] `updateState` e `updateComponents` rodam a cada mensagem.**
   `devtools.go:196-201`: `fmt.Sprintf("%+v", model)` + varredura reflexiva por mensagem.
   Medido: modelo com 500 campos â†’ 3,9 ms / 3,4 MB alocados a cada 100 mensagens.

4. **[MÃ‰DIO] Scroll invertido.** `inspector.go:94-99`: `start = len(messages) - 20 - m.scroll` com
   `KeyDown â†’ m.scroll++` â†’ apertar "baixo" mostra mensagens **mais antigas**. AlÃ©m disso
   `m.scroll` nÃ£o Ã© limitado ao nÃºmero de mensagens.

5. **[MÃ‰DIO] O painel nÃ£o fecha as linhas com `â•‘`** (`inspector.go:50-82`): sÃ³ cabeÃ§alho/rodapÃ© tÃªm
   borda, o corpo fica sem a borda direita.

6. **[MÃ‰DIO] `Name()` sobrescreve o nome do nÃ³ mesmo retornando `""`** (`devtools.go:111-113`) â†’
   nÃ³ aparece sem nome.

7. **[BAIXO] `truncate` corta por bytes** (`inspector.go:163-168`) â†’ UTF-8 invÃ¡lido.

8. **[BAIXO] `w.panel = newPanel.(inspectorModel)`** (`inspector.go:189`) â€” asserÃ§Ã£o de tipo sem
   `comma-ok` â†’ panic latente.

9. **[BAIXO] `Components()` faz cÃ³pia rasa** (`devtools.go:62-68`): as fatias `Children` sÃ£o
   compartilhadas com o estado interno.

10. **TESTES:** nenhum arquivo de teste no repositÃ³rio.

---

## charm-layout â€” ðŸ”´ CRÃTICO

Arquivos: `layout.go`, `grid.go`.

1. **[CONFIRMADO] `Grid.Columns = 0` â†’ `integer divide by zero`.** `Columns` Ã© campo **exportado**
   (`grid.go:11`); sÃ³ `NewGrid` valida (`grid.go:23-25`). `grid.go:67` e `:70` dividem por ele.
   ```go
   g := layout.NewGrid(3); g.Columns = 0; g.AddChild("a"); g.Render()
   // panic: runtime error: integer divide by zero
   ```
   Fix: validar no `Render` (nÃ£o sÃ³ no construtor), pois o campo Ã© pÃºblico.

2. **[CONFIRMADO] A largura declarada nÃ£o Ã© respeitada â€” o container nÃ£o Ã© preenchido.**
   `layout.go:95`/`layout.go:101`: `int(float64(available) * ratio)` trunca sem redistribuir o resto.
   `grid.go:67`: `(g.width - totalHGap) / g.Columns` (divisÃ£o inteira) perde colunas.
   README.md:12 promete *"Responsive â€” `SetSize(w, h)` adapts the layout to any terminal dimensions"*.

3. **[CONFIRMADO] RazÃµes nÃ£o precisam somar 1.** `layout.go:95` com ratios 0.3+0.3 â†’ sÃ³ 60% da
   largura usada. No CSS, `flex-grow` distribui o **espaÃ§o livre** proporcionalmente (dois filhos com
   0.3 â†’ 50/50). SemÃ¢ntica divergente e sem validaÃ§Ã£o.

4. **[MÃ‰DIO] RazÃ£o negativa / gap maior que o espaÃ§o geram layout quebrado.**
   `layout.go:95` com ratio `-0.5` â†’ `Width(-20)`. `grid.go:67` com `Gap=10, Columns=10, width=80`
   â†’ `colWidth = -1` â†’ linha renderizada com **91 colunas num terminal de 80** (estoura a tela).

5. **[MÃ‰DIO] AusÃªncia total de validaÃ§Ã£o de entrada.** `SetSize`, `SetGap`, `AddChild`
   (`layout.go:58,65,71`; `grid.go:35,42,48`) aceitam qualquer valor.

6. **[BAIXO] `grid.go:114-129` â€” `spacerH`/`spacerV` montam string por concatenaÃ§Ã£o em laÃ§o (O(nÂ²))**
   e duplicam o `strings.Repeat` jÃ¡ usado em `layout.go:112,119`.

7. **[BAIXO] `NewFlex` nÃ£o valida `Direction`** (`layout.go:47`): qualquer valor â‰  `Row` cai no `else`
   (`layout.go:99`) e vira Column silenciosamente.

8. **[BAIXO] `Flex.Children` / `Grid.Children` sÃ£o exported e mutÃ¡veis** â†’ ratios invÃ¡lidos sem
   passar por validaÃ§Ã£o.

9. **TESTES:** nenhum arquivo `_test.go` num pacote cujo Ãºnico produto Ã© geometria de layout.

---

## charm-form â€” ðŸ”´ CRÃTICO (funcional)

Arquivos: `form.go`, `generate.go`.

1. **[CONFIRMADO] NÃ£o existe TUI nenhuma.** README.md:3 â€” *"define forms in YAML, get interactive CLI
   apps"*; README.md:13 â€” *"a fully interactive terminal UI"*. O cÃ³digo **nÃ£o tem** nenhum import de
   `bubbletea`/`lipgloss`; `generate.go:19-26` â€” `Run()` chama `ToJSON()` e faz `fmt.Println`.
   O Ãºnico comentÃ¡rio Ã© `// Placeholder para futura integracao com charmbracelet/huh` (`generate.go:18`).
   O prÃ³prio README se contradiz: o Roadmap (`README.md:81-82`) marca `- [ ] Interactive TUI rendering`
   e `- [ ] CLI tool` como **pendentes**, enquanto a seÃ§Ã£o "Solution" jÃ¡ afirma que a feature existe.

2. **[CONFIRMADO] `go install github.com/junhinhow/charm-form@latest` falha.**
   ```
   package github.com/junhinhow/charm-form is not a main package
   ```
   O README (README.md:17-19 e README.pt-br.md:15-19) promete um CLI instalÃ¡vel que nÃ£o existe.

3. **[CONFIRMADO] Campo `validate` (regex) Ã© totalmente inerte.** README.md:41 documenta
   `validate: "^regex$"`; `form.go:28` apenas declara o campo. **Zero ocorrÃªncias de `regexp`** no
   repositÃ³rio â€” a regex nunca Ã© compilada, nunca validada (regex invÃ¡lida passa em silÃªncio) e nunca
   aplicada.

4. **[MÃ‰DIO] Nomes de campos duplicados sÃ£o aceitos.** README.md:33 diz `name: field_id # Required -
   unique identifier`, mas `form.go:52-68` nÃ£o checa unicidade.

5. **[BAIXO] `generate.go:10-13` â€” `json.MarshalIndent` sobre struct de tipos primitivos nunca falha**;
   o `error` Ã© cÃ³digo morto. `Run` escreve direto em `os.Stdout` (sem `io.Writer` injetÃ¡vel â†’
   impossÃ­vel de testar).

6. **[BAIXO] `form.go:14` â€” `Description` Ã© lida do YAML e nunca usada.**

7. **[BAIXO] `form.go:54` â€” o erro usa Ã­ndice 0-based** ("campo 0: 'name' e obrigatorio") para algo
   que o usuÃ¡rio conta como 1-based.

8. **[BAIXO] `fmt.Errorf` sem `%w` e sem formataÃ§Ã£o em `form.go:47,50,54,57,63,66`** â†’ deveria ser
   `errors.New`.

9. **TESTES:** zero arquivos `_test.go`. Todo o valor do pacote estÃ¡ no parsing/validaÃ§Ã£o.

### DecisÃ£o de produto requerida
Duas saÃ­das possÃ­veis (escolha uma e documente):
- **(A) Implementar a TUI** com Bubble Tea + o renderer interativo, e um `cmd/charm-form` instalÃ¡vel.
- **(B) Reduzir o escopo honestamente**: renomear para "parser/validador de formulÃ¡rios YAML",
  implementar o campo `validate` (regex), remover a promessa de TUI/CLI do README e do Ã­ndice
  (`charm-suite/README.md`), e remover o item da lista de "18 bibliotecas interativas".

---

## charm-color â€” ðŸŸ  ALTO

Arquivo: `color.go`.

1. **[CONFIRMADO] Alfa prÃ©-multiplicado tratado como straight RGB.** `color.go:14-51` e `:94-97`:
   `c.RGBA()` devolve valores prÃ©-multiplicados, mas o cÃ³digo lÃª `r>>8` como canal direto e devolve
   `color.NRGBA`.
   ```
   ToHex(color.NRGBA{255,0,0,128})        = #800000   (esperado #ff0000)
   ToHex(Darken(color.NRGBA{255,0,0,128},0)) = #400000 (Darken(c,0) deveria ser identidade)
   ToHex(Lighten(color.NRGBA{255,0,0,128},0))= #400000
   ```
   OperaÃ§Ãµes com alfa < 255 corrompem a cor silenciosamente.

2. **[CONFIRMADO] `Complementary` nÃ£o devolve o complementar.** `color.go:67-76`: Ã© **inversÃ£o RGB**
   (`255-c`), nÃ£o "oposta na roda de cores" como o doc diz.
   ```
   Complementary(#402080) = #bfdf7f   (complementar real HSL+180: #608020)
   Complementary(#00a0b0) = #ff5f4f   (real: #b01000)
   Complementary(#f0e68c) = #0f1973   (real: #8c96f0)
   ```
   SÃ³ coincide para cores com Lâ‰ˆ0,5 (vermelhoâ†’ciano), que Ã© exatamente o caso coberto pelo teste.

3. **[MÃ‰DIO] `FromHex` devolve preto silencioso para entrada invÃ¡lida** (`color.go:101-112`), sem
   `error`. TambÃ©m nÃ£o aceita `#RRGGBBAA`.

4. **[MÃ‰DIO] Truncamento em vez de arredondamento** (`color.go:18,33`): `uint8(float64(r>>8)*factor)`
   â†’ 255Ã—0,5 = 127,5 â†’ 127 (perde meio-tom).

5. **[BAIXO] `max`/`min` locais sombreiam os builtins** do Go 1.21+ (`color.go:149-150`).

6. **[BAIXO] Pacote chamado `color` importando `image/color`** â†’ todo consumidor precisa de alias
   (o prÃ³prio README usa `cc "github.com/junhinhow/charm-color"`). Considerar renomear o pacote para
   `charmcolor` ou manter e documentar.

7. **TESTES:** `color_test.go` nÃ£o cobre alfa, complementar real (sÃ³ o caso do vermelho, que mascara o
   bug #2), arredondamento nem entradas invÃ¡lidas alÃ©m de `"invalid"`.

---

## charm-nav â€” ðŸŸ  ALTO

Arquivos: `sidebar.go`, `tabs.go`, `breadcrumb.go`.

1. **[CONFIRMADO] Cursor do sidebar usa `len()` (bytes) em vez da largura de exibiÃ§Ã£o.**
   `sidebar.go:87`: `padding := strings.Repeat(" ", len(s.Cursor))`. O cursor padrÃ£o `"â–¸ "` tem
   **4 bytes / 2 colunas**.
   ```
   | â–¸ Dashboard        |   <- texto comeÃ§a na coluna 3
   |     Users          |   <- texto comeÃ§a na coluna 5
   ```
   O item selecionado fica 2 colunas Ã  esquerda dos demais. O README (README.md:71-74) mostra o
   resultado alinhado.

2. **[MÃ‰DIO] Itens longos quebram linha em vez de serem truncados.** `sidebar.go:91-93`: o conteÃºdo
   vai para o `containerStyle` (`Width(20)` + `PaddingLeft(1)/PaddingRight(1)`) â†’ o lipgloss faz
   word-wrap em 18 colunas, e as linhas de continuaÃ§Ã£o **nÃ£o recebem o prefixo do cursor** â†’ o item
   desalinha. Falta `MaxWidth`/truncagem.

3. **[MÃ‰DIO] `Items()` expÃµe o slice interno (aliasing).** `sidebar.go:66-68`, `tabs.go:64-66`,
   `breadcrumb.go:47-49` devolvem `s.items` diretamente â†’ `items[0] = "X"` altera o estado interno.
   Os construtores tambÃ©m guardam o slice variÃ¡dico sem cÃ³pia.

4. **[MÃ‰DIO] O highlight do item selecionado nÃ£o cobre a linha inteira.** `sidebar.go:85`:
   `s.SelectedStyle.Render(cursor+item)` aplica o `Background` sÃ³ sobre o texto; o padding atÃ©
   `Width` fica com o fundo padrÃ£o.

5. **[BAIXO] API inconsistente:** `Breadcrumb` tem `Push`/`Pop`; `Tabs`/`Sidebar` nÃ£o tÃªm nenhuma forma
   de adicionar itens apÃ³s a criaÃ§Ã£o (`items` Ã© privado, sem `Add`).

6. **TESTES:** nenhum arquivo `_test.go`.

---

## charm-i18n â€” ðŸŸ  ALTO

Arquivo: `i18n.go`.

1. **[CONFIRMADO] "RTL support" Ã© anunciado e nÃ£o existe.** README.md:3 e README.pt-br.md:3
   mencionam RTL. **Zero ocorrÃªncias de `RTL|bidi|BiDi|arab|hebrew` em todo o repositÃ³rio** alÃ©m do
   README. Sem reordenaÃ§Ã£o visual, sem `direction`, sem tratamento de scripts bidirecionais.

2. **[CONFIRMADO] `parseLocale` nÃ£o normaliza `C.UTF-8` / `POSIX.UTF-8`.** `i18n.go:118-141`: a
   checagem `raw == "C" || raw == "POSIX"` (`i18n.go:119`) ocorre **antes** de remover o encoding
   (`i18n.go:124-126`).
   ```
   LANG=C.UTF-8     -> DetectLocale() == "C"
   LANG=POSIX.UTF-8 -> DetectLocale() == "POSIX"
   ```
   `C.UTF-8` Ã© o default de muitos Linux modernos (systemd/Debian).

3. **[CONFIRMADO] `Tf` injeta artefatos do `fmt.Sprintf` na saÃ­da da UI.** `i18n.go:95-101`:
   ```
   Tf("missing.key", "Gopher") = "missing.key%!(EXTRA string=Gopher)"
   ```
   NÃ£o hÃ¡ como o chamador detectar o erro (retorna `string`, nÃ£o `error`).

4. **[MÃ‰DIO] NÃ£o hÃ¡ negociaÃ§Ã£o de locale (fallback chain) nem normalizaÃ§Ã£o de caixa.**
   `DetectLocale` devolve `"pt-BR"`, mas o catÃ¡logo sÃ³ casa por igualdade exata (`i18n.go:74-87`).
   `LANG=PT_br.UTF-8` â†’ `"PT-br"`, que nÃ£o casa com a chave `"pt-BR"`.

5. **[MÃ‰DIO] `Has` contradiz `T`.** `Has` (`i18n.go:181-190`) sÃ³ olha o locale ativo; `T`
   (`i18n.go:69-91`) cai no fallback. `Has("hello")==false` mas `T("hello")=="Hello"`.

6. **[BAIXO] `Locales()` devolve ordem aleatÃ³ria** (iteraÃ§Ã£o de map) â€” `i18n.go:169-178`.

7. **[BAIXO] `i18n.go:119` nÃ£o trata `"c"`/`"posix"` minÃºsculos.**

8. **TESTES:** `i18n_test.go:101-110` faz `os.Unsetenv` sem restaurar; `i18n_test.go:79-83` faz
   `defer os.Unsetenv("LANG")` em vez de restaurar o valor original â†’ altera permanentemente o
   ambiente do binÃ¡rio de teste. Use `t.Setenv`.

---

## charm-palette â€” ðŸŸ  ALTO

Arquivo: `palette.go`.

1. **[CONFIRMADO] `nil` em `[]color.Color` â†’ nil dereference.**
   `palette.go:30`, `:169`, `:240` chamam `c.RGBA()` sem checar nil e sem nenhuma validaÃ§Ã£o nas 5
   funÃ§Ãµes pÃºblicas.
   ```
   ShowPalette([]color.Color{nil}, 20)
   // panic: runtime error: invalid memory address or nil pointer dereference
   ```

2. **[CONFIRMADO] `ShowPalette` quebra o layout quando a largura Ã© pequena.**
   `palette.go:22-25`: `swatchWidth := width / len(colors)` com clamp mÃ­nimo **4**, mas o rÃ³tulo hex
   tem 7 caracteres (`#rrggbb`) â†’ o `Width(4).Align(Center)` faz o lipgloss quebrar a linha.
   ```
   #ff5
   95e #ffc
   a3a #8ac
   ```
   AlÃ©m disso o clamp mÃ­nimo 4 ignora o `width` pedido.

3. **[CONFIRMADO] `ShowTheme` e `CompareThemes` tÃªm ordem nÃ£o-determinÃ­stica.**
   `palette.go:168` (`for label, c := range colors`) e `palette.go:224` (`for key := range allKeys`)
   iteram maps â†’ 5 chamadas com o mesmo mapa produziram **3 ordens diferentes**. Um "preview de
   tema" que muda a cada renderizaÃ§Ã£o quebra qualquer teste por snapshot.

4. **[MÃ‰DIO] `CompareThemes`: o cabeÃ§alho nÃ£o alinha com as colunas.** `palette.go:213-220` escreve o
   cabeÃ§alho a partir da coluna 0, mas as linhas de cor comeÃ§am com um rÃ³tulo de 12 colunas
   (`palette.go:228`).

5. **[MÃ‰DIO] RÃ³tulos longos quebram linha / padding por bytes.** `palette.go:177-180` (`Width(12)`)
   e `palette.go:226-228` (`%-12s` = padding por bytes, nÃ£o por largura de exibiÃ§Ã£o).

6. **[BAIXO] `palette.go:85-87` â€” o `break` sÃ³ sai do laÃ§o interno** (latente).

7. **[BAIXO] `palette.go:177-180` â€” o rÃ³tulo Ã© desenhado na prÃ³pria cor**: para cores escuras
   (ex. `background: #0f172a`) o texto fica ilegÃ­vel.

8. **[BAIXO] `palette.go:30,169,240` â€” `c.RGBA()` Ã© alpha-premultiplicado em alguns tipos**
   (ex. `color.NRGBA`, `RGBA64`) â†’ `r>>8` devolve cor escurecida.

9. **TESTES:** nenhum; `hslToRGB` (`palette.go:258-280`) nÃ£o tem teste.

---

## charm-wizard â€” ðŸŸ  ALTO

Arquivos: `wizard.go`, `progress.go`.

1. **[CONFIRMADO] `RenderProgress` panic com Ã­ndice fora do range.** `progress.go:63`:
   `etapaAtual := steps[currentIndex]` sem validar o Ã­ndice, em funÃ§Ã£o **exportada**.
   ```
   panic: index out of range [5] with length 2
   ```
   O Ãºnico guard Ã© `len(steps) == 0` (`progress.go:56`). Ãndice negativo tambÃ©m entra em panic.

2. **[MÃ‰DIO] `Back()`/`Forward()` nÃ£o validam transiÃ§Ã£o.** `wizard.go:84-99`: `Forward()` avanÃ§a
   mesmo que a etapa atual tenha falhado (`RunStep()` retornou erro) e `Back()` **nÃ£o desfaz** os
   efeitos colaterais da etapa â€” o `map[string]any` compartilhado (`wizard.go:56-58`) mantÃ©m os dados
   jÃ¡ escritos.

3. **[MÃ‰DIO] `Run()` ignora o estado de navegaÃ§Ã£o.** `wizard.go:120-135`: sempre executa da etapa 0 ao
   fim e sobrescreve `w.currentStep` a cada iteraÃ§Ã£o.

4. **[MÃ‰DIO] NÃ£o hÃ¡ getters tipados.** O exemplo do prÃ³prio README (`README.md:50`) faz
   `data["build_artifact"].(string)` â†’ **panic** se a chave nÃ£o existir. Falta `GetString/GetBool` com
   `(valor, ok)`.

5. **[MÃ‰DIO] `renderBar`: percentual nÃ£o Ã© limitado a 100.** `progress.go:107-122`:
   `percentual := ((current+1)*100)/total` â€” com `current >= total` â†’ 300%, enquanto a barra Ã©
   limitada a 30 (`progress.go:113-115`).

6. **[MÃ‰DIO] `RunStep()` Ã© silencioso** (`wizard.go:143-157`) â€” num wizard interativo o usuÃ¡rio nÃ£o vÃª
   nada a menos que chame `RenderProgress` manualmente â€” e essa chamada entra em pÃ¢nico (achado 1).

7. **[BAIXO] `wizard.go:1` â€” o comentÃ¡rio do pacote comeÃ§a com "Pacote wizard"** em vez de
   "Package wizard ..." (convenÃ§Ã£o Go; `revive`/`golint` acusam).

8. **[BAIXO] `wizard.go:112-139` â€” `Run()` imprime um bloco de progresso por etapa** (nÃ£o redesenha
   in-place) e mistura a saÃ­da do `RunFunc` do usuÃ¡rio com o progresso â†’ saÃ­da embaralhada.

9. **[BAIXO] API incompleta:** nÃ£o hÃ¡ `IsFirst()`, `IsLast()`, `CurrentStepName()`, `Progress()`.

10. **[BAIXO] `README.md:71-84` â€” a tabela de API omite `Steps()`** (`wizard.go:77`).

11. **TESTES:** nenhum arquivo de teste.

---

## charm-banner â€” ðŸŸ  ALTO

Arquivo: `banner.go`.

1. **[CONFIRMADO] Ãndice de BYTE usado como Ã­ndice de RUNE.** `banner.go:68-83`: no
   `for i, ch := range upper`, `i` Ã© o offset em bytes; o teste `if i < len(upper)-1` (`:79`) compara
   offset de byte com comprimento em bytes. Quando o **Ãºltimo** caractere Ã© multibyte, o separador Ã©
   acrescentado indevidamente: `Render("BÃ")` â†’ 8 colunas em vez de 7.
   Fix: iterar com contador de runes ou `utf8.RuneCountInString(upper)`.

2. **[CONFIRMADO] DimensÃµes documentadas erradas.** `banner.go:16-23` e README ("Small (3Ã—3),
   Medium (5Ã—5), Large (7Ã—7)"): as **alturas** conferem (3/5/7), as **larguras** nÃ£o â€” Small=3,
   Medium=**6**, Large=**9** colunas. Corrija a fonte E/OU a documentaÃ§Ã£o (preferencialmente a fonte,
   para que os glifos sejam quadrados).

3. **[BAIXO] `fontWidth()` Ã© cÃ³digo morto** (`banner.go:108`).

4. **[BAIXO] `Render("")` devolve `"\n\n\n\n"`** (4 linhas vazias) em vez de string vazia.

5. **[BAIXO] Caracteres fora do mapa sÃ£o desenhados silenciosamente como espaÃ§o** (`banner.go:69-72`).
   O README promete "common punctuation", mas sÃ³ existem `!`, `.`, `-`, `:`. Faltam `,` `?` `/` `+`
   `=` `(` `)` `*` `#` `&` `@` `$` `%` `'` `"` `<` `>` `[` `]` `_` `{` `}` `|` `~` `^` `` ` `` e
   as letras acentuadas (Ã Ã€ Ã‚ Ãƒ Ã‰ ÃŠ Ã Ã“ Ã” Ã• Ãš Ã‡ etc.).

6. **TESTES:** `banner_test.go` sÃ³ verifica "saÃ­da nÃ£o vazia" e contagem de linhas. Nenhum teste mede
   **largura/alinhamento entre caracteres** nem cobre entrada multibyte.

---

## charm-charts â€” ðŸŸ  ALTO

Arquivos: `barchart.go`, `sparkline.go`, `progress.go`. **Zero testes no repositÃ³rio.**

1. **[CONFIRMADO] `Width(0)` â†’ panic.** `sparkline.go:72-75`: `index out of range [0] with length 0`.
   **`Width(-1)` â†’ panic** (`makeslice: len out of range`). NÃ£o hÃ¡ clamp, ao contrÃ¡rio de `Height()`
   (`sparkline.go:42-51`) que limita 1..8.

2. **[CONFIRMADO] `ProgressBar.Width(-1)` â†’ panic.** `progress.go:86-93`:
   `strings: negative Repeat count`. `NewProgressBar` valida o *value* (`:25-30`), nÃ£o a largura.

3. **[CONFIRMADO] `BarChart.BarWidth(-1)` â†’ panic** (`barchart.go:175`, `:189`:
   `strings: negative Repeat count`). E a truncagem `label = label[:colWidth-1] + "."` (`:189`) corta
   por **bytes**, gerando **UTF-8 invÃ¡lido** (`"a\xc3."`).

4. **[MÃ‰DIO] Modo horizontal: `BarWidth` duplica a linha inteira** (`barchart.go:144-149`) em vez de
   engrossar a barra. Doc diz *"thickness of each bar (in rows for horizontal charts)"*.

5. **[MÃ‰DIO] Modo vertical ignora `Width()` e `ShowValues()`.** `barchart.go:155-204`. O README lista
   `.Width(n)` e `.ShowValues(bool)` como opÃ§Ãµes gerais do `BarChart`.

6. **[MÃ‰DIO] `maxLabelLen` calculado com `len(l)` (bytes)** (`barchart.go:111`) em vez de largura de
   exibiÃ§Ã£o.

7. **[MÃ‰DIO] Comportamento inconsistente do rÃ³tulo do sparkline.** `sparkline.go:88-135`: em
   `Height(1)` o label Ã© inline (`"CPU  â–ˆ"`), em multi-linha ele vira uma linha separada **acima** do
   grÃ¡fico e nÃ£o Ã© estilizado.

8. **[BAIXO] `resample` nÃ£o expande os dados** (`sparkline.go:139-160`) â€” o doc diz *"reduces or
   expands"*, mas com 3 dados e `Width(10)` a saÃ­da tem 3 colunas.

9. **[BAIXO] Reserva fixa de 10 colunas para o valor** (`barchart.go:117-118`) â€” valores grandes
   estouram a largura pedida.

10. **[BAIXO] RÃ³tulos alinhados Ã  direita no horizontal e Ã  esquerda no vertical**
    (`barchart.go:131`, `:192`); no vertical ficam colados (`"GoR."`).

---

## charm-toast â€” ðŸŸ  ALTO

Arquivo: `toast.go`.

1. **[CONFIRMADO] `Render(width)` posiciona mas nÃ£o restringe.** `toast.go:159-161`:
   `lipgloss.PlaceHorizontal(width, lipgloss.Right, boxed)` â€” conteÃºdo mais largo que `width` sai com
   a largura real (medido: largura pedida **20**, largura real **174**). Numa app Bubble Tea a view
   ultrapassa o terminal. Falta `MaxWidth`/truncamento.

2. **[CONFIRMADO] Data race em `MaxVisible`.** `toast.go:170-171` + `:253`: `MaxVisible` Ã© campo
   pÃºblico **lido dentro do `Render` sob o mutex, mas escrito pelo usuÃ¡rio sem lock**.
   ```
   WARNING: DATA RACE
   Write at ... main.go:21
   Previous read at ... charm-toast/toast.go:253
   ```
   O README (README.md:13) afirma *"Thread-safe toast management"* â€” falso para esse campo.

3. **[MÃ‰DIO] `Add()` sobrescreve `t.CreatedAt = time.Now()`** (`toast.go:182-187`): um toast **jÃ¡
   expirado Ã© revivido** ao ser adicionado, e o `CreatedAt` definido pelo usuÃ¡rio Ã© descartado â€” apesar
   do campo exportado documentado em `toast.go:86-87`.

4. **[MÃ‰DIO] `Render` nÃ£o remove toasts expirados.** SÃ³ `Cleanup()` (`toast.go:210`) faz, e nada
   obriga o app a chamar â†’ crescimento ilimitado. AlÃ©m disso `toast.go:258`
   (`append([]string{t.Render(width)}, lines...)`) realoca a slice a cada toast â†’ **O(nÂ²) em alocaÃ§Ãµes
   no hot path de renderizaÃ§Ã£o**.

5. **[MÃ‰DIO] `Toast.Render` instancia 3 `lipgloss.Style` + borda a cada chamada**
   (`toast.go:133-164`), e `ToastManager.Render` chama isso por toast **dentro do lock**.

6. **[MÃ‰DIO] README Ã— implementaÃ§Ã£o:** README.md:10 â€” *"Auto-dismiss with configurable duration"*.
   NÃ£o hÃ¡ timer: sÃ³ funciona se o app chamar `tm.Cleanup()` periodicamente. NÃ£o hÃ¡ `tea.Cmd`/
   `tea.Tick` de expiraÃ§Ã£o nem `tea.Msg` de notificaÃ§Ã£o â€” apesar de o README (README.md:3) chamar o
   pacote de *"Toast notification component for Bubble Tea"*.

7. **[BAIXO] `toast.go:252-261` â€” ordem de exibiÃ§Ã£o do mais antigo (topo) para o mais novo (base)**,
   enquanto o corte de `MaxVisible` mantÃ©m os **mais novos**.

8. **[BAIXO] `toast.go:119-121` â€” `Duration == 0` â†’ expirado imediatamente**, sem aviso.

9. **[BAIXO] API incompleta:** nÃ£o hÃ¡ `Toasts()`, `Remove(id)`, `Update(...)`.

10. **[BAIXO] README.md:60-67 lista `toast.WithType(ToastType) Toast` como se fossem funÃ§Ãµes de
    pacote** â€” sÃ£o mÃ©todos de `Toast`.

11. **TESTES:** `toast_test.go:96-102` sÃ³ verifica `output != ""`; `toast_test.go:164-175`
    (`TestToastManagerMaxVisible`) sÃ³ verifica `output != ""` â€” **nÃ£o verifica que no mÃ¡ximo
    `MaxVisible` sÃ£o renderizados**; o nome do teste mente.

---

## charm-themes â€” ðŸŸ  ALTO

Arquivos: `themes.go`, `theme.go`, `lipgloss.go`.

1. **[CONFIRMADO] `Themes()` devolve ponteiros para as variÃ¡veis globais.** `themes.go:15-23`:
   `map[string]*Theme` com `&Gruvbox`, `&Dracula`, `&Nord`â€¦ Qualquer customizaÃ§Ã£o via
   `themes.Themes()["nord"].Primary = X` **corrompe o tema global** `themes.Nord` para todo o
   processo. Fix: devolver cÃ³pias (`Theme` Ã© struct â€” a cÃ³pia Ã© barata).

2. **[CONFIRMADO] README Ã— implementaÃ§Ã£o:** README.md:5 â€” *"Define a color palette once, use it
   everywhere â€” lipgloss, glamour and bubbles"*; o doc do pacote (`theme.go:1-6`) â€” *"applied
   consistently across lipgloss styles, glamour markdown rendering, and bubbles components"*.
   **NÃ£o existe nenhuma integraÃ§Ã£o com glamour ou bubbles** â€” o Ãºnico mÃ©todo Ã© `Theme.Lipgloss()`
   (`lipgloss.go:28`).

3. **[MÃ‰DIO] NÃ£o hÃ¡ `Get(name)`/lookup por nome** (`themes.go:15`) â€” o usuÃ¡rio itera o mapa e trata
   "nÃ£o encontrado" por conta prÃ³pria â€” e o mapa Ã© reconstruÃ­do (alocaÃ§Ã£o) a cada chamada.

4. **[MÃ‰DIO] `Lipgloss()` cria 13 `lipgloss.Style` por chamada** (`lipgloss.go:28-59`); nada documenta
   que deve ser chamado uma vez.

5. **[MÃ‰DIO] README.md:33-35 â€” o snippet usa `lipgloss.NewStyle()` sem importar lipgloss** â†’ nÃ£o
   compila como estÃ¡.

6. **[BAIXO] `theme.go:14-35` â€” `Theme` e `SyntaxColors` nÃ£o tÃªm `Validate()`**; tema montado Ã  mÃ£o
   com cores ausentes renderiza sem cor nem erro.

7. **TESTES:** nenhum. NÃ£o hÃ¡ verificaÃ§Ã£o de que `Themes()` estÃ¡ em sincronia com as variÃ¡veis
   globais, nem de que os nomes batem com as chaves do mapa (`"tokyo-night"` vs `TokyoNight.Name`).

---

## charm-notify â€” ðŸŸ  ALTO

Arquivos: `notify.go`, `notify_linux.go`, `notify_windows.go`, `notify_darwin.go`, `notify_other.go`.

1. **[CONFIRMADO] OpÃ§Ãµes documentadas sÃ£o silenciosamente ignoradas em cada plataforma.**
   README.md:12 â€” *"Functional options: icon, timeout, sound"* (sem ressalvas por plataforma).
   - `Icon`: sÃ³ usado em `notify_linux.go:20-22` â†’ ignorado no Windows (`notify_windows.go:13-34`
     e `:37-45`) e no macOS (`notify_darwin.go:12-26`).
   - `Sound`: sÃ³ no macOS (`notify_darwin.go:22-24`) e no BurntToast (`notify_windows.go:29-31`) â†’
     ignorado no Linux.
   - `Timeout`: ignorado no macOS e no caminho principal do Windows (`sendBurntToast`). SÃ³ `sendMsg`
     usa, e truncado: `notify_windows.go:38` `int(n.Timeout.Seconds())` â†’ `WithTimeout(500ms)` vira
     **5 segundos** (`notify_windows.go:39-41`).

2. **[CONFIRMADO] Falha silenciosa: stderr descartado e erro do BurntToast perdido.** Todas as
   plataformas usam `exec.Command(...).Run()` sem `Stderr` â†’ a saÃ­da de `osascript`/`powershell`/`msg`
   Ã© jogada fora e o erro devolvido Ã© apenas `exit status 1`. `notify_windows.go:13-19`: se
   `sendBurntToast` falha, o erro Ã© **descartado** e `sendMsg` roda; se tambÃ©m falha, o erro
   retornado Ã© sÃ³ o do `msg` â†’ o usuÃ¡rio nunca descobre que o BurntToast nÃ£o estÃ¡ instalado.
   Fix: `errors.Join(errBurntToast, errMsg)` + capturar stderr.

3. **[MÃ‰DIO] Sem `exec.LookPath` no Windows/macOS.** `notify_linux.go:13-16` faz `LookPath` e devolve
   mensagem Ãºtil; `notify_darwin.go:26` e `notify_windows.go:33,44` vÃ£o direto ao `exec.Command` â†’
   erro cru *"executable file not found in $PATH"*.

4. **[MÃ‰DIO] Erros nÃ£o tipados / sem contexto.** `notify.go:48,51` usam `fmt.Errorf` sem `%w`
   (deveria ser `errors.New`); nenhum erro identifica **qual** comando falhou.

5. **[MÃ‰DIO] CI nunca compila Windows nem macOS.** `.github/workflows/ci.yml` roda sÃ³ em
   `ubuntu-latest` â†’ `notify_windows.go` e `notify_darwin.go` **nunca sÃ£o compilados/testados**.

6. **[BAIXO] `notify_other.go:8` â€” `sendPlatform(n *Notification)` com parÃ¢metro nÃ£o usado**; a
   mensagem de erro nÃ£o inclui `runtime.GOOS`.

7. **[BAIXO] `WithTimeout(0)`/negativo nÃ£o tem semÃ¢ntica documentada.**

8. **NOTA (verificado OK):** o escaping do AppleScript (`notify_darwin.go:14-18`) e do PowerShell
   (`notify_windows.go:24-25`) foram testados com payloads adversariais (`\"`, `$(...)`, aspas
   simples, quebras de linha) e **nenhum** consegue escapar do literal. A Ãºnica ressalva: quebras de
   linha viram comando multilinha e nÃ£o sÃ£o rejeitadas com erro claro.

9. **TESTES:** nenhum.

---

## charm-dialog â€” ðŸŸ  ALTO

Arquivo: `dialog.go`.

1. **[CONFIRMADO] `RenderOverlay` nÃ£o centraliza verticalmente.** `dialog.go:218-243`: calcula
   `topPad` (`:223-226`) mas **nunca adiciona `bottomPad`**. Com `RenderOverlay(80,24)` a saÃ­da tem
   **17 linhas** (nÃ£o 24) e o diÃ¡logo fica deslocado para cima. Contraria o doc: *"centralizado
   vertical e horizontalmente dentro das dimensoes fornecidas"*.

2. **[CONFIRMADO] `RenderOverlay` com `width < 0` â†’ panic.** `dialog.go:230`:
   `strings.Repeat(" ", width)` â†’ `strings: negative Repeat count`.

3. **[MÃ‰DIO] `Render(width)` ignora `width` como limite.** `dialog.go:167-213`: o `width` sÃ³ Ã© usado
   no `lipgloss.PlaceHorizontal` (`:210`), sem `MaxWidth`/quebra. Com mensagem longa e `Render(40)` o
   diÃ¡logo sai com **~330 colunas** â†’ estoura a tela num TUI.

4. **[MÃ‰DIO] README Ã— implementaÃ§Ã£o:** *"**Input** dialogs with text entry"* â€” nÃ£o existe **nenhum**
   mÃ©todo de tratamento de teclas/entrada; o `Dialog` sÃ³ expÃµe o campo `InputValue`
   (`dialog.go:82`), que o usuÃ¡rio deve atualizar manualmente.

5. **[BAIXO] `WithStyles` tem receptor por valor** (`dialog.go:139`) e devolve cÃ³pia: `d.WithStyles(s)`
   sem reatribuiÃ§Ã£o nÃ£o tem efeito.

6. **[BAIXO] No `TypeInput`, o prompt (com `Padding(1,0)`) recebe `\n` depois do padding**
   (`dialog.go:175-181`) â†’ uma linha em branco extra entre prompt e campo.

7. **[BAIXO] `RenderOverlay` sempre termina com `"\n"`** (`dialog.go:240`).

8. **TESTES:** `dialog_test.go` sÃ³ verifica "nÃ£o vazio" e "contÃ©m o texto" (`:102-121`). Nada verifica
   **largura, centralizaÃ§Ã£o, borda, nÃºmero de linhas nem o modo `TypeInput`**.

---

## charm-spinner â€” ðŸŸ¡ MÃ‰DIO

Arquivo: `spinner.go`.

1. **[CONFIRMADO] `Render(frame int)` pode entrar em panic.** `spinner.go:21`:
   `s.Frames[frame%len(s.Frames)]` sem guarda â†’ `frame` negativo dÃ¡ `index out of range [-1]`;
   `Frames` vazio dÃ¡ `integer divide by zero`. Ambos reproduzidos. Como `Spinner` tem campos
   exportados e o README mostra a construÃ§Ã£o de spinner customizado, o panic Ã© alcanÃ§Ã¡vel pela API
   pÃºblica.

2. **[MÃ‰DIO] `var Style` Ã© global exportado e mutÃ¡vel** (`spinner.go:17`), lido dentro de `Render`
   (hot path) â†’ data race se reatribuÃ­do em runtime enquanto outro goroutine renderiza.

3. **[MÃ‰DIO] README Ã— implementaÃ§Ã£o:** README.pt-br.md:37 diz *"Mais de 30 spinners predefinidos"* e
   README.md:3 diz *"30+"*. Existem **exatamente 30** (`All()` â†’ `len == 30`). "Mais de 30" Ã©
   factualmente falso. Ou adicione mais spinners, ou corrija o texto.

4. **[BAIXO] `All()` reconstrÃ³i um mapa de 30 entradas a cada chamada** (`spinner.go:150`).

5. **TESTES:** `spinner_test.go:18-27` (`TestRenderCycles`) sÃ³ checa `result != ""` â†’ nÃ£o pega nenhum
   dos panics do achado 1. NÃ£o hÃ¡ teste de ciclo correto (frame 10 de `Dots` â†’ frame 0) nem de
   unicidade de nomes em `All()`.

---

## Problemas transversais (todos os 18 repos)

1. **A CI estÃ¡ estruturalmente invÃ¡lida em 16 de 18.** A matriz de Go Ã© anterior Ã  diretiva `go` do
   `go.mod`:
   ```
   charm-spinner  go.mod: go 1.26.1  â†  CI: ['1.22','1.23']
   charm-toast    go.mod: go 1.26.1  â†  CI: ['1.23','1.24']
   charm-banner   go.mod: go 1.25.0  â†  CI: ["1.23","1.24"]
   charm-charts   go.mod: go 1.25.0  â†  CI: ['1.23','1.24']
   charm-color    go.mod: go 1.26.1  â†  CI: ["1.22","1.23"]
   charm-dialog   go.mod: go 1.26.1  â†  CI: ['1.23','1.24']
   charm-diff     go.mod: go 1.25.0  â†  CI: ['1.23','1.24']
   charm-layout   go.mod: go 1.25.0  â†  CI: ['1.23','1.24']
   charm-nav      go.mod: go 1.25.0  â†  CI: ['1.23','1.24']
   charm-palette  go.mod: go 1.25.0  â†  CI: ['1.26','1.25']
   charm-table-cli go.mod: go 1.25.0 â†  CI: ['1.26','1.25']   (Ãºnico coerente)
   charm-test     go.mod: go 1.24.2  â†  CI: ['1.23','1.24']
   charm-themes   go.mod: go 1.25.0  â†  CI: ['1.23','1.24']
   charm-toast    go.mod: go 1.26.1  â†  CI: ["1.23","1.24"]
   charm-wizard   go.mod: go 1.25.0  â†  CI: ['1.23','1.24']
   ```
   Verificado: `actions/setup-go@v5` **nÃ£o** define `GOTOOLCHAIN=local`, entÃ£o o Go baixa
   automaticamente a toolchain exigida e o job **nÃ£o falha** â€” apenas roda a versÃ£o nova e
   silenciosamente nÃ£o testa o que o badge afirma. O badge "1.23 âœ“" Ã© falso.

2. **Patch-pins desnecessÃ¡rios no `go.mod`.** `go 1.26.1` (charm-color, charm-dialog, charm-spinner,
   charm-toast) **impede** consumidores em Go 1.25.x/1.26.0. O piso real Ã© `1.25.0` (lipgloss v2)
   ou `1.24.2` (bubbletea v2). Usar sempre a **menor** versÃ£o compatÃ­vel.

3. **Duas geraÃ§Ãµes de dependÃªncia divergentes.** `charm-devtools` e `charm-test` usam
   `colorprofile v0.4.1` + `ultraviolet 20260205` + `displaywidth v0.9.0` + `uax29 v2.5.0` +
   `x/sync v0.19.0`; os outros 16 usam `v0.4.2` + `20251205` + `v0.11.0` + `v2.7.0` + `v0.18.0`.

4. **Nomes de pacote inconsistentes.** Prefixo `charm`: `charmcharts`, `charmdiff`, `charmform`,
   `charmthemes`, `charmtest`. Sem prefixo: `banner`, `color`, `devtools`, `dialog`, `i18n`,
   `layout`, `nav`, `notify`, `palette`, `spinner`, `toast`, `wizard`.

5. **Zero lint.** Nenhum repo tem `golangci-lint`, `staticcheck`, `gofmt -l` ou `go vet` no CI.
   SÃ³ 4 rodam `-race` e sÃ³ 3 geram cobertura.

6. **11 de 18 repos nÃ£o tÃªm nenhum arquivo de teste.** Nenhum repo tem `example_test.go` (o padrÃ£o Go
   para documentaÃ§Ã£o executÃ¡vel).

7. **Nenhum repo tem tags/releases.** Todos em pseudo-version `v0.0.0-...` â€” ninguÃ©m pode
   `go get` uma versÃ£o especÃ­fica.

8. **`README.pt-br.md` escritos sem nenhum acento.** `charm-wizard` e `charm-form` tÃªm **zero**
   caracteres acentuados no arquivo inteiro ("construido", "Execucao", "multiplas etapas",
   "Navegacao", "Instalacao"). O commit "fix: correct UTF-8 encoding of Charm Suite README" do
   Ã­ndice nÃ£o resolveu isso.

9. **`charm-toast/.forgejo/workflows/smoke.yml` Ã© placeholder** (`echo "Hello from Forgejo Actions on
   debian-008"`), versionado como se fosse um smoke test real.

10. **O Ã­ndice `charm-suite` nÃ£o tem:** LICENSE, CI, script de bootstrap, `go.work`, tabela de
    maturidade por lib, nem menÃ§Ã£o de que vÃ¡rias libs ainda nÃ£o implementam o que prometem.
