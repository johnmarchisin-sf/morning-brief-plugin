# Profile Template

This is the structure of the editable PROFILE block that goes at the top of the
scheduled `morning-brief` task. Fill every field from the user's onboarding answers.
This block is the single source of truth the user edits when their situation changes.

```
=====================================================================
PROFILE  —  EDIT THIS SECTION ANY TIME YOUR SITUATION CHANGES
(Single source of truth. Everything below the profile is run logic.)
=====================================================================

IDENTITY
- Name: {full name, and how to address them}
- Email: {primary email address}
- Location / timezone: {city, timezone}

CURRENT STATUS  (last updated {YYYY-MM-DD})
- {Role at Company, or "between roles / job searching", or "student", etc.}
- Primary focus right now: {the one thing that matters most}
- Secondary: {anything else worth tracking}

WORK STYLE: {deep focus AM | admin first | meeting-driven | flexible}.
  {One line on how that should shape the brief, e.g. "Protect mornings; surface
  only true fires up top and batch the rest into Later today."}

WHAT MATTERS (priority signal, high to low)
1. {e.g. messages from manager / customer escalations / interviews}
2. {...}
3. {...}

SOURCES
- Email: ~~email provider = {Gmail | Outlook}. Connector tool prefix: {actual tool names}.
- Calendar: ~~calendar provider = {Google Calendar | Outlook | none}. {connector | read via browser}.
- Chat: ~~chat provider = {Slack | Teams | none}. Channels/DMs that matter: {list, or "none"}.

EMAIL CATEGORIES (how to bucket the inbox each morning)
- {Category name}: {what belongs here, label/filter hints}
- {Category name}: {...}
  (See email-categorization.md for how to learn and refine these.)

CUSTOM SECTIONS (optional; "none" if unused)
Each entry becomes its own named section in the brief. Unlike a category, a custom
section is actionable: it extracts specific fields per item and says what to do with
them, instead of just counting matches.
- Title: {section heading as it should appear in the brief}
  Sources: {email | chat | both; name the specific channels/DMs if chat}
  Watch for: {what a match looks like, in plain language}
  Capture per item: {the fields to extract, e.g. person; what it relates to; stated
    timeline or next step}
  Action: {what makes an item need attention today, e.g. "flag anyone who promised
    something and went quiet"; omit for FYI-only}
  Show when empty: {yes | no (default no — skip the section on quiet days)}

ALWAYS EXCLUDE (never bring into the brief)
- Spam and trash.
- Promotions and social mail unless it clearly matters.
- Marketing newsletters not flagged important.
- Anything the user flagged as "not needed".
- Threads the user already replied to with nothing new since.

IMPORTANT SENDERS (always surface): {names, addresses, domains}.

DELIVERY: {Sent email to inbox via browser | Draft for review | Show in chat}.
  Recipient: {email}. Subject: "Morning Brief: {Weekday} {Mon} {D}".
  Tone: executive assistant, warm, concise. {Any house style notes, e.g. no dashes.}

SCHEDULE: {time} {daily | weekdays}.
```
