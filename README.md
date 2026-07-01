# Morning Brief — Plugin Marketplace

This repository is a Claude plugin **marketplace** that hosts one plugin, **morning-brief**.
Hosting it as a marketplace (rather than a one-off file) means whoever installs it can pull
your updates with a single command whenever you push a change.


## What the plugin does

An executive-assistant morning brief. Every morning it triages your email and calendar
(and, optionally, named chat channels), figures out what actually needs you, and delivers
one concise brief: top 3 priorities, what is on fire, today's calendar, and a clean inbox
snapshot. It is provider agnostic (Gmail or Outlook, Google or Outlook Calendar, Slack or
Teams), and for a brand-new account it will first create a working folder and a reusable
personal context file so it has somewhere to store what it learns about you.

The plugin ships two skills:
- **setup** — onboarding and reconfiguration, including first-time provisioning for empty accounts.
- **daily-brief** — the run itself, triggered on schedule or on demand ("run my morning brief").

---

## For the tester — install and keep updated

1. **Add the marketplace** (one time):

   ```
   /plugin marketplace add johnmarchisin-cx/morning-brief-plugin
   ```

2. **Install the plugin**:

   ```
   /plugin install morning-brief@morning-brief-plugin
   ```

3. **Turn it on**: say `set up my morning brief` and answer the short onboarding. On a
   brand-new account it will create your working folder and context files first.

### Pulling updates later

When the maintainer pushes a new version, refresh the marketplace and the plugin updates:

```
/plugin marketplace update morning-brief-plugin
```

In the Claude desktop app, plugins and marketplaces can also be managed from
**Settings > Capabilities** if you prefer buttons to slash commands.

---

## For the maintainer (John) — shipping updates

The developer loop (branch, dry run against a fake profile, merge, release, roll back) lives
in **`docs/dev-workflow.md`**. Read that for the full flow. In short:

1. Make edits under `plugins/morning-brief/` on a branch, and dry run against
   `test/sample-profile.md` with delivery set to chat so nothing gets sent.
2. Note the change under `Unreleased` in `docs/CHANGELOG.md`.
3. Merge to `main`, then cut a release from a synced `main`:

   ```
   scripts/release.sh 0.2.1 "Describe the change"
   ```

   The script bumps the version in both manifests (which is what signals an update), commits,
   tags, and pushes.
4. Tell your tester to run `/plugin marketplace update morning-brief-plugin`.

Tester feedback is logged and tracked to resolution in **`docs/feedback.md`**.

### Repo layout

```
morning-brief-plugin/
├── .claude-plugin/
│   └── marketplace.json          # marketplace manifest (lists the plugin + version)
├── plugins/
│   └── morning-brief/            # the plugin itself
│       ├── .claude-plugin/plugin.json
│       ├── README.md
│       ├── CONNECTORS.md
│       └── skills/
│           ├── setup/            # onboarding + cold-start provisioning
│           └── daily-brief/      # the daily run
├── scripts/
│   └── release.sh                # version bump + commit + tag + push
├── test/
│   └── sample-profile.md         # fake profile for safe dry runs
├── docs/
│   ├── dev-workflow.md           # the maintainer loop
│   ├── CHANGELOG.md              # what changed per version
│   └── feedback.md               # tester feedback log
├── README.md                     # this file
├── LICENSE
└── .gitignore
```

## License

MIT. See `LICENSE`.
