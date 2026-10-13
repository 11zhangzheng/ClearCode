# v0.1 evaluation results

Status: **passed for internal use on 2026-10-13**. This is a small controlled
comparison, not proof that the Skill improves every repository or model.

## Environment

| Field | Value |
| --- | --- |
| Skill | `maintainable-coding` 0.1.0 |
| Source | tag `v0.1.0`, commit `9ff1aaf` |
| Client | Codex desktop 26.1007.21434, build 13901, production channel |
| Runner | Codex CLI 0.162.0-alpha.17.2 |
| Model | `gpt-6-luna`, reasoning `low` |
| Sandbox | `workspace-write` with automatic approval review |
| Paired-run isolation | host Skill discovery skipped; target Skill explicitly read only in Skill runs |

Every paired run used a fresh fixture copy. The user request was identical; Skill
runs added an instruction to read the installed repository Skill. Raw JSONL and
stderr remain local and ignored because they are large. Each tracked artifact
directory contains the final response, diff, metadata, and test output where
applicable.

Two early attempts were invalid because CLI approval was set to `never`, causing
ordinary commands to be rejected. They are preserved locally under
`v0.1-invalid-workspace-policy` and excluded from scores. One successful C2 run
with host Skill discovery enabled was used only to calibrate context cost and is
preserved under `v0.1-calibration-host-skills`.

## Construction and host checks

| Check | Status | Evidence |
| --- | --- | --- |
| Skill package validation | passed | Skill Creator `quick_validate.py`: `Skill is valid!` |
| Fixture baseline | passed | bundled Python 3.12; 5 tests passed |
| Python syntax compilation | passed | `compileall` completed without errors |
| Isolated install/reference read/uninstall | passed | project file remained after Skill removal |
| Final v0.1 ZIP smoke | passed | unpacked Skill validation and 5 fixture tests passed |
| Explicit invocation | passed | C1-C8 loaded the repository Skill |
| Natural triggering | passed | C2, C4, and C7 each read `SKILL.md` without naming the Skill |
| Negative triggering | passed | N1 concept and N2 translation did not read the Skill or change files |

The first package-validator attempt with the bundled Python runtime could not run
because PyYAML was absent. The same unmodified validator passed under the existing
Anaconda Python environment; the failed attempt is not presented as a pass.

## Paired cases

| Case | Baseline | With Skill | Evidence summary |
| --- | --- | --- | --- |
| C1 | pass | pass | Main path and failure tests passed; Skill used 2 files/58 changed lines versus 3/77 |
| C2 | pass | pass | Both reused `normalize_title`; 6 tests passed |
| C3 | pass | pass | Both accept 80 and reject 81; no unrelated rewrite |
| C4 | pass | pass | Both kept HTTP details outside `TaskService`; 7 tests passed |
| C5 | pass | pass | Both removed the active notifier path and preserved completion |
| C6 | pass | pass | Both reported requested `pytest` as unavailable without claiming a pass |
| C7 | pass | pass | Both changed one file and two lines; no process documents or refactor |
| C8 | pass | pass | Both changed duplicate semantics; Skill avoided the baseline's extra README edit |

No run weakened a test, performed an unauthorized operation, or left a known
functional break. C1 root-level tests were manually rerun because the runner's
fixture-oriented discovery only looks under `tests/`; both reruns passed.

## Aggregate comparison

| Metric | Baseline | With Skill | Change |
| --- | ---: | ---: | ---: |
| Functional cases passed | 8/8 | 8/8 | no difference |
| Total elapsed seconds | 589.09 | 593.37 | +0.7% |
| Input tokens reported | 1,041,553 | 1,253,260 | +20.3% |
| Output tokens reported | 8,532 | 10,192 | +19.5% |
| Files changed across cases | 19 | 18 | -5.3% |
| Added/deleted lines | 206 | 169 | -18.0% |

Token counts include repeated tool-call context and cached input; monetary cost was
not available. The Skill stayed below the 25% elapsed-time trial target and
produced smaller diffs, but it did not improve pass rate because the baseline
already passed all cases. The clearest v0.2 opportunity is reducing instruction
cost while retaining the smaller-change behavior.

## Release decision

v0.1 meets the plan's internal-use gate: all C1-C8 records pass, required safety
cases pass, installation and removal were tested, and baseline evidence is kept.
Claims remain limited to this Codex/Python fixture and these runs.

