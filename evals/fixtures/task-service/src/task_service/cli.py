from .notifications import ConsoleNotifier
from .repository import InMemoryTaskRepository
from .service import TaskService


def main() -> None:
    service = TaskService(InMemoryTaskRepository(), ConsoleNotifier())
    title = input("Title: ")
    service.create_task(title)
    print("Task created")


if __name__ == "__main__":
    main()

