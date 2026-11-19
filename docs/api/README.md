# Backend contract

The backend's API docs, committed and dated: `YYYY-MM-DD-<name>.md` (or the
Swagger JSON). Keep one current file; when a new version arrives, replace it
and read only the diff (`git diff`) to see what changed.

- `drafts/<feature>.md`: an endpoint the app expects before the backend has
  built it (see "Fake data" in `.claude/rules/data-layer.md`). Deleted when the
  real endpoint arrives.

Agents don't edit the contract files unless asked; the backend owns them.
