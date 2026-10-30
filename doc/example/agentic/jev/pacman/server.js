#!/usr/bin/env node
"use strict";

/**
 * Tiny zero-dependency HTTP server that:
 *  - serves pacman.html
 *  - receives a live state snapshot pushed by the running page (POST /api/sync)
 *  - exposes that snapshot for external readers, e.g. a jev-style decision
 *    model (GET /api/state, GET /api/decision)
 *  - lets an external caller drive Pac-Man via plain curl (POST /api/move,
 *    POST /api/control), without touching the keyboard controls at all
 *
 * Usage:
 *   node server.js            # listens on http://localhost:8787
 *   PORT=9000 node server.js  # custom port
 */

const http = require("http");
const fs = require("fs");
const path = require("path");
const { URL } = require("url");

const PORT = process.env.PORT ? Number(process.env.PORT) : 8787;
const HTML_PATH = path.join(__dirname, "pacman.html");

const DIRECTIONS = new Set(["up", "down", "left", "right"]);
const ACTIONS = new Set(["pause", "resume", "restart"]);

// -------------------------------------------------------- autoplay config
// By default the server itself drives Pac-Man: it repeatedly asks the
// jev/ollama decision model (POST OLLAMA_URL) for the next move and applies
// it. There is no built-in fallback — if ollama is unreachable, autoplay
// simply queues no move until it answers again. Toggle with POST
// /api/autoplay or the on-page button; keyboard input always still works
// alongside it.
const OLLAMA_URL = process.env.OLLAMA_URL || "http://localhost:11434/v1/systemone";
const OLLAMA_MODEL = process.env.OLLAMA_MODEL || "tev1:4b";
const OLLAMA_TIMEOUT_MS = process.env.OLLAMA_TIMEOUT_MS ? Number(process.env.OLLAMA_TIMEOUT_MS) : 1500;
// Minimum gap between the *start* of one decision tick and the next, not
// added on top of the ollama call itself (see autoplayTick). A small
// deliberate throttle so autoplay doesn't hammer ollama with literally
// back-to-back requests; set to 0 for "ask again the instant the previous
// call finishes", or raise it to throttle further.
const AUTOPLAY_INTERVAL_MS = process.env.AUTOPLAY_INTERVAL_MS ? Number(process.env.AUTOPLAY_INTERVAL_MS) : 10;

let autoplayEnabled = process.env.AUTOPLAY !== "off";
let autoplayInfo = { lastDirection: null, lastError: null, lastElapsedMs: null, lastAt: 0 };

// ---------------------------------------------------------------- state
let latestState = null;      // last snapshot pushed by the browser via /api/sync
let lastSyncAt = 0;          // Date.now() of that push
let pendingDirection = null; // next direction command for the browser to pick up
let pendingActions = [];     // queued control actions (pause/resume/restart)

// ---------------------------------------------------------------- helpers
function send(res, status, body, contentType) {
  const payload = typeof body === "string" ? body : JSON.stringify(body, null, 2);
  res.writeHead(status, {
    "Content-Type": contentType || "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type"
  });
  res.end(payload);
}

function readJsonBody(req) {
  return new Promise((resolve, reject) => {
    let data = "";
    req.on("data", chunk => {
      data += chunk;
      if (data.length > 2_000_000) {
        req.destroy();
        reject(new Error("payload too large"));
      }
    });
    req.on("end", () => {
      if (!data) return resolve({});
      try { resolve(JSON.parse(data)); }
      catch (e) { reject(e); }
    });
    req.on("error", reject);
  });
}

const DIR_OFFSETS = { up: { x: 0, y: -1 }, down: { x: 0, y: 1 }, left: { x: -1, y: 0 }, right: { x: 1, y: 0 } };

function tileCharAt(gridRows, x, y) {
  if (y < 0 || y >= gridRows.length) return "#";
  const row = gridRows[y];
  if (x < 0 || x >= row.length) return " "; // tunnel wrap
  return row[x];
}

// BFS outward from a tile (not crossing walls or the ghost-house door —
// Pac-Man himself can never cross that either), up to maxDepth steps,
// looking for the nearest pellet/power-pellet. reachableTiles being tiny
// flags a dead end with nothing to find.
function exploreFrom(grid, startX, startY, maxDepth) {
  const rows = grid.length, cols = grid[0].length;
  const key = (x, y) => x + "," + y;
  const visited = new Set([key(startX, startY)]);
  const queue = [{ x: startX, y: startY, dist: 0 }];
  let nearestPelletDist = null, nearestPowerDist = null;
  for (let qi = 0; qi < queue.length; qi++) {
    const cur = queue[qi];
    const t = tileCharAt(grid, cur.x, cur.y);
    if (t === "." && nearestPelletDist === null) nearestPelletDist = cur.dist;
    if (t === "o" && nearestPowerDist === null) nearestPowerDist = cur.dist;
    if (cur.dist >= maxDepth) continue;
    for (const dir of ["up", "down", "left", "right"]) {
      const off = DIR_OFFSETS[dir];
      let nx = cur.x + off.x;
      const ny = cur.y + off.y;
      if (nx < 0) nx = cols - 1; else if (nx >= cols) nx = 0; // tunnel wrap
      if (ny < 0 || ny >= rows) continue;
      const t2 = tileCharAt(grid, nx, ny);
      if (t2 === "#" || t2 === "-") continue;
      const k = key(nx, ny);
      if (visited.has(k)) continue;
      visited.add(k);
      queue.push({ x: nx, y: ny, dist: cur.dist + 1 });
    }
  }
  return { nearestPelletDist, nearestPowerDist, reachableTiles: visited.size };
}

// Builds a short, information-dense description of what taking `dir` leads
// to. This is the actual signal the decision model compares between
// choices — a generic "Move left" gives it nothing to discriminate on,
// which is why it used to just keep going in whatever direction it was
// already moving regardless of pellets or danger.
function describeDirection(state, dir) {
  const { pacman, ghosts, grid } = state;
  const off = DIR_OFFSETS[dir];
  const sx = pacman.tileX + off.x, sy = pacman.tileY + off.y;

  let minDangerDist = Infinity, nearestDangerName = null;
  let minFrightDist = Infinity, nearestFrightName = null;
  for (const g of ghosts) {
    const d = Math.max(Math.abs(g.tileX - sx), Math.abs(g.tileY - sy));
    if (g.dangerous && d < minDangerDist) { minDangerDist = d; nearestDangerName = g.name; }
    if (g.status === "frightened" && d < minFrightDist) { minFrightDist = d; nearestFrightName = g.name; }
  }

  const parts = [];
  if (minDangerDist <= 1) {
    parts.push(`DANGER: ${nearestDangerName} is right there, almost certain death`);
  } else if (minDangerDist <= 3) {
    parts.push(`risky: ${nearestDangerName} (dangerous) is only ${minDangerDist} tile(s) away`);
  }
  if (minFrightDist <= 5) {
    parts.push(`edible ghost ${nearestFrightName} ${minFrightDist} tile(s) away \u2014 chase for bonus points`);
  }

  const { nearestPelletDist, nearestPowerDist, reachableTiles } = exploreFrom(grid, sx, sy, 10);
  if (nearestPowerDist !== null) parts.push(`power pellet ${nearestPowerDist} tile(s) away`);
  if (nearestPelletDist !== null) parts.push(`nearest pellet ${nearestPelletDist} tile(s) away`);
  else if (reachableTiles <= 3) parts.push("dead end, no pellets reachable this way");
  else parts.push("no pellets found within range this way");

  return parts.join("; ");
}

// Builds a request body shaped like the jev / ollama "systemone" examples,
// ready to be curled straight at a decision model. Each legal direction's
// `criteria` entry is a concrete, per-direction analysis (see
// describeDirection) rather than a generic label, since that's what the
// classifier actually compares between choices.
function buildDecisionPrompt() {
  if (!latestState) return null;
  const s = latestState;
  const legal = s.pacman.legalMoves || [];
  const dirs = legal.length ? legal : ["up", "down", "left", "right"];

  const stateText =
    `Pac-Man is at tile (${s.pacman.tileX},${s.pacman.tileY}), currently moving ` +
    `${s.pacman.direction}. ${s.pelletsRemaining} pellets remain on the board.`;

  const criteria = {};
  for (const dir of dirs) {
    criteria[dir] = describeDirection(s, dir);
  }

  return {
    model: "tev1:4b",
    state: stateText,
    questions: {
      move: {
        type: "choice",
        instructions: "Pick the direction whose description below is safest and leads to " +
          "pellets soonest. Never pick a direction marked DANGER unless every option is.",
        criteria
      }
    }
  };
}

// --------------------------------------------------------- decision engine
// Does the actual HTTP call to ollama and returns its raw, unprocessed JSON
// response — used both by callOllama() (autoplay) and by the
// GET /api/decision/call debug endpoint, which exposes this verbatim
// alongside the request that produced it.
async function callOllamaRaw(prompt) {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), OLLAMA_TIMEOUT_MS);
  try {
    const res = await fetch(OLLAMA_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ ...prompt, model: OLLAMA_MODEL }),
      signal: controller.signal
    });
    if (!res.ok) throw new Error(`ollama http ${res.status}`);
    return await res.json();
  } finally {
    clearTimeout(timer);
  }
}

async function callOllama(prompt) {
  const data = await callOllamaRaw(prompt);
  const answer = data && data.answers && data.answers.move;
  const choice = answer && answer.choice;
  if (!DIRECTIONS.has(choice)) throw new Error("ollama response had no usable move.choice");
  return { choice, probabilities: answer.probabilities || {}, confidence: answer.confidence };
}

// Compact, single-line rendering of per-choice probabilities plus overall
// confidence, highest first, e.g. "left=0.98 right=0.02 conf=0.85".
function formatOllamaScores(probabilities, confidence) {
  const parts = Object.entries(probabilities || {})
    .sort((a, b) => b[1] - a[1])
    .map(([dir, p]) => `${dir}=${p.toFixed(2)}`);
  if (typeof confidence === "number") parts.push(`conf=${confidence.toFixed(2)}`);
  return parts.join(" ");
}

async function autoplayTick() {
  const tickStartedAt = Date.now();
  if (autoplayEnabled && latestState) {
    const prompt = buildDecisionPrompt();
    let direction = null, error = null, elapsedMs = null, probabilities = null, confidence = null;

    if (prompt) {
      const startedAt = Date.now();
      try {
        const result = await callOllama(prompt);
        direction = result.choice;
        probabilities = result.probabilities;
        confidence = result.confidence;
      } catch (err) {
        error = String((err && err.message) || err);
      } finally {
        elapsedMs = Date.now() - startedAt;
      }
    }

    if (direction) pendingDirection = direction;
    if (latestState.gameState === "gameover" && !pendingActions.includes("restart")) {
      pendingActions.push("restart"); // keep the self-play demo going indefinitely
    }

    autoplayInfo = {
      lastDirection: direction, lastError: error, lastElapsedMs: elapsedMs,
      lastProbabilities: probabilities, lastConfidence: confidence, lastAt: Date.now()
    };
    // One line per move: ollama was called, its per-choice scores, how long
    // it took, and what came back, e.g. `[ollama] "left=0.98 right=0.02
    // conf=0.85" -> left (53ms)`.
    console.log(error
      ? `[ollama] call failed after ${elapsedMs}ms: ${error}`
      : `[ollama] "${formatOllamaScores(probabilities, confidence)}" -> ${direction} (${elapsedMs}ms)`);
  }
  // Pace ticks AUTOPLAY_INTERVAL_MS apart measured from tick *start*, not
  // stacked on top of however long the ollama call took — otherwise a
  // 480ms call turns into a ~880ms gap between moves instead of ~480ms.
  const nextDelay = Math.max(0, AUTOPLAY_INTERVAL_MS - (Date.now() - tickStartedAt));
  setTimeout(autoplayTick, nextDelay);
}

// ---------------------------------------------------------------- server
const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, `http://${req.headers.host || "localhost"}`);
  const { pathname } = url;

  if (req.method === "OPTIONS") return send(res, 204, "");

  try {
    if (req.method === "GET" && (pathname === "/" || pathname === "/pacman.html")) {
      const html = fs.readFileSync(HTML_PATH, "utf8");
      return send(res, 200, html, "text/html; charset=utf-8");
    }

    // Internal: the page pushes its live state and picks up queued commands.
    if (req.method === "POST" && pathname === "/api/sync") {
      const body = await readJsonBody(req);
      latestState = body;
      lastSyncAt = Date.now();
      const cmd = {
        direction: pendingDirection,
        actions: pendingActions,
        autoplay: { enabled: autoplayEnabled, error: autoplayInfo.lastError }
      };
      pendingDirection = null;
      pendingActions = [];
      return send(res, 200, cmd);
    }

    // External: read-only game state for a human or a decision model.
    if (req.method === "GET" && pathname === "/api/state") {
      if (!latestState) return send(res, 503, { ok: false, error: "no game page connected yet" });
      return send(res, 200, { ok: true, ageMs: Date.now() - lastSyncAt, state: latestState });
    }

    // External: ready-to-curl jev/ollama-style decision request body.
    if (req.method === "GET" && pathname === "/api/decision") {
      const prompt = buildDecisionPrompt();
      if (!prompt) return send(res, 503, { ok: false, error: "no game page connected yet" });
      return send(res, 200, prompt);
    }

    // External: actually calls ollama with the current decision request and
    // returns both, for debugging/inspection — independent of the autoplay
    // loop (does not touch pendingDirection or autoplayInfo).
    if (req.method === "GET" && pathname === "/api/decision/call") {
      const request = buildDecisionPrompt();
      if (!request) return send(res, 503, { ok: false, error: "no game page connected yet" });
      try {
        const response = await callOllamaRaw(request);
        return send(res, 200, { ok: true, request, response });
      } catch (err) {
        return send(res, 502, { ok: false, request, error: String((err && err.message) || err) });
      }
    }

    // External: drive Pac-Man's next direction, e.g.
    //   curl -X POST localhost:8787/api/move -d '{"direction":"up"}'
    if (req.method === "POST" && pathname === "/api/move") {
      const body = await readJsonBody(req);
      const dir = body.direction;
      if (!DIRECTIONS.has(dir)) {
        return send(res, 400, { ok: false, error: "direction must be one of up/down/left/right" });
      }
      pendingDirection = dir;
      return send(res, 200, { ok: true, queued: dir });
    }

    // External: pause/resume/restart, e.g.
    //   curl -X POST localhost:8787/api/control -d '{"action":"restart"}'
    if (req.method === "POST" && pathname === "/api/control") {
      const body = await readJsonBody(req);
      const action = body.action;
      if (!ACTIONS.has(action)) {
        return send(res, 400, { ok: false, error: "action must be one of pause/resume/restart" });
      }
      pendingActions.push(action);
      return send(res, 200, { ok: true, queued: action, pending: pendingActions.slice() });
    }

    // Toggle/inspect the self-play loop, e.g.
    //   curl -X POST localhost:8787/api/autoplay -d '{"enabled":false}'
    if (req.method === "GET" && pathname === "/api/autoplay") {
      return send(res, 200, { enabled: autoplayEnabled, ...autoplayInfo, ollamaUrl: OLLAMA_URL, model: OLLAMA_MODEL });
    }
    if (req.method === "POST" && pathname === "/api/autoplay") {
      const body = await readJsonBody(req);
      if (typeof body.enabled === "boolean") autoplayEnabled = body.enabled;
      return send(res, 200, { enabled: autoplayEnabled });
    }

    return send(res, 404, { ok: false, error: "not found" });
  } catch (err) {
    return send(res, 500, { ok: false, error: String((err && err.message) || err) });
  }
});

server.listen(PORT, () => {
  /* eslint-disable no-console */
  console.log(`Pac-Man server running at http://localhost:${PORT}`);
  console.log(`  Open the game (it plays itself by default): http://localhost:${PORT}/`);
  console.log(`  Query state:            curl http://localhost:${PORT}/api/state`);
  console.log(`  Get decision prompt:    curl http://localhost:${PORT}/api/decision`);
  console.log(`  Call ollama + see both: curl http://localhost:${PORT}/api/decision/call`);
  console.log(`  Move Pac-Man:           curl -X POST http://localhost:${PORT}/api/move -d '{"direction":"up"}'`);
  console.log(`  Pause/resume/restart:   curl -X POST http://localhost:${PORT}/api/control -d '{"action":"pause"}'`);
  console.log(`  Toggle autoplay:        curl -X POST http://localhost:${PORT}/api/autoplay -d '{"enabled":false}'`);
  console.log(`  Autoplay requires ollama at ${OLLAMA_URL} (model ${OLLAMA_MODEL}). No moves are queued while it is unreachable.`);
});

autoplayTick();
