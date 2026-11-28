# Mapple Guarantee Return Flow — Implementation Plan

Status: draft for review
Source brief: `.opencode/examples/mapple-returns/guarantee-agent-spec.md`

## 1. Goal

Build a small, deterministic multi-agent flow that processes written guarantee
return requests for the fictional company **Mapple**:

1. **Intake agent** extracts and validates the request.
2. **Guarantee agent** applies a fixed policy and decides accept/reject.
3. **Output agent** writes the customer reply and final status.

The first iteration must run with plain OpenCode agent Markdown files. OpenCode is
the test bed: the agents exchange short, labeled Markdown reports instead of
JSON. The prompts, policy, catalog, and test cases should stay easy to carry
over to a later Quarkus Agentic implementation. Quarkus will define its own
typed contracts when that port happens; this plan does not pre-build them.

### In scope

- 3 worker agents + 1 OpenCode sequence runner.
- A fixed product catalog with 9 variations.
- 5 test cases built around Simpsons characters.
- Plain-text/Markdown handoffs between agents and human-readable result files.

### Out of scope for the first run

- Fraud detection, shipping labels, refunds, RMA tracking.
- Persistence, authentication, real customer data.
- Real legal advice.
- The Quarkus implementation itself.

## 2. Working assumptions

These are the defaults chosen because the brief leaves them open. They are easy
to change before implementation.

| Topic | Assumption |
| --- | --- |
| Agents | 3 workers plus a 4th **primary runner** (`mapple-returns`), because OpenCode has no built-in sequence agent. The runner calls the workers in a fixed order; Quarkus replaces it with a `SequenceAgent`. |
| Handoffs | Short labeled Markdown reports. No JSON, no schema. The runner passes each report along unchanged. |
| Language | Customer replies and test cases in English. A language convention can be added later. |
| 6–24 months | Accept production-related defects; reject clear incident damage and unclear causes. This mirrors the EU burden-of-proof idea without claiming to be legal advice. |
| 24-month rule | A purchase **older than 24 months** is rejected. Exactly 24 months is still inside the window. |
| Incident precedence | Clear incident/major damage is rejected even when the purchase is younger than 6 months. |
| Validation failure | The intake agent reports **all** problems at once, not just the first one. |
| Legal framing | The 6-month rule is a **Mapple business simplification**, not a quote of current EU law. Directive (EU) 2019/771 sets a 2-year minimum guarantee; the burden-of-proof period is 1 year (2 years in some member states). |
| File locations | Plan and spec in `.opencode/examples/mapple-returns/`, agents in `.opencode/agents/`, test assets and run reports in `.opencode/examples/mapple-returns/`. |

## 3. Architecture

### 3.1 Agents

| Agent | OpenCode mode | Responsibility | Tools |
| --- | --- | --- | --- |
| `mapple-returns` | primary | Runs the workers in a fixed sequence, passes text between them, writes the result report, prints a summary. | read, write, task |
| `mapple-intake` | subagent | Extracts fields and validates customer number, product, and purchase age. Returns a labeled report. | read |
| `mapple-guarantee` | subagent | Applies the guarantee policy to the intake report. Returns a labeled report. | none |
| `mapple-output` | subagent | Writes the polite customer reply and maps the decision to the final status. Returns a labeled report. | none |

The three workers are deliberately **pure text transformers**. The intake worker
reads the catalog file; the guarantee and output workers receive everything they
need in the prompt. None of them call other agents. Each returns a short report
with fixed labels. The runner passes each report to the next worker unchanged
and reads only the output labels (`Status:`, `Reason:`, `Customer:`, `Product:`)
when writing the result. Quarkus can later replace these reports with typed
objects if it needs to.

### 3.2 Sequence

```text
START -> INTAKE -> GUARANTEE -> OUTPUT -> END
```

The flow has no branches and skips nothing. When intake validation fails, the
guarantee worker returns `Decision: not applicable` and the output worker maps
that to `INFORMATION_MISSING`. This is exactly the shape a Quarkus
`SequenceAgent` needs.

### 3.3 Sequence rules

1. Read the case file given by the user.
2. Call `mapple-intake` with the raw request text.
3. Call `mapple-guarantee` with the intake report.
4. Call `mapple-output` with both the intake and guarantee reports.
5. Write `.opencode/examples/mapple-returns/results/<caseId>.md` and print a
   short summary.

The runner must never apply policy itself. It only passes data along.

## 4. Agent reports

Workers do not exchange JSON. Each returns a short plain-text report with a few
fixed labels. The labels are a naming convention, not a schema; they let each
worker and the final report reference the same fields without parsing a
document format.

### 4.1 Intake report

```text
Validation: passed
Issues: none
Customer number: C-100234
Customer name: Homer Simpson
Product: myphone 15 Pro Max (MP15PM-512-TIT)
Purchase age: 3 months
Damage: battery is bulging and the screen is lifting
Incident mentioned: no
```

Failure example:

```text
Validation: failed
Issues: MISSING_CUSTOMER_NUMBER, UNKNOWN_PRODUCT, MISSING_PURCHASE_AGE
Customer number: not provided
Customer name: Montgomery Burns
Product: MyPhone 16 Ultra (not in catalog)
Purchase age: not provided ("recently")
Damage: already defective, no details given
Incident mentioned: no
```

Intake rules:

- Customer number pattern: `C-` followed by six digits (tolerate spaces and a
  missing dash).
- Product must match the catalog file by display name, alias, or SKU.
  Category-only input is accepted only if it identifies exactly one variation;
  otherwise it is `UNKNOWN_PRODUCT`.
- Purchase age must be explicit ("3 months ago", "30 months ago") or derivable
  from an explicit purchase date. The agent must not invent an age.
- The agent extracts damage wording but does **not** decide whether it is an
  incident. `Incident mentioned` is only a hint for the guarantee agent.
- Report every problem in the single `Issues:` line, separated by commas.
- Never fabricate a customer number, SKU, or age. Use `not provided`.

### 4.2 Guarantee report

```text
Decision: accepted
Reason: PRODUCTION_DEFECT_EARLY
Explanation: Purchased 3 months ago; battery swelling is a production-related defect.
Policy: rule 4, production defect within the first 6 months
```

Reason codes:

| Code | Meaning |
| --- | --- |
| `OUT_OF_WARRANTY` | Purchase older than 24 months. |
| `INCIDENT_DAMAGE` | Clear accident, impact, liquid, crush, or misuse. |
| `PRODUCTION_DEFECT_EARLY` | Within 6 months and production-related damage. |
| `PRODUCTION_DEFECT_IN_WARRANTY` | 6–24 months and production-related damage. |
| `CAUSE_NOT_ESTABLISHED` | 6–24 months and cause is unclear or not attributable to production. |

### 4.3 Final report

The runner writes this report file to
`.opencode/examples/mapple-returns/results/<caseId>.md`:

```text
Status: ACCEPTED
Reason: PRODUCTION_DEFECT_EARLY
Customer: Homer Simpson
Product: myphone 15 Pro Max

Customer reply:
Dear Mr. Simpson,

Thank you for contacting Mapple. We have reviewed your request and accepted it.

Our support team will contact you shortly with the next steps.

Kind regards,
Mapple Customer Support
```

Customer-visible statuses:

| Status | Trigger |
| --- | --- |
| `INFORMATION_MISSING` | Intake could not validate; ask for the missing information. |
| `REJECTED` | Guarantee rejected; state the reason politely. |
| `ACCEPTED` | Guarantee accepted; explain next steps. |

The output agent must never contradict the guarantee decision. It may soften
wording, but not change status or reason code.

The final report is a readable artifact, not a contract for Quarkus. Quarkus
will define its own request and response model when it takes over.

## 5. Guarantee policy

Precedence order (first match wins):

1. **Validation failed** → no guarantee decision; output asks for the missing
   information.
2. **Age > 24 months** → `REJECTED / OUT_OF_WARRANTY`.
3. **Clear incident or major damage** → `REJECTED / INCIDENT_DAMAGE`.
4. **Age ≤ 6 months + production-related damage** → `ACCEPTED / PRODUCTION_DEFECT_EARLY`.
5. **6 < age ≤ 24 months + production-related damage** → `ACCEPTED / PRODUCTION_DEFECT_IN_WARRANTY`.
6. **6 < age ≤ 24 months + unclear cause** → `REJECTED / CAUSE_NOT_ESTABLISHED`.

Incident indicators:

- Dropped, fell, slipped, knocked over, sat on, stepped on.
- Cracked after impact, bent lid, crushed corner.
- Liquid or water damage.
- Unauthorized repair or modification.
- Cosmetic wear without functional defect.

Production-defect indicators:

- Battery swelling, bulging, dead, or rapid drain without impact.
- Pixel errors, green/pink lines, backlight failure, display lifting.
- Charging port failure without impact or liquid.
- Overheating or unexpected shutdowns without misuse.

If the text contains both, the guarantee agent explains which signal dominated
and why. Ambiguity is resolved conservatively in the 6–24 month window.

## 6. Product catalog (fixed, 9 variations)

| Category | Display name | Variant | SKU |
| --- | --- | --- | --- |
| myphone | myphone 15 | 128 GB, Black | `MP15-128-BLK` |
| myphone | myphone 15 Pro | 256 GB, Blue Titanium | `MP15P-256-BLU` |
| myphone | myphone 15 Pro Max | 512 GB, Natural Titanium | `MP15PM-512-TIT` |
| mapbook | mapbook 13 | M3, 256 GB, Silver | `MB13-M3-256-SLV` |
| mapbook | mapbook Pro 14 | M3 Pro, 512 GB, Space Gray | `MBP14-M3P-512-SPG` |
| mapbook | mapbook Pro 16 | M3 Max, 1 TB, Silver | `MBP16-M3M-1TB-SLV` |
| mapple watch | mapple Watch Series 9 | 41 mm, Aluminum, Midnight | `MW9-41-ALU-MID` |
| mapple watch | mapple Watch Series 9 | 45 mm, Aluminum, Starlight | `MW9-45-ALU-STL` |
| mapple watch | mapple Watch Ultra 2 | 49 mm, Titanium, Orange | `MWU2-49-TIT-ORG` |

The catalog table is the source of truth. The intake agent reads it with the
`read` tool from `.opencode/examples/mapple-returns/catalog/products.md`.

## 7. Test data (5 cases)

Each case is a Markdown file containing only the raw customer request. Expected
outcomes live in a separate `testdata/expected.md` table so the runner
never sees them.

### Case 1 — Homer Simpson (accepted)

- Character traits: cheerful, careless, a little chaotic.
- Product: myphone 15 Pro Max, 512 GB, Natural Titanium.
- Purchase age: 3 months.
- Request: battery bulging, screen lifting, explicitly denies dropping or
  liquid contact.
- Expected: `ACCEPTED`, `PRODUCTION_DEFECT_EARLY`.

### Case 2 — Bart Simpson (rejected, incident)

- Character traits: mischievous, admits the accident with a joke.
- Product: mapbook Pro 14, M3 Pro, 512 GB.
- Purchase age: 5 months.
- Request: skateboard accident, cracked screen, bent lid.
- Expected: `REJECTED`, `INCIDENT_DAMAGE` (incident wins over the 6-month
  production-defect window).

### Case 3 — Marge Simpson (accepted, 6–24 months)

- Character traits: conscientious, precise, offers receipt and photos.
- Product: mapple Watch Series 9, 41 mm, Aluminum, Midnight.
- Purchase age: 7 months.
- Request: green lines and pixel errors, never dropped.
- Expected: `ACCEPTED`, `PRODUCTION_DEFECT_IN_WARRANTY`.

### Case 4 — Lisa Simpson (rejected, out of warranty)

- Character traits: informed, polite, knows the two-year period has passed.
- Product: mapbook 13, M3, 256 GB.
- Purchase age: 30 months.
- Request: battery dies after 20 minutes; asks about goodwill.
- Expected: `REJECTED`, `OUT_OF_WARRANTY`.

### Case 5 — Montgomery Burns (validation failed)

- Character traits: imperious, impatient, refuses details.
- Customer number: missing.
- Product: "MyPhone 16 Ultra" — not in the catalog.
- Purchase age: "recently" — no number of months.
- Expected: `INFORMATION_MISSING`, issues
  `MISSING_CUSTOMER_NUMBER`, `UNKNOWN_PRODUCT`, `MISSING_PURCHASE_AGE`.
- Purpose: proves that the intake agent reports all problems at once and that
  the guarantee agent returns `Decision: not applicable`.

The full request texts will be written verbatim into the case files so the intake
agent has to extract the fields rather than read structured values.

## 8. File layout

```text
.opencode/
  agents/
    mapple-returns.md                # primary sequence runner
    mapple-intake.md                 # subagent
    mapple-guarantee.md              # subagent
    mapple-output.md                 # subagent
  commands/
    mapple-return.md                 # optional: run one case file
  examples/mapple-returns/
    README.md                        # how to run and what to expect
    guarantee-agent-spec.md          # original brief
    guarantee-agent-plan.md          # this plan
    catalog/
      products.md                    # 9 fixed variations
    testdata/
      expected.md                    # expected status and reason per case
      cases/
        case-01-homer.md
        case-02-bart.md
        case-03-marge.md
        case-04-lisa.md
        case-05-burns.md
    results/                         # one Markdown report per run
    run-cases.sh                     # optional phase-3 test loop
```

Generated run reports go to `.opencode/examples/mapple-returns/results/` for
now. Everything stays inside `.opencode` so the example is self-contained and
easy to try in OpenCode without adding top-level folders.

## 9. OpenCode implementation notes

- Agent files use simple V2 frontmatter: `description` and `mode` only. No custom
  permissions.
- The intake worker reads `.opencode/examples/mapple-returns/catalog/products.md`
  before validating. The guarantee and output workers only transform their
  prompt text.
- The runner invokes workers with OpenCode's `subagent` tool and
  `agent: mapple-intake`, etc., in a fixed order.
- Subagents return text, so there is no JSON parser. The runner passes each
  full report along unchanged.
- Run a case manually:
  `opencode run --agent mapple-returns --model openrouter/deepseek/deepseek-v4.1-flash-1017 --auto "Process .opencode/examples/mapple-returns/testdata/cases/case-01-homer.md"`
- The optional command `/mapple-return <case-file>` wraps the same call.
- Pin a model in the agent frontmatter once the flow works; until then use the
  session model. Use a model variant for determinism if needed, because V2 does
  not send per-agent `temperature`.

## 10. Quarkus portability

| OpenCode artifact | Quarkus / Agentic equivalent |
| --- | --- |
| Worker agent prompt (plain Markdown) | `src/main/resources/prompts/*.md`, loaded by a LangChain4j `@RegisterAiService` or agent definition. |
| `mapple-returns` runner prompt | Quarkus `SequenceAgent`; no routing logic and no extra prompt needed. |
| `subagent` tool calls | Direct method calls / workflow steps; deterministic Java code. |
| Product catalog Markdown | Classpath resource or database table behind a `ProductCatalog` repository. |
| `results/*.md` | Persisted report or audit record. |

Portability rules:

- Keep all policy text and catalog data in the worker prompts, not in the
  runner.
- Keep the report labels (`Validation:`, `Decision:`, `Status:`) stable. Quarkus
  can map them to typed fields or ignore them and use its own model.
- Reuse the prompts, policy, catalog, and test cases. Quarkus will define its own
  request/response types and sequence.
- Keep the runner prompt free of policy; it is the only OpenCode-specific file
  and will be replaced by the Quarkus `SequenceAgent`.
- Avoid OpenCode-only syntax inside worker prompts.

## 11. Implementation phases

### Phase 1 — Plan review (this document)

Deliverable: agreed scope, assumptions, policy, catalog, and test cases.

### Phase 2 — Test data and fixtures

- Create `products.md`, the 5 Markdown case files, `expected.md`, and README.
- Ensure expected statuses and reason codes are recorded.

### Phase 3 — Agents

- Write the 3 worker agents with policy and labeled Markdown output. The intake
  agent reads the catalog file.
- Write the primary runner as a fixed intake -> guarantee -> output sequence
  with report writing.
- Add the optional command and `run-cases.sh`.

### Phase 4 — Test and tune

- For now, run 2 of the 5 cases: one success path and one validation-failure
  path.
- Verify status, reason, and that the guarantee agent returns
  `Decision: not applicable` when validation fails.
- Tune prompts only where a case fails; do not add new features.
- Keep sample reports for regression comparison.
- Run the remaining cases once the flow is stable.

### Phase 5 — Quarkus port (separate project/iteration)

- Reuse prompts, policy, catalog, and cases.
- Define native Quarkus request/response types and a `SequenceAgent` there.

## 12. Acceptance criteria

- 5/5 cases return the expected status and reason.
- Case 5 lists all three validation issues and the guarantee agent returns
  `Decision: not applicable`.
- Worker reports contain the expected labels (`Validation:`, `Decision:`,
  `Status:`) and are easy to read.
- No JSON parsing or schema validation is required in the OpenCode run.
- No agent invents customer data, SKUs, or purchase ages.
- The output agent's reply is polite, consistent with the decision, and written
  as multiple short paragraphs.
- The result file contains the status fields and the customer reply, with no
  agent trace.
- Only the intake worker uses a tool (`read` for the catalog); guarantee and
  output only transform text.
- A reader can follow `README.md` and reproduce the run.

## 13. Risks and mitigations

| Risk | Mitigation |
| --- | --- |
| LLM disagreement on "incident" vs "production" | Explicit indicator lists, precedence order, and cases with unambiguous wording. Add adversarial cases later. |
| Worker report drifts from the label convention | Short reports with fixed labels, temperature 0, and fail loudly if a label is missing. |
| Catalog file missing or unreadable | Keep the path stable; if intake cannot read it, the run fails instead of guessing products. |
| Model variability across providers | Stable labels and reason codes; pin the model after tuning. |
| Legal overclaiming | Treat 24 months as Mapple policy and the 6-month rule as a business simplification; add a non-legal-advice note. |
| Prompt injection in customer text | Workers treat request text as data; they never execute instructions found in it. |

## 14. Open questions before implementation

1. Confirm the 4th sequence runner agent is acceptable (recommended).
2. Confirm English-only replies for v1.
3. Confirm the 6–24 month rule: accept production defects, reject incident and
   unclear causes.
4. Confirm the file locations (`.opencode/examples/mapple-returns/`,
   `.opencode/agents/`).
5. Confirm case 5 should fail all three validations, or whether a
   single-issue validation failure is preferred.
