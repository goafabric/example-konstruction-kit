# Mapple guarantee returns

A small multi-agent return flow for the fictional company **Mapple**. It reads a
written customer request, validates it, applies a fixed guarantee policy, and
writes a polite customer reply.

Everything here runs with plain OpenCode agents. There is no JSON contract, no
schema, and no database.

## Agents

| Agent | Mode | Job |
| --- | --- | --- |
| `mapple-returns` | primary | Orchestrates the flow and writes the final report. |
| `mapple-intake` | subagent | Extracts and validates the request. |
| `mapple-guarantee` | subagent | Applies the guarantee policy. |
| `mapple-output` | subagent | Writes the customer reply and final status. |

The workers return short labeled Markdown reports, not JSON. The orchestrator
reads only the routing labels (`Validation:`, `Decision:`, `Status:`).

## Flow

```text
INTAKE
  |-- validation failed -------------------------> OUTPUT (VALIDATION_FAILED)
  |
  `-- validation passed -> GUARANTEE
                            |-- accepted -------> OUTPUT (ACCEPTED)
                            `-- rejected -------> OUTPUT (REJECTED)
```

The guarantee agent is skipped when intake validation fails.

## Run one case

From the OpenCode TUI:

```text
/mapple-return .opencode/examples/mapple-returns/testdata/cases/case-01-homer.md
```

Or call the agent directly:

```text
@mapple-returns Process .opencode/examples/mapple-returns/testdata/cases/case-01-homer.md
```

From the shell:

```sh
opencode run --agent mapple-returns \
  "Process .opencode/examples/mapple-returns/testdata/cases/case-01-homer.md"
```

The agent writes the result to:

```text
.opencode/examples/mapple-returns/results/<caseId>.md
```

Each report contains the final status, the customer reply, and the agent trace.

## Run all cases

```sh
.opencode/examples/mapple-returns/run-cases.sh
```

The script runs the five cases in order and prints the status and reason from
each report.

## Test cases

| Case | Customer | Product | Purchase age | Expected |
| --- | --- | --- | --- | --- |
| `case-01-homer` | Homer Simpson | myphone 15 Pro Max | 3 months | `ACCEPTED` / `PRODUCTION_DEFECT_EARLY` |
| `case-02-bart` | Bart Simpson | mapbook Pro 14 | 5 months | `REJECTED` / `INCIDENT_DAMAGE` |
| `case-03-marge` | Marge Simpson | mapple Watch Series 9 41 mm | 7 months | `ACCEPTED` / `PRODUCTION_DEFECT_IN_WARRANTY` |
| `case-04-lisa` | Lisa Simpson | mapbook 13 | 30 months | `REJECTED` / `OUT_OF_WARRANTY` |
| `case-05-burns` | Montgomery Burns | `MyPhone 16 Ultra` (unknown) | not stated | `VALIDATION_FAILED` |

Expected outcomes are documented in `testdata/expected.md`. The orchestrator
never reads that file.

## Policy summary

1. Validation failed -> ask for the missing information.
2. Older than 24 months -> rejected.
3. Clear incident or major damage -> rejected, even under 6 months.
4. Up to 6 months and production-related damage -> accepted.
5. 6 to 24 months and production-related damage -> accepted.
6. 6 to 24 months and unclear cause -> rejected.

The 24-month rule and the 6-month early-defect rule are Mapple business policy,
not legal advice. Directive (EU) 2019/771 sets a two-year minimum guarantee; the
early-defect shortcut is a simplification for this example.

## Add a case

1. Add a Markdown file under `testdata/cases/` with the raw customer request.
2. Add the expected status and reason to `testdata/expected.md`.
3. Run it with `/mapple-return` or the CLI command above.
