---
name: maintainable-coding
description: Implement, fix, delete, replace, or review repository code with focused reuse, minimal scope, and honest verification. Use for code changes; do not use for conceptual questions, translation, or answers that do not change a project.
---

# Maintainable Coding

Make the smallest complete change that fits the repository, and leave accurate
evidence about whether the requested behavior works.

## Choose the depth

- **Low risk:** copy, local configuration, or a narrow fix. Read the target and
  closest check, make the precise change, and do not add process documents.
- **Medium risk:** a module feature or business-rule change. Search existing
  implementations and callers, then run a focused behavior check.
- **High risk:** a public interface, persistence format, dependency boundary, or
  cross-module change. Identify affected callers and compatibility or migration
  needs before implementation.

Risk controls investigation depth, not authorization. Continue reversible work
already requested; ask only for an unresolved material choice or an unapproved
irreversible action.

## Workflow

### 1. Read

Read repository instructions, the entry point, owning implementation, direct
callers, relevant tests, fixtures, configuration, and exports. Search for the
same rule, helper, adapter, or pattern before adding code. Preserve unrelated
local changes and avoid a whole-repository audit by default.

For a new project, read [references/new-project.md](references/new-project.md).

### 2. Place

- Reuse a fitting implementation instead of copying its business rule.
- Keep provider, framework, storage, and transport details at their existing
  boundary rather than spreading them through business code.
- Follow current repository style and dependencies.
- Add an abstraction only for a variation the request needs or a pattern the
  repository already uses. Adjust an unsuitable boundary only as far as needed.

### 3. Change

Update every directly affected caller, test, fixture, configuration entry, and
export, but leave unrelated debt alone. Preserve validation and failure behavior.
When a requirement changes, update its tests and say what changed; never weaken a
test merely to obtain a pass.

For deletion, remove the directly related active path, callers, configuration,
exports, tests, and documentation without deleting nearby functionality.

### 4. Verify and inspect

Run the narrowest existing check that exercises the behavior, widening only when
risk or failure justifies it. Inspect the final diff for duplicated rules, mixed
responsibilities, swallowed errors, unused abstraction, stale replaced paths,
and unrelated or generated changes.

For deletion, provider replacement, cross-module work, or a requested review,
read [references/change-review.md](references/change-review.md).

## Truth and stopping

- **Passed** means the named command ran successfully on the relevant path.
- **Failed** means it ran and failed; include the important failure.
- **Not run** means it was unavailable, blocked, or not executed; say why.

Do not turn a static read into a test pass. Attempt at most two focused repair
rounds for the same failing check, then preserve the evidence and report the
remaining failure. Stop before an unapproved destructive action, publication,
secret access, or material product choice.

## Report

Usually report only what changed, why it belongs there, exact checks that passed,
failed, or were not run, and any remaining limitation. A review finding needs a
code location, concrete consequence, and smallest correction; mark uncertainty
when evidence is incomplete.

