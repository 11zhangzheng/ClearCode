---
name: maintainable-coding
description: Build, change, fix, or review code with focused reuse, clear responsibilities, minimal design, and honest verification. Use for repository implementation work; do not use for pure conceptual questions, translation, or text-only answers that do not change a project.
---

# Maintainable Coding

Make the smallest complete change that fits the repository and leaves evidence
that the requested behavior works. Preserve the user's scope and authority.

## Choose the depth

Classify the change before acting:

- **Low risk:** copy, local configuration, or a narrow fix. Read only the target
  and its closest check, then make the precise change.
- **Medium risk:** a module feature or business-rule change. Search for existing
  implementations and callers, state the chosen location briefly, and run a
  focused behavioral check.
- **High risk:** public interfaces, persistence formats, dependency boundaries,
  or changes spanning modules. Identify affected callers, compatibility or
  migration needs, and meaningful alternatives before implementation.

Risk controls depth, not whether work is allowed. Continue reversible work that
is already authorized. Ask only when an unresolved choice materially changes the
result or an unapproved irreversible action is required.

## Four-step workflow

### 1. Read the relevant context

Before editing:

1. Read repository instructions and the files named by the request.
2. Find the entry point, implementation, direct callers, tests, fixtures,
   configuration, and exports that the change can affect.
3. Search for the same business rule, helper, adapter, or pattern before adding
   another implementation.
4. Note pre-existing local changes and do not overwrite unrelated work.

Use targeted searches first. Do not audit the whole repository by default.

For a new project, first read [references/new-project.md](references/new-project.md).
Do not require the user to fill in a template when the request already establishes
the user, core path, and completion criteria.

### 2. Decide responsibility and reuse

Place the change where the repository already owns that responsibility.

- Reuse a fitting existing implementation instead of copying its rule.
- Keep provider, framework, storage, and transport details at their existing
  boundary; do not spread them through business code.
- Prefer the repository's current style and installed dependencies.
- Add an abstraction only when the current request needs a real variation point
  or the repository already uses that abstraction.
- If an existing boundary cannot support the request cleanly, explain the
  concrete pressure and make the smallest boundary adjustment that resolves it.

Do not freeze an unsuitable architecture merely because it already exists.

### 3. Implement the necessary change

Change every directly affected caller, test, fixture, configuration entry, and
export, but do not repair unrelated technical debt.

- Preserve validation at trust boundaries and error handling that prevents data
  loss or misleading success.
- Keep moved or consolidated behavior's validation and failure semantics.
- Update tests when requirements genuinely change; state which expectation
  changed. Never weaken or delete a test merely to obtain a pass.
- Avoid unused factories, registries, plugin systems, base classes, toggles, and
  extension points.
- For deletion, search for and remove the directly related active path, callers,
  configuration, exports, tests, and documentation. Do not delete nearby features.

### 4. Verify behavior and review the diff

Run the narrowest existing check that exercises the changed behavior, then widen
only when risk or failures justify it. Prefer repository commands over inventing
new tooling.

After verification, inspect the actual diff for:

- duplicated business rules introduced by this change;
- mixed responsibilities or provider details crossing a boundary;
- swallowed errors or success reported after failure;
- abstractions with no current caller or variation;
- replaced behavior that remains active through another path;
- accidental unrelated edits, secrets, caches, or generated artifacts.

For deeper incremental review, deletion, replacement, or cross-module work, read
[references/change-review.md](references/change-review.md).

When reporting a maintenance finding, include:

1. the file and precise code location;
2. the concrete behavior or maintenance consequence;
3. the smallest reasonable correction.

Mark uncertainty when evidence is incomplete. Do not infer a defect from naming
alone.

## Verification truthfulness

Keep these states distinct:

- **Passed:** the named command ran successfully and exercised the relevant path.
- **Failed:** the command ran and failed; include the important failure.
- **Not run:** the command was unavailable, blocked, too broad for the authorized
  scope, or not executed; say why.

Do not claim the task is fully verified when its relevant check did not run. A
static read is not a test pass.

## Stop conditions

- Automatically attempt at most two focused repair rounds for the same failing
  check. If it still fails, stop changing code, preserve the evidence, and report
  the remaining failure and likely cause.
- This limit applies to repeated automatic repair of one problem, not to ordinary
  implementation steps or distinct failures.
- Stop before an unapproved destructive operation, external publication, secret
  access, or a material product choice that the user has not made.

## Final report

Usually report only:

- what changed and why it belongs there;
- the exact checks that passed, failed, or were not run;
- any remaining limitation or follow-up the user must decide.

Do not produce a design document or repository health report unless it was
requested or the change is high risk and the information is needed to proceed.

