Implemented the in-memory task service in `task_service.py`. Callers can create and retrieve tasks, mark them done, and receive a callback once on completion.

Added a runnable check in `test_task_service.py`, covering the main path and basic errors.

**Check passed:** `python -m unittest -v` (3 tests).