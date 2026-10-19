# Charm Suite — bootstrap

Clone all 18 charm-* libraries as siblings and prepare the local workspace.

## Usage

```bash
# Linux / macOS / WSL
./scripts/bootstrap.sh

# Windows (PowerShell)
.\scripts\bootstrap.ps1
```

After running, you will have:

```
CharmSuite/
├── charm-suite/        (this repo — index + tooling)
├── libs/
│   ├── charm-banner/
│   ├── charm-charts/
│   └── ... (18 libs)
├── go.work             (generated, gitignored)
└── ...
```

## What the script does

1. Clones each `charm-*` repo into `libs/<name>/` (skips already-cloned).
2. Creates `go.work` pointing at every lib (so cross-module development works).
3. Runs `go work sync`.
4. Prints the next steps (build, test).

## Requirements

- Go 1.25+ (`go version`)
- git

## Notes

- The 18 libs are **independent modules**. `go.work` is only for local development convenience and is gitignored.
- To work on a single lib, `cd libs/<name>` and use it like any Go module.
- CI for each lib lives in `libs/<name>/.github/workflows/ci.yml` and is unified across the suite.
