# Changelog

## 0.2.0 — 2026-10-13

- Reduced the core Skill from 136 lines/6,043 bytes to 82 lines/3,658 bytes by
  removing generic guidance already handled reliably by the base agent.
- Preserved proportional depth, targeted reuse, provider boundaries, deletion
  cleanup, truthful verification, and two-round stopping behavior.
- Added a replayable PowerShell evaluation runner with isolated fixtures, JSONL
  capture, final responses, diffs, test output, timing, and usage metadata.
- Completed all eight v0.1 paired cases, natural/negative trigger checks, five
  v0.2 regression cases, and a six-change continuous project pilot.
- Recorded the evidence-based v0.3 decision: no deterministic product checker is
  justified because no rule was missed in two independent tasks.

Rationale: retain the smaller-change behavior observed in v0.1 while reducing
instruction cost. The evaluation runner remains development infrastructure and is
not installed with the Skill.

## 0.1.0 — 2026-10-12

- Added the four-step maintainable coding workflow with proportional risk depth.
- Added explicit authorization, truthful verification, and two-repair-round stop
  rules to prevent overreach and false success reports.
- Split new-project and deeper change-review guidance into on-demand references.
- Added three short examples for reuse, minimal design, and failed verification.
- Added eight fixed evaluation cases, isolated agent prompts, and a small Python
  task-service fixture with dependency-free baseline tests.
- Added project-scoped installation, update, validation, and uninstall guidance.

Rationale: this first version implements only the behaviors and evidence required
by the delivery plan. It intentionally adds no CLI, CI hook, background agent,
multi-agent workflow, or general dependency analyzer.

