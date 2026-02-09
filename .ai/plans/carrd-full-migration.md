# Plan: Carrd Full Migration

## Inputs
- Task file: `.ai/tasks/CURRENT.md`
- Master plan: `_docs/CARRD_REFACTOR_MASTER_PLAN.md`
- Reference HTML: `carrd/index.html`
- Reference assets: `carrd/assets/`
- Working baseline site: `https://nutcrackerpro.com/`

## Assumptions
- Migration is complete only when replacing `assets` from `carrd/assets` is safe.
- Transitional adapters are temporary and removed at final stage.
- Baseline parity is checked across all main page types.

## Steps
1. Build baseline metrics and automation gates. `[done]`
2. Migrate shell/layout contract. `[done]`
3. Migrate homepage/component partials. `[in progress]`
4. Migrate product/state/legal/article templates. `[in progress]`
5. Normalize JS runtime and remove legacy contract usage. `[in progress]`
6. Run final acceptance cycle with asset replacement simulation.

## Progress Notes
- 2026-02-08:
  - Added migration gates:
    - `scripts/sync-carrd-assets.sh`
    - `scripts/verify-carrd-assets-sync.sh`
    - `scripts/carrd-contract-check.sh`
  - Added strict thresholds:
    - `.ai/contracts/carrd-contract-thresholds.env`
  - Migrated core shell and several home partials to dual contract:
    - `layouts/_default/baseof.html`
    - `layouts/partials/header.html`
    - `layouts/partials/footer.html`
    - `layouts/partials/pageHeader.html`
    - `layouts/partials/product2items.html`
    - `layouts/partials/benefitsHeader.html`
    - `layouts/partials/benefitsContent3Cols.html`
    - `layouts/partials/benefitsCTA.html`
    - `layouts/partials/savingsSingle.html`
    - `layouts/partials/faq.html`
    - `layouts/partials/contactBody.html`
    - `layouts/partials/coverSlider.html`
  - Extended migration coverage to non-home templates and additional partials
    with dual `styleN + style-N` classes and `*-component` classes.
  - Restored build integrity after regression in `layouts/_default/baseof.html`.
  - Added runtime compatibility adapter:
    - `assets/js/carrd-runtime-adapter.js`
    - loaded before `assets/main.js` in `layouts/_default/baseof.html`
    - prevents Carrd `main.js` hard-fail on pages without `#coverSlider` and `#video02`.
  - Improved homepage contract overlap by aligning product card IDs/instances in `layouts/partials/product2items.html`:
    - `home.id_intersection=67/319`
    - `home.class_intersection=75/180`
  - Completed staged core asset replacement from Carrd source:
    - `assets/icons.svg`
    - `assets/noscript.css`
    - `assets/main.css`
    - `assets/main.js`
  - Migrated additional semantic IDs to Carrd IDs/instances in:
    - `layouts/partials/benefitsContent3Cols.html`
    - `layouts/partials/faq.html`
    - `layouts/partials/contactBody.html`
  - Current contract metrics:
    - `home.id_intersection=97/319`
    - `home.class_intersection=89/180`
  - Remaining non-Carrd IDs in generated home HTML: `1` (`G-FY8F76ZGS8`, analytics).
  - Controlled sync rehearsal completed in branch `chore/carrd-sync-delete-media`:
    - `scripts/sync-carrd-assets.sh --delete`
    - `npm run ai:verify:carrd-assets` => `missing=0`, `mismatch=0`
  - Visual smoke validation passed on key pages:
    - home, product pages (`nitrile-gloves`, `hand-cleaner`), `about`, `terms`.
  - Runtime adapter moved to `static/js/carrd-runtime-adapter.js` to survive future `assets` replacement cycles.
  - Added default sync preserve rules:
    - `.ai/contracts/carrd-sync-excludes.txt`
    - `scripts/sync-carrd-assets.sh` now supports `--exclude-from` and default exclude loading.
  - Added visual automation:
    - `scripts/visual-smoke-check.sh`
    - `scripts/capture-visual-baseline.sh`
    - latest capture artifacts: `.ai/reviews/visual-20260208T100353Z`
    - diff report: `.ai/reviews/visual-20260208T100353Z/DIFF_REPORT.md`
  - Product pages cleanup:
    - removed remaining dynamic non-Carrd ids from `savingsFooter2goods`, `savingsFooter4goods`, and product gallery/video wrappers.
    - all main product pages now differ from Carrd IDs only by analytics id.
  - Sync excludes expanded to preserve legacy product image trees and keep Hugo processed images working after `--delete`.
  - Contract check hardening completed:
    - `scripts/carrd-contract-check.sh` now checks non-Carrd IDs on key contract pages only.
    - contract pages are defined in `.ai/contracts/carrd-id-contract-pages.txt`.
    - allowed non-Carrd IDs are defined in `.ai/contracts/carrd-allowed-non-carrd-ids.txt`.
    - strict thresholds extended with public contract-page ID metrics.
    - current strict result:
      - `public.pages_total=5`
      - `public.pages_with_non_carrd_ids=0`
      - `public.max_non_carrd_ids_per_page=0`
      - `public.missing_contract_pages=0`
  - Visual artifacts refreshed:
    - `.ai/reviews/visual-20260208T101354Z`
    - report: `.ai/reviews/visual-20260208T101354Z/DIFF_REPORT.md`
  - Final acceptance rehearsal after `sync --delete` completed:
    - build: pass
    - strict contract: pass
    - Carrd asset verify: pass
    - visual smoke: pass
    - latest visual artifacts: `.ai/reviews/visual-20260208T101700Z`
    - latest visual report: `.ai/reviews/visual-20260208T101700Z/DIFF_REPORT.md`
  - Hero parity tuning pass completed:
    - `assets/js/coverSlider.js`: removes existing `.slideshow-background` before custom slider init.
    - `layouts/partials/benefitsContent.html`: `instance-38` restored for Carrd width layout contract.
    - `scripts/capture-visual-baseline.sh`: waits for `body.is-ready` and stabilization timeout.
    - latest visual artifacts: `.ai/reviews/visual-20260208T103636Z`
    - latest visual report: `.ai/reviews/visual-20260208T103636Z/DIFF_REPORT.md`

## Validation
- Contract checks:
  - `npm run ai:check:carrd-contract`
  - `npm run ai:check:carrd-contract:strict`
- Build:
  - `npm run build`
- Asset flow:
  - `npm run ai:sync:carrd-assets`
  - `npm run ai:verify:carrd-assets`

## Exit Criteria
- New naming/runtime contract is native across the project.
- Legacy contract removed.
- Asset replacement flow is stable.
