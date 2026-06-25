# AGENTS.md

## Project goals

This repository is a fork of MiragianCycle's SketchyBar configuration. The project goal is to port the configuration from `yabai`-based window and space management to `AeroSpace` while preserving the original visual appearance as closely as possible.

The port should keep the bar looking and feeling like the upstream MiragianCycle setup. Changes should focus on replacing window-manager integration, workspace state handling, and event wiring. Visual restyling is out of scope unless it is required to make the AeroSpace port function correctly.

Primary goals:

- Preserve the upstream SketchyBar layout, spacing, typography, colors, icons, animations, and interaction patterns.
- Replace `yabai` commands, signals, and assumptions with equivalent AeroSpace commands and events.
- Support numbered AeroSpace workspaces in a stable and predictable way.
- Keep all behavior event-driven where possible, avoiding polling loops unless there is no practical event source.
- Maintain clear separation between bar item definitions, plugin scripts, helper utilities, configuration constants, and window-manager integration.
- Keep changes small, reviewable, and reversible.

Non-goals:

- Redesigning the bar.
- Replacing SketchyBar with another status bar.
- Reintroducing `yabai` as a runtime dependency.
- Adding unrelated macOS automation, package-management changes, or editor-specific configuration.
- Cleaning up unrelated files while performing the port.

## Current repository state

At the time this file was created, the repository root only contained a placeholder `main.py` and editor metadata. Future sessions should not assume that the upstream SketchyBar configuration has already been copied into this working tree unless the files are present.

Before modifying code, inspect the current tree with:

```sh
rg --files
git status --short
```

Do not overwrite user changes. The working tree may contain untracked or edited files that belong to the user.

## Expected repository structure

The final port may use the upstream structure or a close equivalent. Prefer preserving upstream names and layout where practical so future diffs against MiragianCycle's configuration remain understandable.

Common SketchyBar configuration structure:

```text
.
├── sketchybarrc                 # Main SketchyBar entrypoint
├── items/                       # Bar item definitions grouped by feature
├── plugins/                     # Event handlers and item update scripts
├── helpers/                     # Shared shell helpers or compiled helpers
├── colors.sh                    # Color constants, if used by upstream
├── icons.sh                     # Icon constants, if used by upstream
├── settings.sh                  # Shared bar/item settings
├── aerospace.toml               # AeroSpace configuration, if this repo owns it
└── AGENTS.md                    # Project instructions for Codex sessions
```

The actual repository may differ. Follow these principles:

- Keep SketchyBar item creation in `items/` or the upstream equivalent.
- Keep event handlers in `plugins/`.
- Keep shared constants in a single place rather than duplicating colors, fonts, icon names, and spacing values.
- Keep AeroSpace-specific adapter logic isolated so future changes to AeroSpace commands do not require touching every plugin.
- Avoid burying executable behavior in documentation-only files.

## Coding standards

General standards:

- Prefer POSIX-compatible shell for SketchyBar scripts unless the upstream configuration already depends on `zsh`, `bash`, `jq`, Python, or another tool.
- Match the existing style in nearby files before introducing a new style.
- Keep scripts small and focused on one responsibility.
- Use descriptive variable names for workspace IDs, monitor IDs, app names, and SketchyBar item names.
- Quote shell variables unless word splitting is intentionally required.
- Avoid global side effects in plugin scripts beyond updating SketchyBar items or invoking AeroSpace commands needed for the action.
- Use `set -e` only where the script has been checked for commands whose nonzero statuses are expected. SketchyBar event scripts should fail gracefully.
- Do not add broad dependency assumptions without documenting and testing them.

Shell guidance:

- Use `command -v` when checking for external tools.
- Parse structured command output with structured tools when available. Prefer AeroSpace's documented command output formats over fragile text slicing.
- Keep any `jq` dependency explicit if JSON parsing is introduced.
- Do not hard-code absolute user paths.
- Use executable permissions for scripts that SketchyBar invokes directly.

Formatting guidance:

- Preserve upstream formatting unless changing it improves maintainability for the AeroSpace port.
- Avoid large formatting-only commits.
- Keep comments short and useful. Explain why a workaround exists, not what every line does.

## AeroSpace compatibility requirements

The completed configuration must run without `yabai`.

Forbidden in runtime code after the port:

- `yabai -m ...`
- `yabai` signals
- Direct reliance on yabai space IDs, display indices, or window IDs
- Assumptions that macOS Spaces and AeroSpace workspaces are interchangeable

Required AeroSpace behavior:

- Use AeroSpace workspaces as the source of truth for workspace state.
- Use AeroSpace commands to query focused workspace, visible workspaces, monitor assignment, and workspace contents.
- Use AeroSpace commands to focus or move workspaces when bar items are clicked.
- Subscribe SketchyBar to AeroSpace events when possible.
- Keep all AeroSpace command names and output parsing centralized in a helper or adapter layer.

Recommended adapter responsibilities:

- Return the focused workspace.
- Return all known numbered workspaces.
- Return visible workspaces by monitor, if needed by the visual design.
- Return windows or app counts per workspace, if the bar displays occupancy.
- Focus a workspace by number.
- Move the focused window to a workspace by number, if click or modifier-click behavior supports it.
- Normalize AeroSpace event payloads into stable SketchyBar item updates.

All AeroSpace integrations should tolerate:

- Missing or empty workspaces.
- Multiple monitors.
- Workspaces moving between monitors.
- Workspace names that are numeric strings.
- AeroSpace restarting while SketchyBar is already running.
- SketchyBar restarting while AeroSpace is already running.

## SketchyBar architecture

SketchyBar should be treated as a declarative item layer plus small event-driven update scripts.

Typical layers:

- `sketchybarrc`: initializes the bar, loads shared constants, creates items, subscribes events, and starts services.
- Item files: define SketchyBar items, aliases, brackets, padding, labels, icons, click scripts, and subscriptions.
- Plugin scripts: respond to events and update existing items.
- Helper scripts: encapsulate reusable logic, including AeroSpace queries.
- Constants files: define colors, icons, fonts, dimensions, and item defaults.

Keep these layers separate:

- Item files should not contain large parsing logic.
- Plugin scripts should not redefine visual constants.
- AeroSpace helper scripts should not know about every SketchyBar item unless they are specifically item update scripts.
- Click handlers should call small helpers rather than embedding complex command chains inline.

Prefer this flow:

```text
AeroSpace event or SketchyBar event
    -> plugin script
    -> AeroSpace helper query, if needed
    -> sketchybar --set / --animate updates
```

## Event-driven philosophy

The bar should update in response to events rather than continuous polling.

Use events for:

- Workspace focus changes.
- Workspace content changes.
- Display or monitor changes.
- Front app changes.
- Window focus changes, if the visual design depends on focused-window state.
- System events already provided by SketchyBar, such as volume, Wi-Fi, battery, media, clock, or custom timers.

Avoid:

- Long-running loops inside plugin scripts.
- Frequent polling of all AeroSpace state on a fixed timer.
- Updating every item when only one item changed.
- Calling expensive commands repeatedly in a single event handler.

Polling is acceptable only when:

- AeroSpace or SketchyBar does not expose a suitable event.
- The interval is conservative.
- The script is cheap.
- The reason is documented near the subscription or timer.

When an event may arrive in bursts, design handlers to be idempotent. Re-running the same handler should produce the same visual state without duplicating items or leaving stale highlights.

## Numbered workspace requirements

This port should use numbered AeroSpace workspaces.

Requirements:

- Workspaces should be represented as stable numeric identifiers, normally `1` through `9` or `1` through `10`, depending on the upstream design and user preference.
- The visual ordering in SketchyBar must match numeric order, not lexicographic order. For example, `10` must come after `9`, not after `1`.
- Each numbered workspace item should have a deterministic SketchyBar item name.
- Empty, occupied, visible, and focused workspaces should have distinct states if the upstream visual design supports them.
- Focused workspace styling should update immediately after AeroSpace focus changes.
- Occupancy indicators should update when windows are opened, closed, moved, or reassigned.
- Click behavior should focus the clicked workspace.
- Any modifier-click behavior should be documented in the relevant script and must not conflict with normal focus behavior.

Multi-monitor expectations:

- Do not assume each monitor has the same set of active workspaces.
- Do not assume workspace number equals monitor number.
- If the upstream visual design groups spaces by display, reproduce that grouping using AeroSpace monitor/workspace data.
- If the design shows one global workspace list, ensure it remains accurate when workspaces are visible on different monitors.

Implementation notes:

- Treat workspace IDs as strings at the shell boundary to avoid accidental arithmetic bugs, but sort them numerically when ordering items.
- Do not derive workspace state from macOS Mission Control Spaces.
- Do not use `yabai` space labels or indices as compatibility shims.

## Plugin responsibilities

Each plugin should own one narrow behavior.

Workspace plugin:

- Query AeroSpace for focused, visible, and occupied workspaces.
- Update workspace item icons, labels, backgrounds, and highlights.
- Handle workspace click actions.
- Avoid direct knowledge of unrelated bar modules.

Front app plugin:

- Track and display the currently focused application if the upstream design includes it.
- Use SketchyBar's front-app event or AeroSpace focus events as appropriate.
- Keep app-name formatting consistent with upstream.

Window title plugin:

- Display focused window title only if supported by the intended design.
- Fail gracefully when no window title is available.
- Avoid expensive repeated accessibility queries.

System status plugins:

- Preserve existing behavior for clock, battery, volume, Wi-Fi, Bluetooth, media, calendar, or other system modules.
- Do not rewrite system plugins as part of the AeroSpace port unless needed for compatibility.

AeroSpace event plugin:

- Bridge AeroSpace events into SketchyBar custom events if needed.
- Keep event names stable and documented.
- Avoid duplicating workspace update logic in multiple event handlers.

Shared helper responsibilities:

- Provide a small API for AeroSpace queries.
- Normalize output and error handling.
- Provide fallback empty values when AeroSpace is unavailable.
- Log useful diagnostics without spamming normal SketchyBar output.

## Testing workflow

Before changing files:

```sh
git status --short
rg --files
```

For syntax checks:

```sh
sh -n path/to/script.sh
zsh -n path/to/script.zsh
```

For executable scripts:

```sh
chmod +x path/to/script.sh
```

For SketchyBar reload testing:

```sh
sketchybar --reload
```

For AeroSpace state inspection, use the documented AeroSpace CLI available on the target machine. Verify:

- Focused workspace.
- Workspace list and numeric ordering.
- Workspace-to-monitor mapping.
- Windows or apps assigned to workspaces, if occupancy is displayed.
- Event delivery after focus and window movement.

Manual test checklist:

- Restart SketchyBar.
- Restart AeroSpace.
- Focus each numbered workspace from the bar.
- Focus each numbered workspace from AeroSpace keybindings.
- Move a window between workspaces.
- Open and close windows on occupied and empty workspaces.
- Test with one monitor.
- Test with multiple monitors, if available.
- Confirm the visual appearance still matches the upstream configuration.
- Confirm no runtime code calls `yabai`.

Search checks before considering the port complete:

```sh
rg "yabai|space_changed|display_changed|window_focused|space_windows_change"
rg "aerospace"
```

The first command should eventually show no runtime `yabai` dependencies, except documentation or migration notes.

## Backup policy

Before modifying imported upstream configuration files:

- Check `git status --short`.
- Identify user changes and avoid overwriting them.
- Prefer committing or clearly separating imported upstream files before applying port changes, if the user requests git commits.
- For risky migrations, create timestamped backup copies only when requested by the user or when the file is not yet tracked by git.
- Do not create large backup folders by default.
- Do not delete upstream files until the AeroSpace replacement has been tested.

For Codex sessions:

- Never run destructive commands such as `git reset --hard`, `git clean`, or broad `rm` commands unless the user explicitly asks for that exact action.
- Do not revert user edits.
- If a file has changed since it was last read, re-read it before editing.
- Keep modifications scoped to the user request.

## Rules for future modifications

1. Read this file before making changes.
2. Inspect the repository structure and git status before editing.
3. Do not modify existing files unless the user explicitly asks for implementation work.
4. Preserve MiragianCycle's visual design unless the user requests a design change.
5. Replace yabai behavior with AeroSpace behavior; do not add new yabai dependencies.
6. Centralize AeroSpace command usage in helper scripts or a clearly named adapter.
7. Keep workspace behavior based on numbered AeroSpace workspaces.
8. Keep updates event-driven and idempotent.
9. Prefer small, focused patches over broad rewrites.
10. Do not reformat unrelated files.
11. Do not introduce new dependencies without documenting why they are needed.
12. Test syntax for every changed shell script.
13. Reload SketchyBar after implementation changes when practical.
14. Verify AeroSpace behavior manually or with lightweight scripts where possible.
15. Document any temporary compatibility shims and remove them once no longer needed.
16. Report commands run and tests performed in the final response.
17. Stop after completing the requested scope and wait for further instructions when the user asks to do so.

## Migration notes for Codex

When continuing this project, first determine whether the upstream MiragianCycle files have been imported. If they have not, ask whether the user wants to import them or provide the source files. If they have, locate the yabai integration points and plan the port around those files.

Likely yabai migration targets:

- Space or workspace item creation.
- Space change event subscriptions.
- Window count or occupancy scripts.
- Focused window or front app scripts.
- Click handlers for switching spaces.
- Any scripts that query displays, spaces, or windows.

Likely AeroSpace replacements:

- Workspace query commands.
- Workspace focus commands.
- Window move-to-workspace commands.
- AeroSpace event hooks that trigger SketchyBar custom events.

The safest migration strategy is:

1. Inventory all `yabai` references.
2. Identify the visual state each script is trying to produce.
3. Add an AeroSpace helper layer that can provide equivalent state.
4. Change one SketchyBar module at a time.
5. Test after each module.
6. Remove obsolete yabai code only after the AeroSpace path works.

