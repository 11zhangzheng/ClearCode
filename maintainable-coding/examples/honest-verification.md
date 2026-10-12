# Example: report a verification failure

Request: fix an edge case, but the repository's test command cannot start because
the test runner is missing.

Good report:

> Changed the boundary comparison and added the focused regression test.
> `pytest tests/test_titles.py` was not run because `pytest` is not installed in
> this environment. I did not claim the regression passed.

Avoid: “All tests pass” based only on reading the code, or deleting the failing
test command from documentation.

