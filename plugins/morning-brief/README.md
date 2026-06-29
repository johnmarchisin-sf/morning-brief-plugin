# Morning Brief

Your own executive-assistant morning brief. Every morning it triages your email and
calendar (and, if you want, specific chat channels), figures out what actually needs you,
and delivers one concise brief: what to catch up on, what is on fire, your top 3
priorities, and a clean inbox snapshot.

It is provider agnostic. It works with Gmail or Outlook, Google Calendar or Outlook
Calendar, Slack or Microsoft Teams. You pick your tools during setup.

## What it does

- Reads the last 24 hours of email and buckets it into your categories (for example
  inbound leads, system errors, customer replies) with counts, not noise.
- Keeps spam, promotions, newsletters, and anything you flag as unwanted out of the brief.
- Pulls today's calendar, flags conflicts and anything that needs prep, and notes
  upcoming important events.
- Optionally scans named chat channels for mentions and threads awaiting your reply.
- Surfaces your top 3 priorities, framed around your work style (deep-focus mornings,
  admin first, or meeting-driven).
- Delivers the brief by sending it to your inbox as a real email, saving it as a draft,
  or showing it in chat.

## Getting started

Say "set up my morning brief." The setup skill will:

1. Read what your Claude already knows about you so it does not ask twice.
2. Ask a few questions: your systems, your current role or focus, your work style, what
   matters to you, how to bucket your inbox, when to run, and how to deliver.
3. Help you connect the right tools.
4. Create your scheduled morning run.
5. Offer a test run so you can see it immediately.

## Skills

- **setup** — onboarding and reconfiguration. Run it any time to set up the brief or to
  change your systems, schedule, or profile.
- **daily-brief** — the run itself. Triggered automatically by the schedule, or on demand
  when you say "run my morning brief."

## Changing things later

Your profile is the single source of truth and lives at the top of your scheduled run.
When your situation changes (new job, new tools, new people who matter), just say
"update my morning brief profile" and the setup skill walks the changes with you.

## Connectors

See `CONNECTORS.md` for the tool categories and options. Sending the brief to your inbox
and reading a calendar without a connector both use the browser extension.
