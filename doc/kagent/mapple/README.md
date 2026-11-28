# Mapple guarantee returns on kagent

A kagent variant of the OpenCode flow in `.opencode/agents/`. Three worker
agents do the same jobs as their OpenCode counterparts, an orchestrator agent
ties them together, and the product catalog lives in a ConfigMap.

Test cases are **not** stored in kagent. Paste the customer request into the
session when you run a case.

## Agents

| Agent | Role |
| --- | --- |
| `mapple-returns-agent` | Orchestrator. Runs intake, guarantee, and output in order and returns the final report. |
| `mapple-intake-agent` | Validates the customer request against the product catalog. |
| `mapple-guarantee-agent` | Applies the guarantee policy to the intake report. |
| `mapple-output-agent` | Writes the customer reply and final status. |

The orchestrator calls the three worker Agents through the kagent API MCP
server (`kagent-api`, tool `invoke_agent`), so it receives each report and can
pass it to the next step. A `subAgent` binding hands the conversation over
instead of returning a report, so it cannot express this sequence.

The intake template includes the catalog from the `mapple-product-catalog`
ConfigMap through `promptTemplate`. The orchestrator has no prompt data source;
it uses the case text from the invocation message.

## Files

| File | Purpose |
| --- | --- |
| `mapple-returns-agent.yaml` | Orchestrator Agent + AgentTemplate; binds `invoke_agent` from `kagent-api`. |
| `mapple-intake-agent.yaml` | Intake Agent + AgentTemplate; includes the catalog ConfigMap. |
| `mapple-guarantee-agent.yaml` | Guarantee Agent + AgentTemplate. |
| `mapple-output-agent.yaml` | Output Agent + AgentTemplate. |
| `catalog-configmap.yaml` | The product catalog, ConfigMap `mapple-product-catalog`, key `products`. |
| `harness.yaml` | The same `my-harness` used by the Simpsons examples. |

## Prerequisites

- kagent installed, with `my-harness` and a model config named
  `openai-model-config`. The Simpsons examples show both; `doc/kagent/model-config.sh`
  creates the model config.
- The default `kagent-api` RemoteMCPServer. The orchestrator binds its
  `invoke_agent` tool to call the three worker Agents.
- `kubectl`, `jq`, and `kagent` on `PATH`.

## Apply

Apply the catalog ConfigMap first: the intake AgentTemplate references it while
building its prompt.

```sh
kubectl apply -f doc/kagent/mapple/harness.yaml
kubectl apply -f doc/kagent/mapple/catalog-configmap.yaml
kubectl apply -f doc/kagent/mapple/mapple-intake-agent.yaml
kubectl apply -f doc/kagent/mapple/mapple-guarantee-agent.yaml
kubectl apply -f doc/kagent/mapple/mapple-output-agent.yaml
kubectl apply -f doc/kagent/mapple/mapple-returns-agent.yaml
```

## Run a case

Paste the case text into the invocation. Prefix it with the case ID on the first
line so the final summary line uses that ID:

```sh
SESSION_ID=$(kagent agent session create --agent mapple-returns-agent -o json \
  | jq -r '.session.id')

CASE=case-01-homer
kagent agent invoke --session "$SESSION_ID" --task "$CASE

$(cat .opencode/examples/mapple-returns/testdata/cases/$CASE.md)"
```

If the first line is not a case ID, the orchestrator uses `case` as the ID and
treats the whole message as the customer request.

The orchestrator passes the case text to `intake`, the intake report to
`guarantee`, and both reports to `output`. It returns the output report and a
final line:

```text
case-01-homer: ACCEPTED (PRODUCTION_DEFECT_EARLY)
```

## Expected results

| Case | Expected |
| --- | --- |
| `case-01-homer` | `ACCEPTED` / `PRODUCTION_DEFECT_EARLY` |
| `case-02-bart` | `REJECTED` / `INCIDENT_DAMAGE` |
| `case-03-marge` | `ACCEPTED` / `PRODUCTION_DEFECT_IN_WARRANTY` |
| `case-04-lisa` | `REJECTED` / `OUT_OF_WARRANTY` |
| `case-05-burns` | `INFORMATION_MISSING` / `INFORMATION_MISSING` |

Case 05 is the validation-failure path. The guarantee agent still runs and
returns `Decision: not applicable`; the output agent turns that into
`INFORMATION_MISSING`.

## Notes

- The policy lives only in the worker prompts; the orchestrator never applies
  policy.
- The orchestrator uses `invoke_agent` from `kagent-api`. Do not replace it with
  a `subAgent` binding: a hand-off does not return the worker's report.
- Only the catalog is stored in a ConfigMap. Test cases are pasted into the
  session from `.opencode/examples/mapple-returns/testdata/cases/`.
- AgentTemplates resolve their prompt data sources when kagent builds a
  revision. Change the catalog ConfigMap, then re-apply the intake
  AgentTemplate to pick up the new text.
