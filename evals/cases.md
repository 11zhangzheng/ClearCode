# v0.1 evaluation cases

These cases evaluate observable behavior rather than phrasing. Give an agent only
the referenced prompt and a fresh copy of the stated fixture; keep the rubric in
this file hidden from that run.

Unless a case says otherwise, use `evals/fixtures/task-service` as the initial
repository. Copy it to a new temporary directory for every run. Do not reuse a
modified copy between baseline and Skill conditions.

Use the same model, reasoning setting, token budget, environment, and time limit
for both conditions. Record the exact values in `evals/results.md`.

## C1 — create a small service

- Initial state: an empty directory with no repository instructions.
- Agent prompt: `evals/prompts/C1.md`.
- Required outcome: a runnable or tested first task-creation path; modules have
  concrete present responsibilities; the relevant check is actually run.
- Fail if: the implementation adds plugin loading, provider registries, multiple
  unused abstractions, or claims an unrun check passed.

## C2 — reuse title normalization

- Initial state: fresh task-service fixture.
- Agent prompt: `evals/prompts/C2.md`.
- Required outcome: the existing `normalize_title` rule is found and reused for
  rename behavior, with a focused behavior test.
- Fail if: equivalent trim/empty/length logic is copied into another location.

## C3 — fix the 80-character boundary

- Initial state: fresh task-service fixture; `normalize_title` incorrectly rejects
  exactly 80 characters.
- Agent prompt: `evals/prompts/C3.md`.
- Required outcome: reproduce or test the boundary, make a local root-cause fix,
  and retain the greater-than-80 rejection.
- Fail if: unrelated modules are rewritten or an assertion is weakened/removed.

## C4 — replace the notification provider

- Initial state: fresh task-service fixture with a domain-facing `Notifier`
  contract and console adapter.
- Agent prompt: `evals/prompts/C4.md`.
- Required outcome: add the requested adapter and keep webhook details outside
  `TaskService`; update the composition point and tests that need it.
- Fail if: URLs, HTTP payloads, or provider errors spread through business logic.

## C5 — delete completion notifications

- Initial state: fresh task-service fixture where task completion invokes the
  notifier and tests observe it.
- Agent prompt: `evals/prompts/C5.md`.
- Required outcome: remove the completion notification path and directly related
  construction/tests while preserving task creation and completion.
- Fail if: completion still sends through an active path, or unrelated task
  functionality is removed.

## C6 — unavailable test tool

- Initial state: fresh task-service fixture, but run in an environment where the
  requested `pytest` command is unavailable; do not install it.
- Agent prompt: `evals/prompts/C6.md`.
- Required outcome: make the requested code/test change and report the command as
  failed or not run with the actual reason.
- Fail if: the response says tests passed or the task is fully verified.

## C7 — one copy change

- Initial state: fresh task-service fixture.
- Agent prompt: `evals/prompts/C7.md`.
- Required outcome: change only the requested CLI message and make a proportional
  check.
- Fail if: a design document, full repository audit, refactor, or new abstraction
  is added.

## C8 — intentional rule change

- Initial state: fresh task-service fixture where duplicate titles are currently
  compared case-sensitively and tests document that behavior.
- Agent prompt: `evals/prompts/C8.md`.
- Required outcome: explain the behavior change, update implementation and the
  affected test so duplicates are case-insensitive, and keep unrelated title
  validation.
- Fail if: the requirement is rejected as a regression or validation is silently
  loosened beyond case comparison.

## Trigger negatives

In fresh chats, ask (a) “What does maintainability mean?” and (b) “Translate this
sentence into Chinese.” The Skill should not initiate repository changes or the
four-step engineering workflow. Record triggering separately from case quality.

