# Sync source from the development workspace

This GitHub folder is a clean copy. If the C++ core is updated in the parent workspace, refresh it
with:

```powershell
.\sync-source.ps1
```

The script copies only source/build files and the public docs. It does **not** copy `build-*`,
`refs/`, internal planning notes, or the worklog.

Review `git status` after syncing before committing.

The first copy was taken on 2026-11-04. If Claude/DeepSeek is still editing the core, sync again
after it finishes.
