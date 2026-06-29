---
name: setup
description: Set up or reconfigure the user's daily morning brief. Use when the user says "set up my morning brief", "configure my morning brief", "start my morning briefing", "change my morning brief", "update my morning brief profile", "I got a new job, update my brief", or asks to connect systems / change the schedule for their daily brief. Walks the user through a short onboarding, provisions a working folder and context files for brand-new accounts, helps connect their email, calendar, and chat tools, writes their profile, and creates (or updates) the scheduled morning run.
---

# Morning Brief — Setup

Set up a personalized executive-assistant morning brief for the user, or reconfigure an existing one. The end state is a scheduled task that runs every morning, triages the user's email and calendar (and optionally chat), and sends them one concise brief.

Keep the conversation in plain language. Do not expose file paths or schema details unless asked. Frame everything as what the brief will do for them.

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
6. **Delivery** — how they want it: a real email sent to their inbox (lands like normal mail), a draft they review, or shown in chat. Sent-to-inbox uses the browser to compose and send from their email.
7. **Schedule** — what time, and whether daily or weekdays only.

If the user says "whatever you think is best," propose specific defaults (deep-focus AM, sent-to-inbox at 7am daily, exclude promotions/social/spam) and confirm.

## Step 3 — Connect the systems

For each source the user chose that is not already connected, help them connect it:

- Search the connector registry for the chosen provider and suggest the connector for them to connect.
- If no connector exists for a source (common for calendar), the brief can read it via the browser instead (e.g. the calendar web app) using the same browser access used to send the email. Tell the user this is the fallback.
- Email send-to-inbox requires browser control of their email web app. Confirm the browser extension is connected, or that they will approve it on first run.

Do not enter any passwords or credentials yourself. Direct the user to authenticate in the connector's own flow.

## Step 4 — Build the profile and create the scheduled task

1. Assemble the user's answers into a profile block using `references/profile-template.md` as the structure. Fill every field from Step 2.
2. If this was a cold start (Step 1b ran), now write `about-me.md` and `morning-brief-profile.md` into the working folder as described there.
3. Create a scheduled task via the scheduled-tasks tool:
   - taskId: `morning-brief`
   - schedule: a cron expression for their chosen time (local time). Daily = `M H * * *`; weekdays = `M H * * 1-5`.
   - prompt: the FULL run logic from the `daily-brief` skill, with the assembled profile block pasted in at the top as the editable "PROFILE" section. The prompt must be self-contained because each scheduled run starts fresh. Substitute the user's actual `~~email`, `~~calendar`, and `~~chat` providers and the exact connector tool names for the providers they connected.
4. If a `morning-brief` task already exists (reconfigure), UPDATE it instead of creating a duplicate.

## Step 5 — Offer a test run

Offer to run it once now so the user can see the result and pre-approve the browser/email tools (so future runs do not pause for permissions). If they accept, run the `daily-brief` logic immediately and confirm the brief was sent or drafted.

## Updating later

When the user's situation changes (new job, different systems, new important people), they just say "update my morning brief profile" and you re-run this skill: read the existing task's profile block (and `about-me.md` / `morning-brief-profile.md` if present), change only what they tell you, and update the task and the files. Remind them that the scheduled task's PROFILE block is the single source of truth, with `morning-brief-profile.md` as the editable copy they can open any time.
