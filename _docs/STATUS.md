# Project Status

Last updated (UTC): 2026-02-08
Mode: autonomous
Active profile: carrd-hugo-corporate
IDE stack: vscode,gpt-5.3+-extension,claude-code-extension
Reference markup: /Users/popskraft/hugo/nutcracker/carrd
Baseline site: https://nutcrackerpro.com/

## In Progress
- Carrd full migration plan initialized and recorded.
- Phase 3 migration in progress (home/product templates + runtime hardening).
- Dual-contract classes applied broadly across home and non-home templates.
- Runtime adapter added to support safe future swap to Carrd `assets/main.js` on multipage Hugo pages.
- Staged replacement of core Carrd assets completed:
  - `assets/icons.svg`
  - `assets/noscript.css`
  - `assets/main.css`
  - `assets/main.js`
- Contract metrics improved to:
  - `home.id_intersection=97/319`
  - `home.class_intersection=89/180`
- Home non-Carrd IDs in generated `public/index.html` reduced to 1 (analytics ID).
- Controlled sync rehearsal completed in branch `chore/carrd-sync-delete-media`:
  - `scripts/sync-carrd-assets.sh --delete`
  - `verify-carrd-assets`: `missing=0`, `mismatch=0`
- Visual smoke checks passed for key pages (`/`, `/nitrile-gloves/`, `/hand-cleaner/`, `/about/`, `/terms/`).
- Visual capture baseline created: `.ai/reviews/visual-20260208T095113Z` (local vs production, desktop+mobile).
- Visual capture baseline updated: `.ai/reviews/visual-20260208T100353Z`.
- Visual diff report generated: `.ai/reviews/visual-20260208T100353Z/DIFF_REPORT.md`.
- Visual capture baseline refreshed: `.ai/reviews/visual-20260208T101354Z`.
- Visual diff report refreshed: `.ai/reviews/visual-20260208T101354Z/DIFF_REPORT.md`.
- Final acceptance rehearsal executed after `sync --delete`:
  - `scripts/sync-carrd-assets.sh --delete`
  - `npm run build`
  - `npm run ai:check:carrd-contract:strict`
  - `npm run ai:verify:carrd-assets`
  - `npm run ai:visual:smoke`
  - `npm run ai:visual:capture`
  - `npm run ai:visual:report`
- Latest acceptance visual artifacts:
  - `.ai/reviews/visual-20260208T101700Z`
  - `.ai/reviews/visual-20260208T101700Z/DIFF_REPORT.md`
- Runtime adapter moved to `static/js/carrd-runtime-adapter.js` to keep multipage JS stable after asset replacement.
- Added sync-preserve policy: `.ai/contracts/carrd-sync-excludes.txt` (keeps project extension assets across `--delete` sync).
- Sync-preserve policy expanded to keep legacy product image trees for Hugo-rendered product pages.
- Product pages (`hand-cleaner`, `nitrile-gloves`, `industrial-wipes-roll`, `industrial-absorbent-pads`) now have only analytics ID as non-Carrd ID.
- Hugo processed images restored (`Processed images=103`).
- Contract gate expanded from home-only to key contract pages using:
  - `.ai/contracts/carrd-id-contract-pages.txt`
  - `.ai/contracts/carrd-allowed-non-carrd-ids.txt`
- Current strict contract gate is green with:
  - `public.pages_total=5`
  - `public.pages_with_non_carrd_ids=0`
  - `public.max_non_carrd_ids_per_page=0`
  - `public.missing_contract_pages=0`
- Hero parity tuning completed for product pages:
  - `assets/js/coverSlider.js`: remove pre-existing `#coverSlider > .slideshow-background` before custom slider init to avoid dual-slideshow overlap.
  - `layouts/partials/benefitsContent.html`: restored `instance-38` class required by Carrd layout widths.
  - `scripts/capture-visual-baseline.sh`: visual capture now waits for `body.is-ready` and a stabilization timeout.
- Latest visual artifacts after hero-tuning:
  - `.ai/reviews/visual-20260208T103636Z`
  - `.ai/reviews/visual-20260208T103636Z/DIFF_REPORT.md`
- Validation after hero-tuning is green:
  - `npm run build`
  - `npm run ai:check:carrd-contract:strict`
  - `npm run ai:verify:carrd-assets`
  - `npm run ai:visual:smoke`
- Manual review: product hero sections are visually aligned with production baseline on desktop/mobile.

## Next
1. Final review of `.ai/handoff/2026-02-08-1045-utc-codex-final.md`.
2. Merge/handoff package to main workflow branch.
