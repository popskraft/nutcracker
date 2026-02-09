# Stack Profile

## Active Profile
- Project type: carrd-hugo-corporate
- Project name: Corporate Website
- Markup source: Carrd
- CMS/SSG: Hugo
- CSS stack: Tailwind
- IDE and AI extensions: vscode,gpt-5.3+-extension,claude-code-extension
- Reference markup path: `/Users/popskraft/hugo/nutcracker/carrd`
- Baseline website: `https://nutcrackerpro.com/`

## Commands
- Dev: `npm run dev:all`
- Build: `npm run build`
- Validate: `npm run build`
- Tests: No dedicated tests configured
- Baseline probe: `curl -I -L --max-time 20 https://nutcrackerpro.com/`
- Sync Carrd assets: `npm run ai:sync:carrd-assets`
- Sync Carrd assets (destructive rehearsal): `bash scripts/sync-carrd-assets.sh --delete`
- Verify Carrd asset sync: `npm run ai:verify:carrd-assets`
- Carrd contract report: `npm run ai:check:carrd-contract`
- Carrd contract strict check: `npm run ai:check:carrd-contract:strict`
- Visual smoke check: `npm run ai:visual:smoke`
- Visual capture (local vs baseline): `npm run ai:visual:capture`
- Visual diff report (latest capture): `npm run ai:visual:report`

## Notes
- If profile changes, update this file first, then `AGENTS.md`.
- Store profile-specific constraints in `_docs/CONVENTIONS.md`.
- For Carrd-to-Hugo tasks, verify parity against local `carrd/` before finalizing.
- Master migration control file: `_docs/CARRD_REFACTOR_MASTER_PLAN.md`.
- Sync preserve rules file: `.ai/contracts/carrd-sync-excludes.txt`.
