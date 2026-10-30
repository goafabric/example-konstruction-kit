# intro
- can you adapt the existing pacman.html which has pacman in a single html file
- you can keep the input via keyboard
- but i would also be able to control the movement from the outside to have it controlled by a jev like decission LLM
- for this i guess we need to have endpoints that can be called via curl for the movement
- and you need to provide endpoints that provide data concerning the pacman grid to the jev model, like position of the pacman and the surrounding area and possible ghosts
- below you find simple examples for possible requests and responses
        
# request
curl http://localhost:11434/v1/systemone -d '{
"model": "nimble",
"state": "Design a sharded database schema for a payments ledger.",
"questions": {
"model": {
"type": "choice",
"instructions": "Which model should answer this prompt?",
"criteria": {"gemma4": "Small model", "kimi-k3": "Large model"}
}
}
}'
      
# response
{
"model": "nimble",
"answers": {
"model": {
"type": "choice",
"choice": "kimi-k3",
"probabilities": {"gemma4": 0.151, "kimi-k3": 0.849},
"confidence": 0.388
}
},
"usage": {"input_tokens": 161, "output_tokens": 1}
}