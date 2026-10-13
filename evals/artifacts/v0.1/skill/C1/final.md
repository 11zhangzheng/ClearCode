Implemented the in-memory task service in `task_service.py`. Callers can create titled tasks, mark them done, and read completion notifications. Empty titles are rejected, and completing a task repeatedly records only one notification.

Added a main-path check and focused behavior checks in `test_task_service.py`.

**Checks passed:** `python -m unittest -v` (3 tests); `git diff --check`. No commit was made.