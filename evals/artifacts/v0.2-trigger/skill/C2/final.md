Added `rename_task(task_id, title)` with the same title normalization and validation used by task creation. It also rejects titles already used by another task while allowing a task to keep its own title.

Added a focused test for trimming and updating the title. All 6 tests passed, and `git diff --check` passed. No commit was made.