#!/usr/bin/env bash
set -euo pipefail

check_ids() {
  local page="$1"
  shift
  local fail=0

  echo "[page] $page"
  if [[ ! -f "$page" ]]; then
    echo "  FAIL missing file"
    return 1
  fi

  for id in "$@"; do
    if rg -q "id=\"${id}\"|id=${id}([ >])" "$page"; then
      echo "  OK id:${id}"
    else
      echo "  MISS id:${id}"
      fail=1
    fi
  done

  return "$fail"
}

check_assets_exist() {
  local page="$1"
  local fail=0
  local urls
  urls="$(rg -o "(src|href)=\"[^\"]+\"" "$page" | sed -E 's/^(src|href)=\"([^\"]+)\"$/\2/' | sed 's/[?#].*$//' | sort -u)"

  while IFS= read -r u; do
    [[ -z "$u" ]] && continue
    if [[ "$u" =~ ^(http|mailto:|tel:|javascript:|#|data:|//) ]]; then
      continue
    fi
    if [[ "$u" == "/livereload.js" ]]; then
      continue
    fi
    if [[ "$u" =~ \.(css|js|jpg|jpeg|png|svg|webp|mp4|ico)$ ]]; then
      local target
      if [[ "$u" == /* ]]; then
        target="public${u}"
      else
        target="$(dirname "$page")/${u}"
      fi
      if [[ ! -f "$target" ]]; then
        echo "  MISS asset:${u} -> ${target}"
        fail=1
      fi
    fi
  done <<< "$urls"

  if [[ "$fail" -eq 0 ]]; then
    echo "  OK asset-links"
  fi

  return "$fail"
}

overall=0
check_ids public/index.html pageHeader product2Cols-1 benefitsContent3Cols faqHeader faqBody contactBody footerTop || overall=1
check_assets_exist public/index.html || overall=1

check_ids public/nitrile-gloves/index.html coverSlider CoverBottom benefitsHeader container39 savingsPrice faqHeader faqBody contactBody || overall=1
check_assets_exist public/nitrile-gloves/index.html || overall=1

check_ids public/hand-cleaner/index.html coverSlider CoverBottom benefitsHeader container39 savingsPrice faqHeader faqBody contactBody || overall=1
check_assets_exist public/hand-cleaner/index.html || overall=1

check_ids public/about/index.html aboutContentTop aboutFooter aboutContent2Col footerTop || overall=1
check_assets_exist public/about/index.html || overall=1

check_ids public/terms/index.html articleContentTop footerTop || overall=1
check_assets_exist public/terms/index.html || overall=1

if [[ "$overall" -eq 0 ]]; then
  echo "[visual-smoke] PASS"
else
  echo "[visual-smoke] FAIL"
  exit 1
fi
