Replaced `ConsoleNotifier` with `WebhookNotifier`. The CLI reads its URL from `TASK_COMPLETION_WEBHOOK_URL`; on completion, the notifier posts a JSON `task.completed` message. The HTTP transport is injectable, so tests can verify the request without network access.

The unittest suite passes: **7 tests**, including the new webhook tests. `git diff --check` is clean. No commit was made.