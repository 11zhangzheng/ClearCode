Updated `titles.py` so titles of exactly 80 characters are accepted, and added regression tests for 80 and 81 characters in `test_service.py`.

`git diff --check` passed. I ran the requested `pytest -q`, but it could not start because `pytest` is unavailable. I did not install tools or substitute another test command.