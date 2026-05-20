# Lightweight Oh My Zsh Theme

A lightweight Oh My Zsh theme focused on practical signal density.

The prompt is designed to stay readable in local terminals, remote shells, containers, and VS Code integrated terminals while still surfacing the information that matters most:

- platform and distro
- current user
- short path
- git branch when inside a repository
- active Python environment
- last command failure reason

## Prompt Example

```text
┌─ [linux-x64/ubuntu] user ~
└─ $

┌─ [linux-x64/ubuntu] user ~/project @main <conda|all>
└─ $

+- [linux-x64/ubuntu] user ~ <exit|127|command-not-found>
`- $
```

## Features

- Two-line prompt with a light connector and no right prompt.
- Platform prefix in the form `[os-arch/flavor]`.
- Linux distro detection from `/etc/os-release`.
- macOS and Windows-like shell fallback support.
- Box-drawing connectors in normal terminals with ASCII fallback for `TERM=dumb`.
- Git branch display only when inside a repository.
- Explicit Python environment labels:
	- `conda` -> `<conda|name>`
	- standard venv -> `<venv|name>`
	- uv-style env -> `<uv|name>`
- Human-readable exit reason display for common shell exit codes.
- Red second-line prompt marker.
- Conservative color usage to keep the prompt stable across terminals.
- UTF-8 locale fallback snippet for hosts with incomplete shell locale setup.

## Installation

### One-shot install

For a fresh install from the remote repository:

```bash
git clone https://github.com/moolean/lightweight-zsh-theme.git
cd lightweight-zsh-theme
bash install.sh
```

If the GitHub repository has not been renamed yet, replace the clone URL with the current repository URL and keep the local directory name as `lightweight-zsh-theme`.

If the repository is already present locally, run:

```bash
bash install.sh
```

The installer will:

- install Oh My Zsh into `~/.oh-my-zsh` if it is missing
- symlink the theme file into the active Oh My Zsh theme directory
- set `ZSH_THEME="lightweight"` in `~/.zshrc`
- append a UTF-8 locale fallback block to `~/.zshrc` if it is not already present

The installer is intentionally conservative:

- it does not overwrite the whole `~/.zshrc`
- it only updates the `ZSH_THEME` line if one already exists
- it keeps a legacy `ytk` theme alias so existing setups do not break immediately

Then start a new login shell:

```bash
exec zsh -l
```

### Manual install

Copy the canonical theme file into your Oh My Zsh theme directory:

```bash
cp lightweight.zsh-theme ~/.oh-my-zsh/themes/lightweight.zsh-theme
```

Then set the theme in `~/.zshrc`:

```zsh
ZSH_THEME="lightweight"
```

Reload your shell:

```bash
source ~/.zshrc
```

## Symlink Workflow

If you want to keep editing the theme from a checked-out repository, you can symlink the active Oh My Zsh theme file:

```bash
ln -sf /path/to/repo/lightweight.zsh-theme ~/.oh-my-zsh/themes/lightweight.zsh-theme
```

This keeps the checked-out repository as the single source of truth.

## Prompt Behavior

- Line 1 shows platform, user, short path, optional git branch, optional Python environment, and the last-command failure segment.
- The git branch is shown only inside a git repository.
- Line 2 only shows the prompt marker.
- In normal terminals the connector uses `┌─` and `└─`.
- In limited terminals such as `TERM=dumb`, the connector falls back to `+-` and `` `- ``.

## Exit Code Rendering

When the previous command fails, the prompt appends a readable segment:

```text
<exit|130|interrupted-ctrl-c>
<exit|127|command-not-found>
<exit|139|segmentation-fault>
```

## Compatibility Notes

- Does not require Nerd Fonts.
- Uses standard Zsh prompt escapes.
- Works best on Zsh with Oh My Zsh.
- On Linux, distro detection depends on `/etc/os-release`.
- On macOS and Windows-like shells, the flavor segment falls back to `macos` or `windows`.
- Falls back to ASCII prompt connectors when the terminal is `dumb`.

## Positioning

- Lightweight by default: no right prompt, no patched font dependency, no heavy prompt decorations.
- Portable across local terminals, remote shells, containers, and VS Code terminals.
- Opinionated about clarity: the prompt shows only context that is usually worth keeping in view.

## Files

- `lightweight.zsh-theme`: the canonical theme implementation.
- `ytk.zsh-theme`: legacy compatibility entry for existing users.
- `install.sh`: one-shot installer for new users.
