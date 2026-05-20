# ytk_zsh_theme

A compact Oh My Zsh theme focused on practical signal density.

The prompt is designed to stay readable in local terminals, remote shells, containers, and VS Code integrated terminals while still surfacing the information that matters most:

- platform and distro
- current user
- short path
- git branch when inside a repository
- active Python environment
- last command failure reason

## Prompt Example

```text
┌─ [linux-x64/ubuntu] yaotiankuo ~
└─ $

┌─ [linux-x64/ubuntu] yaotiankuo ~/ytk_zsh_theme @main <conda|all>
└─ $

+- [linux-x64/ubuntu] yaotiankuo ~ <exit|127|command-not-found>
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

For a new user starting from the remote repository:

```bash
git clone https://github.com/moolean/ytk_zsh_theme.git
cd ytk_zsh_theme
bash install.sh
```

If the repository is already present locally, run:

```bash
bash install.sh
```

The installer will:

- install Oh My Zsh into `~/.oh-my-zsh` if it is missing
- symlink `ytk.zsh-theme` into the active Oh My Zsh theme directory
- set `ZSH_THEME="ytk"` in `~/.zshrc`
- append a UTF-8 locale fallback block to `~/.zshrc` if it is not already present

The installer is intentionally conservative:

- it does not overwrite the whole `~/.zshrc`
- it only updates the `ZSH_THEME` line if one already exists
- it backs up an existing non-symlink `ytk` theme file before replacing it

Then start a new login shell:

```bash
exec zsh -l
```

### Manual install

Clone or copy `ytk.zsh-theme` into your Oh My Zsh theme directory:

```bash
cp ytk.zsh-theme ~/.oh-my-zsh/themes/ytk.zsh-theme
```

Then set the theme in `~/.zshrc`:

```zsh
ZSH_THEME="ytk"
```

Reload your shell:

```bash
source ~/.zshrc
```

## Symlink Workflow

If you want to keep editing the theme in a separate repository checkout, you can symlink the active Oh My Zsh theme file:

```bash
ln -sf /path/to/ytk_zsh_theme/ytk.zsh-theme ~/.oh-my-zsh/themes/ytk.zsh-theme
```

This makes the checked-out repository your single source of truth.

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

## Files

- `ytk.zsh-theme`: the theme implementation.
- `install.sh`: one-shot installer for new users.
