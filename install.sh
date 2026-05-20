#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
OH_MY_ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"
THEME_NAME="ytk"
THEME_SOURCE="$REPO_DIR/ytk.zsh-theme"
THEME_TARGET="$OH_MY_ZSH_DIR/themes/${THEME_NAME}.zsh-theme"
ZSHRC_PATH="$HOME/.zshrc"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

LOCALE_BLOCK_START="# >>> ytk locale fallback >>>"
LOCALE_BLOCK_END="# <<< ytk locale fallback <<<"

log() {
  printf '[ytk-install] %s\n' "$*"
}

ensure_oh_my_zsh() {
  if [[ -d "$OH_MY_ZSH_DIR" ]]; then
    return
  fi

  log "Installing Oh My Zsh into $OH_MY_ZSH_DIR"
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$OH_MY_ZSH_DIR"
}

ensure_zshrc() {
  if [[ -f "$ZSHRC_PATH" ]]; then
    return
  fi

  if [[ -f "$OH_MY_ZSH_DIR/templates/zshrc.zsh-template" ]]; then
    cp "$OH_MY_ZSH_DIR/templates/zshrc.zsh-template" "$ZSHRC_PATH"
    log "Created $ZSHRC_PATH from Oh My Zsh template"
  else
    : > "$ZSHRC_PATH"
    log "Created empty $ZSHRC_PATH"
  fi
}

install_theme_link() {
  mkdir -p "$(dirname "$THEME_TARGET")"

  if [[ -e "$THEME_TARGET" && ! -L "$THEME_TARGET" ]]; then
    mv "$THEME_TARGET" "${THEME_TARGET}.${TIMESTAMP}"
    log "Backed up existing theme to ${THEME_TARGET}.${TIMESTAMP}"
  elif [[ -L "$THEME_TARGET" ]]; then
    local current_target
    current_target="$(readlink -f "$THEME_TARGET" || true)"
    if [[ "$current_target" != "$THEME_SOURCE" ]]; then
      mv "$THEME_TARGET" "${THEME_TARGET}.${TIMESTAMP}"
      log "Backed up existing theme symlink to ${THEME_TARGET}.${TIMESTAMP}"
    fi
  fi

  ln -sfn "$THEME_SOURCE" "$THEME_TARGET"
  log "Linked $THEME_TARGET -> $THEME_SOURCE"
}

set_zsh_theme() {
  if grep -qE '^[[:space:]]*ZSH_THEME=' "$ZSHRC_PATH"; then
    sed -i -E 's|^[[:space:]]*ZSH_THEME=.*$|ZSH_THEME="ytk"|' "$ZSHRC_PATH"
  else
    printf '\nZSH_THEME="ytk"\n' >> "$ZSHRC_PATH"
  fi

  log "Configured ZSH_THEME=\"ytk\" in $ZSHRC_PATH"
}

ensure_locale_block() {
  if grep -qF "$LOCALE_BLOCK_START" "$ZSHRC_PATH"; then
    return
  fi

  cat <<'EOF' >> "$ZSHRC_PATH"

# >>> ytk locale fallback >>>
for zsh_locale in C.UTF-8 C.utf8 en_US.UTF-8 en_US.utf8 zh_CN.UTF-8 zh_CN.utf8; do
  if locale -a 2>/dev/null | grep -qx "$zsh_locale"; then
    export LANG="$zsh_locale"
    export LC_CTYPE="$zsh_locale"
    break
  fi
done
unset zsh_locale
# <<< ytk locale fallback <<<
EOF

  log "Appended UTF-8 locale fallback to $ZSHRC_PATH"
}

main() {
  if [[ ! -f "$THEME_SOURCE" ]]; then
    log "Theme source not found: $THEME_SOURCE"
    exit 1
  fi

  ensure_oh_my_zsh
  ensure_zshrc
  install_theme_link
  set_zsh_theme
  ensure_locale_block

  log "Done. Start a new login shell or run: exec zsh -l"
}

main "$@"