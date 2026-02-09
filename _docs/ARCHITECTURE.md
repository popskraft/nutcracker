# Architecture: Multi-Agent Website Delivery

## Scope
This architecture standardizes collaboration between Claude Code Extension and OpenAI GPT-5.3+/Codex Extension inside VS Code for Carrd-to-Hugo delivery.

## Core Principle
The repository is the shared memory bus. All critical state is file-based and versioned.

## Shared Context Layers
1. Contract layer:
   - `AGENTS.md`
   - `CLAUDE.md`
   - `.codex/AGENTS.md`
2. Knowledge layer:
   - `_docs/ARCHITECTURE.md`
   - `_docs/STACK.md`
   - `_docs/CONVENTIONS.md`
   - `_docs/DOMAIN.md`
   - `_docs/REFERENCE_BASELINE.md`
   - `_docs/VSCODE_AGENT_SETUP.md`
   - `_docs/STATUS.md`
3. Execution layer:
   - `.ai/tasks/`
   - `.ai/plans/`
   - `.ai/handoff/`
   - `.ai/decisions/`
   - `.ai/reviews/`

## Agent Synchronization Protocol
1. Intake: read status + current task + latest handoff.
2. Plan: write implementation plan file with assumptions.
3. Execute: implement in isolated git branch/worktree.
4. Verify: run stack checks and manual smoke tests.
5. Compare: validate output against local Carrd reference and production baseline site.
6. Handoff: record done, pending, risks, and next actions.
7. Integrate: merge and update status.

## Baseline Contract
- Design and markup reference: `carrd/` (`/Users/popskraft/hugo/nutcracker/carrd`)
- Operational baseline: `https://nutcrackerpro.com/`
- Allowed divergence: custom runtime features (example: JS slider improvements), only with explicit note in handoff.

## Operating Modes
- autonomous:
  Agent can continue through plan -> implement -> review -> handoff with minimal human gates.
- hybrid:
  Human approves phase transitions (after plan and after review).
- manual:
  Human controls each subtask and merge.

Current mode: autonomous
