# Omarchy Translator

A translator plugin for [Omarchy](https://omarchy.org/) (Hyprland + Quickshell). Translate selected text, clipboard text, or typed input and view the result in a floating, theme-matched result card. The full translation is copied to your clipboard automatically.

## Features

- **Translate selection or clipboard**: uses the primary selection first, then falls back to clipboard text.
- **Type to translate**: opens Omarchy’s native text input prompt when you want to enter text directly.
- **Target language picker**: choose a target language once; it is saved and reused for later translations.
- **Floating result card**: shows the translation in an Omarchy-styled overlay card (separate from notification toasts), with selectable text and scrolling for long results.
- **Reliable translation**: tries Bing first and falls back to Google, with a short per-engine timeout and a clear error message if both fail.
- **Bar widget**: adds a Translator button to the Omarchy bar.

## Dependencies

This plugin requires the following external tools to be installed:

- [translate-shell](https://github.com/soimort/translate-shell) (`trans`) — translation engine
- [wl-clipboard](https://github.com/bugaevc/wl-clipboard) (`wl-paste`, `wl-copy`) — Wayland clipboard access
- [jq](https://jqlang.github.io/jq/) — JSON parsing for monitor/theme integration
- [libnotify](https://gitlab.gnome.org/GNOME/libnotify) (`notify-send`) — progress/error notifications
- [Quickshell](https://quickshell.outfoxxed.me/) (`qs`) — renders the floating result card
- `hyprctl` (Hyprland) — monitor/radius-aware card placement

The plugin also uses Omarchy shell tools that ship with Omarchy: `omarchy-menu-input`, `omarchy-menu-select`, and `omarchy-shell`.

## Installation

Install with the Omarchy plugin CLI:

```bash
omarchy plugin add https://github.com/gurvindersingh-web/omalation.git
```

### Add the bar widget

After installing, add the widget to your bar layout in `~/.config/omarchy/shell.json` (for example in the `right` section):

```json
{
  "bar": {
    "layout": {
      "right": [
        {
          "id": "gurvindersingh-web.omalation"
        }
      ]
    }
  }
}
```

### Optional: add keybindings

The plugin does not modify your Hyprland configuration automatically. If you want keyboard shortcuts, add bindings yourself in your Hyprland config (for example `~/.config/hypr/bindings.conf` or your Omarchy bindings file) that point to the installed plugin scripts:

```bash
# Example paths after installation
PLUGIN="$HOME/.config/omarchy/plugins/gurvindersingh-web.omalation"

# Super+D         — translate selection/clipboard (or type if nothing selected)
# Super+Shift+D   — choose target language
# Super+Alt+T     — type text to translate
```

Example Hyprland bindings (adjust to your preferred keys and config style):

```ini
bind = SUPER, D, exec, ~/.config/omarchy/plugins/gurvindersingh-web.omalation/omarchy-translate
bind = SUPER SHIFT, D, exec, ~/.config/omarchy/plugins/gurvindersingh-web.omalation/omarchy-translate-lang
bind = SUPER ALT, T, exec, ~/.config/omarchy/plugins/gurvindersingh-web.omalation/omarchy-translate-type
```

Reload Hyprland after editing your config (`hyprctl reload`).

## Usage

- **Bar widget**
  - Left click: open the type-to-translate prompt
  - Middle click: translate the current selection or clipboard
  - Right click: choose the target language
- **First run**: you will be asked to pick a target language once (saved in `~/.config/omarchy-translate/target`).
- **Result card**: press `Esc`, `Enter`, or click outside the card to close it. The full translation is copied to the clipboard.

## Removal

Remove the plugin with the Omarchy CLI:

```bash
omarchy plugin remove gurvindersingh-web.omalation
```

If you added the widget to `~/.config/omarchy/shell.json` or created custom keybindings, remove those entries manually.

## License

This plugin is licensed under the [MIT License](LICENSE).
