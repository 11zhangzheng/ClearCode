from .domain import Task
from .notifications import Notifier
from .repository import InMemoryTaskRepository
from .titles import normalize_title


class TaskService:
    def __init__(self, repository: InMemoryTaskRepository, notifier: Notifier) -> None:
        self._repository = repository
        self._notifier = notifier

    def create_task(self, title: str) -> Task:
        normalized = normalize_title(title)
        if self._repository.title_exists(normalized):
            raise ValueError("task title already exists")
        return self._repository.add(normalized)

    def complete_task(self, task_id: int) -> Task:
        task = self._repository.get(task_id)
        task.done = True
        self._notifier.task_completed(task)
        return task

