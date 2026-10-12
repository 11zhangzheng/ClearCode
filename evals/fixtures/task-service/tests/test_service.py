import unittest

from task_service.repository import InMemoryTaskRepository
from task_service.service import TaskService


class RecordingNotifier:
    def __init__(self) -> None:
        self.completed_ids: list[int] = []

    def task_completed(self, task) -> None:
        self.completed_ids.append(task.id)


class TaskServiceTests(unittest.TestCase):
    def setUp(self) -> None:
        self.repository = InMemoryTaskRepository()
        self.notifier = RecordingNotifier()
        self.service = TaskService(self.repository, self.notifier)

    def test_creates_normalized_task(self) -> None:
        task = self.service.create_task("  Write tests  ")
        self.assertEqual("Write tests", task.title)

    def test_rejects_empty_title(self) -> None:
        with self.assertRaises(ValueError):
            self.service.create_task("   ")

    def test_rejects_duplicate_title_but_case_variants_are_currently_allowed(self) -> None:
        self.service.create_task("Review")
        with self.assertRaises(ValueError):
            self.service.create_task("Review")
        self.service.create_task("review")

    def test_completes_and_notifies(self) -> None:
        task = self.service.create_task("Ship")
        completed = self.service.complete_task(task.id)
        self.assertTrue(completed.done)
        self.assertEqual([task.id], self.notifier.completed_ids)

    def test_rejects_unknown_task(self) -> None:
        with self.assertRaises(LookupError):
            self.service.complete_task(999)


if __name__ == "__main__":
    unittest.main()

