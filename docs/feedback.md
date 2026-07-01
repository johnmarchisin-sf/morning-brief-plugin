# Tester Feedback Log

Where tester feedback lives and gets tracked to resolution. Newest round first.

## How to use this file

1. Paste each tester's writeup into a new round below, with the date and the version they
   tested.
2. Break the writeup into individual items. Give each a status:
   - **open** — captured, not yet decided.
   - **planned** — accepted, will be worked. Add it as an `Unreleased` line in
     `docs/CHANGELOG.md`.
   - **done** — shipped. Note the version that addressed it.
   - **wontfix** — declined. Say why in one line.
3. When an item ships, set it to **done** and link the version. That closes the loop from
   report to changelog to release.

## Item template

```
- [status] Short description of the item.
  Area: setup | daily brief | error handling | tooling | other
  Version tested: 0.2.0
  Resolution: (none yet) | see CHANGELOG 0.2.1 | wontfix: reason
```

---

## Rounds

### 2026-07-01 — Tester 1 (RingCentral / custom MCP variant of 0.2.0)

Context: this tester used a chat source (RingCentral) wired through a custom MCP server
(`scrivers/cerca-rc-pkm-mcp`), which the shipped plugin does not support. Most items are
about standing up that MCP server; a few generalize to any setup. Grouped below.

**Generalizable to the plugin (worth folding into the setup skill):**

- [planned] Setup should audit the machine and connectors and report gaps BEFORE building
  anything, instead of assuming things are ready. Verify, report pass/fail, fix the gaps.
  Area: setup
  Version tested: 0.2.0
  Resolution: see CHANGELOG Unreleased (Step 0 pre-flight audit)

- [planned] Gmail must be connected with inbox READ access, not just draft/compose. A draft-only
  connection returns "requires additional permissions" on inbox reads and forces a reconnect.
  Area: setup
  Version tested: 0.2.0
  Resolution: see CHANGELOG Unreleased (read-scope callout in Step 0 and Step 3)

- [planned] After creating the scheduled task, click "Run now" once in the Scheduled panel so it
  stores connector approvals and future automatic runs do not pause for permissions.
  Area: setup
  Version tested: 0.2.0
  Resolution: see CHANGELOG Unreleased (Step 5)

- [planned] Scheduled tasks only fire while the Claude Desktop app is open; if it is closed at
  run time, the task runs at next launch. Document as a schedule caveat.
  Area: setup
  Version tested: 0.2.0
  Resolution: see CHANGELOG Unreleased (Step 4 caveat)

- [planned] Claude in Chrome extension must be installed and signed in for browser delivery and
  browser fallbacks. Ideally one connected Chrome profile, signed into the sites the brief
  needs, so runs do not stop to ask "which browser?".
  Area: setup
  Version tested: 0.2.0
  Resolution: see CHANGELOG Unreleased (Step 0 and Step 3)

**Custom MCP provider support (needs a product decision, see dev notes):**

- [planned] The plugin only supports click-to-connect providers. A source that needs its own MCP
  server (like RingCentral) has a whole prerequisites path the setup skill does not cover:
  install a modern Python (macOS 3.9 is too old for the `mcp` package), register the server by
  editing `~/Library/Application Support/Claude/claude_desktop_config.json`, then fully quit
  and reopen Claude. No `claude` CLI on a normal Desktop machine, so registration is file edits.
  Area: setup / connectors
  Version tested: 0.2.0
  Resolution: see CHANGELOG Unreleased (generic "sources that need their own MCP server" path in
  Step 3; provider-agnostic, no single provider hardcoded)

**RingCentral-specific (belongs with the RingCentral MCP repo, or a provider reference if we
add RingCentral as a first-class source):**

- [wontfix] Biggest friction: the RingCentral developer app. Must use JWT auth flow, NOT
  3-legged OAuth (wrong type throws OAU-251, which looks like a credential error but is not).
  Client ID, Client Secret, and JWT must all belong to the SAME app. A duplicated/pasted-twice
  Client ID silently breaks auth. Optional Bot Add-in app only if you want a phone push.
  Area: reference
  Version tested: 0.2.0
  Resolution: wontfix here: RingCentral-specific values belong with the
  `scrivers/cerca-rc-pkm-mcp` repo's README, not this provider-agnostic plugin. The generic MCP
  path in Step 3 points users to their server's own docs for these.

- [wontfix] Credentials live in a file named exactly `.env` in the repo root; the venv should
  live outside iCloud (e.g. `~/.venvs/ringcentral-mcp`); clone the repo to a known stable path.
  Area: reference
  Version tested: 0.2.0
  Resolution: wontfix here: same as above. The generic MCP path captures the reusable shape
  (credentials file, isolated env outside cloud sync, stable path) without the RingCentral names.

**Minor:**

- [planned] zsh does not treat `#` as a comment on pasted lines; strip comment lines from any
  commands handed to the user, or they error.
  Area: other
  Version tested: 0.2.0
  Resolution: see CHANGELOG Unreleased (noted in the Step 3 MCP path)
