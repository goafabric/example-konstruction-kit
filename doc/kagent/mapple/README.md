# Mapple guarantee returns on kagent

A kagent variant of the OpenCode flow in `.opencode/agents/`. Three worker
agents do the same jobs as their OpenCode counterparts, an orchestrator agent
ties them together, and the catalog and test cases live in ConfigMaps.

## Agents

| Agent | Role |
| --- | --- |
| `mapple-returns-agent` | Orchestrator. Runs intake, guarantee, and output in order and returns the final report. |
| `mapple-intake-agent` | Validates the customer request against the product catalog. |
| `mapple-guarantee-agent` | Applies the guarantee policy to the intake report. |
| `mapple-output-agent` | Writes the customer reply and final status. |

The orchestrator binds the three worker AgentTemplates as `subAgent` tools, the
same way `simpsons-scene-agent` binds the Simpsons specialists. The intake
template includes the catalog from the `mapple-product-catalog` ConfigMap through
`promptTemplate`. The orchestrator includes the five case texts from the
`mapple-test-cases` ConfigMap the same way.

## Files

| File | Purpose |
| --- | --- |
| `mapple-returns-agent.yaml` | Orchestrator Agent + AgentTemplate with the three subagent bindings. |
| `mapple-intake-agent.yaml` | Intake Agent + AgentTemplate; includes the catalog ConfigMap. |
| `mapple-guarantee-agent.yaml` | Guarantee Agent + AgentTemplate. |
| `mapple-output-agent.yaml` | Output Agent + AgentTemplate. |
| `testcases-configmap.yaml` | Two ConfigMaps: `mapple-test-cases` (five cases) and `mapple-product-catalog` (the catalog). |
| `harness.yaml` | The same `my-harness` used by the Simpsons examples. |

## Prerequisites

- kagent installed, with `my-harness` and a model config named
  `openai-model-config`. The Simpsons examples show both; `doc/kagent/model-config.sh`
  creates the model config.
- `kubectl`, `jq`, and `kagent` on `PATH`.

## Apply

Apply the ConfigMaps first: the AgentTemplates reference them while building
their prompts.

```sh
kubectl apply -f doc/kagent/mapple/harness.yaml
kubectl apply -f doc/kagent/mapple/testcases-configmap.yaml
kubectl apply -f doc/kagent/mapple/mapple-intake-agent.yaml
kubectl apply -f doc/kagent/mapple/mapple-guarantee-agent.yaml
kubectl apply -f doc/kagent/mapple/mapple-output-agent.yaml
kubectl apply -f doc/kagent/mapple/mapple-returns-agent.yaml
```

## Run a case

```sh
SESSION_ID=$(kagent agent session create --agent mapple-returns-agent -o json \
  | jq -r '.session.id')

kagent agent invoke --session "$SESSION_ID" --task "Process case-05-burns"
```

The orchestrator selects the case text from its prompt, then calls `intake`,
`guarantee`, and `output`. It returns the output report and a final line:

```text
case-05-burns: INFORMATION_MISSING (INFORMATION_MISSING)
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
- The catalog and test cases are plain ConfigMap data, not skills. There is no
  OCI image to build and no digest to pin.
- AgentTemplates resolve their prompt data sources when kagent builds a
  revision. Change a ConfigMap, then re-apply the affected AgentTemplate to pick
  up the new text.
