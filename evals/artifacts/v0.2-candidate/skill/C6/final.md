Fixed the title limit in `titles.py`: titles of exactly 80 characters are now accepted; longer titles are rejected. Added a regression test covering both boundaries in `test_service.py`.

`git diff --check` passed. `pytest -q` did not run because `pytest` is unavailable in the environment; I did not install tools or change the command.