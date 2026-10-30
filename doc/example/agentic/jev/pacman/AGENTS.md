# Pac-Man + jev decision-model control

## What this is

`pacman.html` is a single-file, canvas-based Pac-Man clone (maze, 4 ghosts
with scatter/chase/frightened modes, pellets, power pellets). `server.js` is
a small zero-dependency Node HTTP server that turns it into something a
"jev"-style decision model (see `../jev.md` / `req.md`) can watch and drive
over plain HTTP, while keyboard play keeps working exactly as before.

This directory (`doc/jev/pacman/`) holds the game + server; `../jev.md` one
level up has the original `ollama`/jev decision-model notes this was built
from.

Concretely, this lets you:
- open the game in a browser and watch it **play itself**, driven by a local
  Ollama decision model (`tev1:4b`, same shape as the `jev.md` examples), or
- drive/inspect it yourself with plain `curl`, with no model involved.

## Files

| File | Role |
|---|---|
| `pacman.html` | The game. Unmodified gameplay/rendering, plus a small bridge at the bottom of the script that syncs state to/from `server.js` every 80ms. Keyboard input (arrows/WASD, P, R) is untouched and always works, even if the server is down. |
| `server.js` | `node server.js` — serves `pacman.html` at `/`, exposes the HTTP API below, and runs the autoplay loop that asks Ollama for the next move. |
| `req.md` | The original feature request this was built from. |
| `../jev.md` | Original `ollama /v1/systemone` "jev" decision-model request/response notes (one directory up, shared with other things under `doc/jev/`). |

## Running it

```bash
cd doc/jev/pacman
node server.js              # http://localhost:8787
PORT=9000 node server.js    # custom port
```

Open `http://localhost:8787/` in a browser. Autoplay is **on by default** —
if Ollama is reachable at `http://localhost:11434/v1/systemone` with the
`tev1:4b` model pulled (`ollama pull tev1:4b`), the game starts playing
itself immediately. If Ollama isn't reachable, the page just sits idle
(no fallback AI — see "Design decisions" below) until Ollama answers or you
move it yourself via keyboard/API.

Env vars (all optional):

| Var | Default | Meaning |
|---|---|---|
| `PORT` | `8787` | HTTP port |
| `OLLAMA_URL` | `http://localhost:11434/v1/systemone` | decision-model endpoint |
| `OLLAMA_MODEL` | `tev1:4b` | model name sent in the request |
| `OLLAMA_TIMEOUT_MS` | `1500` | abort a stalled ollama call after this long |
| `AUTOPLAY_INTERVAL_MS` | `100` | minimum gap between the *start* of one decision tick and the next (not added on top of the ollama call — see Autoplay loop below). A small deliberate throttle so autoplay doesn't hammer ollama with literally back-to-back requests; set to `0` to ask again the instant the previous call finishes, or raise it to throttle further. |
| `AUTOPLAY` | (unset = on) | set to `off` to start with autoplay disabled |

## HTTP API

| Method & path | Purpose |
|---|---|
| `GET /` | the game page |
| `GET /api/state` | current state for a human or a model: Pac-Man tile/direction/legal moves, all 4 ghosts (position, status, distance), a 7x7 text window around Pac-Man, the full maze grid, score/lives/level/pellets. `503` until a browser tab has connected. |
| `GET /api/decision` | the same state, pre-packaged as a ready-to-curl `jev`/ollama `systemone` request body (`state` text + a `move` choice question whose `criteria` are only the currently-legal directions). |
| `GET /api/decision/call` | actually calls ollama with that request right now and returns both `{ request, response }` verbatim — for debugging/inspecting what the model sees and says, independent of the autoplay loop (does not touch `pendingDirection` or `autoplayInfo`). |
| `POST /api/move` `{"direction":"up"\|"down"\|"left"\|"right"}` | queue Pac-Man's next move — same effect as a keypress. |
| `POST /api/control` `{"action":"pause"\|"resume"\|"restart"}` | control the game externally. |
| `GET /api/autoplay` / `POST /api/autoplay {"enabled":true\|false}` | inspect/toggle the self-play loop (also toggleable from the on-page button). |

Examples:

```bash
curl http://localhost:8787/api/state
curl http://localhost:8787/api/decision
curl http://localhost:8787/api/decision/call
curl -X POST http://localhost:8787/api/move -d '{"direction":"up"}'
curl -X POST http://localhost:8787/api/control -d '{"action":"restart"}'
curl -X POST http://localhost:8787/api/autoplay -d '{"enabled":false}'
```

## How the browser <-> server bridge works

`pacman.html` can't expose HTTP endpoints by itself (it's just a page), so
`server.js` sits in between:

1. Every 80ms (comfortably under one tile-crossing, ~185ms at the
   configured `PAC_SPEED`) the page `POST`s its full live state to
   `/api/sync`.
2. The server stores that as `latestState` (what `/api/state` and
   `/api/decision` read from) and replies with any pending direction/action
   commands that were queued via `/api/move`, `/api/control`, or the
   autoplay loop.
3. The page applies those commands exactly like a keypress (`pac.next = ...`)
   and keeps rendering/simulating locally as normal.

If the server is unreachable, the page's `fetch` calls just fail silently
(caught) and keyboard play is unaffected — the "API: offline" badge shows
under the maze.

## Autoplay loop (the self-play part)

`server.js` runs a sequential loop (`autoplayTick`, scheduled via
`setTimeout`, not an overlapping `setInterval`) that, once a game page is
connected:

1. Builds a `jev`-style decision request from the latest state
   (`buildDecisionPrompt`).
2. `POST`s it to `OLLAMA_URL` with model `OLLAMA_MODEL`.
3. Reads `answers.move.choice` from the response and queues it as the next
   move.
4. Logs one line per tick, including how long the Ollama call took:
   `[ollama] -> left (157ms)` or `[ollama] call failed after 1500ms: <reason>`.
5. If the game reaches `gameover`, queues a `restart` so the demo keeps
   running indefinitely.

Tick pacing is measured from the *start* of a tick, not added on top of the
ollama call (`nextDelay = max(0, AUTOPLAY_INTERVAL_MS - elapsed)`), so a slow
ollama response doesn't silently turn a 400ms gap into an 800ms+ one — it
was doing exactly that before this was fixed.

### Making the decision request actually informative

`tev1:4b` is a small choice-classifier, and its behavior tracks very
directly with what's in the `criteria` field per choice, *not* just the
`state` text. Confirmed empirically (`curl`ing ollama directly with hand-
written prompts): with generic criteria like `{"left": "Move left", "right":
"Move right"}` the model falls back hard to "keep going whatever direction
it's already moving", largely ignoring pellet layout, and its confidence on
genuine ghost-danger cases collapses once the `state` text gets long/noisy
(observed down to ~0.003, i.e. a coin flip, despite still picking the
technically-correct side).

So `buildDecisionPrompt()` now does the pellet/ghost analysis itself
(`describeDirection`, BFS via `exploreFrom`) and puts a concrete, short
description *per direction* into `criteria`, e.g.:

```
"left":  "DANGER: blinky is right there, almost certain death"
"right": "nearest pellet 2 tile(s) away"
```

instead of `"Move left"` / `"Move right"`. The shared `state` text was
trimmed to just position/direction/pellet-count — the previous version
crammed the full ghost list and a 7x7 ASCII maze window in there, which
turned out to mostly dilute the signal rather than help. Verified this
meaningfully improved play: pellets are now eaten via fresh routes instead
of repeatedly retracing already-cleared corridors, and isolated danger
scenarios are picked correctly with much higher confidence than before.

**Known remaining limitation**: this is still a single-step-ahead decision
(one BFS from the *next* tile in each direction, re-run every tick) — there
is no multi-step path planning or lookahead for multiple ghosts converging
from different sides at once. Pac-Man can still die to a pincer/ambush near
the ghost-house exit, the same way a purely reactive player might. Fixing
that would mean deeper search (e.g. simulate a few steps ahead per
candidate direction), which is a bigger change than the prompt/criteria fix
done here.

### Where the end-to-end latency actually comes from

There are two independent "polling" loops; neither one is required to be
slow, they just both add some delay:

1. **Server -> Ollama (`AUTOPLAY_INTERVAL_MS`, default `100`)**: how often the
   server *decides* on a new direction. This is a small deliberate throttle
   on top of the raw Ollama round-trip time (observed ~50-500ms with
   `tev1:4b` locally, depending on load), so autoplay doesn't fire requests
   literally back-to-back with zero breathing room. Set to `0` for "ask
   again the instant the previous call finishes" if you want the absolute
   minimum latency instead.
2. **Browser <-> server (`/api/sync`, every 80ms)**: how often the page picks
   up a freshly queued direction and reports its own state back. This value
   just needs to stay comfortably below one tile-crossing (~185ms at
   `PAC_SPEED`) so a queued move isn't stale by the time it's read.

On top of both: Pac-Man can only actually *turn* at a tile-center crossing
(~185ms at the current speed), so even an instantly-available direction can
take up to that long to become visible on screen. That part is inherent to
the tile-based movement model, not the HTTP plumbing.

### Design decision: no built-in fallback AI

An earlier version of this included a built-in heuristic (BFS to the
nearest pellet + ghost-avoidance scoring) that took over whenever Ollama
was unreachable. **This was removed at the user's request** — autoplay now
depends entirely on Ollama. If it's unreachable, no move is queued and the
page just shows "Autoplay: ON (ollama unreachable)" until it answers again.
Keyboard and the `/api/move` / `/api/control` endpoints still work regardless.

## Bug found and fixed in the original game engine

While testing autoplay (score stayed at 0 despite Pac-Man visibly moving),
a pre-existing bug was found in `pacman.html`'s movement code — present
before any of the above changes, affecting plain keyboard play too:

- `updatePac()`/`updateGhost()` each have two separate "snap to tile
  center" code paths: a loose-tolerance (`EPS = 0.06`) turning-check at the
  top of the function, and the movement loop's own exact-arrival check
  further down (the one that calls `eatAt()`/`wrap()`).
- Because a single frame's movement step is similar in size to `EPS`, the
  turning-check almost always fired first and force-rounded the position to
  the tile center *before* the exact-arrival check could ever detect
  "arrived" — so `eatAt()` (pellet consumption / scoring) was silently
  skipped on nearly every tile crossing, for both Pac-Man and the ghosts.
- Fix: the turning-check path now also calls `wrap()` and `eatAt()` (both
  are idempotent, so doing so redundantly is harmless). Also replaced
  `Math.round(currentPos) + direction` (which flips the target tile one
  step early once position crosses a tile midpoint) with a direction-aware
  `nextCenter()` helper using `floor`/`ceil`.
- Verified via Playwright: pellets are now eaten correctly, score tracks
  exactly (10/pellet, 50/power-pellet), turning works, and eating a power
  pellet correctly frightens the ghosts (they turn blue, eyes-and-wobble
  animation).

## Verifying changes

There's no automated test suite here; changes were verified ad hoc with
Playwright (headless Chromium) driving the page and polling `/api/state`
to confirm score/position/ghost-status changes match expectations, plus
`node --check` on the extracted `<script>` body for a quick syntax check
after edits. If you change `pacman.html` or `server.js` again, a similar
spot-check (open the page, play a bit via keyboard or `/api/move`, confirm
score/pellets move and no console errors appear) is the fastest way to
catch regressions.
