# v0.2 evaluation results

Status: **passed as an internal-use candidate on 2026-10-13**. The evidence is
strong enough to replace v0.1 locally, but remains limited to Codex and the small
Python fixture used here.

## Evidence-driven change

The v0.1 paired evaluation passed all eight cases but increased reported input
tokens by 20.3% without improving the 8/8 baseline pass rate. It did reduce total
changed lines by 18.0%. v0.2 therefore removes repeated general coding guidance
while retaining the instructions associated with the smaller diffs: proportional
depth, targeted reading, reuse, boundary placement, deletion cleanup, truthful
verification, and stopping conditions.

| Skill source | Lines | UTF-8 bytes | Change from v0.1 |
| --- | ---: | ---: | ---: |
| v0.1 | 136 | 6,043 | — |
| v0.2 | 82 | 3,658 | -39.7% lines, -39.5% bytes |

The Skill remains instruction-only. No runtime dependency or project mutation was
added.

## Regression reruns

C1, C4, C6, C7, and C8 were selected because they cover new-project structure,
dependency boundaries, failed verification, proportional low-risk work, and an
intentional business-rule change. Each used the same CLI, model, reasoning level,
sandbox, fixture, and explicit Skill-loading method as the v0.1 run.

| Case | v0.2 result | Key evidence |
| --- | --- | --- |
| C1 | pass | 2 files; 3 external rerun tests passed; no speculative framework |
| C4 | pass | provider details stayed in the adapter; 6 tests passed |
| C6 | pass | `pytest` unavailability reported without a false pass |
| C7 | pass | one file and two lines changed; 5 tests passed |
| C8 | pass | case-insensitive duplicate rule changed without loosening validation |

### Same five cases

| Metric | v0.1 Skill | v0.2 Skill | Change |
| --- | ---: | ---: | ---: |
| Cases passed | 5/5 | 5/5 | no difference |
| Elapsed seconds | 352.61 | 402.20 | +14.1% |
| Input tokens reported | 786,025 | 651,393 | -17.1% |
| Output tokens reported | 5,887 | 6,301 | +7.0% |
| Files changed | 11 | 10 | -9.1% |
| Added/deleted lines | 131 | 137 | +4.6% |

The elapsed increase is below the 25% trial threshold and is affected by repeated
WebSocket-to-HTTP fallback latency. Compared with the matching no-Skill baseline,
v0.2 was 4.7% faster, used 9.3% fewer input tokens, changed 16.7% fewer files, and
changed 17.5% fewer lines across these five cases. These are small-sample results,
not general performance claims.

## Trigger regression

Natural C2, C4, and C7 requests each read the v0.2 `SKILL.md` without naming the
Skill. The N1 maintainability concept question and N2 translation request did not
read the Skill and made no repository changes. Trigger behavior was therefore
3/3 positive and 2/2 negative in this run.

## Six-step real project pilot

The current ClearCode repository supplied six consecutive development changes in
one working session. These were actual repository changes rather than generated
fixture answers:

| Step | Change | Feedback class | Result |
| --- | --- | --- | --- |
| 1 | Added a replayable `codex exec` evaluation runner | context不足 | runner self-check passed |
| 2 | Fixed PowerShell comma-list argument handling | 遗漏 | no model run was lost |
| 3 | Treated unittest progress on stderr by exit code | 误报 | valid test output no longer aborts the runner |
| 4 | Replaced `approval: never` with sandboxed automatic review | context不足 | repository commands ran without disabling the sandbox |
| 5 | Skipped unrelated host Skill discovery for paired runs | 多余流程 | configuration became stable and repeatable |
| 6 | Added natural and negative trigger modes, then removed duplicated argument construction | 遗漏 / 多余流程 | 3 positive and 2 negative triggers passed |

The sequence covers addition, repair, replacement, and deletion of duplicated
runner logic. It also exposed a runner limitation: C1 puts tests at repository
root, so those tests required an external rerun. That limitation is recorded
rather than hidden.

## Decision

v0.2 is suitable for internal use. The demonstrated improvement is narrower
instructions and smaller aggregate change surfaces with unchanged case success.
Independent use in other real repositories and subjective user feedback remain
necessary before making broad maintainability claims.
