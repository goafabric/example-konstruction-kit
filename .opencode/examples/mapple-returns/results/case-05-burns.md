# Return result — case-05-burns

Status: VALIDATION_FAILED
Reason: MISSING_CUSTOMER_NUMBER, UNKNOWN_PRODUCT, MISSING_PURCHASE_AGE
Customer: Montgomery Burns
Product: not found in catalog

## Customer reply

Dear Montgomery Burns,

Thank you for contacting Mapple. We need a little more information to review your return request. Please provide your customer number, the exact product and variation, and the purchase age. We will continue processing your request once we receive these details.

Kind regards,
Mapple Customer Support

## Agent trace

1. mapple-intake — done — validation failed; missing customer number, unknown product, missing purchase age
2. mapple-guarantee — skipped — intake validation failed
3. mapple-output — done — reply written
