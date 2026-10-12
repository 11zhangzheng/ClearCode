# Example: reuse an existing rule

Request: add task renaming to a service that already normalizes titles during
task creation.

Good behavior: search for title handling, call the existing normalization helper
from `rename_task`, and add a test showing create and rename use the same rule.

Avoid: copying trim and length checks into a second method. The copies can drift
when the title rule changes.

