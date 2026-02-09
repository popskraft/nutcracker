#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${1:-}"

if [[ -z "$TARGET_DIR" ]]; then
  TARGET_DIR="$(ls -dt "${ROOT_DIR}"/.ai/reviews/visual-* 2>/dev/null | head -n 1 || true)"
fi

if [[ -z "$TARGET_DIR" || ! -d "$TARGET_DIR" ]]; then
  echo "[visual-diff-report] no visual capture directory found" >&2
  exit 1
fi

PYTHON_BIN=""
if command -v python3 >/dev/null 2>&1 && python3 - <<'PY' >/dev/null 2>&1
from PIL import Image
PY
then
  PYTHON_BIN="python3"
elif [[ -x "${ROOT_DIR}/.venv/bin/python" ]] && "${ROOT_DIR}/.venv/bin/python" - <<'PY' >/dev/null 2>&1
from PIL import Image
PY
then
  PYTHON_BIN="${ROOT_DIR}/.venv/bin/python"
else
  echo "[visual-diff-report] no Python interpreter with PIL available" >&2
  exit 1
fi

"$PYTHON_BIN" - "$TARGET_DIR" <<'PY'
import sys
from pathlib import Path

try:
    from PIL import Image, ImageChops, ImageStat
except Exception as exc:
    print(f"[visual-diff-report] PIL is required: {exc}", file=sys.stderr)
    sys.exit(1)

target = Path(sys.argv[1])
rows = []

for local in sorted(target.glob("*.local.png")):
    remote = Path(str(local).replace(".local.png", ".remote.png"))
    if not remote.exists():
        continue

    l = Image.open(local).convert("RGB")
    r = Image.open(remote).convert("RGB")
    if l.size != r.size:
        r = r.resize(l.size)

    diff = ImageChops.difference(l, r)
    stat = ImageStat.Stat(diff)
    mean = sum(stat.mean) / 3.0
    rms = (sum(v * v for v in stat.rms) / 3.0) ** 0.5

    gray = diff.convert("L")
    hist = gray.histogram()
    changed = sum(hist[16:])
    total = sum(hist)
    changed_pct = (changed / total * 100.0) if total else 0.0

    dynamic_excl_pct = None
    stem = local.name.replace(".local.png", "")
    if stem.startswith("nitrile-gloves.") or stem.startswith("hand-cleaner."):
        top = 700 if ".desktop." in local.name else 900
        if l.size[1] > top:
            l_dyn = l.crop((0, top, l.size[0], l.size[1]))
            r_dyn = r.crop((0, top, r.size[0], r.size[1]))
            dyn = ImageChops.difference(l_dyn, r_dyn).convert("L")
            dyn_hist = dyn.histogram()
            dyn_changed = sum(dyn_hist[16:])
            dyn_total = sum(dyn_hist)
            dynamic_excl_pct = (dyn_changed / dyn_total * 100.0) if dyn_total else 0.0

    rows.append(
        {
            "file": local.name,
            "mean": mean,
            "rms": rms,
            "changed_pct": changed_pct,
            "changed_pct_excl_dynamic": dynamic_excl_pct,
            "size": f"{l.size[0]}x{l.size[1]}",
        }
    )

rows.sort(key=lambda item: item["changed_pct"], reverse=True)

md = []
md.append("# Visual Diff Report")
md.append("")
md.append(f"- Folder: `{target}`")
md.append("")
md.append("| File | Mean Diff | RMS Diff | Changed % | Changed % (Excl Dynamic Hero) | Size |")
md.append("|---|---:|---:|---:|---:|---|")
for item in rows:
    excl = "-" if item["changed_pct_excl_dynamic"] is None else f"{item['changed_pct_excl_dynamic']:.2f}%"
    md.append(
        f"| `{item['file']}` | {item['mean']:.2f} | {item['rms']:.2f} | {item['changed_pct']:.2f}% | {excl} | {item['size']} |"
    )

high = [r for r in rows if r["changed_pct"] >= 10.0]
md.append("")
md.append("## Summary")
md.append(f"- Pairs analyzed: {len(rows)}")
md.append(f"- High-diff pairs (>=10% changed): {len(high)}")
if high:
    md.append("- High-diff files:")
    for item in high:
        md.append(f"  - `{item['file']}` ({item['changed_pct']:.2f}%)")

report = target / "DIFF_REPORT.md"
report.write_text("\n".join(md) + "\n", encoding="utf-8")
print(f"[visual-diff-report] report: {report}")
PY
