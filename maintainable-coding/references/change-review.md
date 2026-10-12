# Incremental change and review

Read this reference for medium- or high-risk changes, deletion, provider
replacement, or an explicit maintainability review.

## Trace the change surface

Begin at the requested behavior and trace only its relevant path:

1. entry point and public interface;
2. owning implementation and shared business rules;
3. direct and indirect callers found by search;
4. tests, fixtures, configuration, exports, and user-facing documentation.

For a bug, reproduce the failing behavior when practical before editing. Fix the
shared cause once rather than patching each symptom.

## Replacement and deletion

For provider replacement, keep provider-specific construction and translation at
the adapter or composition boundary. Business code should retain the repository's
existing domain-facing contract unless the requirement changes that contract.

For deletion, search both the symbol name and the user-visible behavior. Confirm
that no active route, scheduled task, configuration flag, export, or test still
invokes the old path. Remove only artifacts owned by that feature.

## Evidence-based findings

A review finding must identify a concrete path to harm: inconsistent behavior,
change amplification, stale execution, data loss, hidden failure, or a verified
maintenance burden. Include the location, consequence, and smallest correction.

Do not report style preferences as defects, demand speculative abstractions, or
recommend broad refactoring without a demonstrated effect on the requested
change.

## Diff and validation

Inspect the final diff rather than relying on memory. Run focused tests first and
broader checks only when the changed boundary warrants them. Report each command
as passed, failed, or not run. After two unsuccessful focused repair rounds for
the same failure, stop and preserve the evidence.

