# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#####################
# FIRST PROMPT LINE #
#####################
#rosso='\e[1;34m'
#NC='\e[0m'
#echo -e "${rosso}Debian${NC}" `cat /etc/debian_version` "| ${rosso}ZSH${NC} ${ZSH_VERSION}"

#####################
# ZINIT             #
#####################
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p $HOME/.zinit
    command git clone https://github.com/zdharma/zinit $HOME/.zinit/bin && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%F" || \
        print -P "%F{160}▓▒░ The clone has failed.%F"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

#####################
# THEME             #
#####################
zinit ice depth=1; zinit light romkatv/powerlevel10k

#####################
# PLUGINS           #
#####################
# SSH-AGENT
zinit light bobsoppe/zsh-ssh-agent
 ##AUTOSUGGESTIONS, TRIGGER PRECMD HOOK UPON LOAD
#ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
#zinit ice wait"0a" lucid atload"_zsh_autosuggest_start"
#zinit light zsh-users/zsh-autosuggestions
# ENHANCD
zinit ice wait"0b" lucid
zinit light b4b4r07/enhancd
export ENHANCD_FILTER=fzf:fzy:peco
# HISTORY SUBSTRING SEARCHING
zinit ice wait"0b" lucid atload'bindkey "$terminfo[kcuu1]" history-substring-search-up; bindkey "$terminfo[kcud1]" history-substring-search-down'
zinit light zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
# TAB COMPLETIONS
zinit ice wait"0b" lucid blockf
zinit light zsh-users/zsh-completions
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '-- %d --'
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:complete:*:options' sort false
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap
zstyle ':fzf-tab:complete:cd:*' extra-opts --preview=$extract'exa -1 --color=always ${~ctxt[hpre]}$in'
# FZF
zinit ice lucid wait'0b' from"gh-r" as"program"
zinit light junegunn/fzf
# FZF BYNARY AND TMUX HELPER SCRIPT
zinit ice lucid wait'0c' as"command" pick"bin/fzf-tmux"
zinit light junegunn/fzf
# BIND MULTIPLE WIDGETS USING FZF
zinit ice lucid wait'0c' multisrc"shell/{completion,key-bindings}.zsh" id-as"junegunn/fzf_completions" pick"/dev/null"
zinit light junegunn/fzf
# FZF-TAB
zinit ice wait"1" lucid
zinit light Aloxaf/fzf-tab
# SYNTAX HIGHLIGHTING
zinit ice wait"0c" lucid atinit"zpcompinit;zpcdreplay"
zinit light zdharma/fast-syntax-highlighting
# EXA
zinit ice wait"2" lucid from"gh-r" as"program" mv"exa* -> exa"
zinit light ogham/exa
zinit ice wait blockf atpull'zinit creinstall -q .'
# BAT
zinit ice from"gh-r" as"program" mv"bat* -> bat" pick"bat/bat" atload"alias cat=bat"
zinit light sharkdp/bat
# BAT-EXTRAS
zinit ice wait"1" as"program" pick"src/batgrep.sh" lucid
zinit ice wait"1" as"program" pick"src/batdiff.sh" lucid
zinit light eth-p/bat-extras
alias rg=batgrep.sh
alias bd=batdiff.sh
alias man=batman.sh
# RIPGREP
zinit ice from"gh-r" as"program" mv"ripgrep* -> ripgrep" pick"ripgrep/rg"
zinit light BurntSushi/ripgrep
# FORGIT
# ga - git add
# glo - git log
# gd - git diff
zinit ice wait lucid
zinit load 'wfxr/forgit'
# FD
zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zinit light sharkdp/fd
# ZSH MANYDOTS MAGIC
zinit autoload'#manydots-magic' for knu/zsh-manydots-magic
# GIT-FLOW
zinit light petervanderdoes/git-flow-completion
## GIT-HUBFLOW
#zinit ice wait"2" lucid from"gh-r" as"program" mv"exa* -> exa"
#zinit light mborsuk/hubflow

#####################
# HISTORY           #
#####################
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=290000
SAVEHIST=$HISTSIZE

#####################
# SETOPT            #
#####################
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_all_dups   # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data
setopt always_to_end          # cursor moved to the end in full completion
setopt hash_list_all          # hash everything before completion
# setopt completealiases        # complete alisases
setopt always_to_end          # when completing from the middle of a word, move the cursor to the end of the word
setopt complete_in_word       # allow completion from within a word/phrase
setopt nocorrect                # spelling correction for commands
setopt list_ambiguous         # complete as much of a completion until it gets ambiguous.
setopt nolisttypes
setopt listpacked
setopt automenu
setopt vi

# Automatic ls when changing directory
# removed --classify
chpwd() exa --git --icons --group-directories-first --time-style=long-iso --group --color-scale
#####################
# ENV VARIABLE      #
#####################
export EDITOR='nvim'
export VISUAL=$EDITOR
export PAGER='less'
export SHELL='/bin/zsh'
#export LANG='en_GB.UTF-8'
#export LC_ALL='en_GB.UTF-8'
export BAT_THEME="gruvbox"

#PATH="/usr/local/bin:/usr/local/sbin/:$PATH"
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/bin
#path+=('/usr/local/bin')
#path+=('$HOME/.local/bin')
#path+=('$HOME/.cargo/bin')
#export PATH

#####################
# COLORING          #
#####################
autoload colors && colors

#####################
# ALIASES           #
#####################
#source $HOME/.zsh_aliases
alias ..="cd .."
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias pskill="ps aux  |  grep -i csp_build  |  awk '{print $2}'  |  xargs sudo kill -9"
alias myip="curl http://ipecho.net/plain; echo"
alias ls="exa --git --icons --group-directories-first --time-style=long-iso --group --color-scale"
alias vim=nvim
alias vi=nvim
alias myconfig='/usr/bin/git --git-dir=$HOME/.myconfig/ --work-tree=$HOME'
alias -- -='cd -'
#alias python=python3
alias cht="cht.sh"

alias syu='sudo apt update && sudo apt upgrade'
alias srconfig='source ~/.zshrc'
alias vpn='cd $HOME/MEGA/brytlyt/openvpn && sudo openvpn --config mgajewskik.brytlyt.com.ovpn --auth-user-pass'
alias s76=system76-power

alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

alias poetry=$HOME/.poetry/bin/poetry

#####################
# DOCKER FUNC      #
#####################
docker-ip () { docker inspect "$@" | grep "IPAddress\": \"1" | grep -o "[0-9\.]*"| uniq | head -1; }
logs () { docker logs -f --tail 100  "$@" ; }
b () { docker exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`"  -it "$@" bash; }

#####################
# FANCY-CTRL-Z      #
#####################
function fg-fzf() {
	job="$(jobs | fzf -0 -1 | sed -E 's/\[(.+)\].*/\1/')" && echo '' && fg %$job
}
function fancy-ctrl-z () {
	if [[ $#BUFFER -eq 0 ]]; then
		BUFFER=" fg-fzf"
		zle accept-line -w
	else
		zle push-input -w
		zle clear-screen -w
	fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

#####################
# FZF SETTINGS      #
#####################
#--info=inline
#--no-sort
export FZF_DEFAULT_OPTS="
--ansi
--layout=reverse
--height=50%
--multi
--preview-window=right:60%
--preview-window=sharp
--preview-window=cycle
--preview '([[ -f {} ]] && (bat --style=header,grid,numbers --color=always --theme=gruvbox --line-range :500 {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
--prompt='λ -> '
--pointer='|>'
--marker='✓'
--bind 'ctrl-s:select-all'
--bind 'ctrl-e:execute(nvim {} < /dev/tty > /dev/tty 2>&1)' > selected
--bind 'ctrl-v:execute(code {+})'"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git/*,.tox/*,venv/*,.venv/*,.pyenv/*,*.pyi,*.pyc,__pycache__/*,.cache/*}" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

#####################
# CONDA SETTINGS       #
#####################
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/mgajewskik/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/mgajewskik/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/mgajewskik/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/mgajewskik/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

#####################
# GO SETTINGS       #
#####################
export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
#export GOPATH=$GOPATH:$HOME/code

############################
## PYENV SETTINGS          #
############################
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

############################
## POETRY SETTINGS         #
############################
export PATH="$HOME/.poetry/bin:$PATH"

#####################
# P10K SETTINGS     #
#####################
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
