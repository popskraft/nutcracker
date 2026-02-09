# Current Task

## Title
Full Carrd Naming/Asset Contract Migration (Project-wide)

## Goal
Refactor the entire Hugo project to the new Carrd naming/runtime contract so future template updates are done by replacing files from `carrd/assets` into `assets` without structural breakage.

## Scope
- All page types and templates.
- All relevant partials and JS integration points.
- Asset flow and contract checks.

## Primary Reference
- `_docs/CARRD_REFACTOR_MASTER_PLAN.md`
- `.ai/plans/carrd-full-migration.md`

## Constraints
- Use minimal verifiable steps.
- Preserve design/content/behavior parity while changing markup contract.
- Transitional compatibility is allowed but must be removed by final phase.

## Acceptance Criteria
1. Project structure is aligned with new Carrd class/id/runtime contract.
2. Replacing `assets` from `carrd/assets` does not break the website.
3. Build and contract checks pass and are repeatable.
