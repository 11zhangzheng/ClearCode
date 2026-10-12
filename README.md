# maintainable-coding

`maintainable-coding` is an instruction-only Codex Skill for focused repository
changes: read the relevant path, reuse the right responsibility, implement only
what the request needs, and report verification honestly.

Version 0.1.0 is a build candidate. Its package structure and fixture can be
validated locally; behavioral case runs and fresh-session trigger tests remain
explicitly recorded as not run in `evals/results.md` until they are performed.

## Scope

The first supported target is Codex with small Python agent/backend repositories.
The guidance is language-neutral where practical, but no other host or repository
type is currently claimed as tested. The Skill does not provide permission or CI
enforcement, and it does not perform automatic whole-repository refactoring.

## Install for one repository

Current Codex guidance supports repository-scoped Skills under
`.codex/skills/<skill-name>/SKILL.md`. From the target repository root, copy the
complete directory:

```powershell
New-Item -ItemType Directory -Force .codex\skills | Out-Null
Copy-Item -Recurse -Force <path-to-this-repo>\maintainable-coding .codex\skills\maintainable-coding
```

Start a fresh Codex chat in that repository so discovery uses the installed copy.
Invoke it explicitly with:

```text
$maintainable-coding implement this repository change
```

The metadata also permits implicit selection for matching implementation, fix,
and review requests. Automatic selection is model- and context-dependent; prefer
explicit invocation when evaluating a particular version.

Official references used for this layout:

- https://developers.openai.com/plugins/concepts/skills
- https://developers.openai.com/blog/eval-skills

### Host smoke record

On 2026-10-12, the package was checked with Codex desktop 26.1007.21434 (build
13901, production channel). A copy at
`<isolated-repository>\.codex\skills\maintainable-coding` retained all required
references and metadata, and removing that directory preserved the repository's
`pyproject.toml`. Fresh-chat explicit and automatic invocation are still not run;
see `evals/results.md`.

## Update

Replace the installed `maintainable-coding` directory with the new complete
version, then start a fresh chat. Do not merge old and new reference files.

## Uninstall

Remove only `.codex/skills/maintainable-coding` from the target repository. This
does not require changing project source, tests, or other Codex instructions.

```powershell
Remove-Item -Recurse .codex\skills\maintainable-coding
```

Confirm the resolved path before removal if running the command outside the
repository root.

## Validate this source tree

Use the Skill Creator validator, then run the dependency-free fixture suite:

```powershell
python <codex-home>\skills\.system\skill-creator\scripts\quick_validate.py maintainable-coding
$env:PYTHONPATH = "evals\fixtures\task-service\src"
python -m unittest discover -s evals\fixtures\task-service\tests -v
```

The fixed prompts and hidden rubrics are in `evals/`. Follow `evals/cases.md` for
independent baseline-versus-Skill runs; do not treat package validation as evidence
that the Skill improves behavior.

## Package contents

- `maintainable-coding/`: installable Skill source and UI metadata;
- `evals/`: isolated prompts, rubric, fixed Python fixture, and result log;
- `CHANGELOG.md`: version history and reasons for rule changes.

