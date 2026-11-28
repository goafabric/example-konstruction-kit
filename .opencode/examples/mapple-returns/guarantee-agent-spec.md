#
- please create a plan for the following scenario, if there is anything unclear please ask questions
- a multi agent flow for a guarantee return process of damaged devices, for a fictional company "mapple" that orients itself to "apple"
- should be build for simple opencode agents.md files first, but later be portable to quarkus agentic
- also create test data with 5 specific test return cases, please use simpsons characters with their typical character trades
- should products of category "myphone" "mapbook (pro)" "mapple watch", you may for now create a fixed set of overall variations
- should at least consist of 3 agents
- in the first run should be as simple as possible, e.g. no fraud agent in the first batch

# intake agent
- reads the written customer return requests
- validates if it contains a customer number
- validates if it is a valid product
- validates if it contains a hint how many months ago the product was bought
- continues with guarantee agent if validation ok, otherwise skips it

# guarantee agent
- follows eu regulations for the most part
- rejects any product return if it was bought more than 24 months ago
- rejects any product return that clearly shows major damage by incident
- accepts any product return that was returned within the first 6 months and shows damage related to the production process (e.g. battery dead, screen pixel errors)
  
# output agent
- writes a nice and polite answer to the customer and reports back the final status which can be
  - validation failed, please provide more info
  - return rejected because ...
  - return accepted
                              

# frontend (not needed for opencode)
- have a selection tile at the left side that displays the test cases which can be selected
- on the upper right side display the content of the test case
- on the bottom right show the result of the output agent as text, but also the status in a clear indication
- also display the agents itself and which one is currently working