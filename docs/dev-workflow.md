# Morning Brief: Developer Workflow in Conductor

A guide to tweaking the Morning Brief plugin the developer way: branch, test, release,
and update your live brief only when you choose to. Nothing here touches your running
morning brief until you deliberately pull an update.

## The core idea

Treat the brief as two separate things:

1. **Source**: this GitHub repo, edited through Conductor on branches. Experiment freely here.
2. **Live install**: the plugin and scheduled task that actually run each morning.

The live brief changes only when a tester runs the marketplace update command. That
separation is what keeps experiments from ever disturbing the brief you rely on.

A second separation matters too: your real PROFILE (name, email, sources, schedule) lives
in the scheduled task, not in the repo. So pulling an update changes the run logic, never
your personal data. The two are updated independently, on purpose.

## Repo layout

```
morning-brief-plugin/
├── .claude-plugin/
│   └── marketplace.json                    # marketplace manifest (lists the plugin + version)
├── plugins/
│   └── morning-brief/
│       ├── .claude-plugin/plugin.json      # plugin manifest + version
│       ├── README.md
│       ├── CONNECTORS.md
│       └── skills/
│           ├── setup/                      # onboarding + cold start provisioning
│           │   ├── SKILL.md
│           │   └── references/
│           └── daily-brief/                # the daily run
│               ├── SKILL.md
│               └── references/
├── scripts/
│   └── release.sh                          # version bump + commit + tag + push, in one step
├── test/
│   └── sample-profile.md                   # fake profile for safe dry runs
├── docs/
│   ├── dev-workflow.md                     # this file
│   ├── CHANGELOG.md                        # what changed in each version
│   └── feedback.md                         # tester feedback log
├── README.md
└── LICENSE
```

## What was set up for this workflow

These pieces make iteration safe and reversible:

1. **Tag `v0.2.0`** marks the source snapshot that is live right now. It is your recovery
   anchor: it is how you get the exact files of a past release back.
2. **`scripts/release.sh`** bumps the version in both `plugin.json` and `marketplace.json`
   (including the nested `plugins[]` entry), then commits, tags, and pushes. Keeping the two
   version fields in lockstep is what signals an update to installed copies, and the script
   removes the risk of forgetting one. It refuses to run unless you are on an up to date
   `main`, so a release always tags the commit that actually ships.
3. **`test/sample-profile.md`** is a fake profile with delivery forced to chat only, so you
   can dry run `daily-brief` in a worktree without touching your real inbox or live task.
4. **`docs/CHANGELOG.md`** records what changed in each version. **`docs/feedback.md`** logs
   tester feedback and links each item to the version that addresses it.

## The everyday loop

1. **Branch per tweak.** In Conductor, start a new workspace. It creates an isolated
   worktree on its own branch, so nothing you do can affect other work or your live brief.

2. **Make the change** under `plugins/morning-brief/`.

3. **Test in the worktree.** Dry run against the fake profile so nothing gets sent:

   > run my morning brief using test/sample-profile.md, delivery = show in chat

   Because the data is fake and delivery is chat only, this never reaches your inbox or your
   scheduled task.

4. **Note it in the changelog.** Add a line under the `Unreleased` heading in
   `docs/CHANGELOG.md`, in the section that fits (Setup, Daily brief, Error handling,
   Tooling and docs, or Other).

5. **Merge.** Open a PR, review the diff, and merge to `main`. Merging means the source is
   updated. Your live brief has still not changed.

6. **Cut a release** when you want the new behavior available to testers. See below.

7. **Update your live brief** only when you want the new behavior running:

   ```
   /plugin marketplace update morning-brief-plugin
   ```

## Cutting a release

A release is what testers actually pick up, so it must come from `main`:

1. Switch to `main` and sync it:

   ```
   git checkout main
   git pull --ff-only
   ```

2. In `docs/CHANGELOG.md`, move the `Unreleased` notes under a new version heading, then
   commit that:

   ```
   git commit -am "Changelog for 0.2.1"
   ```

3. Cut the release. The script checks you are on an up to date `main`, refuses a dirty
   tree, bumps both manifests, commits the bump, tags, and pushes:

   ```
   scripts/release.sh 0.2.1 "Tighten inbox categorization"
   ```

4. Tell your tester to run `/plugin marketplace update morning-brief-plugin`.

## Rolling back

Understand the mechanism first, because a local checkout does not roll a tester back.

- Testers pick up whatever is on `main`, and the **version numbers in the manifests** are
  what mark a new build. Tags are source snapshots on your machine. Checking out a tag
  locally changes nothing that a tester has installed.
- So you roll back by rolling **forward**: restore the prior version's plugin files onto
  `main`, then cut a new release with a **higher** version number that carries that prior
  behavior. Because the version goes up, the update is detected, and behavior returns to the
  known good state.

```
git checkout main && git pull --ff-only
git checkout v0.2.0 -- plugins/morning-brief    # recover the plugin as it was at v0.2.0
git commit -am "Restore plugin behavior from v0.2.0"
scripts/release.sh 0.2.4 "Roll back plugin behavior to v0.2.0"
```

The `git checkout v0.2.0 -- plugins/morning-brief` step restores the plugin files (including
their old version string); `release.sh` then bumps everything to the new higher version. Add
a changelog entry noting the rollback and why.

## Tracking changes and feedback

- **`docs/CHANGELOG.md`** is the record of what shipped in each version. Update it as part of
  every change, and finalize the version heading when you cut the release.
- **`docs/feedback.md`** is the log of tester feedback. Paste each writeup in, tag each item
  open or planned or done, and link the item to the changelog version that addresses it. That
  keeps the loop closed: a report goes in, becomes an `Unreleased` changelog line, ships in a
  version, and gets marked done in the feedback log.

## Rules of thumb

- Keep `main` matching what is live. When they drift, cut a release and update.
- Never commit real profile data or secrets. Personal data belongs in the scheduled task.
- Tag every release. A version with no tag has no clean way to recover its files.
- Always dry run against the fake profile before merging anything that changes the run logic.
- Every change earns a changelog line. Every tester report earns a feedback entry.
