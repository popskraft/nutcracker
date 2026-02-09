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
