# TODO.md

## Master migration roadmap

This document is the master roadmap for porting this SketchyBar configuration from `yabai` to `AeroSpace` while preserving the visual appearance of MiragianCycle's original setup.

The work should be completed in small, reviewable phases. Each phase should leave the repository in a usable state, or clearly document any temporary limitation before moving forward. Do not combine unrelated phases in a single change unless the user explicitly approves it.

Before every phase:

- Read `AGENTS.md`.
- Run `git status --short`.
- Inspect the relevant files before editing.
- Confirm whether the upstream SketchyBar configuration has been imported into this repository.
- Avoid modifying unrelated files.

After every phase:

- Run syntax checks for changed scripts.
- Run targeted manual tests.
- Record any known gaps before continuing.

## Phase 1: Repository audit

### Goal

Create a complete inventory of the current configuration, every `yabai` dependency, and every location that will need an AeroSpace replacement.

This phase should not perform the migration. It should produce a clear map of what exists and what must change.

### Files to modify

- `TODO.md`, only if audit findings need to be appended.
- `README.md`, only if the user asks to capture audit findings there.
- No SketchyBar runtime files should be changed in this phase.

Likely files to inspect:

- `sketchybarrc`
- `items/*`
- `plugins/*`
- `helpers/*`
- `colors.sh`
- `icons.sh`
- `settings.sh`
- Any existing `yabai` or window-management helper files
- Any existing AeroSpace config such as `aerospace.toml`

### Expected behavior

- Repository structure is understood.
- Every `yabai` command, signal, event name, and space/window/display assumption is identified.
- Every SketchyBar item that depends on window-manager state is identified.
- Every future AeroSpace integration point is identified.
- No runtime behavior changes.

### Test procedure

Run:

```sh
git status --short
rg --files
rg "yabai|space_changed|display_changed|window_focused|space_windows_change|window_created|window_destroyed"
rg "aerospace|AeroSpace"
```

If the upstream files are present, inspect each match and classify it as:

- Runtime dependency
- Comment or documentation
- Dead or unused code
- Candidate for AeroSpace replacement

### Success criteria

- There is a written inventory of all `yabai` dependencies.
- There is a written inventory of all likely AeroSpace integration points.
- No existing runtime files were modified unless explicitly approved.
- The next phase can start without rediscovering basic repository structure.

## Phase 2: Workspace compatibility

### Goal

Replace `yabai` space handling with AeroSpace numbered workspace handling.

This phase owns numbered workspaces, workspace highlighting, workspace switching, and AeroSpace-triggered workspace updates.

### Files to modify

Likely files:

- `items/spaces.sh`
- `items/workspaces.sh`
- `plugins/space.sh`
- `plugins/spaces.sh`
- `plugins/workspace.sh`
- `plugins/workspaces.sh`
- `helpers/aerospace.sh`
- `helpers/workspaces.sh`
- `sketchybarrc`
- AeroSpace event bridge scripts, if needed
- `aerospace.toml`, only if this repository owns AeroSpace event hooks and the user approves changing it

Actual filenames may differ. Match the repository's existing structure.

### Expected behavior

- SketchyBar displays numbered AeroSpace workspaces in numeric order.
- Focused workspace is highlighted using the upstream visual style.
- Empty and occupied workspaces retain the intended upstream distinction if the original design supports it.
- Clicking a workspace item focuses that AeroSpace workspace.
- AeroSpace workspace focus changes update SketchyBar promptly.
- Window moves between workspaces update occupancy indicators where supported.
- The bar no longer calls `yabai` for workspace behavior.

### Test procedure

Run syntax checks on changed scripts:

```sh
sh -n path/to/script.sh
zsh -n path/to/script.zsh
```

Run search checks:

```sh
rg "yabai" items plugins helpers sketchybarrc
rg "aerospace|AeroSpace" items plugins helpers sketchybarrc
```

Manual checks:

- Restart SketchyBar with `sketchybar --reload`.
- Focus each numbered workspace using AeroSpace keybindings.
- Focus each numbered workspace by clicking the SketchyBar item.
- Move a window from one workspace to another.
- Open and close windows on occupied and empty workspaces.
- Test numeric ordering, especially if workspace `10` exists.
- Test with multiple monitors if available.

### Success criteria

- Workspace items reflect AeroSpace state accurately.
- Highlighting updates on every workspace focus change.
- Workspace click handlers use AeroSpace, not `yabai`.
- No runtime workspace code depends on macOS Spaces IDs or `yabai` space indices.
- Event subscriptions are documented and repeatable.

## Phase 3: Front application and active window

### Goal

Port front application, active window, and focus-driven widgets from `yabai` assumptions to SketchyBar and AeroSpace-compatible events.

### Files to modify

Likely files:

- `items/front_app.sh`
- `items/window_title.sh`
- `plugins/front_app.sh`
- `plugins/window_title.sh`
- `plugins/window_focus.sh`
- `helpers/aerospace.sh`
- `helpers/windows.sh`
- `sketchybarrc`

Actual filenames may differ.

### Expected behavior

- Front application widget displays the active app name consistently.
- Active window detection works without `yabai`.
- Window title or active-window state updates when focus changes, if the upstream design includes that widget.
- Event subscriptions are minimal and reliable.
- Missing window data does not break the bar.

### Test procedure

Run syntax checks on changed scripts:

```sh
sh -n path/to/script.sh
zsh -n path/to/script.zsh
```

Manual checks:

- Switch between several apps.
- Switch between windows in the same app.
- Switch to a workspace with no normal windows.
- Close the focused window.
- Restart AeroSpace while SketchyBar is running.
- Restart SketchyBar while AeroSpace is running.

Search checks:

```sh
rg "yabai" items plugins helpers sketchybarrc
rg "front_app|window|focused" items plugins helpers sketchybarrc
```

### Success criteria

- Front app display is accurate after focus changes.
- Active window state does not rely on `yabai`.
- Event subscriptions update the widget without excessive polling.
- Empty or unavailable window state is handled gracefully.

## Phase 4: Remaining widgets

### Goal

Verify and preserve non-workspace widgets while making only compatibility fixes required by the migration.

Widgets in scope:

- Battery
- Calendar
- Clock
- Spotify
- Volume
- CPU

### Files to modify

Likely files:

- `items/battery.sh`
- `items/calendar.sh`
- `items/clock.sh`
- `items/spotify.sh`
- `items/volume.sh`
- `items/cpu.sh`
- `plugins/battery.sh`
- `plugins/calendar.sh`
- `plugins/clock.sh`
- `plugins/spotify.sh`
- `plugins/volume.sh`
- `plugins/cpu.sh`
- Shared settings files if widget layout depends on workspace changes

Actual filenames may differ.

### Expected behavior

- Existing widget visuals are preserved.
- Widgets continue updating on their intended events or timers.
- No widget gains a new `yabai` dependency.
- Any widget affected by workspace or layout changes is adjusted minimally.

### Test procedure

Run syntax checks on changed scripts:

```sh
sh -n path/to/script.sh
zsh -n path/to/script.zsh
```

Manual checks:

- Battery updates when charging state or percentage changes, if available.
- Calendar opens or displays as expected.
- Clock updates at the expected interval.
- Spotify/media state updates for play, pause, track change, and no-player state.
- Volume updates after volume and mute changes.
- CPU widget updates at the expected interval without visible lag.

Search checks:

```sh
rg "yabai" items plugins helpers sketchybarrc
```

### Success criteria

- Each remaining widget behaves at least as well as before the AeroSpace migration.
- Visual appearance remains consistent with the upstream design.
- Timers and polling intervals are documented where they exist.
- No unrelated widget rewrites were introduced.

## Phase 5: Visual polish

### Goal

Compare the AeroSpace port against the original visual design and tune only the visual details needed to preserve the upstream appearance.

Visual areas in scope:

- Animations
- Padding
- Borders
- Blur
- Typography
- Colors
- Icon alignment
- Label spacing
- Bracket and background sizing

### Files to modify

Likely files:

- `colors.sh`
- `icons.sh`
- `settings.sh`
- `items/*`
- `plugins/*`, only where visual state is set dynamically
- `sketchybarrc`

Actual filenames may differ.

### Expected behavior

- The bar visually matches MiragianCycle's configuration as closely as practical.
- AeroSpace-specific changes do not introduce visual drift.
- Focused, visible, occupied, and empty workspace states look intentional.
- Animation timing remains smooth and not distracting.
- Text and icons remain aligned across workspace state changes.

### Test procedure

Manual checks:

- Reload SketchyBar.
- Compare screenshots against the original configuration if reference images are available.
- Toggle between empty, occupied, focused, and visible workspaces.
- Test left, center, and right bar sections.
- Test with long app names and long media titles.
- Test light and dark desktop backgrounds if transparency or blur is used.
- Test on different display scale factors if available.

Search checks:

```sh
rg "color|font|padding|background|border|blur|shadow|drawing|animate" items plugins helpers settings.sh colors.sh sketchybarrc
```

### Success criteria

- Visual differences from upstream are either eliminated or documented.
- No text, icon, or background overlap is visible.
- Workspace state transitions are smooth.
- Padding and borders are consistent across widgets.
- Colors and typography remain centralized where practical.

## Phase 6: Performance optimization

### Goal

Make the port efficient, event-driven, and reliable during startup and frequent workspace changes.

Focus areas:

- Event-driven updates
- Reduced polling
- Startup time improvements
- Avoiding duplicate commands
- Avoiding full-bar refreshes for local state changes

### Files to modify

Likely files:

- `sketchybarrc`
- `plugins/*`
- `helpers/*`
- Any event bridge scripts
- Any launch or service scripts

Actual filenames may differ.

### Expected behavior

- SketchyBar startup is fast and deterministic.
- Workspace changes do not trigger unnecessary updates to unrelated widgets.
- AeroSpace queries are batched or cached only when it materially helps.
- Polling is reduced to widgets that genuinely need it.
- Repeated events do not create duplicate items or stale state.

### Test procedure

Manual checks:

- Time a SketchyBar reload before and after optimization.
- Rapidly switch workspaces.
- Rapidly move windows between workspaces.
- Restart AeroSpace.
- Restart SketchyBar.
- Watch for delayed highlights, stale occupancy, or flickering.

Command checks:

```sh
rg "sleep|while|--update|mach_helper|update_freq|script=" items plugins helpers sketchybarrc
```

Use system tools such as Activity Monitor only as needed to verify that scripts are not consuming excessive CPU.

### Success criteria

- Workspace updates feel immediate.
- Unrelated widgets are not refreshed during workspace-only changes.
- Polling is minimized and justified.
- Startup does not produce visible stale state after initial load.
- CPU usage remains reasonable during idle and rapid workspace switching.

## Phase 7: Documentation

### Goal

Document installation, configuration, usage, and troubleshooting for the completed AeroSpace port.

Documentation areas in scope:

- `README.md`
- Installation instructions
- AeroSpace configuration guide
- SketchyBar reload instructions
- Troubleshooting
- Dependency list
- Migration notes from `yabai`

### Files to modify

Likely files:

- `README.md`
- `AGENTS.md`, only if project rules changed
- `TODO.md`, to mark roadmap progress or add final status
- Example AeroSpace config files, if included
- Any docs directory, if present

Actual filenames may differ.

### Expected behavior

- A user can install the configuration from scratch.
- A user can configure AeroSpace numbered workspaces correctly.
- A user can reload and troubleshoot SketchyBar.
- A future Codex session can understand completed work and remaining gaps.
- Documentation clearly states that the runtime target is AeroSpace, not `yabai`.

### Test procedure

Review documentation for:

- Required tools and package-manager commands.
- Expected file locations.
- AeroSpace workspace naming requirements.
- SketchyBar startup and reload commands.
- Known limitations.
- Troubleshooting steps for missing icons, stale workspaces, missing media state, and event issues.

Command checks:

```sh
rg "yabai|AeroSpace|aerospace|SketchyBar|sketchybar" README.md AGENTS.md TODO.md
```

### Success criteria

- `README.md` is accurate for the AeroSpace port.
- Installation instructions are complete enough for a fresh setup.
- Troubleshooting covers the most likely failures.
- Remaining limitations are documented.
- `TODO.md` reflects completed and remaining phases.

## Final completion checklist

The migration should not be considered complete until:

- No runtime code depends on `yabai`.
- AeroSpace numbered workspaces are the source of truth.
- Workspace clicks, highlights, and occupancy states work.
- Front app and active window widgets work without `yabai`.
- Battery, calendar, clock, Spotify, volume, and CPU widgets work.
- Visual appearance remains faithful to the upstream configuration.
- Updates are event-driven wherever practical.
- Startup is reliable.
- Documentation is complete.
- All changed scripts pass syntax checks.
- Manual testing has been performed and summarized.

