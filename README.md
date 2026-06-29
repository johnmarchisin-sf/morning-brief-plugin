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

The whole point of this layout is fast iteration: edit, commit, push, and your tester pulls.

1. **First push** (create the GitHub repo first, named `morning-brief-plugin`, public):

   ```
   cd morning-brief-plugin
   git init
   git add .
   git commit -m "Morning Brief plugin v0.2.0"
   git branch -M main
   git remote add origin https://github.com/johnmarchisin-cx/morning-brief-plugin.git
   git push -u origin main
   ```

2. **Each tweak afterward**:
   - Make your edits under `plugins/morning-brief/`.
   - Bump the `version` in BOTH `plugins/morning-brief/.claude-plugin/plugin.json` and the
     matching entry in `.claude-plugin/marketplace.json` (version bumps are what signal an
     update). Use semver, e.g. `0.2.0` -> `0.2.1`.
   - Commit and push:

     ```
     git add .
     git commit -m "Describe the change"
     git push
     ```

   - Tell your tester to run `/plugin marketplace update morning-brief-plugin`.

### Repo layout

```
morning-brief-plugin/
├── .claude-plugin/
│   └── marketplace.json          # marketplace manifest (lists the plugin)
├── plugins/
│   └── morning-brief/            # the plugin itself
│       ├── .claude-plugin/plugin.json
│       ├── README.md
│       ├── CONNECTORS.md
│       └── skills/
│           ├── setup/            # onboarding + cold-start provisioning
│           └── daily-brief/      # the daily run
├── README.md                     # this file
├── LICENSE
└── .gitignore
```

## License

MIT. See `LICENSE`.
