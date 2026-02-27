# AGENTS.md

schema_version: 1
contract_type: runtime
bootstrap_source: AGENTS_INIT.md
last_updated_utc: 2026-02-09

## Entry Points And Priority
1. Runtime contract: `AGENTS.md` (this file).
2. Bootstrap contract: `AGENTS_INIT.md` (for workspace initialization and profile migration only).
3. Legacy bootstrap doc: `AI_AGENT_SYSTEM_BOOTSTRAP.md` (compatibility layer, non-authoritative).
4. Runtime entry files `CLAUDE.md` and `.codex/AGENTS.md` point to this file.

## Project Contract
- Project family: Corporate Website
- Profile: carrd-hugo-corporate
- Markup source: Carrd
- CMS/SSG: Hugo
- CSS stack: Carrd (native) / Tailwind
- Primary IDE workflow: VS Code + GPT-5.3+ extension + Claude Code extension
- AI model stack: Claude Opus 4.6, GPT-5.3+, Codex
- Automation mode: autonomous
- Bootstrap date (UTC): 2026-02-08
- Reference markup source: `carrd/`
- Reference markup absolute path: `/Users/popskraft/hugo/nutcracker/carrd`
- Production working baseline: `https://nutcrackerpro.com/`
- Netlify publish dir: `public`
- Netlify build command: `hugo --gc --minify`
- Production branch policy: `main`
- Preview policy: Netlify `deploy-preview` and `branch-deploy` contexts

## Goal
Build and maintain a production-ready Carrd-to-Hugo website through coordinated AI agents with deterministic handoffs and reproducible decisions.

## Workspace Structure Reference
For generated file inventory and template policy, see `AGENTS_INIT.md` -> `Bootstrap Output Set` and `Template Mapping`.

## Start Of Every Session
1. Read `_docs/STATUS.md`.
2. Read `.ai/tasks/CURRENT.md`.
3. Read `_docs/STACK.md` and `_docs/CONVENTIONS.md`.
4. Read `_docs/REFERENCE_BASELINE.md` and `_docs/VSCODE_AGENT_SETUP.md`.
5. Read `_docs/CARRD_REFACTOR_MASTER_PLAN.md`.
6. Read latest handoff: `ls -t .ai/handoff/*.md 2>/dev/null | head -n 1`.
7. If session changes bootstrap architecture, read `AGENTS_INIT.md` before editing agent-system files.

## Agent Roles
1. Architect: plans architecture and writes ADRs in `.ai/decisions/`.
2. Implementer: builds feature code according to active plan.
3. Reviewer: validates behavior, quality, and risks.
4. Integrator: merges approved changes and updates project state.
5. Baseline Auditor: compares implementation against `carrd/` and `https://nutcrackerpro.com/`.

## Delivery Workflow
1. Define scope in `.ai/tasks/CURRENT.md`.
2. Create implementation plan in `.ai/plans/`.
3. Execute changes in branch/worktree.
4. Run checks.
5. Compare changed pages/components with `carrd/` and document intended deviations.
6. Write handoff file in `.ai/handoff/`.
7. Update `_docs/STATUS.md`.
8. Update `_docs/CARRD_REFACTOR_MASTER_PLAN.md` at every phase boundary.

## Conflict Resolution Rule (Mandatory)
If contradiction appears between runtime contract and repository reality:
1. List contradiction explicitly.
2. Propose 2-3 safe options.
3. Ask for confirmation.
4. Apply only confirmed option.

## Required Completion Checklist
1. Run project checks:
   - Dev: `npm run dev:all`
   - Build: `npm run build`
   - Validation: `npm run build`
   - Carrd contract report: `npm run ai:check:carrd-contract`
   - Carrd contract strict check: `npm run ai:check:carrd-contract:strict`
   - Carrd asset sync verification: `npm run ai:verify:carrd-assets`
2. Run baseline availability check:
   - `[ -f "carrd/index.html" ]`
   - `curl -I -L --max-time 20 https://nutcrackerpro.com/`
3. Verify Netlify deployment contract:
   - `netlify.toml` build command and publish dir match docs
   - production branch is `main`
4. Document all intentional differences from Carrd export (example: custom slider JS).
5. Produce explicit next steps and blockers in handoff.

## Guardrails
- Do not change architecture conventions without ADR.
- Do not add dependencies without documenting rationale.
- Keep generated artifacts and runtime logs out of commits where possible.
- If requirements are ambiguous, write assumptions into plan and handoff.
- If markup behavior diverges from `carrd/`, describe why and where in handoff.
- Treat `https://nutcrackerpro.com/` as operational baseline and `carrd/` as design/markup baseline.
- Keep `_docs/CARRD_REFACTOR_MASTER_PLAN.md` in sync with current migration phase and gates.
