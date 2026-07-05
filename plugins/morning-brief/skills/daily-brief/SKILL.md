---
name: daily-brief
description: Generate and deliver the user's executive-assistant morning brief now. Use when the user says "run my morning brief", "morning brief", "give me my brief", "catch me up this morning", or when the scheduled morning-brief task fires. Triages email and calendar (and named chat channels), surfaces top priorities and fires, and delivers one concise brief by sending it to the inbox, drafting it, or showing it in chat per the user's profile.
---

# Morning Brief — Daily Run

Produce ONE concise executive-assistant brief from the user's email, calendar, and
(optionally) chat, then deliver it per their profile. Run end to end without
questions back to the user. This is the canonical run logic; the scheduled
`morning-brief` task embeds a copy of these steps with the user's profile pasted on top.

Read the PROFILE block (in the scheduled task prompt, or ask the user to point you at
their setup if running manually). It defines identity, what matters, sources,
categories, exclusions, important senders, delivery, and schedule. Honor any house
style notes (e.g. no dashes in prose).

## Step 0 — Setup
- Get today's date and weekday.
- Load the connector tools for the user's providers: `~~email`, `~~calendar`, `~~chat`,
  plus browser tools if delivery is sent-to-inbox or calendar is read via browser.

## Step 1 — Email triage
- Pull email from the last ~24 hours, excluding sent, drafts, spam, trash, and the
  promotions/social buckets (unless a promo clearly carries something that matters).
- Read the consequential threads in full. Bucket each into the user's EMAIL CATEGORIES.
  Drop everything in ALWAYS EXCLUDE and any thread the user already handled.
- Identify the FIRES: anything time sensitive today, anything an important sender is
  waiting on, anything matching the top of WHAT MATTERS.
- Large digest/alert emails can blow size limits: read the snippet/subject first and
  only open full content when you need a specific detail; if full content is too large,
  work from the snippet.
- See `references/email-categorization.md` for how to learn and refine categories and
  how to respect user-flagged "not needed" mail.

## Step 2 — Chat (only if a chat source is configured)
- For each named channel/DM in the profile, pull messages since yesterday.
- Surface only direct mentions, threads awaiting the user's reply, and decisions/asks
  that matter. Summarize the rest as a count. Do not dump channel chatter.

## Step 2b — Custom sections (only if the profile defines any)
- While triaging in Steps 1 and 2, also match items against each CUSTOM SECTIONS entry:
  scan that entry's sources for its "Watch for" pattern and extract the "Capture per
  item" fields for every match. One pass over the data; do not re-pull sources.
- A field with no stated value stays blank — never infer a name, timeline, or commitment
  the message does not contain.
- Apply the entry's "Action" rule to decide which matches need attention today versus
  are informational. Items needing attention also count toward FIRES if they meet the
  Step 1 bar.
- An item can appear in both a custom section and a category count; the custom section
  is where its extracted detail lives, so do not duplicate the detail elsewhere.

## Step 3 — Calendar
- Read today's events (via connector, or the calendar web app in the browser).
- List each event with its time. Flag conflicts, back-to-back blocks, and anything
  needing prep. Note upcoming interviews/important calls in the next few days.

## Step 4 — Compose the brief
Keep it tight and scannable. Readable in under 90 seconds. Honor house style.

  Good morning {name}. {one line: the single most important thing today, or
  "nothing on fire, clear runway for deep work."}

  TOP 3 PRIORITIES TODAY
  1. ...   2. ...   3. ...
  (Outcomes, not chores. Lead with whatever sits highest in WHAT MATTERS. Frame for
  their work style: deep-focus AM = protect the morning; admin-first = quick clears
  first; meeting-driven = lead with prep.)

  ON FIRE / TIME SENSITIVE
  - Only what needs action today. If none: "Nothing time sensitive."

  TODAY'S CALENDAR
  - {time} {event}   (or "No events scheduled.")  + UPCOMING note if relevant.

  INBOX SNAPSHOT (last 24h)
  - {Category}: {count} {one-liners for the ones that matter}
  - ...

  {CHAT SNAPSHOT — only if chat configured}
  - {channel}: {mentions / threads awaiting reply}

  {CUSTOM SECTIONS — one block per profile entry with matches}
  {TITLE FROM PROFILE}
  - {captured fields as one line per item, needs-attention items first}
  (Skip a section with no matches unless its profile entry says "Show when empty: yes",
  then render the title with one line: "Nothing new.")

  LATER TODAY (does not need your morning)
  - {batched non-urgent items}

## Step 4b — Style it as HTML
Build the brief as a styled HTML email, not raw text, using
`references/html-email-template.md`. A browser-typed email can only be plain text, so the
reliable way to deliver formatted mail is: create a DRAFT via the email connector with an
`htmlBody`, then send that draft from the browser. Always set BOTH a plain-text `body`
(simple fallback) and the `htmlBody`. Use solid `background-color` plus the `bgcolor`
attribute on colored bands (email clients strip CSS gradients).

## Step 5 — Deliver (per profile DELIVERY)
- **Sent email to inbox** (styled): create the draft with htmlBody via the email connector.
  Then in the browser, open the email web app, isolate THIS draft (search drafts by the
  "Morning Brief" subject so you never open another draft), open it, screenshot to confirm
  the styled header/cards rendered and the recipient is only the user, then click Send and
  confirm the "sent" toast.
- **Draft for review**: create the styled draft and stop there; tell the user it is ready to send.
- **Show in chat**: render the brief in the reply.
- FALLBACK: if sending from the browser fails, leave the styled draft in place and say it
  was drafted not sent, and why.

## Step 6 — Report back
One line: sent / drafted / shown, plus the headline (fires, interviews, offers, key items).
Do not repaste the whole brief.

Be conservative and accurate. Better to undercount than to surface noise. Never invent
emails, events, or messages.
