Updated duplicate-title checking in `repository.py` to compare case-folded titles, and updated the focused test so `Review` and `review` are rejected as duplicates. Existing title normalization and validation remain unchanged.

**Checks passed:** `python -m unittest discover -s tests -v` (5 tests); `git diff --check`. No commit was made.