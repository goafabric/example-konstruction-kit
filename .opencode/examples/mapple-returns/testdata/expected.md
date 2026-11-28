# Expected results

These expectations are for the human tester. The orchestrator reads only the
selected case file, never this table.

| Case | Expected status | Expected reason | Notes |
| --- | --- | --- | --- |
| `case-01-homer` | `ACCEPTED` | `PRODUCTION_DEFECT_EARLY` | Battery swelling at 3 months; no incident. |
| `case-02-bart` | `REJECTED` | `INCIDENT_DAMAGE` | Skateboard impact at 5 months; incident wins over the 6-month window. |
| `case-03-marge` | `ACCEPTED` | `PRODUCTION_DEFECT_IN_WARRANTY` | Pixel errors at 7 months; no incident. |
| `case-04-lisa` | `REJECTED` | `OUT_OF_WARRANTY` | Purchased 30 months ago. |
| `case-05-burns` | `VALIDATION_FAILED` | `VALIDATION_FAILED` | Missing customer number, unknown product (`MyPhone 16 Ultra`), and missing purchase age. |

## Case 5 expected issues

The intake report should list all three issues in one line:

```text
Issues: MISSING_CUSTOMER_NUMBER, UNKNOWN_PRODUCT, MISSING_PURCHASE_AGE
```

The guarantee agent must be skipped for this case.
