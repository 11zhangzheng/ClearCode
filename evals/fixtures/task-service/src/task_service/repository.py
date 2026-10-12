from .domain import Task


class InMemoryTaskRepository:
    def __init__(self) -> None:
        self._tasks: dict[int, Task] = {}
        self._next_id = 1

    def add(self, title: str) -> Task:
        task = Task(self._next_id, title)
        self._tasks[task.id] = task
        self._next_id += 1
        return task

    def get(self, task_id: int) -> Task:
        try:
            return self._tasks[task_id]
        except KeyError as error:
            raise LookupError(f"task {task_id} not found") from error

    def title_exists(self, title: str) -> bool:
        return any(task.title == title for task in self._tasks.values())

