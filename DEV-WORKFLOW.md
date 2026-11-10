# Morning Brief: Developer Workflow in Conductor

A guide to tweaking the Morning Brief plugin the developer way: branch, test, deploy,
and update your live brief only when you choose to. Nothing here touches your running
morning brief until you deliberately pull an update.

## The core idea

Treat the brief as two separate things:

1. **Source**: this GitHub repo, edited through Conductor on branches. Experiment freely here.
2. **Live install**: the plugin and scheduled task that actually run each morning.

The live brief changes only when you run the marketplace update command. That separation
is what keeps experiments from ever disturbing the brief you rely on.

A second separation matters too: your real PROFILE (name, email, sources, schedule) lives
in the scheduled task, not in the repo. So pulling an update changes the run logic, never
your personal data. The two are updated independently, on purpose.

## Repo layout

```
morning-brief-plugin/
├── .claude-plugin/
│   └── marketplace.json          # marketplace manifest (lists the plugin + version)
├── plugins/
│   └── morning-brief/
│       ├── .claude-plugin/plugin.json   # plugin manifest + version
│       ├── skills/
│       │   ├── setup/            # onboarding + cold start provisioning
│       │   └── daily-brief/      # the daily run
│       └── CONNECTORS.md
├── scripts/
│   └── release.sh                # version bump + commit + tag + push, in one step
├── test/
│   └── sample-profile.md         # fake profile for safe dry runs
├── docs/
│   └── dev-workflow.md           # this file
└── README.md
```

## What was set up for this workflow

Three things now make iteration safe and reversible:

1. **Tag `v0.2.0`** marks the version that is live right now. It is your rollback anchor.
2. **`scripts/release.sh`** bumps the version in both `plugin.json` and `marketplace.json`
   (including the nested `plugins[]` entry), then commits, tags, and pushes. Keeping the two
   version fields in lockstep is what signals an update to installed copies, and the script
   removes the risk of forgetting one.
3. **`test/sample-profile.md`** is a fake profile with delivery forced to chat only, so you
   can dry run `daily-brief` in a worktree without touching your real inbox or live task.

These currently sit on the branch `chore/dev-workflow-tooling`, with the `v0.2.0` tag on
`main`. First step below is to push them.

## First time: push what is already staged

Run these in Conductor, which has your GitHub credentials:

```
# push the rollback tag
git push origin v0.2.0

# push the tooling branch, then open a PR and merge to main
git push -u origin chore/dev-workflow-tooling
```

After the branch merges, `main` has the release script and test profile.

## The everyday loop

1. **Branch per tweak.** In Conductor, start a new workspace. It creates an isolated
   worktree on its own branch, so nothing you do can affect other work or your live brief.

2. **Make the change** under `plugins/morning-brief/`.

3. **Test in the worktree.** Dry run against the fake profile so nothing gets sent:

   > run my morning brief using test/sample-profile.md, delivery = show in chat

   Because the data is fake and delivery is chat only, this never reaches your inbox or your
   scheduled task.

4. **Deploy.** Open a PR, review the diff, and merge to `main`. Merging to `main` means the
   source is updated. Your live brief has still not changed.

5. **Ship a version.** Cut a release, which bumps both manifests, tags, and pushes:

   ```
   scripts/release.sh 0.2.1 "Describe what changed"
   ```

6. **Update your live brief** only when you want the new behavior running:

   ```
   /plugin marketplace update morning-brief-plugin
   ```

## Rolling back

Every release is tagged, so reverting the live brief is quick:

```
git checkout v0.2.0        # or any earlier tag
```

Then reinstall the plugin from that checkout. Because the version bump drives updates, going
back to an earlier tagged version cleanly restores the prior behavior.

## Rules of thumb

- Keep `main` matching what is live. When they drift, cut a release and update.
- Never commit real profile data or secrets. Personal data belongs in the scheduled task.
- Tag every release. A version with no tag has no clean way back.
- Always dry run against the fake profile before merging anything that changes the run logic.
