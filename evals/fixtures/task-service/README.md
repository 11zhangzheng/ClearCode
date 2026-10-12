# Task service evaluation fixture

This intentionally small Python repository is the fixed starting state for C2–C8.
It contains one deliberate title-length defect for C3/C6 and documents the current
case-sensitive duplicate rule for C8. Those are evaluation inputs, not accidental
unfinished production work.

Run the dependency-free baseline suite from this directory:

```powershell
$env:PYTHONPATH = "src"
python -m unittest discover -s tests -v
```

For a case run, copy this entire directory to a fresh temporary location. Do not
edit this source fixture and do not share a modified copy between runs.

