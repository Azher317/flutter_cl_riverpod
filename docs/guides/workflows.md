# Agent workflows

Three workflows in [.claude/workflows/](../../.claude/workflows/) let one
request run several Claude agents. They **never run by themselves**: only when
the owner asks for one by name. For one feature or one fix, a normal session
with the skills is faster and cheaper; use these for big phases and checks.

| Workflow | Writes | Use it for | Say |
|---|---|---|---|
| `app-check` | Nothing | Checking one or more apps against their rules, before a release or on old apps | "run app-check on this app" / "run app-check on ../nayeb and ../Basmah against base" |
| `feature-plan` | `docs/plans/<phase>.md` only | Planning a phase with 3 or more features | "run feature-plan for phase-2: wallet, transfers, history" |
| `feature-build` | Local branches only | Building a plan the owner approved | "approved, run feature-build for phase-2" |

## app-check

One read-only agent per app and area (layers, ui, strings, tests, session).
A second agent tries to disprove every blocker and major finding; what it
can't confirm is dropped. The report comes back in chat, grouped by app,
blockers first.

Options: `targets` (paths), `areas` (a subset), `against: 'base'` (judge an
older app by the base's rules instead of its own), `focus` (one extra thing to
look for).

## feature-plan

1. A dispatcher splits the request into features (skip it by naming them).
2. One planner per feature, side by side, following `add-feature` and
   `feature-brief.md`: backend ready or not, screens with their four states,
   widgets reused / improved / added, every endpoint, model field, provider,
   route and string (in every language) by name, tests, and questions.
3. Plain code checks the plans against each other (two features claiming the
   same route or key, a string missing a language) and writes
   `docs/plans/<phase>.md`.

It stops there. Read the plan, edit it, tick each question with your answer
(`- [x] … → yes, monthly`), then approve it.

## feature-build

Refuses to start if the plan has an unticked question or the checkout has
uncommitted changes.

- **One feature (the small team):** one developer, then a reviewer, then a
  tester, with up to 2 fix rounds, then the lead runs `bin/gates.sh`.
- **Several features (the full team):**
  1. One commit with every endpoint, route name and string, on
     `feat/<phase>-shared`.
  2. One developer per feature, each in **its own git worktree**, so no two
     agents write in the same checkout. Each owns only
     `lib/features/<name>/` and `test/features/<name>/`.
  3. A reviewer (read only) and a tester per feature; up to 2 fix rounds.
  4. The lead makes `feat/<phase>-<name>` for each feature, merges them into
     `integrate/<phase>`, adds the routes in one commit and runs
     `bin/gates.sh`.

Nothing is pushed. Review the branches, then push and open the PRs yourself,
the shared branch first. With several features the plan file is committed on
`feat/<phase>-shared`, so it is no longer in the starting branch's folder
afterwards; it travels with that PR.

## Cost

Roughly: app-check on 3 apps is 15 to 30 agents (5 areas each, plus checks);
feature-plan for 8 features about 10; feature-build for 6 features 20 to 30.
A normal session is 1.
