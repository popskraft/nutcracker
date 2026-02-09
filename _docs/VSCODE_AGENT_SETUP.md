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
