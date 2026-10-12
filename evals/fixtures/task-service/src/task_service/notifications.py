from typing import Protocol

from .domain import Task


class Notifier(Protocol):
    def task_completed(self, task: Task) -> None: ...


class ConsoleNotifier:
    def task_completed(self, task: Task) -> None:
        print(f"Task completed: {task.title}")

