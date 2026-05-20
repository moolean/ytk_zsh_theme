setopt prompt_subst

lightweight_detect_platform_prefix() {
  local os_name arch_name os_text arch_text flavor_text os_release_id
  os_name=$(uname -s 2>/dev/null)
  arch_name=$(uname -m 2>/dev/null)

  case "$os_name" in
    Linux) os_text='linux' ;;
    Darwin) os_text='macos' ;;
    FreeBSD) os_text='freebsd' ;;
    CYGWIN*|MINGW*|MSYS*) os_text='windows' ;;
    *) os_text='unix' ;;
  esac

  case "$arch_name" in
    x86_64|amd64) arch_text='x64' ;;
    aarch64|arm64) arch_text='arm64' ;;
    armv7*|armv6*|arm) arch_text='arm' ;;
    riscv64) arch_text='riscv64' ;;
    i386|i486|i586|i686) arch_text='x86' ;;
    *) arch_text="$arch_name" ;;
  esac

  case "$os_name" in
    Linux)
      flavor_text='linux'
      if [[ -r /etc/os-release ]]; then
        os_release_id=$(sed -n 's/^ID=//p' /etc/os-release | head -n 1)
        os_release_id=${os_release_id%\"}
        os_release_id=${os_release_id#\"}
        if [[ -n "$os_release_id" ]]; then
          flavor_text=${os_release_id:l}
        fi
      fi
      ;;
    Darwin) flavor_text='macos' ;;
    CYGWIN*|MINGW*|MSYS*) flavor_text='windows' ;;
    FreeBSD) flavor_text='freebsd' ;;
    *) flavor_text="$os_text" ;;
  esac

  print -nr -- "[${os_text}-${arch_text}/${flavor_text}]"
}

LIGHTWEIGHT_PREFIX_TEXT="$(lightweight_detect_platform_prefix)"
LIGHTWEIGHT_PROMPT_MARK='$'
LIGHTWEIGHT_LINE1_MARK='+-'
LIGHTWEIGHT_LINE2_MARK='`-'

if [[ -t 1 && -n "$TERM" && "$TERM" != "dumb" ]]; then
  LIGHTWEIGHT_PREFIX_COLOR='%F{blue}'
  LIGHTWEIGHT_USER_COLOR='%F{cyan}'
  LIGHTWEIGHT_LINK_COLOR='%F{blue}'
  LIGHTWEIGHT_PATH_COLOR='%F{yellow}'
  LIGHTWEIGHT_GIT_COLOR='%F{green}'
  LIGHTWEIGHT_ENV_COLOR='%F{magenta}'
  LIGHTWEIGHT_ERROR_COLOR='%F{red}'
  LIGHTWEIGHT_PROMPT_COLOR='%F{red}'
  LIGHTWEIGHT_RESET='%f'
  LIGHTWEIGHT_LINE1_MARK='┌─'
  LIGHTWEIGHT_LINE2_MARK='└─'
else
  LIGHTWEIGHT_PREFIX_COLOR=''
  LIGHTWEIGHT_USER_COLOR=''
  LIGHTWEIGHT_LINK_COLOR=''
  LIGHTWEIGHT_PATH_COLOR=''
  LIGHTWEIGHT_GIT_COLOR=''
  LIGHTWEIGHT_ENV_COLOR=''
  LIGHTWEIGHT_ERROR_COLOR=''
  LIGHTWEIGHT_PROMPT_COLOR=''
  LIGHTWEIGHT_RESET=''
fi

git_branch_info() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ "$branch" == "HEAD" ]]; then
      branch=$(git rev-parse --short HEAD 2>/dev/null)
    fi
    if [[ -z "$branch" || "$branch" == "HEAD" ]]; then
      branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null)
    fi
    if [[ -n "$branch" ]]; then
      print -nr -- " ${LIGHTWEIGHT_GIT_COLOR}@${branch}${LIGHTWEIGHT_RESET}"
    fi
}

lightweight_python_env_prompt() {
  if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
    print -nr -- " ${LIGHTWEIGHT_ENV_COLOR}<conda|${CONDA_DEFAULT_ENV}>${LIGHTWEIGHT_RESET}"
    return
  fi

  if [[ -n "$VIRTUAL_ENV" ]]; then
    local env_name
    env_name=${VIRTUAL_ENV:t}
    if [[ "$env_name" == ".venv" || "$env_name" == "venv" ]]; then
      print -nr -- " ${LIGHTWEIGHT_ENV_COLOR}<venv|${PWD:t}>${LIGHTWEIGHT_RESET}"
    elif [[ "$env_name" == *uv* ]]; then
      print -nr -- " ${LIGHTWEIGHT_ENV_COLOR}<uv|${env_name}>${LIGHTWEIGHT_RESET}"
    else
      print -nr -- " ${LIGHTWEIGHT_ENV_COLOR}<venv|${env_name}>${LIGHTWEIGHT_RESET}"
    fi
  fi
}

virtenv_prompt() {
  lightweight_python_env_prompt
}

lightweight_exit_reason() {
  local code=$1
  case "$code" in
    1) print -nr -- 'general-error' ;;
    2) print -nr -- 'shell-misuse' ;;
    126) print -nr -- 'not-executable' ;;
    127) print -nr -- 'command-not-found' ;;
    128) print -nr -- 'invalid-exit' ;;
    129) print -nr -- 'hangup' ;;
    130) print -nr -- 'interrupted-ctrl-c' ;;
    131) print -nr -- 'quit-signal' ;;
    132) print -nr -- 'illegal-instruction' ;;
    133) print -nr -- 'trace-trap' ;;
    134) print -nr -- 'abort-signal' ;;
    135) print -nr -- 'bus-error' ;;
    136) print -nr -- 'fp-exception' ;;
    137) print -nr -- 'killed-sigkill' ;;
    138) print -nr -- 'user-signal-1' ;;
    139) print -nr -- 'segmentation-fault' ;;
    141) print -nr -- 'broken-pipe' ;;
    143) print -nr -- 'terminated' ;;
    255) print -nr -- 'exit-out-of-range' ;;
    *)
      if (( code > 128 )); then
        print -nr -- "signal-$((code - 128))"
      else
        print -nr -- 'command-failed'
      fi
      ;;
  esac
}

lightweight_exit_code() {
  local code=$?
  if (( code != 0 )); then
    print -nr -- " ${LIGHTWEIGHT_ERROR_COLOR}<exit|${code}|$(lightweight_exit_reason "$code")>${LIGHTWEIGHT_RESET}"
  fi
}

PROMPT='${LIGHTWEIGHT_LINK_COLOR}${LIGHTWEIGHT_LINE1_MARK}${LIGHTWEIGHT_RESET} ${LIGHTWEIGHT_PREFIX_COLOR}${LIGHTWEIGHT_PREFIX_TEXT}${LIGHTWEIGHT_RESET} ${LIGHTWEIGHT_USER_COLOR}%n${LIGHTWEIGHT_RESET} ${LIGHTWEIGHT_PATH_COLOR}%2~${LIGHTWEIGHT_RESET}$(git_branch_info)$(virtenv_prompt)$(lightweight_exit_code)
${LIGHTWEIGHT_LINK_COLOR}${LIGHTWEIGHT_LINE2_MARK}${LIGHTWEIGHT_RESET} ${LIGHTWEIGHT_PROMPT_COLOR}${LIGHTWEIGHT_PROMPT_MARK}${LIGHTWEIGHT_RESET} '
PROMPT_EOL_MARK=''
