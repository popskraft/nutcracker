# Reference And Baseline Rules

## Canonical Inputs
- Local design/markup reference (primary): `carrd/`
- Local absolute path (primary): `/Users/popskraft/hugo/nutcracker/carrd`
- Production site baseline (operational): `https://nutcrackerpro.com/`

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
