#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CARRD_HTML="${ROOT_DIR}/carrd/index.html"
PUBLIC_HOME="${ROOT_DIR}/public/index.html"
LAYOUTS_DIR="${ROOT_DIR}/layouts"
THRESHOLDS_FILE="${ROOT_DIR}/.ai/contracts/carrd-contract-thresholds.env"
METRICS_FILE="${ROOT_DIR}/.ai/logs/carrd-contract-metrics.json"
ALLOWED_NON_CARRD_IDS_FILE="${ROOT_DIR}/.ai/contracts/carrd-allowed-non-carrd-ids.txt"
CONTRACT_PAGES_FILE="${ROOT_DIR}/.ai/contracts/carrd-id-contract-pages.txt"
NON_CARRD_REPORT_FILE="${ROOT_DIR}/.ai/logs/carrd-non-carrd-id-report.txt"
STRICT=0
RUN_BUILD=0
REQUIRE_SYNC_OVERRIDE=""

usage() {
  cat <<'USAGE'
Usage:
  scripts/carrd-contract-check.sh [--strict] [--build] [--require-sync=0|1]

Options:
  --strict            Enforce thresholds from .ai/contracts/carrd-contract-thresholds.env
  --build             Run npm run build before checks
  --require-sync=0|1  Override REQUIRE_CORE_ASSET_SYNC for this execution
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --strict)
      STRICT=1
      shift
      ;;
    --build)
      RUN_BUILD=1
      shift
      ;;
    --require-sync=*)
      REQUIRE_SYNC_OVERRIDE="${1#*=}"
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

if [[ "$RUN_BUILD" -eq 1 ]]; then
  echo "[carrd-contract-check] building site"
  (cd "$ROOT_DIR" && npm run build >/dev/null)
fi

if [[ ! -f "$CARRD_HTML" ]]; then
  echo "[carrd-contract-check] missing Carrd reference: $CARRD_HTML" >&2
  exit 1
fi

if [[ ! -f "$PUBLIC_HOME" ]]; then
  echo "[carrd-contract-check] missing built home page: $PUBLIC_HOME" >&2
  echo "[carrd-contract-check] run with --build or execute npm run build first" >&2
  exit 1
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

extract_ids() {
  local input_file="$1"
  (
    rg --no-filename -o 'id="[^"]+"' "$input_file" | sed -E 's/id="([^"]+)"/\1/' || true
    rg --no-filename -o 'id=[^ >]+' "$input_file" | sed -E 's/id=//' | tr -d '"' || true
  ) | sed '/^$/d' | sort -u
}

extract_classes() {
  local input_file="$1"
  (
    rg --no-filename -o 'class="[^"]+"' "$input_file" | sed -E 's/class="([^"]+)"/\1/' | tr ' ' '\n' || true
    rg --no-filename -o 'class=[^ >]+' "$input_file" | sed -E 's/class=//' | tr -d '"' | tr ' ' '\n' || true
  ) | sed '/^$/d' | sort -u
}

extract_ids "$CARRD_HTML" > "${tmp_dir}/carrd_ids.txt"
cp "${tmp_dir}/carrd_ids.txt" "${tmp_dir}/carrd_home_ids.txt"
extract_ids "$PUBLIC_HOME" > "${tmp_dir}/public_home_ids.txt"
extract_classes "$CARRD_HTML" > "${tmp_dir}/carrd_home_classes.txt"
extract_classes "$PUBLIC_HOME" > "${tmp_dir}/public_home_classes.txt"

carrd_home_ids="$(wc -l < "${tmp_dir}/carrd_home_ids.txt" | tr -d ' ')"
public_home_ids="$(wc -l < "${tmp_dir}/public_home_ids.txt" | tr -d ' ')"
home_id_intersection="$(comm -12 "${tmp_dir}/carrd_home_ids.txt" "${tmp_dir}/public_home_ids.txt" | wc -l | tr -d ' ')"
home_id_missing="$(comm -23 "${tmp_dir}/carrd_home_ids.txt" "${tmp_dir}/public_home_ids.txt" | wc -l | tr -d ' ')"

carrd_home_classes="$(wc -l < "${tmp_dir}/carrd_home_classes.txt" | tr -d ' ')"
public_home_classes="$(wc -l < "${tmp_dir}/public_home_classes.txt" | tr -d ' ')"
home_class_intersection="$(comm -12 "${tmp_dir}/carrd_home_classes.txt" "${tmp_dir}/public_home_classes.txt" | wc -l | tr -d ' ')"
home_class_missing="$(comm -23 "${tmp_dir}/carrd_home_classes.txt" "${tmp_dir}/public_home_classes.txt" | wc -l | tr -d ' ')"

allowed_non_carrd_ids="${tmp_dir}/allowed_non_carrd_ids.txt"
if [[ -f "$ALLOWED_NON_CARRD_IDS_FILE" ]]; then
  sed -E '/^[[:space:]]*#/d; /^[[:space:]]*$/d' "$ALLOWED_NON_CARRD_IDS_FILE" | sort -u > "$allowed_non_carrd_ids"
else
  : > "$allowed_non_carrd_ids"
fi

mkdir -p "$(dirname "$NON_CARRD_REPORT_FILE")"
: > "$NON_CARRD_REPORT_FILE"
public_pages_total=0
public_pages_with_non_carrd_ids=0
public_max_non_carrd_ids_per_page=0
public_missing_contract_pages=0

declare -a pages_to_scan
if [[ -f "$CONTRACT_PAGES_FILE" ]]; then
  while IFS= read -r raw_line; do
    line="$(printf '%s' "$raw_line" | sed -E 's/[[:space:]]*#.*$//; s/^[[:space:]]+//; s/[[:space:]]+$//')"
    if [[ -z "$line" ]]; then
      continue
    fi
    if [[ "$line" == "/" ]]; then
      pages_to_scan+=("${ROOT_DIR}/public/index.html")
      continue
    fi
    if [[ "$line" == *.html ]]; then
      pages_to_scan+=("${ROOT_DIR}/public/${line#/}")
      continue
    fi
    normalized="${line#/}"
    normalized="${normalized%/}"
    pages_to_scan+=("${ROOT_DIR}/public/${normalized}/index.html")
  done < "$CONTRACT_PAGES_FILE"
else
  while IFS= read -r page; do
    pages_to_scan+=("$page")
  done < <(find "${ROOT_DIR}/public" -name '*.html' | sort)
fi

for page in "${pages_to_scan[@]}"; do
  public_pages_total=$((public_pages_total + 1))
  if [[ ! -f "$page" ]]; then
    public_missing_contract_pages=$((public_missing_contract_pages + 1))
    relative_page="${page#${ROOT_DIR}/}"
    {
      echo "## ${relative_page} (missing)"
      echo "__MISSING_PAGE__"
      echo
    } >> "$NON_CARRD_REPORT_FILE"
    continue
  fi
  page_ids_file="${tmp_dir}/page_ids.txt"
  page_extra_raw="${tmp_dir}/page_extra_raw.txt"
  page_extra_filtered="${tmp_dir}/page_extra_filtered.txt"
  extract_ids "$page" > "$page_ids_file"
  comm -23 "$page_ids_file" "${tmp_dir}/carrd_ids.txt" > "$page_extra_raw"
  if [[ -s "$allowed_non_carrd_ids" ]]; then
    grep -vxF -f "$allowed_non_carrd_ids" "$page_extra_raw" > "$page_extra_filtered" || true
  else
    cp "$page_extra_raw" "$page_extra_filtered"
  fi
  page_extra_count="$(wc -l < "$page_extra_filtered" | tr -d ' ')"
  if (( page_extra_count > 0 )); then
    public_pages_with_non_carrd_ids=$((public_pages_with_non_carrd_ids + 1))
    if (( page_extra_count > public_max_non_carrd_ids_per_page )); then
      public_max_non_carrd_ids_per_page="$page_extra_count"
    fi
    relative_page="${page#${ROOT_DIR}/}"
    {
      echo "## ${relative_page} (${page_extra_count})"
      cat "$page_extra_filtered"
      echo
    } >> "$NON_CARRD_REPORT_FILE"
  fi
done

layout_legacy_style_class_count="$( (rg -o 'style[0-9]+' "$LAYOUTS_DIR" -g '*.html' || true) | wc -l | tr -d ' ' )"
layout_new_style_dash_class_count="$( (rg -o 'style-[0-9]+' "$LAYOUTS_DIR" -g '*.html' || true) | wc -l | tr -d ' ' )"
layout_component_class_count="$( (rg -o '(container-component|image-component|buttons-component|links-component|gallery-component|text-component|divider-component|form-component|list-component|video-component|table-component)' "$LAYOUTS_DIR" -g '*.html' || true) | wc -l | tr -d ' ' )"

core_assets_sync=0
if "${ROOT_DIR}/scripts/verify-carrd-assets-sync.sh" >/dev/null 2>&1; then
  core_assets_sync=1
fi

mkdir -p "$(dirname "$METRICS_FILE")"
cat > "$METRICS_FILE" <<EOF
{
  "timestamp_utc": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "home": {
    "carrd_ids": ${carrd_home_ids},
    "public_ids": ${public_home_ids},
    "id_intersection": ${home_id_intersection},
    "id_missing": ${home_id_missing},
    "carrd_classes": ${carrd_home_classes},
    "public_classes": ${public_home_classes},
    "class_intersection": ${home_class_intersection},
    "class_missing": ${home_class_missing}
  },
  "layouts": {
    "legacy_style_class_count": ${layout_legacy_style_class_count},
    "new_style_dash_class_count": ${layout_new_style_dash_class_count},
    "component_class_count": ${layout_component_class_count}
  },
  "public": {
    "pages_total": ${public_pages_total},
    "pages_with_non_carrd_ids": ${public_pages_with_non_carrd_ids},
    "max_non_carrd_ids_per_page": ${public_max_non_carrd_ids_per_page},
    "missing_contract_pages": ${public_missing_contract_pages}
  },
  "assets": {
    "core_assets_sync": ${core_assets_sync}
  }
}
EOF

echo "[carrd-contract-check] metrics"
echo "  home.id_intersection=${home_id_intersection}/${carrd_home_ids}"
echo "  home.class_intersection=${home_class_intersection}/${carrd_home_classes}"
echo "  home.id_missing=${home_id_missing}"
echo "  home.class_missing=${home_class_missing}"
echo "  layouts.legacy_style_class_count=${layout_legacy_style_class_count}"
echo "  layouts.new_style_dash_class_count=${layout_new_style_dash_class_count}"
echo "  layouts.component_class_count=${layout_component_class_count}"
echo "  public.pages_total=${public_pages_total}"
echo "  public.pages_with_non_carrd_ids=${public_pages_with_non_carrd_ids}"
echo "  public.max_non_carrd_ids_per_page=${public_max_non_carrd_ids_per_page}"
echo "  public.missing_contract_pages=${public_missing_contract_pages}"
echo "  assets.core_assets_sync=${core_assets_sync}"
echo "  metrics_file=${METRICS_FILE}"
if (( public_pages_with_non_carrd_ids > 0 || public_missing_contract_pages > 0 )); then
  echo "  non_carrd_id_report=${NON_CARRD_REPORT_FILE}"
fi

if [[ "$STRICT" -ne 1 ]]; then
  exit 0
fi

if [[ ! -f "$THRESHOLDS_FILE" ]]; then
  echo "[carrd-contract-check] thresholds file not found: $THRESHOLDS_FILE" >&2
  exit 1
fi

# shellcheck disable=SC1090
source "$THRESHOLDS_FILE"

if [[ -n "$REQUIRE_SYNC_OVERRIDE" ]]; then
  REQUIRE_CORE_ASSET_SYNC="$REQUIRE_SYNC_OVERRIDE"
fi

fail=0

check_min() {
  local name="$1"
  local value="$2"
  local min_value="$3"
  if (( value < min_value )); then
    echo "[strict] FAIL ${name}: ${value} < ${min_value}" >&2
    fail=1
  fi
}

check_max() {
  local name="$1"
  local value="$2"
  local max_value="$3"
  if (( value > max_value )); then
    echo "[strict] FAIL ${name}: ${value} > ${max_value}" >&2
    fail=1
  fi
}

check_min "home_id_intersection" "$home_id_intersection" "${MIN_HOME_ID_INTERSECTION}"
check_min "home_class_intersection" "$home_class_intersection" "${MIN_HOME_CLASS_INTERSECTION}"
check_max "home_id_missing" "$home_id_missing" "${MAX_HOME_ID_MISSING}"
check_max "home_class_missing" "$home_class_missing" "${MAX_HOME_CLASS_MISSING}"
check_max "layout_legacy_style_class_count" "$layout_legacy_style_class_count" "${MAX_LAYOUT_LEGACY_STYLE_CLASS_COUNT}"
check_min "layout_new_style_dash_class_count" "$layout_new_style_dash_class_count" "${MIN_LAYOUT_NEW_STYLE_DASH_CLASS_COUNT}"
check_min "layout_component_class_count" "$layout_component_class_count" "${MIN_LAYOUT_COMPONENT_CLASS_COUNT}"
: "${MAX_PUBLIC_PAGES_WITH_NON_CARRD_IDS:=999999}"
: "${MAX_PUBLIC_MAX_NON_CARRD_IDS_PER_PAGE:=999999}"
: "${MAX_PUBLIC_MISSING_CONTRACT_PAGES:=999999}"
check_max "public_pages_with_non_carrd_ids" "$public_pages_with_non_carrd_ids" "${MAX_PUBLIC_PAGES_WITH_NON_CARRD_IDS}"
check_max "public_max_non_carrd_ids_per_page" "$public_max_non_carrd_ids_per_page" "${MAX_PUBLIC_MAX_NON_CARRD_IDS_PER_PAGE}"
check_max "public_missing_contract_pages" "$public_missing_contract_pages" "${MAX_PUBLIC_MISSING_CONTRACT_PAGES}"

if [[ "${REQUIRE_CORE_ASSET_SYNC}" == "1" && "$core_assets_sync" -ne 1 ]]; then
  echo "[strict] FAIL core asset sync required but not satisfied" >&2
  fail=1
fi

if [[ "$fail" -ne 0 ]]; then
  exit 1
fi

echo "[strict] PASS"
