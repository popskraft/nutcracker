# Carrd To Hugo Refactor Master Plan

## Status
- Owner: AI agents (Claude Code + Codex/GPT-5.3+)
- Last updated (UTC): 2026-02-09
- Phase: 3 (home/product migration in progress, remediation track started)
- Rule: this file is the migration source of truth and must be updated at each phase boundary.

## Mission
Move the entire project to the new Carrd naming/runtime contract so future template updates are done by replacing files from `carrd/assets` into `assets` without breaking the website.

## Hard Constraints
1. Full project scope, but implemented in small verifiable steps.
2. Target state is fully new naming standard:
   - `style-*`
   - `*-component`
   - `instance-*`
3. Transitional adapters are allowed only during migration.
4. End state must remove migration-only compatibility layers.
5. Design/content/view must remain equivalent to the working site.

## Success Criteria
1. Replacing files from `carrd/assets` updates the project without structural breakage.
2. Visual parity with baseline pages on desktop/mobile.
3. Functional parity for navigation, forms, slider/video, and key interactions.
4. Build and contract checks pass.

## Current Execution Snapshot (2026-02-09)
- Build:
  - `npm run build` passes.
- Carrd contract gate:
  - `npm run ai:check:carrd-contract` passes (report mode).
  - `npm run ai:check:carrd-contract:strict` passes with current thresholds and allowlist.
- Core Carrd asset sync:
  - `npm run ai:verify:carrd-assets` passes with documented allowlisted `main.js` normalization diff.
- Visual smoke:
  - `npm run ai:visual:smoke` passes for key pages.
- Markup quality:
  - Duplicate CTA IDs on product pages fixed.
- Final acceptance cycle:
  - `dev:all` startup check, `build`, strict contract, asset verify, visual smoke/capture/report, and baseline availability checks are green.
- Deferred:
  - none in immediate remediation track.

## Implementation Phases
1. Phase 1 (in progress): baseline and quality gates.
   - Create sync/verify/check scripts.
   - Record measurable baseline metrics.
   - Gate future changes with repeatable checks.
2. Phase 2: core shell migration.
   - `baseof`, body wrappers, header/footer contract alignment.
   - Ensure new Carrd runtime selectors are supported.
3. Phase 3: homepage and core partials migration.
   - `pageHeader`, `product2items`, `benefits*`, `faq`, `contactBody`, `savings*`.
4. Phase 4: product and section templates migration.
   - `_default/product.html`, shared product partials, state variants.
5. Phase 5: remaining page types migration.
   - `about`, `articles`, `list`, `single`, `sitemap`, `404`, legal pages.
6. Phase 6: JS runtime normalization.
   - Align with new `carrd/assets/main.js`.
   - Keep custom JS only as extension hooks.
7. Phase 7: legacy cleanup.
   - Remove old class/id usage.
   - Remove temporary compatibility code.
8. Phase 8: final acceptance.
   - Execute real asset replacement flow.
   - Validate parity and stability.

## Immediate Remediation Track (Phase 3.1)
1. Remove duplicate IDs on product pages. `[done]`
   - Ensure `ctaButtonsStyle2` instances rendered in `coverSlider` and `benefitsCTA` use unique IDs per block.
   - Add a deterministic ID strategy for repeated CTA partial invocations.
2. Recover strict Carrd contract metrics to gate thresholds. `[done]`
   - Remove/replace remaining non-Carrd IDs on contract pages.
   - Raise `home.id_intersection` and `style-*` contract coverage to thresholds.
3. Resolve `assets/main.js` sync policy. `[done]`
   - Decide and document one of:
     - full byte-equality with `carrd/assets/main.js`, or
     - controlled patch policy + allowlisted verification logic.
4. Implement conditional product price rendering across product templates. `[done]`
   - Hide price and price-caption blocks when `price`/`priceWholesale` are empty in front matter/data.
   - Keep non-price descriptive product text visible.
   - Ensure behavior is consistent in `coverSlider`, `savingsPrice`, savings footer variants, and schema offer output.
5. Harden visual capture automation for deterministic execution. `[done]`
   - Update `scripts/capture-visual-baseline.sh` to avoid build lock contention (`--noBuildLock`) and add explicit request timeouts.
6. Repository hygiene for generated artifacts. `[done]`
   - Keep runtime/generated logs and bulky review binaries out of normal commits unless explicitly required.
7. Tooling hygiene. `[done]`
   - Refresh Browserslist DB and address current dev dependency audit findings.

## Current Baseline (2026-02-08)
- Home ID intersection (Carrd vs `public/index.html`): `97 / 319`
- Home class intersection (Carrd vs `public/index.html`): `89 / 180`
- Layout legacy class tokens (`style[0-9]+`): `182`
- Layout new class tokens (`style-[0-9]+`): `179`
- Layout component tokens (`*-component`): `155`
- Core Carrd asset file equality (`assets/*` vs `carrd/assets/*`):
  - `main.css`: synced
  - `main.js`: synced
  - `noscript.css`: synced
  - `icons.svg`: synced

## Phase Progress
1. Phase 1 completed.
   - Migration gates added:
     - `scripts/sync-carrd-assets.sh`
     - `scripts/verify-carrd-assets-sync.sh`
     - `scripts/carrd-contract-check.sh`
   - Threshold contract added: `.ai/contracts/carrd-contract-thresholds.env`.
2. Phase 2 started.
   - Core shell migrated to dual contract:
     - `layouts/_default/baseof.html`
     - `layouts/partials/header.html`
     - `layouts/partials/footer.html`
   - Home core partial migration started:
     - `layouts/partials/pageHeader.html`
     - `layouts/partials/product2items.html`
     - `layouts/partials/benefitsHeader.html`
     - `layouts/partials/benefitsContent3Cols.html`
     - `layouts/partials/benefitsCTA.html`
     - `layouts/partials/savingsSingle.html`
     - `layouts/partials/faq.html`
     - `layouts/partials/contactBody.html`
     - `layouts/partials/coverSlider.html`
   - Extended dual-contract migration to additional templates/partials:
     - `layouts/_default/about.html`
     - `layouts/_default/list.html`
     - `layouts/_default/single.html`
     - `layouts/_default/contacts.html`
     - `layouts/_default/sitemap.html`
     - `layouts/404.html`
     - multiple product/savings/gallery partials.
3. Phase 3 started.
   - Build regression fixed after mass class normalization:
     - restored valid `body` class template expression in `layouts/_default/baseof.html`.
   - Added Carrd runtime guard for multipage Hugo pages:
     - `assets/js/carrd-runtime-adapter.js`
     - included before `main.js` in `layouts/_default/baseof.html`.
   - Product card IDs/instances partially aligned with Carrd contract in:
     - `layouts/partials/product2items.html`
   - Staged replacement of core assets completed (with checks after each file):
     - `assets/icons.svg`
     - `assets/noscript.css`
     - `assets/main.css`
     - `assets/main.js`
   - Additional semantic-id migration on homepage completed in:
     - `layouts/partials/benefitsContent3Cols.html`
     - `layouts/partials/faq.html`
     - `layouts/partials/contactBody.html`
     - `layouts/partials/product2items.html` (removed non-Carrd icon title ids for non-reference button sets)
   - Contract metrics improved:
     - `home.id_intersection: 97`
     - `home.class_intersection: 89`
     - `home.id_missing: 222`
     - `home.class_missing: 91`
   - Home non-Carrd IDs reduced to 1 (`G-FY8F76ZGS8`, analytics).
   - Controlled sync rehearsal executed on branch `chore/carrd-sync-delete-media`:
     - command: `scripts/sync-carrd-assets.sh --delete`
     - result: `verify-carrd-assets` => `missing=0`, `mismatch=0`.
   - Added sync safety rules:
     - default exclude list at `.ai/contracts/carrd-sync-excludes.txt`
     - `scripts/sync-carrd-assets.sh` now supports `--exclude-from` and default excludes.
     - exclude list extended with legacy product image trees:
       - `images/handcleaner/`, `images/gloves/`, `images/wipes/`, `images/abspads/`, `images/articles/`, `images/carflag.jpg`, `images/ogimage.jpg`.
   - Restored and protected project extension assets used by local workflow:
     - `assets/tailwind/`, `assets/tailwindstyle.css`, `assets/custom.css`, `assets/js/theme.js`, `assets/js/coverSlider.js`.
     - `npm run tailwind:build` is green again.
   - Runtime hardening after `--delete`:
     - moved adapter from `assets/js` to `static/js/carrd-runtime-adapter.js`.
     - `layouts/_default/baseof.html` now loads adapter from static path (`/js/carrd-runtime-adapter.js`).
   - Key-page visual smoke check passed for:
     - `public/index.html`
     - `public/nitrile-gloves/index.html`
     - `public/hand-cleaner/index.html`
     - `public/about/index.html`
     - `public/terms/index.html`
   - Visual capture automation added:
     - `scripts/capture-visual-baseline.sh`
     - latest artifact set: `.ai/reviews/visual-20260208T100353Z`.
     - diff report command: `npm run ai:visual:report`.
   - Contract gate hardening:
     - `scripts/carrd-contract-check.sh` now validates non-Carrd IDs on explicit contract pages.
     - contract scope file: `.ai/contracts/carrd-id-contract-pages.txt`.
     - allowlist file: `.ai/contracts/carrd-allowed-non-carrd-ids.txt`.
     - strict thresholds extended with:
       - `MAX_PUBLIC_PAGES_WITH_NON_CARRD_IDS`
       - `MAX_PUBLIC_MAX_NON_CARRD_IDS_PER_PAGE`
       - `MAX_PUBLIC_MISSING_CONTRACT_PAGES`
     - current strict metrics:
       - `public.pages_total: 5`
       - `public.pages_with_non_carrd_ids: 0`
       - `public.max_non_carrd_ids_per_page: 0`
       - `public.missing_contract_pages: 0`
   - Visual baseline refreshed:
     - artifact set: `.ai/reviews/visual-20260208T101354Z`
     - diff report: `.ai/reviews/visual-20260208T101354Z/DIFF_REPORT.md`
   - Final acceptance rehearsal completed (post `sync --delete`):
     - full validation bundle passed (`build`, strict contract, asset verify, smoke).
     - latest visual capture: `.ai/reviews/visual-20260208T101700Z`
     - latest visual report: `.ai/reviews/visual-20260208T101700Z/DIFF_REPORT.md`
   - Hero parity tuning pass:
     - fixed product hero slideshow collision by clearing pre-existing `.slideshow-background` in `assets/js/coverSlider.js`.
     - restored Carrd width contract hook `instance-38` in `layouts/partials/benefitsContent.html`.
     - stabilized visual automation timing in `scripts/capture-visual-baseline.sh` using `body.is-ready` wait.
     - latest artifacts after tuning: `.ai/reviews/visual-20260208T103636Z`.
     - latest report: `.ai/reviews/visual-20260208T103636Z/DIFF_REPORT.md`.
   - Product page semantic-id cleanup:
     - removed dynamic IDs from `layouts/partials/savingsFooter2goods.html` and `layouts/partials/savingsFooter4goods.html`.
     - removed non-Carrd ids from product gallery/video wrappers.
     - product pages now only include non-Carrd analytics id (`G-FY8F76ZGS8`) when compared to Carrd reference IDs.
   - Hugo image pipeline restored while keeping Carrd sync stable:
     - `Processed images` back to `103`.
   - Important migration effect of `--delete`:
     - project-specific legacy assets under `assets/` are removed if absent in `carrd/assets`.
     - build remains green, but `Processed images` dropped to `0` because Hugo resource image tree was replaced by Carrd static media.

## Working Rules
1. Every migration step must run contract check script.
2. Any temporary deviation must be documented in handoff.
3. No bulk uncontrolled rewrite without checkpoint build and check.
4. Update this plan before starting a new phase.
