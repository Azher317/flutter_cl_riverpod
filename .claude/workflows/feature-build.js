export const meta = {
  name: 'feature-build',
  description:
    'Build an approved plan: shared pieces first, then one developer per feature in its own git worktree, a reviewer and a tester for each, and a lead who joins everything and runs bin/gates.sh. Local branches only; never pushes or merges into main.',
  whenToUse:
    'Only when the owner asks for feature-build by name, after approving docs/plans/<phase>.md. args: { phase } | { phase, features: [names] } (a subset) | + maxFixRounds?, maxSignoffRounds?. One feature = the small team (build, review, test); several = the full team.',
  phases: [
    { title: 'Read plan', detail: 'the lead reads the approved plan and checks the checkout is clean', model: 'opus' },
    { title: 'Shared', detail: 'endpoints, route names and strings for every feature, one commit', model: 'sonnet' },
    { title: 'Develop', detail: 'one developer per feature, each in its own worktree', model: 'sonnet' },
    { title: 'Review', detail: 'one reviewer per feature, read only', model: 'sonnet' },
    { title: 'Test', detail: 'one tester per feature, in its own worktree', model: 'haiku' },
    { title: 'Sign-off', detail: 'the lead joins the features, wires the routes and runs bin/gates.sh', model: 'opus' },
  ],
};

// ---------- input ----------
const input = typeof args === 'string' ? { phase: args } : (args ?? {});
const PHASE = typeof input.phase === 'string' && /^[a-z0-9][a-z0-9-]*$/.test(input.phase) ? input.phase : null;
if (!PHASE) {
  throw new Error('feature-build: pass { phase: "phase-2" }. It builds docs/plans/<phase>.md, which the owner must have approved.');
}
const ONLY = Array.isArray(input.features) ? input.features : null;
const MAX_FIX_ROUNDS = input.maxFixRounds ?? 2;
const MAX_SIGNOFF_ROUNDS = input.maxSignoffRounds ?? 2;
const PLAN_PATH = `docs/plans/${PHASE}.md`;

const LEAD = { model: 'opus', effort: 'high' };
const SHARED_DEV = { model: 'sonnet', effort: 'medium' };
const DEV = { model: 'sonnet', effort: 'high', isolation: 'worktree' };
const REVIEWER = { model: 'sonnet', effort: 'high' };
const TESTER = { model: 'haiku', effort: 'medium', isolation: 'worktree' };

// The files every feature would otherwise touch. With several features, only
// the shared step and the lead's wiring commit may change them.
const HOTSPOTS = ['lib/core/network/endpoints.dart', 'lib/core/utils/constants/route_names.dart', 'lib/router/app_router.dart', 'lib/l10n/arb/', 'untranslated_messages.txt'];

// ---------- schemas ----------
const READ_SCHEMA = {
  type: 'object',
  properties: {
    ready: { type: 'boolean', description: 'false when the plan is missing, not approved, has an open question or conflict, or the checkout is not clean' },
    reason: { type: 'string', description: 'Why not ready, in one or two plain sentences; empty when ready' },
    baseBranch: { type: 'string', description: 'git branch --show-current' },
    baseSha: { type: 'string', description: 'git rev-parse HEAD (full sha)' },
    shared: {
      type: 'string',
      description: 'Every endpoint constant, RouteNames constant (+ signedInOnly) and ARB key with its texts from the plan\'s shared-pieces section, as the shared developer must add them',
    },
    features: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          name: { type: 'string', description: 'snake_case, as in the plan' },
          plan: { type: 'string', description: "That feature's whole section of the plan, verbatim, plus its rows from the shared-pieces tables" },
        },
        required: ['name', 'plan'],
      },
    },
  },
  required: ['ready', 'reason', 'baseBranch', 'baseSha', 'shared', 'features'],
};

const CHECKS = {
  type: 'array',
  items: {
    type: 'object',
    properties: {
      command: { type: 'string' },
      passed: { type: 'boolean' },
      output: { type: 'string', description: 'Failure excerpt, or a one-line pass summary with counts' },
    },
    required: ['command', 'passed', 'output'],
  },
};

const SHARED_SCHEMA = {
  type: 'object',
  properties: {
    status: { type: 'string', enum: ['done', 'failed'] },
    sha: { type: 'string', description: 'Full sha of the commit on the shared branch' },
    branch: { type: 'string' },
    checks: CHECKS,
    notes: { type: 'string' },
  },
  required: ['status', 'sha', 'branch', 'checks', 'notes'],
};

const DEV_SCHEMA = {
  type: 'object',
  properties: {
    status: { type: 'string', enum: ['done', 'blocked'] },
    sha: { type: 'string', description: 'Full sha of your last commit (git rev-parse HEAD)' },
    filesChanged: { type: 'array', items: { type: 'string' }, description: 'git diff --name-only <start>..HEAD' },
    checks: CHECKS,
    routeEntry: { type: 'string', description: 'The exact GoRoute(...) code the lead must add to lib/router/app_router.dart, with its imports. Empty when you added it yourself (single-feature build).' },
    notes: { type: 'string', description: 'Deviations from the plan, decisions, anything the reviewer must know' },
    blockers: { type: 'array', items: { type: 'string' } },
  },
  required: ['status', 'sha', 'filesChanged', 'checks', 'routeEntry', 'notes', 'blockers'],
};

const ISSUES = {
  type: 'array',
  items: {
    type: 'object',
    properties: {
      file: { type: 'string' },
      line: { type: 'number' },
      severity: { type: 'string', enum: ['blocker', 'major', 'minor'], description: 'blocker = broken or a check fails; major = breaks the plan, a rule or misses a required test or language; minor = polish' },
      problem: { type: 'string' },
      fix: { type: 'string' },
    },
    required: ['file', 'severity', 'problem', 'fix'],
  },
};

const REVIEW_SCHEMA = {
  type: 'object',
  properties: { summary: { type: 'string' }, issues: ISSUES },
  required: ['summary', 'issues'],
};

const TEST_SCHEMA = {
  type: 'object',
  properties: { passed: { type: 'boolean' }, summary: { type: 'string' }, checks: CHECKS, issues: ISSUES },
  required: ['passed', 'summary', 'checks', 'issues'],
};

const SIGNOFF_SCHEMA = {
  type: 'object',
  properties: {
    status: { type: 'string', enum: ['done', 'needs_fixes'] },
    checks: CHECKS,
    branches: { type: 'array', items: { type: 'string' }, description: 'Every branch this run leaves, in the order to review them' },
    fixes: {
      type: 'array',
      description: 'Only when needs_fixes: one entry per feature that must change',
      items: {
        type: 'object',
        properties: { feature: { type: 'string' }, instructions: { type: 'string', description: 'Concrete, naming the failing check or line' } },
        required: ['feature', 'instructions'],
      },
    },
    report: { type: 'string', description: 'Short and factual: what was built, test counts from real output, open review notes, screens to try on a phone in each language, light and dark' },
  },
  required: ['status', 'checks', 'branches', 'fixes', 'report'],
};

// ---------- prompts ----------
const NO_PUSH = `Never push, never merge into main or the starting branch, never open a PR. Never edit docs/api/, design/ or generated files (*.g.dart, *.freezed.dart, lib/core/l10n/generated/) by hand: change the source and run codegen.`;

function readPrompt() {
  return `You are the LEAD. Read the approved plan for this phase and check the checkout before anyone builds. Change nothing.

1. Read ${PLAN_PATH}. Not there → ready = false.
2. Approved? The owner approves in chat; the file's "Questions for the owner" section must have no unticked "- [ ]" item (a ticked "- [x]" item carries the owner's answer in its text). Any unticked question or "Conflict:" → ready = false, and list them in reason.
3. Run \`git status --porcelain --untracked-files=all\`. Any line except ${PLAN_PATH} itself and modified env/*.json files (each developer's local server settings, never part of a feature) → ready = false ("commit or stash these first: …"). The plan file may be uncommitted.
4. Run \`git branch --show-current\` and \`git rev-parse HEAD\`.
5. Extract the features${ONLY ? ` — ONLY these: ${ONLY.join(', ')}` : ''}: each feature's whole section verbatim, with its rows from the shared tables. Extract the shared pieces as one block of text for the shared developer.`;
}

function sharedPrompt(read, branch) {
  return `You are the SHARED DEVELOPER. You are the only agent writing in this checkout right now. Add the pieces every feature of ${PHASE} needs, in one commit, so the feature developers can start from it.

1. \`git switch -c ${branch} ${read.baseSha}\` (if it exists from an earlier run: \`git switch -C ${branch} ${read.baseSha}\`).
2. If ${PLAN_PATH} is not committed yet, \`git add ${PLAN_PATH}\` so it lands in this commit.
3. Add exactly these, nothing else:
${read.shared}

   - Endpoint constants in lib/core/network/endpoints.dart (clr-core-endpoint shape).
   - Route paths as RouteNames constants in lib/core/utils/constants/route_names.dart (and in signedInOnly when marked). Do NOT add GoRoute entries: the screens don't exist yet; the lead wires them at the end.
   - Every ARB key in every file under lib/l10n/arb/, with the plan's text for that language and @key blocks for placeholders (the add-string skill).
4. Run \`flutter pub get\` (regenerates the translations), \`bin/check_arch.sh\`, \`flutter analyze\`. All must pass.
5. \`git commit -m "${PHASE}: shared endpoints, routes and strings"\` and report the full sha.

${NO_PUSH}`;
}

function devPrompt(feature, startSha, single) {
  const owns = single
    ? `lib/features/${feature.name}/, test/features/${feature.name}/, and the shared files your plan names (${HOTSPOTS.join(', ')}). Add your own endpoint constants, RouteNames entries, GoRoute entry and ARB keys.`
    : `lib/features/${feature.name}/ and test/features/${feature.name}/ ONLY. Endpoints, RouteNames and ARB keys are already committed for you. Do NOT edit ${HOTSPOTS.join(', ')}: put the GoRoute code you need in routeEntry and the lead adds it. Anything else outside your folders → don't edit it; put it in blockers.`;
  return `You are the DEVELOPER for feature "${feature.name}" of ${PHASE}. You work alone in your own git worktree; other developers build other features in theirs at the same time.

Start:
1. \`git checkout --detach ${startSha}\` (your worktree may start elsewhere; this puts you on the right commit).
2. \`flutter pub get\`.

You own: ${owns}

THE PLAN (approved by the owner — follow it exactly, names included):
${feature.plan}

Build it with the add-feature skill (.claude/skills/add-feature/SKILL.md), its clr-* snippets and the auth slice as the reference shape. Write the tests .claude/rules/testing.md asks for, in test/features/${feature.name}/.

Before you finish, all of these must pass in your worktree:
- \`dart run build_runner build --delete-conflicting-outputs\`
- \`bin/check_arch.sh\`
- \`flutter analyze\`
- \`flutter test test/features/${feature.name}/\`

Then:
- \`git add -A && git commit -m "${PHASE}: ${feature.name}"\` (generated *.g.dart / *.freezed.dart files are committed in this repo; include them).
- \`git branch -f wip/${PHASE}/${feature.name} HEAD\`
- Report the full sha (\`git rev-parse HEAD\`) and \`git diff --name-only ${startSha}..HEAD\` as filesChanged.

If the plan is wrong or impossible (a missing endpoint, a widget that doesn't exist), don't invent: build what you can, set status "blocked" and say exactly what's missing.

${NO_PUSH}`;
}

function fixPrompt(feature, originSha, sha, feedback, single) {
  return `You are the DEVELOPER for feature "${feature.name}" of ${PHASE}, in your own git worktree. The reviewer, tester or lead asked for changes. Fix EVERY issue below, minor ones too.

Start: \`git checkout --detach ${sha}\`, then \`flutter pub get\`.

You own: ${single ? `lib/features/${feature.name}/, test/features/${feature.name}/ and the shared files your plan names` : `lib/features/${feature.name}/ and test/features/${feature.name}/ ONLY (put GoRoute changes in routeEntry)`}.

THE PLAN:
${feature.plan}

WHAT TO FIX — ${feedback.summary}
${feedback.issues.map((i, n) => `${n + 1}. [${i.severity}] ${i.file}${i.line ? `:${i.line}` : ''} — ${i.problem}\n   Fix: ${i.fix}`).join('\n')}

Then the same checks as before must pass (build_runner, bin/check_arch.sh, flutter analyze, flutter test test/features/${feature.name}/), then:
\`git add -A && git commit -m "${PHASE}: ${feature.name} fixes"\`, \`git branch -f wip/${PHASE}/${feature.name} HEAD\`, report the new full sha and \`git diff --name-only ${originSha}..HEAD\` as filesChanged (every file changed since the feature started). Repeat routeEntry in full if there is one.

${NO_PUSH}`;
}

function reviewPrompt(feature, startSha, dev, round, outside) {
  return `You are the REVIEWER for feature "${feature.name}" of ${PHASE} (round ${round}). READ ONLY: never edit, never switch branches, never commit. Use only \`git diff\`, \`git show\` and reading files.

The developer's work is commit ${dev.sha}, built on ${startSha}.
See it with: \`git diff ${startSha} ${dev.sha}\` and \`git show ${dev.sha}:<path>\`.

THE PLAN it had to follow:
${feature.plan}

Developer's report:
${JSON.stringify({ status: dev.status, notes: dev.notes, blockers: dev.blockers, checks: dev.checks, routeEntry: dev.routeEntry }, null, 2)}
${outside.length ? `\nFILES OUTSIDE ITS OWNERSHIP (each is a blocker unless the plan names it): ${outside.join(', ')}\n` : ''}
Check the diff against: the plan (every screen, name, field and string), .claude/CLAUDE.md layer rules 1 to 20, .claude/rules/ for the folders touched, the add-feature skill (the auth slice shape, snippets) and .claude/rules/testing.md. In particular: no user-visible literal (every string in every ARB), no hard-coded colour or spacing, shared widgets only, Either/Failure flow, provider names, loading / error / empty / success on every screen, tests present.

Severity: blocker = broken, wrong behaviour, a failing check or a file it must not touch; major = breaks the plan or a rule, or misses a required test or language; minor = polish. Report only real issues, each with a concrete fix. An empty issues list means approved.`;
}

function testPrompt(feature, dev, round) {
  return `You are the TESTER for feature "${feature.name}" of ${PHASE} (round ${round}), in your own git worktree. Report only — never edit or commit.

1. \`git checkout --detach ${dev.sha}\`, then \`flutter pub get\`.
2. Run \`flutter test test/features/${feature.name}/\` and \`bin/check_arch.sh\`. Every test must pass.
3. Read the tests against .claude/rules/testing.md: repository failure paths; each screen in loading, error (with retry), empty and success; one check in each language file the app ships; screens at the phone sizes (testAtScreenSizes); no skipped tests. A missing one is an issue.
4. Check every screen and string of the plan below is really covered.

THE PLAN:
${feature.plan}

Severity: blocker = a failing test or check; major = a required test, state or language missing; minor = test polish. passed = true only when there is no blocker or major.`;
}

function signoffPrompt(read, sharedBranch, done, round, single) {
  return `You are the LEAD at sign-off (round ${round}) for ${PHASE}. The developers have stopped; you are the only agent writing in this checkout.

Features and their final commits:
${done.map((d) => `- ${d.name}: ${d.sha} (review ${d.approved ? 'approved' : 'NOT approved'}, tests ${d.testsPassed ? 'passed' : 'NOT passed'})`).join('\n')}

Do this:
1. For each feature: \`git branch -f feat/${PHASE}-<name> <sha>\`.
2. \`git switch -C integrate/${PHASE} ${single ? read.baseSha : sharedBranch}\`, then \`git merge --no-ff feat/${PHASE}-<name>\` for each feature. A conflict → \`git merge --abort\`, and send a fix to the feature that should change.
${single ? '' : `3. Add every route to lib/router/app_router.dart from these entries, in one commit "${PHASE}: wire routes":
${done.map((d) => `--- ${d.name} ---\n${d.routeEntry || '(none)'}`).join('\n')}
`}${single ? '3' : '4'}. Run \`bin/gates.sh --force\`. Read the whole combined diff against the plan in ${PLAN_PATH}: wiring between features, every string in every language, nothing missing.
${single ? '4' : '5'}. Everything green and complete → status "done". Any failure or gap → "needs_fixes", one entry per feature with concrete instructions naming the failing check. A one-line mechanical fix in the wiring commit you may make yourself.
${single ? '5' : '6'}. Finally \`git switch ${read.baseBranch}\` so the checkout is back where it started.

branches = ${single ? '' : `${sharedBranch}, `}every feat/${PHASE}-<name>, integrate/${PHASE}.
${NO_PUSH}`;
}

// ---------- helpers ----------
function outsideOwnership(files, name, single) {
  const own = [`lib/features/${name}/`, `test/features/${name}/`];
  if (single) own.push(...HOTSPOTS);
  return (files ?? []).filter((f) => !own.some((o) => f === o || f.startsWith(o)) && f !== PLAN_PATH);
}

// originSha: the commit the feature was first built on (shared commit or base).
// fromSha: where this call starts — originSha for a new build, the feature's
// last commit for a sign-off fix.
async function buildFeature(feature, originSha, fromSha, single, firstFeedback) {
  let dev = firstFeedback
    ? await agent(fixPrompt(feature, originSha, fromSha, firstFeedback, single), { ...DEV, label: `dev:${feature.name} sign-off fix`, phase: 'Develop', schema: DEV_SCHEMA })
    : await agent(devPrompt(feature, originSha, single), { ...DEV, label: `dev:${feature.name}`, phase: 'Develop', schema: DEV_SCHEMA });
  let review = null;
  let test = null;
  let lastBlocking = [];
  let approved = false;
  let testsPassed = false;
  let round = 1;

  while (dev && dev.sha) {
    const outside = outsideOwnership(dev.filesChanged, feature.name, single);
    review = await agent(reviewPrompt(feature, originSha, dev, round, outside), {
      ...REVIEWER,
      label: `review:${feature.name}#${round}`,
      phase: 'Review',
      schema: REVIEW_SCHEMA,
    });
    if (!review) break;
    let blocking = review.issues.filter((i) => i.severity !== 'minor');
    if (outside.length && !blocking.some((i) => outside.includes(i.file))) {
      blocking = [...blocking, ...outside.map((f) => ({ file: f, severity: 'blocker', problem: 'Changed a file outside this feature', fix: 'Revert it; if the feature really needs it, say so in blockers' }))];
    }
    let feedback = { summary: review.summary, issues: [...blocking, ...review.issues.filter((i) => i.severity === 'minor')] };
    approved = blocking.length === 0;

    if (approved) {
      test = await agent(testPrompt(feature, dev, round), { ...TESTER, label: `test:${feature.name}#${round}`, phase: 'Test', schema: TEST_SCHEMA });
      if (!test) break;
      blocking = test.issues.filter((i) => i.severity !== 'minor');
      testsPassed = test.passed && blocking.length === 0;
      if (testsPassed) break;
      if (blocking.length === 0) {
        blocking = [{ file: `test/features/${feature.name}/`, severity: 'blocker', problem: test.summary, fix: 'Make every test and check pass.' }];
      }
      feedback = { summary: `Tests failed: ${test.summary}`, issues: [...blocking, ...test.issues.filter((i) => i.severity === 'minor')] };
    }

    lastBlocking = blocking;
    if (round > MAX_FIX_ROUNDS) {
      log(`${feature.name}: still ${blocking.length} blocking issue(s) after ${MAX_FIX_ROUNDS} fix round(s) — handing to the lead`);
      break;
    }
    log(`${feature.name}: ${approved ? 'tester' : 'reviewer'} asked for ${blocking.length} change(s), round ${round}`);
    const next = await agent(fixPrompt(feature, originSha, dev.sha, feedback, single), {
      ...DEV,
      label: `dev:${feature.name} fix#${round}`,
      phase: 'Develop',
      schema: DEV_SCHEMA,
    });
    if (!next || !next.sha) break;
    dev = { ...next, routeEntry: next.routeEntry || dev.routeEntry };
    round += 1;
  }

  return {
    name: feature.name,
    sha: dev?.sha ?? null,
    status: dev?.status ?? 'no-result',
    routeEntry: dev?.routeEntry ?? '',
    approved,
    testsPassed,
    rounds: round,
    blockers: dev?.blockers ?? [],
    // What still blocks it, including problems the workflow found itself (files outside the feature).
    openIssues: approved && testsPassed ? [...(review?.issues ?? []), ...(test?.issues ?? [])] : lastBlocking.length ? lastBlocking : [...(review?.issues ?? []), ...(test?.issues ?? [])],
  };
}

// ---------- run ----------
phase('Read plan');
const read = await agent(readPrompt(), { ...LEAD, label: 'lead:read-plan', phase: 'Read plan', schema: READ_SCHEMA });
if (!read) {
  throw new Error('feature-build: the lead could not read the plan');
}
if (!read.ready) {
  return { status: 'not-started', reason: read.reason };
}
let FEATURES = read.features;
if (ONLY) {
  const missing = ONLY.filter((n) => !FEATURES.some((f) => f.name === n));
  if (missing.length) {
    return { status: 'not-started', reason: `Not in ${PLAN_PATH}: ${missing.join(', ')}` };
  }
  FEATURES = FEATURES.filter((f) => ONLY.includes(f.name));
}
if (FEATURES.length === 0) {
  return { status: 'not-started', reason: `No features found in ${PLAN_PATH}` };
}
const SINGLE = FEATURES.length === 1;
log(`${SINGLE ? 'Small team' : 'Full team'}: ${FEATURES.map((f) => f.name).join(', ')} on top of ${read.baseBranch} (${read.baseSha.slice(0, 7)})`);

let startSha = read.baseSha;
const sharedBranch = `feat/${PHASE}-shared`;
if (!SINGLE) {
  phase('Shared');
  const shared = await agent(sharedPrompt(read, sharedBranch), { ...SHARED_DEV, label: 'shared', phase: 'Shared', schema: SHARED_SCHEMA });
  if (!shared || shared.status !== 'done' || !shared.sha) {
    return {
      status: 'stopped',
      reason: 'The shared step failed, so no feature was started.',
      checks: shared?.checks ?? [],
      notes: shared?.notes ?? '',
    };
  }
  startSha = shared.sha;
  log(`Shared pieces committed on ${sharedBranch} (${startSha.slice(0, 7)})`);
}

phase('Develop');
let results = (await pipeline(FEATURES, (f) => buildFeature(f, startSha, startSha, SINGLE, null))).map(
  (r, i) => r ?? { name: FEATURES[i].name, sha: null, status: 'no-result', routeEntry: '', approved: false, testsPassed: false, rounds: 0, blockers: [], openIssues: [] },
);

let signoff = null;
for (let round = 1; round <= MAX_SIGNOFF_ROUNDS; round += 1) {
  const done = results.filter((r) => r.sha);
  if (done.length === 0) {
    log('No feature produced a commit — nothing to sign off');
    break;
  }
  phase('Sign-off');
  signoff = await agent(signoffPrompt(read, sharedBranch, done, round, SINGLE), {
    ...LEAD,
    label: `lead:sign-off#${round}`,
    phase: 'Sign-off',
    schema: SIGNOFF_SCHEMA,
  });
  if (!signoff || signoff.status === 'done' || signoff.fixes.length === 0) break;
  if (round === MAX_SIGNOFF_ROUNDS) {
    log(`The lead still asks for ${signoff.fixes.length} fix(es) after ${MAX_SIGNOFF_ROUNDS} sign-off round(s) — returning to the main session`);
    break;
  }
  log(`The lead sent ${signoff.fixes.length} fix(es) back`);
  const toFix = signoff.fixes.filter((fx) => results.some((r) => r.name === fx.feature && r.sha));
  const fixed = await pipeline(toFix, (fx) => {
    const feature = FEATURES.find((f) => f.name === fx.feature);
    const current = results.find((r) => r.name === fx.feature);
    return buildFeature(feature, startSha, current.sha, SINGLE, { summary: 'Sign-off found problems', issues: [{ file: `lib/features/${fx.feature}/`, severity: 'blocker', problem: fx.instructions, fix: fx.instructions }] });
  });
  fixed.forEach((r, i) => {
    if (r && r.sha) {
      results = results.map((x) => (x.name === toFix[i].feature ? { ...r, routeEntry: r.routeEntry || x.routeEntry } : x));
    }
  });
}

// The lead's "done" is not enough: every feature must also be approved and tested.
const unfinished = results.filter((r) => !r.approved || !r.testsPassed).map((r) => r.name);
const status = !signoff ? 'no-signoff' : signoff.status !== 'done' ? signoff.status : unfinished.length ? 'done-with-open-issues' : 'done';
if (unfinished.length) {
  log(`Not approved or not tested: ${unfinished.join(', ')} — see openIssues`);
}

return {
  status,
  unfinished,
  phase: PHASE,
  startedFrom: `${read.baseBranch} @ ${read.baseSha.slice(0, 7)}`,
  branches: signoff?.branches ?? [],
  report: signoff?.report ?? '',
  checks: signoff?.checks ?? [],
  features: results.map((r) => ({
    name: r.name,
    status: r.status,
    approved: r.approved,
    testsPassed: r.testsPassed,
    rounds: r.rounds,
    blockers: r.blockers,
    openIssues: r.openIssues,
  })),
  next: 'Nothing was pushed. Review the branches, push the ones you want and open the PRs (shared first).',
};
