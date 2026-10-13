Updated `titles.py` to accept titles up to 80 characters, and added a regression test in `test_service.py` covering the 80- and 81-character boundaries.

`git diff --check` passed. `pytest -q` could not run because `pytest` is unavailable; I did not install tools or substitute another command. No commit was made.