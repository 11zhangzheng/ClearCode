Added `TaskService.rename_task(task_id, title)` in `service.py`. It uses the same title normalization and validation as task creation, rejects duplicate titles, and returns the renamed task.

Added a focused test for trimming and empty-title rejection in `test_service.py`.

Verification: all 6 tests passed with `PYTHONPATH=src python -m unittest discover -s tests -v`; `git diff --check` passed.