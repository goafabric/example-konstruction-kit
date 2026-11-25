# ollama
https://ollama.com/blog/speech-models

ollama pull phonon:40m-en
ollama pull phonon:40m-de


# english
curl http://localhost:11434/v1/audio/speech \
-H "Content-Type: application/json" \
-d '{
"model": "phonon:40m-en",
"voice": "Zoey",
"input": "In a hole in the ground there lived a hobbit. Not a nasty, dirty, wet hole. It was a hobbit-hole, and that means comfort."
}' --output speech.wav && afplay speech.wav

# german
curl http://localhost:11434/v1/audio/speech \
-H "Content-Type: application/json" \
-d '{
"model": "phonon:40m-de",
"voice": "Annika",
"input": "In einer Höhle in der Erde, da lebte ein Hobbit. Nicht in einem schmutzigen, nassen Loch. Es war eine Hobbithöhle, und das bedeutet Behaglichkeit."
}' --output speech.wav && afplay speech.wav