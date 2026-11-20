# Connecting a new backend

Do this once, at the start of a project, before building any screen that
calls the server. The agent does it from the backend's API docs (Swagger or
their guide); the backend fills in nothing.

1. **Save the contract.** Put the backend's API docs in `docs/api/`, with the
   date in the file name (`docs/api/2026-11-19-mobile.md`). It is committed.
2. **Set the servers.** Fill `API_HOST` in `env/dev.json`, `env/uat.json` and
   `env/prod.json`. Leave a server you don't have yet as `*.invalid`: a build
   pointing at it stops at launch.
3. **Match the wrapper.** Rewrite the three functions in
   [api_envelope.dart](../../lib/core/network/api_envelope.dart) to match how
   this backend answers: where the payload sits on success, where the error
   text sits, and how a page of items looks. This is the only file that knows
   the backend's shape. Add a test for each with a real response copied from
   the docs.
4. **Check the base path.** `ApiDocument.baseUrl` is `$host/api/user`; change
   the path if this backend uses another.
5. **Check dates.** Look at one date in the docs. A date-time with no time
   zone is read as UTC; if the backend sends local time instead, say so in
   `nullable_date_time_convertor.dart`.
6. **Check sign-in.** Compare the login request and response with
   `features/auth`. The sign-in method for this app is decided in its first
   feature plan.

When the backend changes its shape later, only `api_envelope.dart` (and the
affected models) change.
