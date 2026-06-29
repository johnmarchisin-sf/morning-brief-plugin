# HTML Email Template

Use this to render the morning brief as a styled email. Fill the `{placeholders}` with the
brief content. Keep it readable in under 90 seconds.

## Rules that keep it rendering correctly in email clients

- Inline styles only. No `<style>` blocks, no external CSS, no classes.
- Colored bands (the header) must use a SOLID `background-color` AND the `bgcolor`
  attribute. Email clients (Gmail) strip CSS gradients, which would leave white text on
  white. Never rely on a gradient.
- Use table-based layout for the cards so spacing holds across clients.
- Light card backgrounds are fine to lose; dark text on them stays readable either way.
- Keep the sun emoji in the header (&#9728;&#65039;) and a warning emoji for conflicts
  (&#9888;&#65039;).

## Delivery flow

Create a draft via the email connector with this as the `htmlBody` (and a plain-text
`body` fallback), then open that draft in the browser and send it. Do not type HTML into
a compose window; typing only inserts plain text.

## Template

```html
<div style="background-color:#f3f4f6;padding:24px 12px;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Helvetica,Arial,sans-serif;">
<table align="center" width="600" cellpadding="0" cellspacing="0" role="presentation" style="max-width:600px;width:100%;background-color:#ffffff;border-radius:16px;overflow:hidden;border:1px solid #e5e7eb;">
<tr><td bgcolor="#F59E0B" style="background-color:#F59E0B;padding:26px 32px;">
<div style="font-size:26px;font-weight:700;color:#ffffff;">&#9728;&#65039; Morning Brief</div>
<div style="font-size:14px;color:#fff7ed;margin-top:4px;">{Weekday}, {Month} {D}, {Year}{ &middot; holiday if any}</div></td></tr>
<tr><td style="padding:24px 32px 6px;"><p style="margin:0;font-size:16px;line-height:1.55;color:#111827;">{greeting line}</p></td></tr>
<tr><td style="padding:18px 32px 2px;"><div style="font-size:12px;font-weight:700;letter-spacing:0.09em;text-transform:uppercase;color:#9ca3af;margin-bottom:12px;">Top 3 Priorities Today</div>
<!-- PRIORITY CARD x3. Card 1: bg #fffbeb, border #fde68a, badge #F59E0B. Card 2: bg #eef2ff, border #c7d2fe, badge #6366f1. Card 3: bg #ecfdf5, border #a7f3d0, badge #10b981. -->
<table width="100%" cellpadding="0" cellspacing="0" role="presentation" style="margin-bottom:10px;background-color:#fffbeb;border:1px solid #fde68a;border-radius:12px;"><tr><td width="58" valign="top" style="padding:14px 0 14px 16px;"><div style="width:32px;height:32px;border-radius:50%;background-color:#F59E0B;color:#ffffff;font-weight:700;font-size:15px;line-height:32px;text-align:center;">1</div></td><td style="padding:14px 18px 14px 6px;"><div style="font-size:15px;font-weight:600;color:#111827;line-height:1.4;">{priority 1 title}</div><div style="font-size:13px;color:#6b7280;margin-top:3px;line-height:1.45;">{priority 1 detail}</div></td></tr></table>
</td></tr>
<tr><td style="padding:14px 32px 2px;"><div style="background-color:#f0fdf4;border:1px solid #bbf7d0;border-radius:10px;padding:12px 16px;font-size:14px;color:#166534;"><strong>On fire:</strong> {fires, or "Nothing time sensitive."}</div></td></tr>
<tr><td style="padding:18px 32px 2px;"><div style="font-size:12px;font-weight:700;letter-spacing:0.09em;text-transform:uppercase;color:#9ca3af;margin-bottom:8px;">Today's Calendar</div><div style="font-size:14px;color:#374151;line-height:1.5;">{events, or "No events scheduled."}</div>
<!-- conflict callout ONLY if needed -->
<div style="margin-top:10px;background-color:#fef2f2;border:1px solid #fecaca;border-left:4px solid #ef4444;border-radius:10px;padding:12px 16px;"><div style="font-size:13px;font-weight:700;color:#b91c1c;margin-bottom:4px;">&#9888;&#65039; {conflict heading}</div><div style="font-size:14px;color:#374151;line-height:1.5;">{conflict detail}</div></div></td></tr>
<tr><td style="padding:18px 32px 2px;"><div style="font-size:12px;font-weight:700;letter-spacing:0.09em;text-transform:uppercase;color:#9ca3af;margin-bottom:10px;">Worth Applying / Key Items</div>
<!-- item card; alternate left accent #6366f1 / #10b981 -->
<table width="100%" cellpadding="0" cellspacing="0" role="presentation" style="margin-bottom:10px;background-color:#fafafa;border:1px solid #e5e7eb;border-left:4px solid #6366f1;border-radius:10px;"><tr><td style="padding:14px 16px;"><div style="font-size:15px;font-weight:600;color:#111827;">{item title}</div><div style="font-size:13px;color:#6b7280;margin-top:3px;">{item detail} &middot; <span style="color:#9ca3af;">{source}</span></div></td></tr></table></td></tr>
<tr><td style="padding:18px 32px 2px;"><div style="font-size:12px;font-weight:700;letter-spacing:0.09em;text-transform:uppercase;color:#9ca3af;margin-bottom:10px;">Inbox Snapshot &middot; last 24h</div>
<table width="100%" cellpadding="0" cellspacing="0" role="presentation" style="font-size:14px;color:#374151;">
<!-- count pill: nonzero/matters = bg #eef2ff color #4338ca ; zero = bg #f3f4f6 color #6b7280 -->
<tr><td style="padding:7px 0;border-bottom:1px solid #f3f4f6;">{category}</td><td align="right" style="padding:7px 0;border-bottom:1px solid #f3f4f6;"><span style="background-color:#eef2ff;color:#4338ca;font-weight:700;font-size:12px;padding:3px 10px;border-radius:999px;">{n}</span></td></tr>
<tr><td colspan="2" style="padding:9px 0 0;font-size:13px;color:#6b7280;line-height:1.5;"><strong style="color:#374151;">Personal:</strong> {personal items}</td></tr></table></td></tr>
<tr><td style="padding:16px 32px 4px;"><div style="font-size:12px;font-weight:700;letter-spacing:0.09em;text-transform:uppercase;color:#9ca3af;margin-bottom:6px;">Later Today</div><div style="font-size:13px;color:#6b7280;line-height:1.5;">{batched non-urgent items}</div></td></tr>
<tr><td style="padding:18px 32px 26px;border-top:1px solid #f3f4f6;"><div style="font-size:13px;color:#9ca3af;">Have a good one. &mdash; Your morning brief</div></td></tr>
</table></div>
```

## Theming

The accent color is amber `#F59E0B` (the sun). To re-theme for a different user, change the
header `bgcolor`/`background-color` and the three priority-card accents to their preferred
palette. Keep contrast high: white text only on solid dark/saturated bands.
