#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
case "${1:-core}" in
  core|--core) ./scripts/bootstrap_core.sh ;;
  full|--full) ./scripts/bootstrap_full.sh ;;
  *) echo "Usage: ./scripts/bootstrap.sh [core|full]"; exit 2 ;;
esac
