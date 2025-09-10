# Modified from Zsh Theme ys
# Mar 2013 Yad Smood



# VCS
YS_VCS_PROMPT_PREFIX1=" %{$reset_color%}on%{$fg[blue]%} "
YS_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YS_VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
YS_VCS_PROMPT_CLEAN=" %{$fg[green]%}o"

# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# SVN info
local svn_info='$(svn_prompt_info)'
ZSH_THEME_SVN_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}svn${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_SVN_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_SVN_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_SVN_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# HG info
local hg_info='$(ys_hg_prompt_info)'
ys_hg_prompt_info() {
	# make sure this is a hg dir
	if [ -d '.hg' ]; then
		echo -n "${YS_VCS_PROMPT_PREFIX1}hg${YS_VCS_PROMPT_PREFIX2}"
		echo -n $(hg branch 2>/dev/null)
		if [[ "$(hg config oh-my-zsh.hide-dirty 2>/dev/null)" != "1" ]]; then
			if [ -n "$(hg status 2>/dev/null)" ]; then
				echo -n "$YS_VCS_PROMPT_DIRTY"
			else
				echo -n "$YS_VCS_PROMPT_CLEAN"
			fi
		fi
		echo -n "$YS_VCS_PROMPT_SUFFIX"
	fi
}

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
${hg_info}\
${git_info}\
${svn_info}\
${venv_info}\
${conda_prompt}\
 \
$exit_code
%{$terminfo[bold]$fg[blue]%}╰─%{$reset_color%}\
%{$terminfo[bold]$fg[red]%} $ %{$reset_color%}"

# %{$fg[green]%}%m  # ipcode 31c94879-c4d5-11ee-a5fa-9e29792dec2f
# %{$reset_color%}in # in
