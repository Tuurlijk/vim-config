#!/usr/bin/env zsh
# vim:ft=zsh
# @see prompt_tuurlijk_help

local -A symbols
symbols=(
	'branch' ''
	'hash' '➦'
)

local -A colours
# Use extended color palette if available
if [[ -n ${terminfo[colors]} && ${terminfo[colors]} -ge 256 ]]; then
	colours=(
	'pwd' 253
	'pwdBg' 31
	'userHost' 245
	'userHostBg' 238
	'exit' 124
	'exitBg' 74
	'root' 235
	'rootBg' 235
	'vcsClean' 28
	'vcsDirty' 124
	)
else
	colours=(
	'pwd' white
	'pwdBg' blue
	'userHost' black
	'userHostBg' cyan
	'exit' red
	'exitBg' cyan
	'root' red
	'rootBg' yellow
	'vcsClean' green
	'vcsDirty' red
	)
fi

# Set symbols from user preferences (zstyle ':theme:tuurlijk:branch' symbol '')
local newSymbol
for symbol in ${(@k)symbols}; do
	zstyle -s ":theme:tuurlijk:$symbol" symbol newSymbol && symbols[$symbol]=$newSymbol
done

# Set colours from user preferences (zstyle ':theme:tuurlijk:pwd' colour 250)
local newColour
for colour in ${(@k)colours}; do
	zstyle -s ":theme:tuurlijk:$colour" colour newColour && colours[$colour]=$newColour
done

# Define prompts
prompt_tuurlijk_setup() {
	# Load required modules
	autoload -Uz vcs_info

	# vcs_info format strings, formatted using zformat
	# See: man zformat
	#
	# max-exports: Defines the maximum number of vcs_info_msg_*_ variables vcs_info will set.
	# %b: branch
	# %a: action (rebase/merge)
	# %i: revision number or identifier
	# %s: version control system
	# %r: name of the root directory of the repository
	# %S: path relative to the repository root directory
	# %m: in case of Git, show information about stashes
	# %u: unstaged changes in the repository
	# %c: staged changes in the repository
	#
	zstyle ':vcs_info:*' enable git
	zstyle ':vcs_info:*' check-for-changes true
	zstyle ':vcs_info:*' get-revision true
	zstyle ':vcs_info:*' max-exports 6
	zstyle ':vcs_info:*:*' unstagedstr '!'
	zstyle ':vcs_info:*:*' stagedstr '+'
	zstyle ':vcs_info:*:*' formats \
		"%F{$colours[pwdBg]}%K{$colours[pwdBg]}%F{$colours[pwd]} $symbols[hash] %7.7i" \
		"%F{$colours[vcsClean]}${symbols[branch]} %F{$colours[pwd]}%b" \
		"%F{$colours[vcsDirty]}${symbols[branch]} %F{$colours[pwd]}%b" \
		"%r" \
		"%u%c"
	zstyle ':vcs_info:*:* actionformats' \
		"%F{$colours[pwdBg]}%K{$colours[pwdBg]}%F{$colours[pwd]} $symbols[hash] %7.7i" \
		"%F{$colours[vcsClean]}${symbols[branch]} %F{$colours[pwd]}%b" \
		"%F{$colours[vcsDirty]}${symbols[branch]} %F{$colours[pwd]}%b" \
		"%r" \
		"%i" \
		"%u%c (%a)"
	autoload -Uz colors && colors
	autoload -Uz add-zsh-hook

	prompt_opts=(percent subst)

	add-zsh-hook preexec _prompt_tuurlijk_preexec
	add-zsh-hook precmd _prompt_tuurlijk_precmd

	# Prompt format strings
	#
	# %F: foreground color dict
	# %f: reset foreground color
	# %K: background color dict
	# %k: reset background color
	# %~: current path
	# %*: time
	# %n: username
	# %m: shortname host
	# %(?..): prompt conditional - %(condition.true.false)
	PROMPT_PWD=' $(shrink_path -f) '
	PROMPT_EXIT="%K{$colours[exitBg]}%F{$colours[exit]}%(?.. ✘ %K{$colours[pwdBg]}%F{$colours[exitBg]})%K{$colours[pwdBg]}%F{$colours[pwd]}"
	PROMPT_SU="%(!.%k%F{$colours[pwdBg]}%K{$colours[rootBg]} ⚡ %F{$colours[rootBg]}%k.%k%F{$colours[pwdBg]})%{%f%k%b%} "
	PROMPT='${PROMPT_EXIT}${(e)${PROMPT_PWD}}${PROMPT_SU}'

	RPROMPT_HOST="%F{$colours[userHostBg]}${SSH_TTY:+}%K{$colours[userHostBg]}%F{$colours[userHost]}${SSH_TTY:+ %n@%m }%{%f%k%b%}"
	RPROMPT_VCS_START="%F{$colours[pwdBg]}%K{$colours[pwdBg]}%F{$colours[pwd]} "
	RPROMPT='$(_prompt_tuurlijk_vcs_path_and_branch)%F{yellow}$(_prompt_tuurlijk_cmd_exec_time)${RPROMPT_HOST}'
}

# Fastest possible way to check if repo is dirty
_prompt_tuurlijk_vcs_is_git_dirty() {
	if [[ $(command git diff --shortstat 2> /dev/null | tail -n1) != "" ]]; then
	  return true
	else
		return false
	fi
}

# Display information about the current path and branch
_prompt_tuurlijk_vcs_path_and_branch() {
	local segment
	if [[ -n "$vcs_info_msg_0_" ]]; then
		segment+=( "$vcs_info_msg_0_" )
		if [[ -z $vcs_info_msg_4_ ]]; then
			segment+=( "$vcs_info_msg_1_" )
		else
			segment+=( "$vcs_info_msg_2_" )
		fi
		[[ -n "$vcs_info_msg_3_" ]] && segment+=( " $vcs_info_msg_3_ " )
	fi
	echo $segment
}

# Display information about the current repository
_prompt_tuurlijk_vcs_repository() {
	echo "${vcs_info_msg_0_}"
}

# Displays the exec time of the last command if set threshold was exceeded
_prompt_tuurlijk_cmd_exec_time() {
	local stop=`date +%s`
	local start=${_cmd_timestamp:-$stop}
	let local elapsed=$stop-$start
	[ $elapsed -gt 5 ] && echo "${elapsed}s "
}

# Get the initial timestamp for cmd_exec_time
_prompt_tuurlijk_preexec() {
	_cmd_timestamp=`date +%s`
}

# Get version control info before we start outputting stuff
_prompt_tuurlijk_precmd() {
	vcs_info
}

prompt_tuurlijk_help () {
	cat <<EOH
	Tuurlijk's lightweight prompt

	You will need a Powerline capable font:
 	https://github.com/powerline/powerline

	You can style this prompt using zstyles in your .zshrc:

	# Set custom prompt colours
	zstyle ':theme:tuurlijk:pwd' colour 250
	zstyle ':theme:tuurlijk:pwdBg' colour 238
	zstyle ':theme:tuurlijk:exit' colour 124
	zstyle ':theme:tuurlijk:exitBg' colour 245
	zstyle ':theme:tuurlijk:root' colour 234
	zstyle ':theme:tuurlijk:rootBg' colour 52
	zstyle ':theme:tuurlijk:userHost' colour 16
	zstyle ':theme:tuurlijk:userHostBg' colour 245
	zstyle ':theme:tuurlijk:vcsClean' colour 28
	zstyle ':theme:tuurlijk:vcsDirty' colour 124

	# Set custom prompt symbols
	zstyle ':theme:tuurlijk:branch' symbol 
	zstyle ':theme:tuurlijk:hash' symbol ➦

EOH
}

prompt_tuurlijk_setup "$@"

