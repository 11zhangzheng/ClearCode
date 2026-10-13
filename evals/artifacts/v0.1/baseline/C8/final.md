Task titles that differ only by letter case are now treated as duplicates using Unicode-aware `casefold()`. Existing whitespace normalization and title storage behavior are preserved.

Updated the duplicate tests and README. All 6 unit tests pass, and `git diff --check` passes. No commit was made.