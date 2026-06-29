# Email Categorization

How the morning brief buckets the inbox, learns the user's categories over time, and
keeps noise (spam, promotions, flagged-as-unwanted mail) out of the brief.

## The goal

Turn a raw inbox into a short, bucketed snapshot, e.g. "20 inbound leads, 5 system
errors, 3 customer replies awaiting you" rather than a list of 60 subject lines. Counts
for the routine stuff, one-liners only for what actually needs the user.

## Defining categories

Categories come from the user's PROFILE. Typical sets:

- **For someone with a job**: inbound leads, system errors / alerts, customer
  escalations, internal/team, approvals/sign-offs needed, personal/admin.
- **For a job seeker**: interviews & scheduling, recruiter replies owed, application
  updates, job alerts, rejections, offers, personal.

Each category should say what belongs in it and, where possible, a concrete signal:
a sender domain, a subject pattern, or an email label/folder the user already uses.

## Learning and refining categories

1. **Reuse existing labels/folders.** If the user already labels or filters mail (e.g.
   a "Leads" label, a "Jobs/*" label tree), map categories to those first. They encode
   the user's own judgment.
2. **Infer from senders.** Group by sender domain and recurring subject patterns to
   propose buckets. Alerting systems, CRMs, ticketing tools, and recruiters each have
   stable sender signatures.
3. **Confirm edge cases, then remember.** When a message does not fit cleanly, make a
   conservative call and note it in the run-back so the user can correct. Fold confirmed
   corrections into the PROFILE's category definitions so the next run improves.
4. **Counts over contents.** High-volume, low-stakes categories (alerts, newsletters,
   confirmations) are summarized as a number. Reserve one-liners for items that need a
   human decision.

## Excluding noise

Never bring these into the brief:

- Spam and trash.
- Promotions and social-category mail, unless it clearly contains something that matters
  (e.g. a job alert for a job seeker).
- Marketing newsletters the user has not flagged as important.
- Anything the user has flagged as "not needed" — honor an explicit deny list in the
  PROFILE (senders, domains, or subjects the user said to skip). Add to this list
  whenever the user says "stop showing me X."
- Threads the user already replied to with nothing new since.

## Flagged / unwanted handling

If the user marks brief items as unwanted (replies "drop the X stuff", stars/labels
something as ignore), record that signal in the PROFILE deny list during the next setup
or update pass, so it is excluded going forward. The brief should get quieter and more
accurate over time, never noisier.
