# Morning Brief — Software Prerequisites

Everything a tester needs installed before the brief can run. Work top to bottom. The
"Base plugin" section covers every tester. Only do the "Custom MCP source" section if the
tester pulls from a source that has no click to connect connector (for example
RingCentral).

Setup itself runs a Step 0 pre-flight audit that checks most of this and reports gaps, but
having it in place first makes onboarding fast instead of stalling halfway through.

## Base plugin (every tester)

| # | Software | Why it is needed | How to get it |
| - | -------- | ---------------- | ------------- |
| 1 | macOS | The plugin and Claude Desktop are built and tested here. | Already on the tester's Mac. |
| 2 | Claude Desktop app | Hosts the plugin and runs the scheduled morning task. Scheduled runs only fire while this app is open. | Download from claude.ai. Sign in. |
| 3 | Morning Brief plugin | The brief itself (setup and daily-brief skills). | Install from the plugin marketplace, then say "set up my morning brief". |
| 4 | Google Chrome or Microsoft Edge | Required for delivery that sends the brief to the inbox, and for reading a calendar that has no connector. | Chrome is the primary, most tested path. Edge works too (it is Chromium and installs the same extension). Sign into the sites the brief needs (email web app, calendar). Prefer one signed in profile so runs do not stop to ask which browser to use. |
| 5 | Claude in Chrome extension | Gives Claude the browser control used for sent to inbox delivery and browser calendar fallback. | Install the extension (version 1.0.36 or higher) from the Chrome Web Store and sign in. It runs in both Chrome and Edge. On Edge, if browser control does not connect on the first try, that is usually the native messaging host registering under Edge's own path; retry or reinstall the extension. |

## Connectors (choose per category, connected during setup)

These are not local installs. They are click to connect authorizations the tester approves
inside Claude during setup. Listed here so testers know what accounts they need on hand.

| Category | Options | Required? | Note |
| -------- | ------- | --------- | ---- |
| Email | Gmail, Outlook | Yes | Must grant inbox READ access, not only draft or compose. A draft only connection fails the morning inbox read. |
| Calendar | Google Calendar, Outlook | Recommended | If not connected, the brief reads it through the browser web app instead. |
| Chat | Slack, Microsoft Teams | Optional | The brief only reads the specific channels or DMs the tester names. |

## Custom MCP source (only if the source has no connector)

Some sources are not click to connect and need their own local MCP server. RingCentral is
the current example. Follow the specific server's own README for exact values; the shape
below is what every custom source needs.

| # | Software | Why it is needed | Notes |
| - | -------- | ---------------- | ----- |
| 1 | Python 3.12 from python.org | The MCP server's vendored wheels are built for 3.12 specifically. | Not "modern Python". Not 3.11 or 3.13. The macOS system Python 3.9 is too old for the `mcp` package. Claude Desktop bundles Node, not Python, so this is a separate install. |
| 2 | The source's MCP server | Reads the source and exposes its tools to the brief. | Newer builds ship as a one click `.mcpb` Claude Desktop extension: install it, fill in the form, fully quit and relaunch Claude. Older builds are a manual clone plus a virtual environment kept outside cloud synced folders (not inside iCloud), registered by editing `~/Library/Application Support/Claude/claude_desktop_config.json`. |
| 3 | Provider developer credentials | Authenticate the MCP server against the source. | Created in the provider's developer app and stored where the server expects (an install form, or a file named exactly `.env` in its root). Test that authentication actually succeeds, do not just confirm the file exists. |

### Gotchas that still bite (custom MCP)

- Install Python 3.12 first. Anything else fails to import the vendored wheels.
- After installing an MCP server or extension, fully quit Claude Desktop with Cmd+Q and
  reopen it. Closing the window is not enough; the server only loads on a real quit and
  relaunch.
- Keep any manual virtual environment out of iCloud and at a stable path, or it breaks when
  the folder syncs or moves.
- When pasting shell commands, strip comment lines first. zsh does not treat `#` as a
  comment on pasted input, so commented lines error.

## Quick checklist

Base plugin, every tester:

- [ ] macOS
- [ ] Claude Desktop app, signed in
- [ ] Morning Brief plugin installed
- [ ] Google Chrome or Microsoft Edge, signed into the sites the brief needs
- [ ] Claude in Chrome extension, installed and signed in
- [ ] Email connector with inbox READ access
- [ ] Calendar connector or browser calendar fallback
- [ ] Chat connector (optional)

Custom MCP source only:

- [ ] Python 3.12 from python.org
- [ ] The source's MCP server installed and registered
- [ ] Provider credentials created and verified
- [ ] Claude fully quit and relaunched, server tools visible
