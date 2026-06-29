# Connectors

## How tool references work

This plugin is provider agnostic. Plugin files use `~~category` as a placeholder for
whatever tool you connect in that category, instead of naming a specific product. During
setup, the plugin asks which provider you use for each category and wires the brief to it.

## Connectors for this plugin

| Category | Placeholder  | Options                          | Required?                          |
| -------- | ------------ | -------------------------------- | ---------------------------------- |
| Email    | `~~email`    | Gmail, Outlook                   | Yes (the brief is built around it) |
| Calendar | `~~calendar` | Google Calendar, Outlook         | Recommended                        |
| Chat     | `~~chat`     | Slack, Microsoft Teams           | Optional                           |

## Notes

- **Delivery by email** (sending the brief to your inbox so it arrives like normal mail)
  uses browser control of your email web app. Connect the browser extension, or approve
  it on the first run. If you prefer, the brief can instead be saved as a draft for you
  to send, or simply shown in chat.
- **Calendar without a connector**: if no calendar connector is available, the brief can
  read your calendar through its web app in the browser, using the same browser access
  used to send the email.
- **Chat is opt-in and scoped**: the brief only reads the specific channels or DMs you
  name during setup, never your whole workspace.
