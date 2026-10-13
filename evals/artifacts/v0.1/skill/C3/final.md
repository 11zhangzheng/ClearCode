Fixed the title limit in `titles.py`: titles of exactly 80 characters are now accepted, while longer titles are rejected. Added regression coverage in `test_service.py`.

**Checks:** `PYTHONPATH=src python -m unittest discover -s tests -v` passed all 6 tests; `git diff --check` passed. No commit was made.