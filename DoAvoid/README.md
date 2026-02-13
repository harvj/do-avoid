# Do / Avoid 

Do / Avoid is a minimalist habit and reflection app focused on clarity, flexibility, and long-term use.

It is designed to be simple enough to live with quietly, while still providing meaningful personal feedback over time.

There are no accounts, no feeds, and no required routines.

Just a small space to notice patterns.

---

## Purpose

Most habit apps emphasize:

- Streaks
- Rankings
- Notifications
- Rigid daily expectations

Those tools work for some people.

Do / Avoid is built for people who want something lighter and more adaptable.

It supports consistency without demanding it.

It supports memory without turning it into pressure.

---

## Core Concept

Each item is either:

- A **Do** — something you want to practice
- An **Avoid** — something you want to reduce

Each day, an item may be:

- Marked or unmarked
- Given an optional note
- Given an optional numeric value (user-defined meaning)

There is no required daily check-in.

Engagement is optional.

---

## Daily Status Logic

### Do Items
- Default state: neutral
- When tapped: marked as done (green check)
- No status is shown unless explicitly marked

### Avoid Items
- Default state: successful (green check)
- When tapped: marked as failed (red X)
- Action is only required when the behavior occurs

This reflects the different nature of “doing” and “not doing.”

---

## Interface Overview

The app has three primary views:

### Field View (Default)
- Displays all items as horizontal bars
- Shows today’s status at a glance
- Supports filtering and display modes via gestures

### Create View
- Used to add new items
- Revealed by vertically dragging the Field
- Exists in the same vertical space (not a modal overlay)

### Timeline View (Landscape)
- Read-only historical view
- Displays item activity over time in a horizontal calendar layout

All views are physically connected and navigated through gestures.

---

## Interaction Design

The interface is largely gesture-based:

- Vertical swipes → navigation and filtering
- Horizontal swipes → display modes
- Long press → item history and notes
- Rotation → timeline view

Different visual layers (badges, numbers, color overlays) can be added or removed without changing core behavior.

Users control how much information they see.

---

## Optional Display Layers

Several elements can be toggled on or off:

- Numeric indicators (totals, frequencies, longevity)
- Status badges
- Color progression overlays

These are considered “views” on the same data, not requirements.

The default presentation is intentionally minimal.

---

## Data Model

Each item maintains:

- Creation date
- Type (Do / Avoid)
- Per-day entries
- Optional notes
- Optional numeric values

All visualizations are derived from this history.

There are no artificial scores.

---

## Color System (Optional View)

The color system provides a slow, visual summary of engagement patterns.

- Do items move through a gradual spectrum
- Avoid items subtly degrade and recover
- Extended inactivity returns items toward baseline
- Re-engagement accelerates recovery

Color is treated as an optional interpretive layer, not a primary metric.

---

## Long-Term Behavior

Items are not meant to remain permanently active.

Over time, many items will naturally stabilize and become “background habits.”

The app supports this by allowing items to visually mature or retire.

New cycles can be started if needed.

---

## Notifications

There are no notifications.

The app does not prompt, remind, or pressure.

It is designed to be opened when useful, not when demanded.

---

## Pricing Intent

- One-time purchase
- No subscriptions
- No accounts
- No analytics
- No data export requirements

Data remains local.

---

## Current Status

Active development.

Current priorities:

1. Reliable persistence
2. Stable gesture behavior
3. Timeline implementation
4. Clear item inspection view
5. Minimal, readable UI

Polish and refinement follow functionality.

---

## Intended Audience

This app is primarily built for its creator.

It may be useful to others who prefer:

- Low-friction tools
- Non-competitive tracking
- Flexible routines
- Quiet interfaces

It is not designed for performance tracking or social sharing.

---

## Technology

- Swift
- SwiftUI
- Local-first storage
- No backend services

Architecture may evolve.

---

## License

TBD

---

## Closing

Do / Avoid is an experiment in building software that supports awareness without requiring discipline.

If it works well, it should fade into the background of daily life.

That is the intended outcome.
