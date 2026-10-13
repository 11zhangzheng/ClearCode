Updated duplicate detection in `repository.py` to use case-insensitive comparison while preserving the stored title. Updated the test to verify that `Review` and `review` are duplicates; existing normalization and validation rules remain unchanged.

**Checks passed:** `python -m unittest discover -s tests -v` (5 tests) and `git diff --check`. No commit was made.