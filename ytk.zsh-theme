# Modified from Zsh Theme ys
# Mar 2013 Yad Smood

# VCS
YS_VCS_PROMPT_PREFIX1=" %{$reset_color%}on%{$fg[blue]%} "
YS_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"

# Git info (super lightweight)
# only shows current branch or commit hash
git_branch_info() {
  # judge if we're in a git repo
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    # get current branch name (or commit short SHA)
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ "$branch" == "HEAD" ]]; then
      # detached HEAD state, show commit short hash
      branch=$(git rev-parse --short HEAD 2>/dev/null)
    fi
    echo -n "${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2}${branch}${YS_VCS_PROMPT_SUFFIX}"
  fi
}

local git_info='$(git_branch_info)'


# Virtualenv
local venv_info='$(virtenv_prompt)'
virtenv_prompt() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo "%{$reset_color%}%{$fg[yellow]%} <uv|$(basename $VIRTUAL_ENV)>%{$reset_color%}"
  fi
}

# Conda
local conda_prompt='$(conda_prompt_info)'
conda_prompt_info() {
    if [ -n "$CONDA_DEFAULT_ENV" ]; then
        echo -n "%{$reset_color%}%{$fg[yellow]%} <conda|$CONDA_DEFAULT_ENV> %{$reset_color%}"
    else
        echo -n ''
    fi
}

local exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"

PROMPT="
%{$terminfo[bold]$fg[blue]%}╭─%{$reset_color%} \
%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n) \
%{$reset_color%}>> \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
${git_info}\
${venv_info}\
${conda_prompt}\
 \
$exit_code
%{$terminfo[bold]$fg[blue]%}╰─%{$reset_color%}\
%{$terminfo[bold]$fg[red]%} $ %{$reset_color%}"

# %{$fg[green]%}%m  # ipcode 31c94879-c4d5-11ee-a5fa-9e29792dec2f
# %{$reset_color%}in # in
