#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIBS_DIR="$ROOT_DIR/libs"

REPOS=(
  charm-a11y
  charm-banner
  charm-charts
  charm-cli
  charm-color
  charm-command
  charm-config
  charm-devtools
  charm-dialog
  charm-diff
  charm-form
  charm-fuzzy
  charm-gallery
  charm-i18n
  charm-image
  charm-input
  charm-json
  charm-keys
  charm-layout
  charm-lint
  charm-logs
  charm-mock
  charm-nav
  charm-notify
  charm-palette
  charm-panes
  charm-progress
  charm-record
  charm-router
  charm-spinner
  charm-store
  charm-table-cli
  charm-test
  charm-themes
  charm-toast
  charm-update
  charm-wizard
)

echo "==> Charm Suite bootstrap"
echo "    root: $ROOT_DIR"
echo "    libs: $LIBS_DIR"
echo

mkdir -p "$LIBS_DIR"

for repo in "${REPOS[@]}"; do
  target="$LIBS_DIR/$repo"
  if [ -d "$target/.git" ]; then
    echo "  [skip] $repo (already cloned)"
  else
    echo "  [clone] $repo"
    git clone --quiet "https://github.com/junhinhow/$repo.git" "$target"
  fi
done

echo
echo "==> Generating go.work"
{
  echo "go 1.25.8"
  echo
  echo "use ("
  for repo in "${REPOS[@]}"; do
    echo "    ./libs/$repo"
  done
  echo ")"
} > "$ROOT_DIR/go.work"

echo "==> go work sync"
(cd "$ROOT_DIR" && go work sync)

echo
echo "==> Done. Next steps:"
echo "    cd $ROOT_DIR"
echo "    go build ./libs/...   # build every lib"
echo "    (cd libs/charm-diff && go test ./...)   # run one lib's tests"
echo
echo "    See scripts/README.md for more."