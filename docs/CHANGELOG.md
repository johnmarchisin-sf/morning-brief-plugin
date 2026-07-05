# Changelog

What changed in each version of the Morning Brief plugin. Newest first.

Versions follow semver and match the `version` field in `plugin.json` and
`marketplace.json`. A version bump is what tells installed copies to update, so every
shipped change lands under a version heading here.

Each entry is grouped by area so setup, run, and error handling changes stay easy to scan:

- **Setup** — onboarding, provisioning, profile, scheduling.
- **Daily brief** — the morning run: triage, compose, deliver.
- **Error handling** — fallbacks, limits, guardrails, failure behavior.
- **Tooling and docs** — release script, tests, docs, changelog, feedback.
- **Other** — anything that does not fit above.

While working, add lines under `Unreleased`. When you cut a release, move them under a new
version heading with the version number.

## Unreleased

### Daily brief
- Added profile-driven custom sections: a CUSTOM SECTIONS block in the profile defines named,
  actionable sections (title, sources, what a match looks like, fields to extract per item, and
  an action rule for what needs attention), and the brief collects and renders them during the
  normal triage pass. Empty sections are skipped by default. Unlike a category, a custom section
  extracts detail and drives action instead of just counting matches. (Tester 2)

### Setup
- Onboarding and profile updates can now define custom sections; adding one to an existing
  profile is documented as the standard light update path, no re-onboarding. (Tester 2)
- Added a Step 0 pre-flight audit: setup now verifies connectors and environment and reports
  gaps before building, instead of assuming readiness. (Tester 1)
- Call out that email must be connected with inbox READ access, not only draft or compose, so a
  draft-only connection no longer fails the morning run. (Tester 1)
- Added a path for sources that need their own MCP server (runtime, install, credentials,
  registering in `claude_desktop_config.json`, quit and relaunch, verify), so custom MCP sources
  are supported without hardcoding any one provider. (Tester 1)
- Noted that scheduled tasks only fire while Claude Desktop is open, and that clicking "Run now"
  once in the Scheduled panel stores the approvals so automatic runs do not pause. (Tester 1)
- Prefer a single connected Chrome profile to avoid a "which browser?" step. (Tester 1)

### Tooling and docs
- Added `scripts/release.sh` to bump both manifests, commit, tag, and push in one step, with
  a guard that refuses to release unless you are on an up to date `main`.
- Added `test/sample-profile.md`, a fake profile with delivery forced to chat only, for safe
  dry runs of `daily-brief` in a worktree.
- Rewrote `docs/dev-workflow.md`: corrected the rollback section to match how the marketplace
  update actually works (roll forward from a tag, not a local checkout), added the release
  precondition of being on a synced `main`, and fixed the repo layout.
- Added this changelog and `docs/feedback.md` for tracking changes and tester feedback.
- Reconciled `README.md` maintainer section to point at the scripted release flow.

## 0.2.0

First tracked release. Baseline of the plugin as it shipped.

### Setup
- Onboarding flow that asks only for what it cannot already infer.
- Cold start provisioning for brand-new accounts: creates a working folder, an `about-me.md`
  reusable context file, and a `morning-brief-profile.md` editable copy.
- Provider agnostic source selection: Gmail or Outlook, Google Calendar or Outlook Calendar,
  Slack or Microsoft Teams. Chat is opt-in and scoped to named channels or DMs.
- Builds a PROFILE block and creates a scheduled `morning-brief` task on a cron time.
  Re-running updates the existing task instead of duplicating it.
- Optional test run at the end of setup to preview the result and pre-approve tools.

### Daily brief
- Email triage over the last ~24 hours, bucketed into the user's categories, with fires
  (time sensitive, important senders, top of what matters) surfaced up top.
- Optional chat pass over named channels: mentions, threads awaiting reply, decisions only.
- Calendar for today via connector, or the calendar web app in the browser as a fallback.
- Concise brief: top 3 priorities, on fire, today's calendar, inbox snapshot, later today.
- Styled HTML email delivery, with three modes: sent to inbox, draft for review, or shown
  in chat.

### Error handling
- Large digest and alert emails: read the snippet or subject first and only open full content
  when a detail is needed, to avoid blowing size limits.
- Delivery fallback: if sending from the browser fails, the styled draft is left in place and
  the run reports that it drafted rather than sent, and why.
- Calendar fallback to the browser web app when no calendar connector is available.
- Conservative by design: never invents emails, events, or messages; prefers undercounting to
  surfacing noise.
