#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="${ROOT_DIR}/.ai/reviews/visual-$(date -u +%Y%m%dT%H%M%SZ)"
LOCAL_PORT="${LOCAL_PORT:-1314}"
LOCAL_BASE_URL="http://127.0.0.1:${LOCAL_PORT}"
REMOTE_BASE_URL="${REMOTE_BASE_URL:-https://nutcrackerpro.com}"

PAGES=(
  "/"
  "/nitrile-gloves/"
  "/hand-cleaner/"
  "/about/"
  "/terms/"
)

mkdir -p "${REPORT_DIR}"

cleanup() {
  if [[ -n "${HUGO_PID:-}" ]]; then
    kill "${HUGO_PID}" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

echo "[capture-visual] report_dir=${REPORT_DIR}"
echo "[capture-visual] starting local hugo server on ${LOCAL_BASE_URL}"

(cd "${ROOT_DIR}" && hugo server --bind 127.0.0.1 --port "${LOCAL_PORT}" --baseURL "${LOCAL_BASE_URL}/" --disableFastRender --noBuildLock --quiet >/tmp/hugo-visual.log 2>&1) &
HUGO_PID=$!

for _ in {1..40}; do
  if curl -fsS --max-time 5 "${LOCAL_BASE_URL}/" >/dev/null 2>&1; then
    break
  fi
  sleep 0.5
done

if ! curl -fsS --max-time 5 "${LOCAL_BASE_URL}/" >/dev/null 2>&1; then
  echo "[capture-visual] local hugo server did not start" >&2
  exit 1
fi

capture_page() {
  local slug="$1"
  local path="$2"

  local local_url="${LOCAL_BASE_URL}${path}"
  local remote_url="${REMOTE_BASE_URL}${path}"

  npx --yes playwright screenshot --wait-for-selector="body.is-ready" --wait-for-timeout=2500 --viewport-size="1440,2600" "${local_url}" "${REPORT_DIR}/${slug}.desktop.local.png" >/dev/null
  npx --yes playwright screenshot --wait-for-selector="body.is-ready" --wait-for-timeout=2500 --viewport-size="1440,2600" "${remote_url}" "${REPORT_DIR}/${slug}.desktop.remote.png" >/dev/null
  npx --yes playwright screenshot --wait-for-selector="body.is-ready" --wait-for-timeout=2500 --viewport-size="390,2000" "${local_url}" "${REPORT_DIR}/${slug}.mobile.local.png" >/dev/null
  npx --yes playwright screenshot --wait-for-selector="body.is-ready" --wait-for-timeout=2500 --viewport-size="390,2000" "${remote_url}" "${REPORT_DIR}/${slug}.mobile.remote.png" >/dev/null

  echo "[capture-visual] captured ${slug}"
}

for path in "${PAGES[@]}"; do
  case "$path" in
    "/") slug="home" ;;
    *) slug="$(echo "$path" | sed -E 's#^/##; s#/$##; s#[^a-zA-Z0-9]+#-#g')" ;;
  esac
  capture_page "$slug" "$path"
done

{
  echo "# Visual Capture Report"
  echo
  echo "- UTC: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "- Local: ${LOCAL_BASE_URL}"
  echo "- Remote: ${REMOTE_BASE_URL}"
  echo
  echo "## Files"
  find "${REPORT_DIR}" -type f -name '*.png' -exec basename {} \; | sort | sed 's/^/- /'
} > "${REPORT_DIR}/README.md"

echo "[capture-visual] completed"
echo "[capture-visual] artifacts: ${REPORT_DIR}"
