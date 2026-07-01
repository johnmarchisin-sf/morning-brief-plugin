# Sample Profile (TEST DATA — not real)

Use this to dry-run the `daily-brief` skill inside a Conductor worktree without
touching your live scheduled task. Everything here is fake. Point a test run at
this profile, and have delivery set to "Show in chat" so nothing gets sent.

```
=====================================================================
PROFILE  —  TEST FIXTURE (fake data)
=====================================================================

IDENTITY
- Name: Test User (address as "Test")
- Email: test.user@example.com
- Location / timezone: San Francisco, America/Los_Angeles

CURRENT STATUS  (last updated 2026-07-01)
- Product manager at Acme Co (fictional).
- Primary focus right now: shipping the Q3 launch.
- Secondary: hiring a designer.

WORK STYLE: deep focus AM.
  Protect mornings; surface only true fires up top and batch the rest into
  Later today.

WHAT MATTERS (priority signal, high to low)
1. Messages from manager (Dana Lee) and customer escalations.
2. Launch blockers and anything tagged urgent.
3. Recruiting replies from candidates.

SOURCES
- Email: provider = Gmail. Connector tool prefix: {test/fake}.
- Calendar: provider = Google Calendar. {test/fake}.
- Chat: provider = Slack. Channels/DMs that matter: #launch, DMs from Dana.

EMAIL CATEGORIES (how to bucket the inbox each morning)
- Needs reply: direct asks addressed to me.
- FYI: cc'd threads, status updates.
- Recruiting: candidate and recruiter mail.

ALWAYS EXCLUDE (never bring into the brief)
- Spam and trash.
- Promotions and social mail unless it clearly matters.
- Marketing newsletters not flagged important.
- Threads already replied to with nothing new since.

IMPORTANT SENDERS (always surface): Dana Lee (dana@example.com), any @bigcustomer.example.

DELIVERY: Show in chat (TEST — never send during a dry run).
  Recipient: test.user@example.com. Subject: "Morning Brief: {Weekday} {Mon} {D}".
  Tone: executive assistant, warm, concise. No dashes.

SCHEDULE: 6:30am weekdays.
```

## How to use in a Conductor worktree

1. Open this branch/worktree in Conductor.
2. Ask: "run my morning brief using test/sample-profile.md, delivery = show in chat".
3. Review the output. Because delivery is chat-only and the data is fake, this
   never touches your real inbox or your live scheduled task.
