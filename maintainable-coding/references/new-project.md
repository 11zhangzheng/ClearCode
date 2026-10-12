# New project guidance

Read this reference only when starting a project or creating its first usable
path.

## Establish the first path

Infer or confirm only what is needed to build:

- the first user or caller;
- the input, core operation, and visible result;
- the completion check;
- any real external boundary such as storage or notifications.

If the request already answers these points, do not ask the user to restate them
in a template.

## Choose the minimum structure

Start with one executable path and separate modules only where responsibilities
or external boundaries are already different. For a small Python service, a
domain model, one application service, and concrete adapters are usually enough.
A protocol or interface is useful when the first implementation already crosses
an external boundary or tests need a safe substitute.

Do not create factories, registries, plugin loading, multi-level base classes, or
configuration layers for hypothetical future providers. Add them only after a
real caller or variation requires them.

## First verification

Provide one end-to-end check for the main path and focused checks for important
failure behavior. Prefer the project's normal test runner. If no runner exists,
use the language's standard test support before adding a dependency.

Record a design decision only when a future maintainer would otherwise be likely
to reverse it without seeing an important constraint. Empty architecture docs
are not a deliverable.

