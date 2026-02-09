#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="${ROOT_DIR}/carrd/assets"
DST_DIR="${ROOT_DIR}/assets"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

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

allowlisted_mismatch=0

is_allowlisted_main_js_diff() {
  local src_file="$1"
  local dst_file="$2"
  local normalized_src="${TMP_DIR}/main.js.src.norm"
  local normalized_dst="${TMP_DIR}/main.js.dst.norm"

  # Allowed patch policy:
  # keep Carrd runtime intact while permitting absolute asset paths for slideshow
  # (`assets/images/...` -> `/assets/images/...`) on Hugo multipage routes.
  sed -E "s#src: '/assets/images/#src: 'assets/images/#g" "$src_file" | tr -d '[:space:]' > "$normalized_src"
  sed -E "s#src: '/assets/images/#src: 'assets/images/#g" "$dst_file" | tr -d '[:space:]' > "$normalized_dst"

  cmp -s "$normalized_src" "$normalized_dst"
}

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
    if [[ "$rel_path" == "main.js" ]] && is_allowlisted_main_js_diff "$src_file" "$dst_file"; then
      echo "[verify-carrd-assets] allowlisted mismatch: ${rel_path} (absolute slideshow asset paths)"
      allowlisted_mismatch=$((allowlisted_mismatch + 1))
    else
      echo "[verify-carrd-assets] mismatch: ${rel_path}"
      mismatch=$((mismatch + 1))
    fi
  fi
done < <(find "$SRC_DIR" -type f | sort)

echo "[verify-carrd-assets] checked=${checked} missing=${missing} mismatch=${mismatch} allowlisted=${allowlisted_mismatch}"

if [[ "$missing" -gt 0 || "$mismatch" -gt 0 ]]; then
  exit 1
fi

echo "[verify-carrd-assets] all Carrd asset files are synchronized"
