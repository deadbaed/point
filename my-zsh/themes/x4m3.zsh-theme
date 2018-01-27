# the x4m3 zsh theme
# requires git plugin & ohmyz.sh
#
# Philippe Loctaux aka x4m3chki aka x4m3
# https://philippeloctaux.com

local cc="%{$reset_color%}"
local current_dir="%{$terminfo[bold]$fg_bold[blue]%} %~${cc}"
local ret_status="%(?:%{$fg_bold[green]%}$ :%{$fg_bold[red]%}$ )${cc}"
local full_time="%{$fg_bold[cyan]%}[%D{%d/%m/%Y}|%D{%H:%M:%S}]${cc}"
local git_branch='$(git_prompt_info)${cc}'

local host_name="$(hostname)"
local user_name="%n"
local separation_name="%{$fg_bold[cyan]%};${cc}"
local full_name="${user_name}${separation_name}${host_name}"

PROMPT="${current_dir} ${ret_status}"
RPROMPT="${git_branch} ${full_name} ${full_time}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${cc}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[magenta]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[magenta]%}*"
