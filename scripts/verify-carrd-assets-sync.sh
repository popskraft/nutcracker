#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="${ROOT_DIR}/carrd/assets"
DST_DIR="${ROOT_DIR}/assets"

if [[ ! -d "$SRC_DIR" ]]; then
  echo "[verify-carrd-assets] source directory not found: $SRC_DIR" >&2
  exit 1
fi

if [[ ! -d "$DST_DIR" ]]; then
  echo "[verify-carrd-assets] destination directory not found: $DST_DIR" >&2
  exit 1
fi

missing=0
mismatch=0
checked=0

while IFS= read -r src_file; do
  rel_path="${src_file#${SRC_DIR}/}"
  dst_file="${DST_DIR}/${rel_path}"
  checked=$((checked + 1))

  if [[ ! -f "$dst_file" ]]; then
    echo "[verify-carrd-assets] missing: ${rel_path}"
    missing=$((missing + 1))
    continue
  fi

  if ! cmp -s "$src_file" "$dst_file"; then
    echo "[verify-carrd-assets] mismatch: ${rel_path}"
    mismatch=$((mismatch + 1))
  fi
done < <(find "$SRC_DIR" -type f | sort)

echo "[verify-carrd-assets] checked=${checked} missing=${missing} mismatch=${mismatch}"

if [[ "$missing" -gt 0 || "$mismatch" -gt 0 ]]; then
  exit 1
fi

echo "[verify-carrd-assets] all Carrd asset files are synchronized"
