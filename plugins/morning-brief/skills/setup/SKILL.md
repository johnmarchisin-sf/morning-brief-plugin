---
name: setup
description: Set up or reconfigure the user's daily morning brief. Use when the user says "set up my morning brief", "configure my morning brief", "start my morning briefing", "change my morning brief", "update my morning brief profile", "I got a new job, update my brief", or asks to connect systems / change the schedule for their daily brief. Walks the user through a short onboarding, provisions a working folder and context files for brand-new accounts, helps connect their email, calendar, and chat tools, writes their profile, and creates (or updates) the scheduled morning run.
---

# Morning Brief — Setup

Set up a personalized executive-assistant morning brief for the user, or reconfigure an existing one. The end state is a scheduled task that runs every morning, triages the user's email and calendar (and optionally chat), and sends them one concise brief.

Keep the conversation in plain language. Do not expose file paths or schema details unless asked. Frame everything as what the brief will do for them.

## Step 0 — Pre-flight audit (verify, do not assume)

Before building anything, check that the environment is actually ready and report the result
to the user, item by item, as pass or needs action. Do not assert things are set up; verify
them and fix the gaps together first. This is what keeps a setup fast instead of stalling
halfway through.

- **Email connector scope.** Confirm the email source is connected with inbox READ access,
  not only draft or compose. A draft-only connection returns "requires additional
  permissions" on inbox reads and has to be reconnected and re-approved for viewing mail.
- **Calendar connector.** Confirm the calendar source is connected, or note that it will be
  read through the browser (Step 3 fallback).
- **Claude in Chrome extension.** Confirm it is installed and signed in. It is required for
  sent-to-inbox delivery and for reading calendar in the browser. Prefer a single connected
  Chrome profile, signed into the sites the brief needs, so runs do not stop to ask which
  browser to use.
- **Sources that need their own MCP server.** If a chosen source is not click-to-connect (see
  Step 3), verify its prerequisites before continuing rather than discovering them mid-setup.

Report what passes and what needs action, walk the user through the gaps, then continue.

## Step 1 — Read what you already know

Before asking anything, gather context so you do not ask for things you can already infer:

- Check whether a Cowork working folder is connected. If none is connected, note it: this is a strong signal of a brand-new account that needs first-time provisioning (Step 1b).
- Check for connected connectors and tools (email, calendar, chat). Note which providers are present (Gmail vs Outlook, Google Calendar vs Outlook, Slack vs Teams).
- Check existing scheduled tasks for a task named `morning-brief`. If one exists, this is a reconfigure: read its current profile block and confirm what is changing rather than starting from scratch.
- Look for any memory, profile, or context files about the user (name, role, company, what they care about). In a connected folder, look for an `about-me.md` and a `morning-brief-profile.md`. Use whatever you find to pre-fill answers.

Decide the path:

- **Cold start** — no working folder AND no profile/memory/context about the user. Do Step 1b first, then Step 2.
- **Returning user / reconfigure** — a folder, profile, or `morning-brief` task already exists. Skip Step 1b. Tell the user briefly what you already know, then only ask for the gaps.

## Step 1b — First-time provisioning (only on a cold start)

Run this only when Step 1 found essentially nothing (think: someone who just created their Claude account). The goal is to give the user a home for their context before onboarding, so the brief and future sessions have somewhere to read and write. Say in one friendly line that you will set up a home for their information first, then ask the quick questions.

1. **Working folder.** If no Cowork working folder is connected, use the request-directory tool so the user can pick or create one (suggest a simple name like "Claude" or "My Workspace"). Everything below lives in that folder. If the user declines a folder, continue, but warn them their context will live only inside the scheduled task and will not be an editable file they can open.
2. **Reusable context file.** Create a personal context file named `about-me.md` at the root of that folder, using `references/personal-context-template.md` as the structure. This is a general profile that other skills and future sessions can reuse, not just this plugin. You will fill it from the Step 2 answers, so it is fine to create it now and populate it once Step 2 is done.
3. **Brief profile file.** After Step 4 assembles the PROFILE block, also save a copy as `morning-brief-profile.md` in the folder so the user can read and edit it outside a session. Make clear that the scheduled task is what actually runs each morning, and `about-me.md` plus this file are the human-friendly copies.
4. **Then onboard.** Because the account was empty, expect to ask everything in Step 2 (nothing could be pre-filled).

Do not create accounts, change security settings, or enter credentials during provisioning. Only create folders and plain files, and let the user authenticate connectors in their own flow.

## Step 2 — Onboard (ask only what is missing)

Use AskUserQuestion. Ask only for what you could not infer in Step 1 (on a cold start, that is everything). Cover:

1. **Sources** — which systems should the brief pull from? Email (almost always), calendar, and optionally chat. Identify the provider for each: `~~email` (Gmail, Outlook), `~~calendar` (Google Calendar, Outlook Calendar), `~~chat` (Slack, Microsoft Teams). If chat is selected, ask which channels or DMs matter (the brief only reads the ones they name).
2. **Current status / role** — who they are right now: their name, role, company, OR that they are between roles / job searching / a student / etc. This shapes what counts as important. Capture it plainly. Make clear they can change it any time.
3. **Work style** — deep focus in the morning, admin first thing, meeting-driven, or flexible. This sets how the brief frames the day (protect mornings vs clear comms first vs lead with meeting prep).
4. **What matters to them** — the high-priority signals (e.g. messages from their manager, customer escalations, inbound leads, interviews, deadlines). Ask for their important people and senders.
5. **Email categories** — how they want the inbox bucketed (e.g. inbound leads, system errors, customer issues, personal). See `references/email-categorization.md` and walk them through it. Also capture what to always exclude (spam, promotions, newsletters, anything they flag).
6. **Custom sections (optional)** — anything they track that deserves its own named section in the brief, beyond the standard categories. A custom section is actionable, not just a bucket: it pulls specific fields out of each matching item and applies a rule for what needs attention (e.g. a recruiter tracking resume requests per candidate: name, the role they are attached to, and the timeline they stated). For each one, capture the fields in the profile template's CUSTOM SECTIONS block: title, sources, what a match looks like, the fields to extract, and the action rule. Most users skip this at first setup; mention it exists and move on unless they bite.
7. **Delivery** — how they want it: a real email sent to their inbox (lands like normal mail), a draft they review, or shown in chat. Sent-to-inbox uses the browser to compose and send from their email.
8. **Schedule** — what time, and whether daily or weekdays only.

If the user says "whatever you think is best," propose specific defaults (deep-focus AM, sent-to-inbox at 7am daily, exclude promotions/social/spam) and confirm.

## Step 3 — Connect the systems

For each source the user chose that is not already connected, help them connect it:

- Search the connector registry for the chosen provider and suggest the connector for them to connect.
- When connecting email, make sure the connection grants inbox READ access, not only draft or compose. A draft-only connection cannot triage the inbox and will fail the morning run.
- If no connector exists for a source (common for calendar), the brief can read it via the browser instead (e.g. the calendar web app) using the same browser access used to send the email. Tell the user this is the fallback.
- Email send-to-inbox requires browser control of their email web app. Confirm the browser extension is connected, or that they will approve it on first run. Prefer a single connected Chrome profile so runs do not add a "which browser?" step.

Do not enter any passwords or credentials yourself. Direct the user to authenticate in the connector's own flow.

### Sources that need their own MCP server

Some sources are not click-to-connect and need a local MCP server (for example a provider with
no built-in connector). These require setup before the brief can read them. Do not assume any
of it is in place; verify each step and fix gaps with the user. Follow the specific server's own
README for exact values; the shape below is what generalizes:

1. **Runtime.** Confirm the server's runtime meets its minimum. A common trap on macOS is the
   bundled Python 3.9, which is too old for the `mcp` package; install a current Python first if
   so.
2. **Install the server.** Clone or install it to a known, stable path, and install its
   dependencies in an isolated environment kept outside cloud-synced folders (e.g. not inside
   iCloud).
3. **Credentials.** Create the provider's developer app and mint its credentials as the server
   documents, then place them exactly where it expects (often a file named `.env` in its root).
   Test that authentication actually succeeds; do not just confirm the file exists.
4. **Register it.** On Claude Desktop, add the server to
   `~/Library/Application Support/Claude/claude_desktop_config.json` (there is no `claude` CLI on
   a normal Desktop machine, so registration is a config-file edit), then fully quit with Cmd+Q
   and reopen Claude so it loads.
5. **Verify.** Confirm the server's tools appear and a real call works before wiring the brief to
   it.

When you hand the user shell commands, strip comment lines first: zsh does not treat `#` as a
comment on pasted input, so commented lines error.

## Step 4 — Build the profile and create the scheduled task

1. Assemble the user's answers into a profile block using `references/profile-template.md` as the structure. Fill every field from Step 2.
2. If this was a cold start (Step 1b ran), now write `about-me.md` and `morning-brief-profile.md` into the working folder as described there.
3. Create a scheduled task via the scheduled-tasks tool:
   - taskId: `morning-brief`
   - schedule: a cron expression for their chosen time (local time). Daily = `M H * * *`; weekdays = `M H * * 1-5`.
   - prompt: the FULL run logic from the `daily-brief` skill, with the assembled profile block pasted in at the top as the editable "PROFILE" section. The prompt must be self-contained because each scheduled run starts fresh. Substitute the user's actual `~~email`, `~~calendar`, and `~~chat` providers and the exact connector tool names for the providers they connected.
4. If a `morning-brief` task already exists (reconfigure), UPDATE it instead of creating a duplicate.
5. Tell the user how scheduled runs behave: the task only fires while the Claude Desktop app is open, so if the app is closed at run time the brief runs at next launch.

## Step 5 — Offer a test run

Offer to run it once now so the user can see the result and pre-approve the browser/email tools (so future runs do not pause for permissions). If they accept, run the `daily-brief` logic immediately and confirm the brief was sent or drafted.

The most reliable way to store approvals for the scheduled task itself is to click "Run now"
once in the Scheduled panel after the task is created. That persists the connector and browser
approvals against the task, so the automatic runs do not stop to ask for permissions.

## Updating later

When the user's situation changes (new job, different systems, new important people), they just say "update my morning brief profile" and you re-run this skill: read the existing task's profile block (and `about-me.md` / `morning-brief-profile.md` if present), change only what they tell you, and update the task and the files. Remind them that the scheduled task's PROFILE block is the single source of truth, with `morning-brief-profile.md` as the editable copy they can open any time.

Adding a custom section is the most common update: the user describes something they want
tracked as its own section ("I want the brief to capture X"), and you translate it into a
CUSTOM SECTIONS entry (Step 2, item 6) in their existing profile. No re-onboarding; add the
entry, update the task and files, and offer a test run so they can see the new section on
real data.
