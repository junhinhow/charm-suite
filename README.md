<div align="center">
<img src="https://capsule-render.vercel.app/api?type=waving&color=0:16A34A,100:15803D&height=200&section=header&text=The%20Charm%20Suite&fontSize=55&fontColor=ffffff&animation=fadeIn&fontAlignY=35&desc=37%20Go%20TUI%20libraries%20for%20the%20Charmbracelet%20stack&descAlignY=55&descSize=16" width="100%"/>
</div>

<p align="center">
<strong>PT:</strong> Um ecossistema curado de bibliotecas Go para o stack <strong>Charmbracelet / Bubble Tea v2</strong>. Cada <code>charm-*</code> resolve uma lacuna específica que falta no conjunto oficial.<br/>
<strong>EN:</strong> A curated ecosystem of Go libraries for the <strong>Charmbracelet / Bubble Tea v2</strong> stack. Each <code>charm-*</code> fills a specific gap missing from the official set.
</p>

<p align="center">
<a href="https://github.com/junhinhow"><img src="https://img.shields.io/badge/Author-Altair%20Jr-16A34A?style=for-the-badge&logo=go&logoColor=white"/></a>
<a href="https://go.dev/"><img src="https://img.shields.io/badge/Language-Go-00ADD8?style=for-the-badge&logo=go&logoColor=white"/></a>
<img src="https://img.shields.io/github/repo-size/junhinhow/charm-suite?style=for-the-badge&color=15803D"/>
</p>

<img src="https://capsule-render.vercel.app/api?type=rect&color=0:16A34A,100:15803D&height=3&width=1000" width="100%"/>

## As Bibliotecas / The Libraries

### Fundação / Foundation

| Library | Description (EN) | Descrição (PT) |
|---|---|---|
| [**charm-router**](https://github.com/junhinhow/charm-router) | Screen stack with push/pop, typed params, guards and breadcrumbs | Pilha de telas com push/pop, parâmetros tipados, guards e breadcrumbs |
| [**charm-keys**](https://github.com/junhinhow/charm-keys) | Context-scoped keybindings with conflict detection and help generation | Keybindings com escopo por contexto, detecção de conflito e geração de help |
| [**charm-store**](https://github.com/junhinhow/charm-store) | Observable state store with undo/redo and snapshots | Store de estado observável com undo/redo e snapshots |
| [**charm-config**](https://github.com/junhinhow/charm-config) | Layered configuration (defaults → file → env → flags) with a TUI editor | Configuração em camadas (defaults → arquivo → env → flags) com editor TUI |

### Layout & navegação / Layout & navigation

| Library | Description (EN) | Descrição (PT) |
|---|---|---|
| [**charm-layout**](https://github.com/junhinhow/charm-layout) | Flexbox-inspired layout engine — responsive flex and grid | Motor de layout inspirado em Flexbox — flex e grid responsivos |
| [**charm-panes**](https://github.com/junhinhow/charm-panes) | Resizable split panes with focus and dividers | Painéis divisíveis redimensionáveis com foco e divisores |
| [**charm-nav**](https://github.com/junhinhow/charm-nav) | Tab, breadcrumb and sidebar navigation styled with lipgloss | Navegação por abas, breadcrumb e sidebar com lipgloss |
| [**charm-wizard**](https://github.com/junhinhow/charm-wizard) ⭐ | Multi-step wizard — progress tracking, back/forward, shared state | Wizard multi-etapas — progresso, voltar/avançar, estado compartilhado |

### Dados & visualização / Data & visualization

| Library | Description (EN) | Descrição (PT) |
|---|---|---|
| [**charm-charts**](https://github.com/junhinhow/charm-charts) | Sparklines, bar charts and progress bars | Sparklines, gráficos de barras e barras de progresso |
| [**charm-progress**](https://github.com/junhinhow/charm-progress) | Multi-task progress dashboard with per-task ETA | Dashboard de progresso multi-tarefa com ETA por tarefa |
| [**charm-logs**](https://github.com/junhinhow/charm-logs) | Interactive log pane — levels, filtering, search, follow | Painel de log interativo — níveis, filtro, busca, follow |
| [**charm-json**](https://github.com/junhinhow/charm-json) | Interactive JSON and YAML explorer | Explorador interativo de JSON e YAML |
| [**charm-diff**](https://github.com/junhinhow/charm-diff) ⭐ | Unified and side-by-side diff, byte-compatible with `git diff -U<N>` | Diff unificado e lado a lado, compatível byte a byte com `git diff -U<N>` |
| [**charm-table-cli**](https://github.com/junhinhow/charm-table-cli) | CLI to render CSV/JSON/TSV as styled terminal tables | CLI para renderizar CSV/JSON/TSV como tabelas estilizadas |

### Feedback

| Library | Description (EN) | Descrição (PT) |
|---|---|---|
| [**charm-spinner**](https://github.com/junhinhow/charm-spinner) | 42 terminal spinner animations | 42 animações de spinner para terminal |
| [**charm-toast**](https://github.com/junhinhow/charm-toast) | Auto-dismissing toasts with real Bubble Tea integration | Toasts auto-dismiss com integração real ao Bubble Tea |
| [**charm-dialog**](https://github.com/junhinhow/charm-dialog) | Modal dialogs — confirm, alert, input, custom | Diálogos modais — confirmar, alerta, input, customizado |
| [**charm-notify**](https://github.com/junhinhow/charm-notify) | Cross-platform desktop notifications | Notificações desktop cross-platform |
| [**charm-banner**](https://github.com/junhinhow/charm-banner) | ASCII art banner generator with square glyphs | Gerador de banners ASCII art com glifos quadrados |

### Entrada / Input

| Library | Description (EN) | Descrição (PT) |
|---|---|---|
| [**charm-form**](https://github.com/junhinhow/charm-form) | Declarative YAML forms — interactive TUI or CLI | Formulários declarativos em YAML — TUI interativa ou CLI |
| [**charm-input**](https://github.com/junhinhow/charm-input) | Date, time, range and masked inputs | Inputs de data, hora, range e mascarado |
| [**charm-command**](https://github.com/junhinhow/charm-command) | Command palette (Ctrl+P) | Command palette (Ctrl+P) |
| [**charm-fuzzy**](https://github.com/junhinhow/charm-fuzzy) | Fuzzy matching, ranking and picker | Matching fuzzy, ranking e picker |

### Estilo / Styling

| Library | Description (EN) | Descrição (PT) |
|---|---|---|
| [**charm-themes**](https://github.com/junhinhow/charm-themes) ⭐ | Unified theming for lipgloss, glamour and bubbles | Tema unificado para lipgloss, glamour e bubbles |
| [**charm-color**](https://github.com/junhinhow/charm-color) | Color utilities — darken, lighten, blend, contrast, complementary | Utilitários de cor — escurecer, clarear, misturar, contraste, complementar |
| [**charm-palette**](https://github.com/junhinhow/charm-palette) | Palette viewer and generator with live theme preview | Visualizador e gerador de paletas com preview de tema |
| [**charm-image**](https://github.com/junhinhow/charm-image) | Terminal images — sixel, kitty, iTerm2 and half-blocks | Imagens no terminal — sixel, kitty, iTerm2 e half-blocks |

### Internacionalização / Internationalization

| Library | Description (EN) | Descrição (PT) |
|---|---|---|
| [**charm-i18n**](https://github.com/junhinhow/charm-i18n) | Message catalogs, locale detection, fallback chain and RTL | Catálogos de mensagens, detecção de locale, fallback e RTL |

### Qualidade & ferramentas / Quality & tooling

| Library | Description (EN) | Descrição (PT) |
|---|---|---|
| [**charm-test**](https://github.com/junhinhow/charm-test) ⭐ | Bubble Tea testing — inputs, snapshots, virtual clock | Testes para Bubble Tea — inputs, snapshots, relógio virtual |
| [**charm-devtools**](https://github.com/junhinhow/charm-devtools) | DevTools inspector — message log, state, component tree | Inspetor DevTools — log de mensagens, estado, árvore de componentes |
| [**charm-record**](https://github.com/junhinhow/charm-record) | Record and replay sessions as deterministic cassettes | Grava e reproduz sessões como cassetes determinísticos |
| [**charm-mock**](https://github.com/junhinhow/charm-mock) | Fakes for clock, filesystem, HTTP and clipboard | Fakes de relógio, filesystem, HTTP e clipboard |
| [**charm-lint**](https://github.com/junhinhow/charm-lint) ⭐ | Static analysis for TUI pitfalls — byte width, unsafe slicing, nondeterminism | Análise estática de armadilhas de TUI — largura em bytes, corte inseguro, não-determinismo |
| [**charm-a11y**](https://github.com/junhinhow/charm-a11y) | Accessibility — NO_COLOR, TERM=dumb, high contrast, ASCII fallback | Acessibilidade — NO_COLOR, TERM=dumb, alto contraste, fallback ASCII |
| [**charm-update**](https://github.com/junhinhow/charm-update) | Signed self-update with atomic replace | Auto-update com checksum e troca atômica |
| [**charm-gallery**](https://github.com/junhinhow/charm-gallery) | Live component gallery for the whole suite | Gallery interativa de todos os componentes da suíte |
| [**charm-cli**](https://github.com/junhinhow/charm-cli) | Project scaffolder (`charm-suite new`) | Scaffolder de projetos (`charm-suite new`) |

<img src="https://capsule-render.vercel.app/api?type=rect&color=0:16A34A,100:15803D&height=3&width=1000" width="100%"/>

## Quick Start / Começando Rápido

```bash
# Pick any library / Escolha qualquer biblioteca
go get github.com/junhinhow/charm-router@v0.1.1
go get github.com/junhinhow/charm-themes@v0.1.1
go get github.com/junhinhow/charm-test@v0.1.1
```

Todas as 37 bibliotecas estão publicadas em **`v0.1.x`**, cada uma com tag e release.
All 37 libraries are published as **`v0.1.x`**, each with a tag and release.

Scaffold a new project with the suite pre-wired / Crie um projeto já integrado à suíte:

```bash
go install github.com/junhinhow/charm-cli@latest
charm-suite new meu-app
cd meu-app && go run .
```

Para desenvolver todos os repos juntos localmente / To work on all repos locally:

```bash
git clone https://github.com/junhinhow/charm-suite
cd charm-suite
./scripts/bootstrap.sh          # Linux / macOS / WSL
# ou: .\scripts\bootstrap.ps1   (Windows)
```

<img src="https://capsule-render.vercel.app/api?type=rect&color=0:16A34A,100:15803D&height=3&width=1000" width="100%"/>

## Compatibilidade / Compatibility

| | Versão |
|---|---|
| Go | **1.25+** (`charm-themes` exige 1.25.8 por causa do glamour v2) |
| `charm.land/lipgloss/v2` | v2.0.2 |
| `charm.land/bubbletea/v2` | v2.0.2 |
| `charm.land/bubbles/v2` | v2.1.0 |
| `charm.land/glamour/v2` | v2.0.0 |
| Licença | MIT |

Política de versões / Version policy:
- **v0.x** — a API ainda pode mudar entre minors; mudanças incompatíveis são documentadas no release.
- **v1.0** — congelamento de API.
- Toda release passa por `gofmt`, `go vet` e `go test -race` na CI.

<img src="https://capsule-render.vercel.app/api?type=rect&color=0:16A34A,100:15803D&height=3&width=1000" width="100%"/>

## Why this suite? / Por que esta suite?

**PT:** O stack oficial Charmbracelet é excelente, mas deixa lacunas: não há pilha de telas, keybindings por contexto, dashboard multi-tarefa, visualizador de log, painéis redimensionáveis, command palette, i18n, layout responsivo, nem ferramentas de teste e lint específicas para TUI. A Charm Suite preenche cada uma dessas lacunas com bibliotecas pequenas, focadas e interoperáveis — todas em Go idiomático e estilizadas com lipgloss v2.

**EN:** The official Charmbracelet stack is excellent but leaves gaps: no screen stack, no context-scoped keybindings, no multi-task dashboard, no log viewer, no resizable panes, no command palette, no i18n, no responsive layout, and no TUI-specific testing or linting tools. The Charm Suite fills each of those gaps with small, focused, interoperable libraries — all idiomatic Go, all styled with lipgloss v2.

<img src="https://capsule-render.vercel.app/api?type=rect&color=0:16A34A,100:15803D&height=3&width=1000" width="100%"/>

## Development / Desenvolvimento

- Cada repo é um **módulo Go independente**, com versão própria.
- A CI é **única**: todos os repos chamam [`charm-suite/.github/workflows/go-ci.yml`](.github/workflows/go-ci.yml) via `uses:`. Uma mudança na CI vale para os 37.
- `go.work` na raiz (gerado pelo bootstrap) permite compilar e testar tudo junto.
- Commits seguem [Conventional Commits](https://www.conventionalcommits.org/), em português do Brasil.
- `AUDIT.md` documenta a auditoria que originou a reescrita de 18 bibliotecas.

<img src="https://capsule-render.vercel.app/api?type=rect&color=0:16A34A,100:15803D&height=3&width=1000" width="100%"/>

## Contributing / Contribuindo

Issues and PRs are welcome on any `charm-*` repo. Keep changes small, idiomatic and covered by tests. / Issues e PRs são bem-vindos em qualquer repo `charm-*`. Mantenha mudanças pequenas, idiomáticas e cobertas por testes.

<div align="center">
<a href="https://github.com/junhinhow"><img src="https://capsule-render.vercel.app/api?type=waving&color=0:15803D,100:16A34A&height=120&section=footer" width="100%"/></a>
</div>
