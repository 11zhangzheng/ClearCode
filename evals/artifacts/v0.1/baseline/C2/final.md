Added `TaskService.rename_task(task_id, title)`. It reuses creation-time title normalization and validation, rejects duplicate titles, and updates the existing task. Added a focused test for trimming and renaming.

All 6 tests pass with `PYTHONPATH=src python -m unittest discover -s tests -v`.