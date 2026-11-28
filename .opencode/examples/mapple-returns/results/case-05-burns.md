# Return result — case-05-burns

Status: VALIDATION_FAILED
Reason: VALIDATION_FAILED
Customer: Montgomery Burns
Product: not found in catalog

## Customer reply

Dear Montgomery Burns,

Thank you for contacting Mapple. We could not validate your return request yet. Please provide your customer number, the exact product name and variation, and the purchase age or original purchase date. Once we receive this information, we will continue reviewing your request; this is not a rejection.

Kind regards,
Mapple Customer Support

## Agent trace

1. mapple-intake — done — validation failed: MISSING_CUSTOMER_NUMBER, UNKNOWN_PRODUCT, MISSING_PURCHASE_AGE
2. mapple-guarantee — skipped — intake validation failed
3. mapple-output — done — reply written
