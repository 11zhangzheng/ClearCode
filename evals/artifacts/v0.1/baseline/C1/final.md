Implemented a small in-memory task service in `task_service.py`. It creates and stores titled tasks, marks them done, and notifies registered callbacks once on completion.

Added usage instructions in `README.md` and main-path checks in `test_task_service.py`.

Verification passed: `python -m unittest -v` (2 tests) and `git diff --check`. No commit made.