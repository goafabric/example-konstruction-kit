# model
ollama pull tev1:4b
https://ollama.com/blog/ollama-now-supports-jev-style-decision-models

# ledger

curl http://localhost:11434/v1/systemone -d '{
"model": "tev1:4b",
"state": "Design a sharded database schema for a payments ledger.",
"questions": {
"model": {
"type": "choice",
"instructions": "Which model should answer this prompt?",
"criteria": {"gemma4": "Small model", "kimi-k3": "Large model"}
}
}
}' | jq .
           
# lunch
## inside opencode/doc/jev/pacman

curl http://localhost:11434/v1/systemone -d '{
"model": "tev1:4b",
"state": "We would like to go to lunch",
"questions": {
"label": {
"type": "choice",
"instructions": "Where should we go for lunch. It should be tasty and maybe not to unhealthy. The doener has pizza, fallafel and kebap. The schwarma has no pizza, but schwarma, fallafel, humus, baba ganough",
"criteria": {"doener": "tasty", "schawarma": "tasty and healthy"}
}
}
}' | jq .
             
# pacman

curl http://localhost:11434/v1/systemone -d '{
"model": "tev1:4b",
"state": "Pac-Man is at tile (6,22), currently moving left. 221 pellets remain on the board.",
"questions": {
"move": {
"type": "choice",
"instructions": "Pick the direction whose description below is safest and leads to pellets soonest. Never pick a direction marked DANGER unless every option is.",
"criteria": {
"up": "power pellet 8 tile(s) away; nearest pellet 0 tile(s) away",
"down": "power pellet 8 tile(s) away; nearest pellet 0 tile(s) away",
"right": "power pellet 10 tile(s) away; nearest pellet 2 tile(s) away"
}
}
}
}'