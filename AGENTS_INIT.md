# AGENTS_INIT.md
<!-- Quick Start (English):
1) Ask the AI agent to run this file in dry-run mode first.
2) Review detected inputs, conflicts, and planned file actions.
3) Ask the AI agent to run apply mode (`--apply`) only after confirmation.
4) Review `git status` and create commit manually.
-->

<!-- metadata_format: markdown-inline metadata (not YAML front matter) -->
schema_version: 1
contract_type: bootstrap
language: English

## Purpose
This file is the single bootstrap contract for creating the AI agent workspace in an existing or new repository.
It defines inputs, discovery, generation, safety policies, self-tests, and rollback.

## Entry Points And Priority
1. `AGENTS_INIT.md` is the only bootstrap authority.
2. `AGENTS.md` is runtime-only and is generated or refreshed from this bootstrap contract.
3. `AI_AGENT_SYSTEM_BOOTSTRAP.md` is legacy compatibility documentation and must point back to this file.
4. `CLAUDE.md` and `.codex/AGENTS.md` must point to `AGENTS.md` for runtime sessions.

## Invocation Model
- Initiator: human asks an AI agent to run bootstrap.
- Default mode: `dry-run` (report only, no file writes).
- Apply mode: `--apply` (create/merge files according to policy).
- Optional strict apply: `--apply --force-runtime` (regenerate `AGENTS.md` runtime contract after confirmation).
- If `scripts/init-ai-workspace.sh` exists, it may be used. If it does not exist, agent runs manual bootstrap using this file.

## Input Contract

### Required Inputs
- `PROJECT_FAMILY`
- `PROFILE_ID`
- `AUTOMATION_MODE` (`autonomous|hybrid|manual`)
- `IDE_WORKFLOW`
- `AI_MODEL_STACK`
- `PRODUCTION_BASELINE_URL`

### Profile-Conditional Required Inputs
- For `carrd-*` profiles:
  - `REFERENCE_MARKUP_DIR` (default recommended: `carrd`)

### Optional Inputs With Defaults
- `PREVIEW_BASELINE_URL` default: empty
- `PRODUCTION_BRANCH` default: `main`
- `PREVIEW_BRANCH` default: `develop`
- `BOOTSTRAP_DATE_UTC` default: current UTC date
- `ENABLE_NETLIFY_VALIDATION` default: `auto` (enabled if `netlify.toml` exists)
- `DOC_LANGUAGE` default: `English`

## Missing Input Policy
- In `dry-run` mode:
  - list all missing required inputs
  - show proposed defaults where safe
  - do not mark bootstrap as successful
- In `--apply` mode:
  - if required inputs are missing, run only partial bootstrap (Phase 0 scaffolding)
  - write blockers into `_docs/STATUS.md`
  - keep unresolved values as `TBD` placeholders
  - require user confirmation before generating final `AGENTS.md`

## Supported Profiles And Overlays

### Profiles
- `carrd-hugo-landing`
- `carrd-hugo-corporate`
- `carrd-processwire-corporate`
- `bootstrap-processwire-corporate`
- `tailwind-processwire-corporate`

### Overlay Rules (MUST)
- `carrd-*` overlays:
  - checklist MUST include:
    - `carrd-contract-report`
    - `carrd-contract-strict`
    - `carrd-asset-verify`
  - guardrails MUST include:
    - explicit documentation of intentional Carrd divergence
- `*-hugo-*` overlays:
  - checklist MUST include:
    - Hugo build (`hugo --gc --minify` or project-specific equivalent)
    - static output existence check (for example `public/`)
- `*-processwire-*` overlays:
  - checklist MUST include:
    - PHP syntax check (project command or `php -l` sweep)
    - migration/status verification (project-specific DB migration command)
  - MUST NOT require static-Hugo-only checks

## Discovery Algorithm (Deterministic)
1. Detect repository root and git status.
2. Detect stack signals:
   - Hugo if any of: `hugo.toml`, `hugo.yaml`, `hugo.json`, `layouts/`
   - ProcessWire if any of: `site/`, `wire/`, `index.php` with ProcessWire markers
   - Netlify if `netlify.toml`
   - Carrd reference if `<REFERENCE_MARKUP_DIR>/index.html` or `carrd/index.html`
3. Detect command surface:
   - prefer `package.json` scripts
   - else fallback to `_docs/STACK.md`
4. Detect existing AI workspace:
   - `_docs/`, `.ai/`, `AGENTS.md`, `CLAUDE.md`, `.codex/AGENTS.md`
5. Resolve stack priority:
   - if `PROFILE_ID` is set, prefer stack signals matching `PROFILE_ID`
   - if `PROFILE_ID` is not set and multiple stacks detected, list all and ask user confirmation
6. Compare discovered state vs expected control structure.
7. Produce bootstrap report:
   - detected profile signals
   - missing files/folders
   - conflicts
   - planned actions for `--apply`

## Conflict Handling (Mandatory)
When contradiction exists between bootstrap contract and repository reality:
1. List contradictions explicitly.
2. Propose 2-3 safe options.
3. Ask for confirmation.
4. Apply only confirmed option.

## Idempotency Policy
- Default: additive and non-destructive.
- Existing project files: do not overwrite blindly.
- File handling modes:
  - `create_if_missing`: create only if absent
  - `merge_if_exists`: append/update bounded managed block
  - `skip_if_exists`: leave as-is and log skip
  - `replace_with_confirmation`: only after explicit user confirmation

## Safety Policy (Never Overwrite Automatically)
- `hugo.toml`, `hugo.yaml`, `hugo.json`
- `netlify.toml`
- `content/**`
- `data/**`
- `layouts/**`
- `assets/**`
- `static/**`
- `.gitignore`

## Bootstrap Output Set

### Minimum Viable Bootstrap (Phase 0)
1. `AGENTS.md`
2. `_docs/STATUS.md`
3. `_docs/STACK.md`
4. `.ai/tasks/CURRENT.md`

### Full Bootstrap (Phase 1)
1. `_docs/CONVENTIONS.md`
2. `_docs/REFERENCE_BASELINE.md`
3. `_docs/VSCODE_AGENT_SETUP.md`
4. `_docs/CARRD_REFACTOR_MASTER_PLAN.md`
5. `.ai/plans/_TEMPLATE.md`
6. `.ai/handoff/_TEMPLATE.md`
7. `.ai/contracts/PROJECT_PROFILE.yaml`
8. `.ai/decisions/` (directory)
9. `.ai/reviews/` (directory)
10. `.ai/logs/.gitkeep`

## Template Mapping (Minimum Content Requirements)
- `AGENTS.md`:
  - `schema_version`
  - project contract with discovered values
  - runtime session order
  - delivery workflow
  - profile-aware completion checklist
  - conflict rule
- `_docs/STATUS.md`:
  - last updated date (UTC)
  - mode
  - active profile
  - in progress / done / next / blockers
- `_docs/STACK.md`:
  - active stack and profile
  - normalized command map (`dev`, `build`, `validate`, profile checks)
  - deployment baseline and environment notes
- `_docs/CONVENTIONS.md`:
  - branching rules
  - source-control hygiene
  - coding and review conventions
  - QA requirements
- `_docs/REFERENCE_BASELINE.md`:
  - canonical reference sources (local + production)
  - comparison priority and allowed deviations
  - documentation requirements for deviations
- `_docs/VSCODE_AGENT_SETUP.md`:
  - recommended extension setup
  - two-agent collaboration mode
  - safety checklist before finalization
- `_docs/CARRD_REFACTOR_MASTER_PLAN.md` (for Carrd profiles):
  - mission, constraints, phases
  - measurable gates and pass/fail criteria
  - phase progress log
- `.ai/tasks/CURRENT.md`:
  - title
  - goal
  - scope
  - acceptance criteria
- `.ai/contracts/PROJECT_PROFILE.yaml`:
  - `schema_version`
  - `profile_id`
  - `stack_family`
  - `checks_enabled`

## Netlify Policy
If `netlify.toml` exists:
1. Read `build.command` and `build.publish`.
2. Detect deploy contexts (`production`, `deploy-preview`, `branch-deploy`).
3. Use detected values over defaults.
4. If production branch is not explicit, default to `main` and record assumption.

## Carrd Reference Policy
For `carrd-*` profiles:
- If reference markup is missing, do not abort bootstrap.
- Create workspace and record blocker in `_docs/STATUS.md`:
  - `blocker: reference markup missing`

## Self-Test (Bootstrap Integrity)
Bootstrap is successful only if all are true:
1. Required files for selected phase exist.
2. `AGENTS.md` has no unresolved placeholders except explicit `TBD` blockers.
3. `AGENTS.md` profile matches `.ai/contracts/PROJECT_PROFILE.yaml`.
4. `CLAUDE.md` and `.codex/AGENTS.md` point to `AGENTS.md`.
5. Profile overlay checks are present in checklist.
6. No protected file was overwritten.

## Escape Hatch
- If bootstrap changes are uncommitted:
  - review with `git status`
  - restore only bootstrap-generated files
- If bootstrap changes are committed:
  - revert bootstrap commit with a dedicated revert commit
- Always preserve user-authored product/content/config files.

## Profile Migration Procedure
Use when changing `PROFILE_ID` on an existing project:
1. Run discovery and profile diff.
2. Update `.ai/contracts/PROJECT_PROFILE.yaml`.
3. Regenerate profile-dependent sections in `AGENTS.md` and `_docs/STACK.md`.
4. Re-run self-test and project checks.
5. Record migration in handoff and status.

Example migration:
- from `carrd-hugo-landing` to `carrd-hugo-corporate`
  - add product-page checks to completion checklist
  - extend contract-page set for Carrd parity checks
  - expand migration plan sections for product templates

## Commit Policy
- Bootstrap does not auto-commit by default.
- Show resulting `git status` and propose commit message.
- Commit only after user confirmation.
