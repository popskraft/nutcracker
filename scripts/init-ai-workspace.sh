#!/usr/bin/env bash
set -euo pipefail

PROJECT_TYPE="carrd-hugo-corporate"
AUTOMATION_MODE="autonomous"
IDE_STACK="vscode,gpt-5.3+-extension,claude-code-extension"
REFERENCE_DIR="carrd"
BASELINE_URL="https://nutcrackerpro.com/"
FORCE=0

usage() {
  cat <<'USAGE'
Usage:
  scripts/init-ai-workspace.sh [options]

Options:
  --project-type TYPE     Project profile.
                          Supported:
                          - carrd-hugo-landing
                          - carrd-hugo-corporate
                          - carrd-processwire-corporate
                          - bootstrap-processwire-corporate
                          - tailwind-processwire-corporate
  --automation-mode MODE  autonomous | hybrid | manual
  --ide LIST              Comma-separated IDE/extension stack
  --reference-dir DIR     Reference markup folder relative to repo root
  --baseline-url URL      Production baseline URL used for parity checks
  --force                 Overwrite existing AI bootstrap files
  --help                  Show this help

Example:
  scripts/init-ai-workspace.sh \
    --project-type carrd-hugo-landing \
    --automation-mode autonomous \
    --ide vscode,gpt-5.3+-extension,claude-code-extension \
    --reference-dir carrd \
    --baseline-url https://nutcrackerpro.com/
USAGE
}

log() {
  printf '[init-ai] %s\n' "$1"
}

write_file() {
  local path="$1"
  if [[ -f "$path" && "$FORCE" -ne 1 ]]; then
    log "skip existing: $path"
    cat >/dev/null
    return
  fi
  mkdir -p "$(dirname "$path")"
  cat >"$path"
  log "wrote: $path"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-type)
      PROJECT_TYPE="${2:-}"
      shift 2
      ;;
    --automation-mode)
      AUTOMATION_MODE="${2:-}"
      shift 2
      ;;
    --ide)
      IDE_STACK="${2:-}"
      shift 2
      ;;
    --reference-dir)
      REFERENCE_DIR="${2:-}"
      shift 2
      ;;
    --baseline-url)
      BASELINE_URL="${2:-}"
      shift 2
      ;;
    --force)
      FORCE=1
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

case "$AUTOMATION_MODE" in
  autonomous|hybrid|manual) ;;
  *)
    echo "Invalid --automation-mode: $AUTOMATION_MODE" >&2
    exit 1
    ;;
esac

PROJECT_NAME="Website Project"
PROJECT_FAMILY="Corporate Website"
MARKUP_SOURCE="Carrd"
CMS="Hugo"
CSS_STACK="Tailwind"
DEV_COMMAND="npm run dev:all"
BUILD_COMMAND="npm run build"
CHECK_COMMAND="npm run build"
TEST_COMMAND="No dedicated tests configured"
EXPECT_REFERENCE=0

case "$PROJECT_TYPE" in
  carrd-hugo-landing)
    PROJECT_NAME="Landing Page"
    PROJECT_FAMILY="Landing Website"
    MARKUP_SOURCE="Carrd"
    CMS="Hugo"
    CSS_STACK="Tailwind"
    DEV_COMMAND="npm run dev:all"
    BUILD_COMMAND="npm run build"
    CHECK_COMMAND="npm run build"
    TEST_COMMAND="No dedicated tests configured"
    EXPECT_REFERENCE=1
    ;;
  carrd-hugo-corporate)
    PROJECT_NAME="Corporate Website"
    PROJECT_FAMILY="Corporate Website"
    MARKUP_SOURCE="Carrd"
    CMS="Hugo"
    CSS_STACK="Tailwind"
    DEV_COMMAND="npm run dev:all"
    BUILD_COMMAND="npm run build"
    CHECK_COMMAND="npm run build"
    TEST_COMMAND="No dedicated tests configured"
    EXPECT_REFERENCE=1
    ;;
  carrd-processwire-corporate)
    PROJECT_NAME="Corporate Website"
    PROJECT_FAMILY="Corporate Website"
    MARKUP_SOURCE="Carrd"
    CMS="ProcessWire"
    CSS_STACK="Custom CSS"
    DEV_COMMAND="php -S 127.0.0.1:8080 -t public"
    BUILD_COMMAND="N/A (runtime CMS)"
    CHECK_COMMAND="php -l site/templates/*.php"
    TEST_COMMAND="Add PHPUnit or smoke tests if available"
    EXPECT_REFERENCE=1
    ;;
  bootstrap-processwire-corporate)
    PROJECT_NAME="Corporate Website"
    PROJECT_FAMILY="Corporate Website"
    MARKUP_SOURCE="Bootstrap"
    CMS="ProcessWire"
    CSS_STACK="Bootstrap"
    DEV_COMMAND="php -S 127.0.0.1:8080 -t public"
    BUILD_COMMAND="N/A (runtime CMS)"
    CHECK_COMMAND="php -l site/templates/*.php"
    TEST_COMMAND="Add PHPUnit or smoke tests if available"
    ;;
  tailwind-processwire-corporate)
    PROJECT_NAME="Corporate Website"
    PROJECT_FAMILY="Corporate Website"
    MARKUP_SOURCE="Tailwind"
    CMS="ProcessWire"
    CSS_STACK="Tailwind"
    DEV_COMMAND="php -S 127.0.0.1:8080 -t public"
    BUILD_COMMAND="N/A (runtime CMS)"
    CHECK_COMMAND="php -l site/templates/*.php"
    TEST_COMMAND="Add PHPUnit or smoke tests if available"
    ;;
  *)
    echo "Invalid --project-type: $PROJECT_TYPE" >&2
    exit 1
    ;;
esac

BOOTSTRAP_DATE="$(date -u +%Y-%m-%d)"
LATEST_HANDOFF_CMD='ls -t .ai/handoff/*.md 2>/dev/null | head -n 1'
REPO_ROOT="$(pwd)"
REFERENCE_PATH="${REPO_ROOT}/${REFERENCE_DIR}"

if [[ "$EXPECT_REFERENCE" -eq 1 && ! -d "$REFERENCE_DIR" ]]; then
  echo "Reference directory is required for this profile but not found: ${REFERENCE_DIR}" >&2
  exit 1
fi

log "creating AI workspace structure"
mkdir -p \
  .ai/tasks \
  .ai/handoff \
  .ai/plans \
  .ai/decisions \
  .ai/reviews \
  .ai/contracts \
  .ai/logs \
  _docs \
  .claude/commands \
  .claude/skills \
  .claude/agents \
  .codex/prompts \
  .codex/skills

write_file "AGENTS.md" <<EOF
# AGENTS.md

## Project Contract
- Project family: ${PROJECT_FAMILY}
- Profile: ${PROJECT_TYPE}
- Markup source: ${MARKUP_SOURCE}
- CMS/SSG: ${CMS}
- CSS stack: ${CSS_STACK}
- Primary IDE workflow: VS Code
- AI model stack: ${IDE_STACK}
- Automation mode: ${AUTOMATION_MODE}
- Bootstrap date (UTC): ${BOOTSTRAP_DATE}
- Reference markup source: \`${REFERENCE_DIR}/\`
- Reference markup absolute path: \`${REFERENCE_PATH}\`
- Production working baseline: \`${BASELINE_URL}\`

## Goal
Build and maintain a production-ready Carrd-to-Hugo website through coordinated AI agents (Claude Code and OpenAI Codex/GPT-5.3+) with deterministic handoffs and reproducible decisions.

## Start Of Every Session
1. Read \`_docs/STATUS.md\`.
2. Read \`.ai/tasks/CURRENT.md\`.
3. Read \`_docs/STACK.md\` and \`_docs/CONVENTIONS.md\`.
4. Read \`_docs/REFERENCE_BASELINE.md\` and \`_docs/VSCODE_AGENT_SETUP.md\`.
5. Read latest handoff: \`${LATEST_HANDOFF_CMD}\`.

## Agent Roles
1. Architect: plans architecture and writes ADRs in \`.ai/decisions/\`.
2. Implementer: builds feature code according to active plan.
3. Reviewer: validates behavior, quality, and risks.
4. Integrator: merges approved changes and updates project state.
5. Baseline Auditor: compares implementation against \`${REFERENCE_DIR}/\` and \`${BASELINE_URL}\`.

## Delivery Workflow
1. Define scope in \`.ai/tasks/CURRENT.md\`.
2. Create implementation plan in \`.ai/plans/\`.
3. Execute changes in branch/worktree.
4. Run checks.
5. Compare changed pages/components with \`${REFERENCE_DIR}/\` and document intended deviations.
6. Write handoff file in \`.ai/handoff/\`.
7. Update \`_docs/STATUS.md\`.

## Required Completion Checklist
1. Run project checks:
   - Dev: \`${DEV_COMMAND}\`
   - Build: \`${BUILD_COMMAND}\`
   - Validation: \`${CHECK_COMMAND}\`
2. Run baseline availability check:
   - \`[ -f "${REFERENCE_DIR}/index.html" ]\`
   - \`curl -I -L --max-time 20 ${BASELINE_URL}\`
3. Document all intentional differences from \`${REFERENCE_DIR}/\` (example: custom slider JS).
4. Produce explicit next steps and blockers in handoff.

## Guardrails
- Do not change architecture conventions without ADR.
- Do not add dependencies without documenting rationale.
- Keep generated artifacts and runtime logs out of commits where possible.
- If requirements are ambiguous, write assumptions into plan and handoff.
- If markup behavior diverges from \`${REFERENCE_DIR}/\`, describe why and where in handoff.
- Treat \`${BASELINE_URL}\` as operational baseline and \`${REFERENCE_DIR}/\` as design/markup baseline.
EOF

write_file "CLAUDE.md" <<'EOF'
# Claude Entry Point

Read `AGENTS.md` first.
Then read `_docs/VSCODE_AGENT_SETUP.md` and `_docs/REFERENCE_BASELINE.md`.
Follow the session start sequence exactly.
EOF

write_file ".codex/AGENTS.md" <<'EOF'
# Codex Entry Point

Primary contract is in `../AGENTS.md`.
Then read `../_docs/VSCODE_AGENT_SETUP.md` and `../_docs/REFERENCE_BASELINE.md`.
Read all three before any planning or coding.
EOF

write_file "_docs/ARCHITECTURE.md" <<EOF
# Architecture: Multi-Agent Website Delivery

## Scope
This architecture standardizes collaboration between Claude Code Extension and OpenAI GPT-5.3+/Codex Extension inside VS Code for Carrd-to-Hugo delivery.

## Core Principle
The repository is the shared memory bus. All critical state is file-based and versioned.

## Shared Context Layers
1. Contract layer:
   - \`AGENTS.md\`
   - \`CLAUDE.md\`
   - \`.codex/AGENTS.md\`
2. Knowledge layer:
   - \`_docs/ARCHITECTURE.md\`
   - \`_docs/STACK.md\`
   - \`_docs/CONVENTIONS.md\`
   - \`_docs/DOMAIN.md\`
   - \`_docs/REFERENCE_BASELINE.md\`
   - \`_docs/VSCODE_AGENT_SETUP.md\`
   - \`_docs/STATUS.md\`
3. Execution layer:
   - \`.ai/tasks/\`
   - \`.ai/plans/\`
   - \`.ai/handoff/\`
   - \`.ai/decisions/\`
   - \`.ai/reviews/\`

## Agent Synchronization Protocol
1. Intake: read status + current task + latest handoff.
2. Plan: write implementation plan file with assumptions.
3. Execute: implement in isolated git branch/worktree.
4. Verify: run stack checks and manual smoke tests.
5. Compare: validate output against local Carrd reference and production baseline site.
6. Handoff: record done, pending, risks, and next actions.
7. Integrate: merge and update status.

## Baseline Contract
- Design and markup reference: \`${REFERENCE_DIR}/\` (\`${REFERENCE_PATH}\`)
- Operational baseline: \`${BASELINE_URL}\`
- Allowed divergence: custom runtime features (example: JS slider improvements), only with explicit note in handoff.

## Operating Modes
- autonomous:
  Agent can continue through plan -> implement -> review -> handoff with minimal human gates.
- hybrid:
  Human approves phase transitions (after plan and after review).
- manual:
  Human controls each subtask and merge.

Current mode: ${AUTOMATION_MODE}
EOF

write_file "_docs/STACK.md" <<EOF
# Stack Profile

## Active Profile
- Project type: ${PROJECT_TYPE}
- Project name: ${PROJECT_NAME}
- Markup source: ${MARKUP_SOURCE}
- CMS/SSG: ${CMS}
- CSS stack: ${CSS_STACK}
- IDE and AI extensions: ${IDE_STACK}
- Reference markup path: \`${REFERENCE_PATH}\`
- Baseline website: \`${BASELINE_URL}\`

## Commands
- Dev: \`${DEV_COMMAND}\`
- Build: \`${BUILD_COMMAND}\`
- Validate: \`${CHECK_COMMAND}\`
- Tests: ${TEST_COMMAND}
- Baseline probe: \`curl -I -L --max-time 20 ${BASELINE_URL}\`

## Notes
- If profile changes, update this file first, then \`AGENTS.md\`.
- Store profile-specific constraints in \`_docs/CONVENTIONS.md\`.
- For Carrd-to-Hugo tasks, verify parity against local \`${REFERENCE_DIR}/\` before finalizing.
EOF

write_file "_docs/CONVENTIONS.md" <<'EOF'
# Engineering Conventions

## Branching
- One feature/fix per branch.
- Use short-lived branches and clean commit messages.

## Source Control Hygiene
- Keep generated output and logs out of commits unless explicitly required.
- Record architectural changes in `.ai/decisions/`.

## Coding Rules
- Reuse existing patterns before introducing new abstractions.
- Prefer readable templates/components over hidden "magic."
- Keep naming explicit for CMS fields, content blocks, and partials.
- Keep Carrd source structure traceable to Hugo partials/layouts for easier diffing.

## QA Rules
- Every change must include verification notes in handoff.
- For content-heavy edits, include quick smoke checks for key pages.
- Compare updated fragments with `carrd/index.html` and linked Carrd assets.
- If behavior intentionally differs from Carrd (for example slider JS), note it explicitly.
EOF

write_file "_docs/DOMAIN.md" <<'EOF'
# Domain Notes

## Product Domain
- B2B website content with product, trust, and conversion blocks.
- Multi-page corporate/landing variants depending on project profile.

## Information Priorities
1. Conversion clarity (CTA, form flow, contact)
2. Trust signals (proof, testimonials, certifications)
3. SEO consistency (metadata, schema, internal linking)

## Content Model
- Shared product content and state/segment variants where applicable.
- Keep marketing claims and legal-sensitive text traceable.
- Treat production baseline content as operational reference while modernizing markup from Carrd source.
EOF

write_file "_docs/REFERENCE_BASELINE.md" <<EOF
# Reference And Baseline Rules

## Canonical Inputs
- Local design/markup reference (primary): \`${REFERENCE_DIR}/\`
- Local absolute path (primary): \`${REFERENCE_PATH}\`
- Production site baseline (operational): \`${BASELINE_URL}\`

## Comparison Priority
1. Compare against local Carrd source for layout and section fidelity.
2. Compare against production baseline for operational behavior and critical content.
3. If they conflict, preserve production stability and document planned migration path.

## Allowed Differences
- Runtime JS enhancements not present in Carrd export (example: custom slider behavior).
- Hugo-specific optimizations (partials, image processing, SEO tags).
- Accessibility and performance improvements.

## Required Documentation For Differences
For each intentional difference, record:
1. What changed.
2. Why it changed.
3. Where it is implemented.
4. How it was tested.

Record this in handoff and, if structural, in ADR.
EOF

write_file "_docs/VSCODE_AGENT_SETUP.md" <<'EOF'
# VS Code Agent Setup

## Target IDE Stack
- VS Code
- OpenAI extension/session with GPT-5.3+ for implementation and review
- Claude Code extension/session for architecture and cross-check review

## Session Pattern
1. Open repository in VS Code.
2. Start GPT-5.3+ session and Claude Code session.
3. Ensure both read `AGENTS.md` before any edits.
4. Assign one primary writer agent per task to avoid edit collisions.
5. Use handoff files for cross-model synchronization.

## Recommended Task Split
- Claude Code: architecture, planning, risk review, ADR drafting.
- GPT-5.3+: implementation, refactoring, test/run automation, build fixes.
- Either model may switch roles, but the handoff protocol remains mandatory.

## Safety Checklist
- Never skip `_docs/REFERENCE_BASELINE.md`.
- Do not finalize without build/validation commands.
- Do not merge if intentional Carrd divergence is undocumented.
EOF

write_file "_docs/STATUS.md" <<EOF
# Project Status

Last updated (UTC): ${BOOTSTRAP_DATE}
Mode: ${AUTOMATION_MODE}
Active profile: ${PROJECT_TYPE}
IDE stack: ${IDE_STACK}
Reference markup: ${REFERENCE_PATH}
Baseline site: ${BASELINE_URL}

## In Progress
- AI workspace bootstrap initialized.

## Next
1. Fill \`.ai/tasks/CURRENT.md\` with the first concrete feature/task.
2. Create first plan in \`.ai/plans/\`.
3. Start implementation branch.
4. Run first baseline parity check against \`${REFERENCE_DIR}/\`.
EOF

write_file ".ai/tasks/BACKLOG.md" <<'EOF'
# AI Backlog

## Ready
- [ ] Define first production task

## Later
- [ ] Add automated quality gates for selected stack
EOF

write_file ".ai/tasks/CURRENT.md" <<'EOF'
# Current Task

## Title
Bootstrap complete, waiting for first task.

## Goal
Describe one concrete deliverable.

## Constraints
- Keep scope small and testable.
- Define acceptance criteria before coding.

## Acceptance Criteria
1. ...
2. ...
3. ...
EOF

write_file ".ai/handoff/_TEMPLATE.md" <<'EOF'
# Handoff: YYYY-MM-DD HH:MM UTC - <Agent Name>

## Done
- ...

## Pending
- ...

## Decisions
- ADR link(s): ...

## Validation
- Commands run:
  - ...
- Result:
  - ...
- Baseline comparison:
  - Carrd reference files checked: ...
  - Production baseline probe result: ...

## Risks / Blockers
- ...

## Next Steps
1. ...
2. ...
EOF

write_file ".ai/plans/_TEMPLATE.md" <<'EOF'
# Plan: <Task Name>

## Inputs
- Task file: `.ai/tasks/CURRENT.md`
- Related docs: ...

## Assumptions
- ...

## Steps
1. ...
2. ...
3. ...

## Validation
- Command(s): ...
- Manual checks: ...
- Carrd reference comparison: ...
- Production baseline comparison: ...

## Exit Criteria
- ...
EOF

write_file ".ai/decisions/000-template.md" <<'EOF'
# ADR 000: <Title>

## Status
Proposed

## Context
- ...

## Decision
- ...

## Consequences
- Positive: ...
- Negative: ...
EOF

write_file ".ai/reviews/_TEMPLATE.md" <<'EOF'
# Review: <Scope>

## Findings
1. [severity] file/path:line - issue description

## Risks
- ...

## Recommendation
- ...
EOF

write_file ".ai/contracts/SESSION_PROTOCOL.md" <<'EOF'
# Session Protocol

## Required Order
1. Read context (`_docs` + `.ai/tasks/CURRENT.md`).
2. Read `_docs/REFERENCE_BASELINE.md` and confirm reference source availability.
3. Confirm plan file exists.
4. Implement in isolated branch/worktree.
5. Validate with stack commands.
6. Compare against Carrd reference and baseline site.
7. Write handoff and update status.

## Session Guard
If any step is skipped, session is considered incomplete.
EOF

write_file ".ai/contracts/PROJECT_PROFILE.yaml" <<EOF
project_type: ${PROJECT_TYPE}
project_name: "${PROJECT_NAME}"
project_family: "${PROJECT_FAMILY}"
markup_source: "${MARKUP_SOURCE}"
cms: "${CMS}"
css_stack: "${CSS_STACK}"
automation_mode: "${AUTOMATION_MODE}"
ide_stack: "${IDE_STACK}"
reference_dir: "${REFERENCE_DIR}"
reference_path: "${REFERENCE_PATH}"
baseline_url: "${BASELINE_URL}"
commands:
  dev: "${DEV_COMMAND}"
  build: "${BUILD_COMMAND}"
  validate: "${CHECK_COMMAND}"
  tests: "${TEST_COMMAND}"
EOF

write_file ".claude/README.md" <<'EOF'
# Claude Workspace

- Put reusable Claude commands in `.claude/commands/`.
- Put optional Claude skills in `.claude/skills/`.
- Use `.claude/agents/` for role-specific prompt assets.
- For VS Code extension sessions, always read `AGENTS.md` and `_docs/VSCODE_AGENT_SETUP.md` first.
EOF

write_file ".codex/README.md" <<'EOF'
# Codex Workspace

- Put reusable Codex prompts in `.codex/prompts/`.
- Put optional Codex skills in `.codex/skills/`.
- Keep `.codex/AGENTS.md` aligned with root `AGENTS.md`.
- For VS Code GPT-5.3+ sessions, follow `_docs/VSCODE_AGENT_SETUP.md`.
EOF

for keep_dir in \
  ".ai/logs" \
  ".claude/commands" \
  ".claude/skills" \
  ".claude/agents" \
  ".codex/prompts" \
  ".codex/skills"; do
  if [[ ! -f "${keep_dir}/.gitkeep" ]]; then
    : > "${keep_dir}/.gitkeep"
    log "wrote: ${keep_dir}/.gitkeep"
  fi
done

log "AI workspace bootstrap completed"
log "next: update .ai/tasks/CURRENT.md and start the first plan in .ai/plans/"
