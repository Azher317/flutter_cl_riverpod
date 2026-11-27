export const meta = {
  name: 'feature-plan',
  description:
    'Plan a phase of features for the owner to read: split the request into features, one planner per feature (side by side), check the plans against each other, write docs/plans/<phase>.md. Writes no code.',
  whenToUse:
    'Only when the owner asks for feature-plan by name, usually for a phase with 3 or more features. args: { phase, request } (split by a dispatcher) | { phase, features: [{ name, brief }] } (already split). Optional: contract (path under docs/api/). Stops at the plan; feature-build runs only after the owner approves it.',
  phases: [
    { title: 'Dispatch', detail: 'split the request into features and name the shared pieces', model: 'sonnet' },
    { title: 'Plan', detail: 'one planner per feature, side by side', model: 'opus' },
    { title: 'Write', detail: 'cross-check the plans and write docs/plans/<phase>.md', model: 'haiku' },
  ],
};

// ---------- input ----------
const input = typeof args === 'string' ? { request: args } : (args ?? {});
const PHASE = typeof input.phase === 'string' && /^[a-z0-9][a-z0-9-]*$/.test(input.phase) ? input.phase : null;
if (!PHASE) {
  throw new Error('feature-plan: pass { phase: "phase-2", request: "..." } or { phase, features: [{ name, brief }] }. phase is kebab-case, it names docs/plans/<phase>.md');
}
let FEATURES = Array.isArray(input.features) ? input.features : [];
if (FEATURES.length === 0 && !input.request) {
  throw new Error('feature-plan: pass request (a sentence or a list) or features: [{ name, brief }]');
}
const CONTRACT = typeof input.contract === 'string' ? input.contract : 'docs/api/';
const PLAN_PATH = `docs/plans/${PHASE}.md`;

const DISPATCHER = { model: 'sonnet', effort: 'medium' };
const PLANNER = { model: 'opus', effort: 'high' };
const WRITER = { model: 'haiku', effort: 'low' };

// ---------- schemas ----------
const DISPATCH_SCHEMA = {
  type: 'object',
  properties: {
    features: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          name: { type: 'string', description: 'snake_case folder name under lib/features/, e.g. "wallet"' },
          brief: { type: 'string', description: 'Self-contained: what the user can do, the screens, the endpoints (method + path from the contract), what it must NOT do' },
        },
        required: ['name', 'brief'],
      },
    },
    notes: { type: 'string', description: 'Anything every planner must know: the shipped languages, guest mode or sign-in required, tablets, links between features' },
  },
  required: ['features', 'notes'],
};

const STRING_ITEM = {
  type: 'object',
  properties: {
    key: { type: 'string', description: 'camelCase ARB key, prefixed with the feature, e.g. walletEmptyTitle' },
    texts: {
      type: 'object',
      description: 'One entry per ARB file the app ships, keyed by language code (ar, en, and ku when present)',
      additionalProperties: { type: 'string' },
    },
    placeholders: { type: 'string', description: 'e.g. "amount: String", or empty' },
  },
  required: ['key', 'texts'],
};

const PLAN_SCHEMA = {
  type: 'object',
  properties: {
    feature: { type: 'string' },
    summary: { type: 'string', description: 'Two or three plain sentences: what the user gets' },
    backend: { type: 'string', enum: ['ready', 'not ready', 'unknown'], description: 'not ready → the fake data rule in data-layer.md applies' },
    screens: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          name: { type: 'string' },
          what: { type: 'string', description: 'What it shows and does, including loading, error, empty and success' },
          tablet: { type: 'string', description: 'How it looks on a tablet, or empty when the app has no tablets' },
        },
        required: ['name', 'what'],
      },
    },
    widgets: {
      type: 'object',
      properties: {
        reuse: { type: 'array', items: { type: 'string' } },
        improve: { type: 'array', items: { type: 'string' }, description: 'Shared widget + the parameter to add' },
        add: { type: 'array', items: { type: 'string' }, description: 'New shared widget + why no existing one fits' },
      },
      required: ['reuse', 'improve', 'add'],
    },
    endpoints: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          constName: { type: 'string', description: 'Endpoints.<name> in lib/core/network/endpoints.dart' },
          method: { type: 'string' },
          path: { type: 'string', description: 'Exactly as the contract writes it' },
          paged: { type: 'boolean' },
        },
        required: ['constName', 'method', 'path'],
      },
    },
    models: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          name: { type: 'string' },
          fields: { type: 'string', description: 'name: type pairs, JSON names exactly as the contract returns them, nullability marked' },
        },
        required: ['name', 'fields'],
      },
    },
    domain: { type: 'string', description: 'Entities, repository methods (with Either types), usecases and params, by name' },
    providers: { type: 'string', description: 'Every generated provider name (remember the generator drops a trailing Notifier)' },
    routes: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          constName: { type: 'string', description: 'RouteNames.<name>' },
          path: { type: 'string' },
          screen: { type: 'string' },
          signedInOnly: { type: 'boolean' },
        },
        required: ['constName', 'path', 'screen'],
      },
    },
    strings: { type: 'array', items: STRING_ITEM },
    tests: { type: 'array', items: { type: 'string' }, description: 'Test files under test/features/<feature>/ and what each covers' },
    questions: { type: 'array', items: { type: 'string' }, description: 'Things only the owner can decide. Never guess these.' },
  },
  required: ['feature', 'summary', 'backend', 'screens', 'widgets', 'endpoints', 'models', 'domain', 'providers', 'routes', 'strings', 'tests', 'questions'],
};

const WRITE_SCHEMA = {
  type: 'object',
  properties: {
    written: { type: 'boolean' },
    path: { type: 'string' },
    note: { type: 'string' },
  },
  required: ['written', 'path', 'note'],
};

// ---------- prompts ----------
function dispatchPrompt() {
  return `You are the DISPATCHER for a phase of a Flutter app built on this structure. Do not plan details and do not write code or files.

REQUEST:
${input.request}

Read only what you need: the backend contract in ${CONTRACT}, docs/PHASES.md if it exists, lib/l10n/arb/ (which languages ship), lib/features/ (what exists already) and docs/owner-preferences.md.

Split the request into FEATURES, one per backend resource or screen group (one folder under lib/features/ each). A feature that already exists in lib/features/ is not a new feature: say so in notes and leave it out (it needs add-endpoint, not this workflow). Don't over-split: a feature is a meaningful slice (a list + detail + form is one feature), not a single screen.`;
}

function planPrompt(f, notes) {
  return `You are the PLANNER for one feature of a Flutter app built on this structure. Plan it; do not write code or files.

FEATURE "${f.name}":
${f.brief}
${notes ? `\nNOTES FOR EVERY PLANNER:\n${notes}\n` : ''}
Other planners are planning the other features of this phase at the same time. Keep everything inside lib/features/${f.name}/ and test/features/${f.name}/, plus the shared entries you list (endpoints, routes, strings), which the build adds for everyone in one step.

Read first: the add-feature skill (.claude/skills/add-feature/SKILL.md), docs/guides/feature-brief.md, docs/guides/widgets.md, .claude/rules/feature-layout.md, data-layer.md, testing.md, the auth slice in lib/features/auth/ (the reference shape) and the contract in ${CONTRACT}.

Rules for the plan:
- backend: is every endpoint this feature needs in the contract? If not, "not ready", and list the missing ones in questions.
- Mirror the contract exactly: paths, JSON field names, nullability, paging. Never invent a field.
- Every name the developer will type is decided here: Endpoints.*, RouteNames.*, models, entities, usecases, provider names, ARB keys with the real text in EVERY language file under lib/l10n/arb/ (Arabic in Arabic; Kurdish in Sorani when the app ships it).
- Screens list loading, error (with retry), empty and success.
- Widgets: shared ones reused, improved (with the parameter) or added (with why none fits). No new public *Field/*Button/*Dialog/*Sheet/*Card inside the feature (rule 17).
- Tests follow .claude/rules/testing.md.
- questions: anything only the owner can decide (a UX choice outside docs/owner-preferences.md, a missing endpoint, a business rule). Never guess these.
- Keep it compact: names and fields, not code.`;
}

// ---------- plan markdown (plain code) ----------
function esc(s) {
  return String(s ?? '').replace(/\|/g, '\\|').replace(/\n/g, ' ');
}

function planMarkdown(plans, conflicts, notes) {
  const out = [];
  out.push(`# Plan: ${PHASE}`);
  out.push('');
  out.push(`Status: waiting for the owner. Edit anything below, answer the questions, then say "approved, run feature-build for ${PHASE}".`);
  out.push('');
  out.push(`Features: ${plans.map((p) => p.feature).join(', ')}.`);
  if (notes) {
    out.push('');
    out.push(`Notes: ${notes}`);
  }
  const open = plans.flatMap((p) => p.questions.map((q) => `${p.feature}: ${q}`));
  if (open.length || conflicts.length) {
    out.push('');
    out.push('## Questions for the owner');
    out.push('');
    for (const q of open) out.push(`- [ ] ${q}`);
    for (const c of conflicts) out.push(`- [ ] Conflict: ${c}`);
  }

  // Shared pieces: the only files two features would both touch. The build adds them in one step.
  out.push('');
  out.push('## Shared pieces (added once, before the features)');
  out.push('');
  out.push('| Feature | Kind | Name | Value |');
  out.push('| --- | --- | --- | --- |');
  for (const p of plans) {
    for (const e of p.endpoints) out.push(`| ${p.feature} | endpoint | Endpoints.${esc(e.constName)} | ${esc(e.method)} ${esc(e.path)}${e.paged ? ' (paged)' : ''} |`);
    for (const r of p.routes) out.push(`| ${p.feature} | route | RouteNames.${esc(r.constName)} | ${esc(r.path)} → ${esc(r.screen)}${r.signedInOnly ? ' (signed in only)' : ''} |`);
  }
  out.push('');
  out.push('Strings (every language file the app ships):');
  out.push('');
  const langs = [...new Set(plans.flatMap((p) => p.strings.flatMap((s) => Object.keys(s.texts))))].sort();
  out.push(`| Feature | Key | ${langs.join(' | ')} |`);
  out.push(`| --- | --- | ${langs.map(() => '---').join(' | ')} |`);
  for (const p of plans) {
    for (const s of p.strings) {
      const key = s.placeholders ? `${s.key} (${s.placeholders})` : s.key;
      out.push(`| ${p.feature} | ${esc(key)} | ${langs.map((l) => esc(s.texts[l] ?? 'MISSING')).join(' | ')} |`);
    }
  }

  for (const p of plans) {
    out.push('');
    out.push(`## Feature: ${p.feature}`);
    out.push('');
    out.push(p.summary);
    out.push('');
    out.push(`Backend: ${p.backend}.`);
    out.push('');
    out.push('Screens:');
    for (const s of p.screens) out.push(`- **${s.name}:** ${s.what}${s.tablet ? ` Tablet: ${s.tablet}` : ''}`);
    out.push('');
    out.push(`Widgets. Reuse: ${p.widgets.reuse.join(', ') || 'none'}. Improve: ${p.widgets.improve.join('; ') || 'none'}. Add: ${p.widgets.add.join('; ') || 'none'}.`);
    out.push('');
    out.push('Models:');
    for (const m of p.models) out.push(`- \`${m.name}\`: ${m.fields}`);
    out.push('');
    out.push(`Domain: ${p.domain}`);
    out.push('');
    out.push(`Providers: ${p.providers}`);
    out.push('');
    out.push('Tests:');
    for (const t of p.tests) out.push(`- ${t}`);
  }
  out.push('');
  return out.join('\n');
}

// Names two features both claim: they would collide in the shared files.
function findConflicts(plans) {
  const owners = new Map();
  const conflicts = [];
  const claim = (kind, name, feature) => {
    const key = `${kind}:${name}`;
    if (owners.has(key) && owners.get(key) !== feature) {
      conflicts.push(`${kind} "${name}" is planned by both ${owners.get(key)} and ${feature}`);
    }
    owners.set(key, feature);
  };
  for (const p of plans) {
    for (const e of p.endpoints) claim('Endpoints', e.constName, p.feature);
    for (const r of p.routes) {
      claim('RouteNames', r.constName, p.feature);
      claim('route path', r.path, p.feature);
    }
    for (const s of p.strings) claim('ARB key', s.key, p.feature);
  }
  return conflicts;
}

// Strings missing a language another string in the phase has.
function findMissingTexts(plans) {
  const langs = [...new Set(plans.flatMap((p) => p.strings.flatMap((s) => Object.keys(s.texts))))];
  const missing = [];
  for (const p of plans) {
    for (const s of p.strings) {
      for (const l of langs) {
        if (!s.texts[l] || !String(s.texts[l]).trim()) missing.push(`${p.feature}: ${s.key} has no ${l} text`);
      }
    }
  }
  return missing;
}

// ---------- run ----------
let NOTES = typeof input.notes === 'string' ? input.notes : '';

if (FEATURES.length === 0) {
  phase('Dispatch');
  const dispatch = await agent(dispatchPrompt(), { ...DISPATCHER, label: 'dispatcher', phase: 'Dispatch', schema: DISPATCH_SCHEMA });
  if (!dispatch || dispatch.features.length === 0) {
    throw new Error('feature-plan: the dispatcher found no new feature in the request. Name the features yourself with { features: [...] }.');
  }
  FEATURES = dispatch.features;
  NOTES = [NOTES, dispatch.notes].filter(Boolean).join('\n');
}

const badNames = FEATURES.filter((f) => !/^[a-z][a-z0-9_]*$/.test(f.name ?? ''));
if (badNames.length) {
  throw new Error(`feature-plan: feature names must be snake_case folder names: ${badNames.map((f) => JSON.stringify(f.name)).join(', ')}`);
}
const dupes = FEATURES.map((f) => f.name).filter((n, i, a) => a.indexOf(n) !== i);
if (dupes.length) {
  throw new Error(`feature-plan: the same feature is listed twice: ${[...new Set(dupes)].join(', ')}`);
}
log(`Planning ${FEATURES.length} feature(s): ${FEATURES.map((f) => f.name).join(', ')}`);

phase('Plan');
const planned = await pipeline(FEATURES, (f) =>
  agent(planPrompt(f, NOTES), { ...PLANNER, label: `plan:${f.name}`, phase: 'Plan', schema: PLAN_SCHEMA }),
);
const plans = [];
planned.forEach((p, i) => {
  if (p) {
    plans.push({ ...p, feature: FEATURES[i].name });
  } else {
    log(`${FEATURES[i].name}: the planner returned nothing — left out of the plan`);
  }
});
if (plans.length === 0) {
  throw new Error('feature-plan: no planner returned a plan');
}
const missingPlans = FEATURES.filter((f) => !plans.some((p) => p.feature === f.name)).map((f) => f.name);

const conflicts = [
  ...findConflicts(plans),
  ...findMissingTexts(plans),
  ...missingPlans.map((n) => `${n} has no plan (its planner failed); run feature-plan again for it`),
];
const markdown = planMarkdown(plans, conflicts, NOTES);

phase('Write');
const written = await agent(
  `Write the plan below to ${PLAN_PATH} with the Write tool, exactly as given, creating docs/plans/ if needed. Change nothing else, run nothing else. If ${PLAN_PATH} already exists, overwrite it (the owner asked for a new plan).

----- BEGIN FILE -----
${markdown}
----- END FILE -----`,
  { ...WRITER, label: 'write-plan', phase: 'Write', schema: WRITE_SCHEMA },
);

return {
  planPath: PLAN_PATH,
  written: Boolean(written && written.written),
  features: plans.map((p) => ({ name: p.feature, backend: p.backend, screens: p.screens.length, questions: p.questions.length })),
  conflicts,
  questions: plans.flatMap((p) => p.questions.map((q) => `${p.feature}: ${q}`)),
  // Fallback when the file could not be written: the main session shows this in chat.
  markdown: written && written.written ? undefined : markdown,
};
