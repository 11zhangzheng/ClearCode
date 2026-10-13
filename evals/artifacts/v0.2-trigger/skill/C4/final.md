Replaced `ConsoleNotifier` with `WebhookNotifier`. It sends a JSON `POST` containing the `task_completed` event and task ID/title. The CLI reads the required URL from `TASK_COMPLETION_WEBHOOK_URL`; `TaskService` still accepts an injected notifier, so service tests need no network.

Checks passed: `python -m unittest discover -s tests -v` (7 tests) and `git diff --check`. No commit was made.