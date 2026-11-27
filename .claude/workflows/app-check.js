export const meta = {
  name: 'app-check',
  description:
    'Read-only check of one or more Flutter apps against their rules: one reader per app and area, a second agent tries to disprove every serious finding, one report comes back in chat',
  whenToUse:
    'Only when the owner asks for app-check by name. args: a path | [paths] | { targets: [paths], areas?: [names], against?: "own" | "base", focus? }. Writes nothing.',
  phases: [
    { title: 'Read', detail: 'one read-only agent per app and area' },
    { title: 'Verify', detail: 'a second read-only agent tries to disprove each blocker and major finding' },
  ],
};

// ---------- input ----------
const input = Array.isArray(args) ? { targets: args } : typeof args === 'string' ? { targets: [args] } : (args ?? {});
const TARGETS = Array.isArray(input.targets) && input.targets.length ? input.targets : ['.'];
const AGAINST = input.against === 'base' ? 'base' : 'own';
const FOCUS = typeof input.focus === 'string' ? input.focus : '';

// Read-only by construction: this agent type only has Read, Grep and Glob.
const READER = { agentType: 'architecture-auditor', model: 'sonnet', effort: 'high' };
const VERIFIER = { agentType: 'architecture-auditor', model: 'sonnet', effort: 'medium' };

const AREAS = {
  layers: 'Layer rules 1 to 10, 14, 16, 19 and 20 of .claude/CLAUDE.md: imports between core, shared, features and router; domain purity; data sources, repositories, guard(), Failure, Either; usecase providers; the API envelope; guest data.',
  ui: 'Presentation: rules 11, 12, 17 and 18 (no string literals, no hard-coded colours, fonts or spacing, shared widgets only, AppLogger and AppHaptics only), plus .claude/rules/presentation.md, theming.md, motion-feedback.md and tablets.md when the app has them. Look for very large screen files (over 400 lines) too.',
  strings: 'Languages: every key present in every ARB file under lib/l10n/arb/, real translations (Arabic in Arabic, Kurdish in Sorani when the app ships Kurdish), placeholders declared, untranslated_messages.txt empty, no user-visible text outside the ARBs, RTL-safe layout (directional padding and icons).',
  tests: 'Tests: what .claude/rules/testing.md asks for when the app has it (otherwise the add-feature skill step 15): repository failure paths, screen states loading / error / empty / success, every shipped language, screen sizes. Name each feature with no or thin tests. Never run the tests; read them.',
  session: 'Session, networking and data: .claude/rules/session-networking.md, data-layer.md, observability.md and pagination.md when the app has them; keepAlive providers holding per-user data; requests made for guests; fake data left on a path a release build can reach.',
};
const AREA_NAMES = Array.isArray(input.areas) && input.areas.length ? input.areas.filter((a) => AREAS[a]) : Object.keys(AREAS);
if (AREA_NAMES.length === 0) {
  throw new Error(`app-check: unknown areas. Use any of: ${Object.keys(AREAS).join(', ')}`);
}

// ---------- schemas ----------
const FINDINGS_SCHEMA = {
  type: 'object',
  properties: {
    summary: { type: 'string', description: 'Two sentences: overall state of this area in this app' },
    findings: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          rule: { type: 'string', description: 'The rule broken, e.g. "rule 3" or "testing.md: screen states"' },
          file: { type: 'string', description: 'Path relative to the app root' },
          line: { type: 'number' },
          severity: {
            type: 'string',
            enum: ['blocker', 'major', 'minor'],
            description: 'blocker = wrong behaviour, crash, data leak or a broken checked rule; major = breaks a written rule or misses required tests; minor = polish',
          },
          problem: { type: 'string', description: 'One sentence, plain words' },
          evidence: { type: 'string', description: 'The exact line or import that shows it, quoted' },
          fix: { type: 'string', description: 'One concrete fix' },
        },
        required: ['rule', 'file', 'severity', 'problem', 'evidence', 'fix'],
      },
    },
  },
  required: ['summary', 'findings'],
};

const VERDICT_SCHEMA = {
  type: 'object',
  properties: {
    real: { type: 'boolean', description: 'true only if you read the cited file and the problem is there as described' },
    severity: { type: 'string', enum: ['blocker', 'major', 'minor'], description: 'The severity it really deserves' },
    reason: { type: 'string' },
  },
  required: ['real', 'severity', 'reason'],
};

// ---------- prompts ----------
function readPrompt(target, area) {
  const rulesNote =
    AGAINST === 'base'
      ? `Judge it against the BASE structure's rules: .claude/CLAUDE.md and .claude/rules/ in the current working directory. The app may be older than the base; a difference from the base is a finding only when the base rule exists for a reason that applies to this app.`
      : `Judge it against the app's OWN rules: ${target}/.claude/CLAUDE.md and ${target}/.claude/rules/ (fall back to the base's, in the current working directory, only when the app has none).`;
  return `You are checking the Flutter app at ${target} — READ ONLY. You cannot and must not change any file.

AREA: ${area}
${AREAS[area]}
${FOCUS ? `\nTHE OWNER ALSO ASKED YOU TO LOOK FOR: ${FOCUS}\n` : ''}
${rulesNote}

How:
- Map the folders with Glob first, then Grep for violations, then Read the lines you cite.
- Skip generated files: *.g.dart, *.freezed.dart, lib/core/l10n/generated/.
- Report only what you saw in the code, with the exact line as evidence. No guesses, no generic advice.
- If the area is clean, say so and return an empty findings list.
- At most 25 findings: the most serious first. If there are more, say how many more in the summary.

Paths in findings are relative to ${target}.`;
}

function verifyPrompt(target, f) {
  return `Another reviewer reported this finding in the Flutter app at ${target}. Try to DISPROVE it. READ ONLY.

Rule: ${f.rule}
File: ${f.file}${f.line ? `:${f.line}` : ''}
Severity claimed: ${f.severity}
Problem: ${f.problem}
Evidence quoted: ${f.evidence}

Open ${target}/${f.file} and read the cited lines and what calls them. Check the rule in ${target}/.claude/CLAUDE.md or .claude/rules/ (or the base's in the working directory).
real = false when the line isn't there, the rule doesn't say that, or the code is an allowed exception (e.g. a generated file, a test file, core infrastructure the rule exempts).
If it is real but less serious than claimed, return real = true with the lower severity.`;
}

// ---------- run ----------
const jobs = [];
for (const target of TARGETS) {
  for (const area of AREA_NAMES) {
    jobs.push({ target, area });
  }
}
log(`Checking ${TARGETS.length} app(s) × ${AREA_NAMES.length} area(s) = ${jobs.length} readers (against ${AGAINST} rules)`);

const results = await pipeline(
  jobs,
  (job) =>
    agent(readPrompt(job.target, job.area), {
      ...READER,
      label: `read:${job.target.split('/').pop() || job.target}:${job.area}`,
      phase: 'Read',
      schema: FINDINGS_SCHEMA,
    }),
  async (read, job) => {
    if (!read) {
      return { ...job, summary: 'The reader returned nothing.', findings: [], failed: true };
    }
    const serious = read.findings.filter((f) => f.severity !== 'minor');
    const minors = read.findings.filter((f) => f.severity === 'minor');
    const verdicts = await parallel(
      serious.map((f, i) => () =>
        agent(verifyPrompt(job.target, f), {
          ...VERIFIER,
          label: `verify:${job.target.split('/').pop() || job.target}:${job.area}#${i + 1}`,
          phase: 'Verify',
          schema: VERDICT_SCHEMA,
        }),
      ),
    );
    const kept = [];
    let dropped = 0;
    serious.forEach((f, i) => {
      const v = verdicts[i];
      if (!v) {
        kept.push({ ...f, unverified: true });
      } else if (v.real) {
        kept.push({ ...f, severity: v.severity });
      } else {
        dropped += 1;
      }
    });
    return { ...job, summary: read.summary, findings: [...kept, ...minors], dropped };
  },
);

// ---------- report (plain code, no agent) ----------
const ORDER = { blocker: 0, major: 1, minor: 2 };
// A job whose reader or verifier threw comes back null: count it, don't hide it.
const all = results.map((r, i) => r ?? { ...jobs[i], summary: 'Not checked: the agent failed.', findings: [], failed: true });
const seen = new Set();
const lines = [];
let totalDropped = 0;
let failedReaders = 0;

lines.push(`# App check`);
lines.push('');
lines.push(`Apps: ${TARGETS.join(', ')} · areas: ${AREA_NAMES.join(', ')} · rules: ${AGAINST}. Read only; nothing was changed.`);

for (const target of TARGETS) {
  const parts = all.filter((r) => r.target === target);
  const findings = [];
  for (const r of parts) {
    totalDropped += r.dropped ?? 0;
    if (r.failed) failedReaders += 1;
    for (const f of r.findings) {
      const key = `${target}|${f.file}|${f.line ?? ''}|${f.rule}`;
      if (seen.has(key)) continue;
      seen.add(key);
      findings.push({ ...f, area: r.area });
    }
  }
  findings.sort((a, b) => ORDER[a.severity] - ORDER[b.severity] || a.file.localeCompare(b.file));
  const count = (s) => findings.filter((f) => f.severity === s).length;

  lines.push('');
  lines.push(`## ${target}`);
  lines.push('');
  lines.push(`${count('blocker')} blocker · ${count('major')} major · ${count('minor')} minor`);
  for (const r of parts) {
    lines.push(`- **${r.area}:** ${r.summary}`);
  }
  if (findings.length) {
    lines.push('');
    lines.push('| Severity | Area | Where | Problem | Fix |');
    lines.push('| --- | --- | --- | --- | --- |');
    for (const f of findings) {
      const where = `\`${f.file}${f.line ? `:${f.line}` : ''}\``;
      const sev = f.unverified ? `${f.severity} (unverified)` : f.severity;
      const cell = (s) => String(s).replace(/\|/g, '\\|').replace(/\n/g, ' ');
      lines.push(`| ${sev} | ${f.area} | ${where} | ${cell(f.problem)} | ${cell(f.fix)} |`);
    }
  }
}

lines.push('');
lines.push(
  `${totalDropped} finding(s) were dropped because a second reader could not confirm them.` +
    (failedReaders ? ` ${failedReaders} reader(s) returned nothing; those areas were not checked.` : ''),
);

return { report: lines.join('\n'), results: all };
