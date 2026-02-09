#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="${ROOT_DIR}/carrd/assets"
DST_DIR="${ROOT_DIR}/assets"
DEFAULT_EXCLUDES_FILE="${ROOT_DIR}/.ai/contracts/carrd-sync-excludes.txt"
DRY_RUN=0
DELETE_MODE=0
NO_DEFAULT_EXCLUDES=0
EXCLUDE_FROM_FILE=""

usage() {
  cat <<'USAGE'
Usage:
  scripts/sync-carrd-assets.sh [--dry-run] [--delete] [--exclude-from FILE] [--no-default-excludes]

Options:
  --dry-run  Show what would change without modifying files.
  --delete   Make destination mirror source for overlapping tree paths.
             Use with caution: files missing in source can be removed.
  --exclude-from FILE
             Additional rsync excludes file (one pattern per line).
  --no-default-excludes
             Ignore default excludes file: .ai/contracts/carrd-sync-excludes.txt
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --delete)
      DELETE_MODE=1
      shift
      ;;
    --exclude-from)
      EXCLUDE_FROM_FILE="${2:-}"
      if [[ -z "${EXCLUDE_FROM_FILE}" ]]; then
        echo "Missing value for --exclude-from" >&2
        exit 1
      fi
      shift 2
      ;;
    --no-default-excludes)
      NO_DEFAULT_EXCLUDES=1
      shift
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ ! -d "$SRC_DIR" ]]; then
  echo "Source directory not found: $SRC_DIR" >&2
  exit 1
fi

mkdir -p "$DST_DIR"

RSYNC_ARGS=(-av --itemize-changes --exclude='.DS_Store')
if [[ "$DRY_RUN" -eq 1 ]]; then
  RSYNC_ARGS+=(-n)
fi
if [[ "$DELETE_MODE" -eq 1 ]]; then
  RSYNC_ARGS+=(--delete)
fi
if [[ "$NO_DEFAULT_EXCLUDES" -ne 1 && -f "$DEFAULT_EXCLUDES_FILE" ]]; then
  RSYNC_ARGS+=(--exclude-from="$DEFAULT_EXCLUDES_FILE")
fi
if [[ -n "$EXCLUDE_FROM_FILE" ]]; then
  RSYNC_ARGS+=(--exclude-from="$EXCLUDE_FROM_FILE")
fi

echo "[sync-carrd-assets] source: $SRC_DIR"
echo "[sync-carrd-assets] destination: $DST_DIR"
echo "[sync-carrd-assets] mode: $( [[ "$DRY_RUN" -eq 1 ]] && echo dry-run || echo apply )"
echo "[sync-carrd-assets] delete: $( [[ "$DELETE_MODE" -eq 1 ]] && echo enabled || echo disabled )"
echo "[sync-carrd-assets] default_excludes: $( [[ "$NO_DEFAULT_EXCLUDES" -ne 1 && -f "$DEFAULT_EXCLUDES_FILE" ]] && echo "$DEFAULT_EXCLUDES_FILE" || echo disabled )"
echo "[sync-carrd-assets] extra_excludes: ${EXCLUDE_FROM_FILE:-none}"

rsync "${RSYNC_ARGS[@]}" "${SRC_DIR}/" "${DST_DIR}/"

echo "[sync-carrd-assets] completed"
