if [[ -f ~/.aliases ]]; then
	. ~/.aliases
fi

autoload -U promptinit && promptinit
autoload -U compinit && compinit

zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' rehash true

export PS1='%F{#9ab8d7}[%n%F{#3f3f3f}@%F{#8cd0d3}%m %~]%# %f'

HISTFILE=~/.histfile
HISTCONTROL=
HISTIGNORE=
HISTFILESIZE=-1 # unlimited
HISTSIZE=10000
HISTTIMEFORMAT="%F-%R "
SAVEHIST=10000

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^[[3~' delete-char

# Plugins
## zsh-autosuggestions (https://github.com/zsh-users/zsh-autosuggestions)
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#f8f8f2,bg=#282a36,bold,underline"

## zsh-colored-mang-pages (https://github.com/ael-code/zsh-colored-man-pages)
source ~/.zsh/zsh-colored-man-pages/colored-man-pages.plugin.zsh

# setopt autocd
# this creates issues with comments
# setopt extendedglob
setopt HIST_IGNORE_SPACE
unsetopt beep

# fix broken prompt
autoload -Uz add-zsh-hook

function reset_broken_terminal () {
	printf '%b' '\e[0m\e(B\e)0\017\e[?5l\e7\e[0;0r\e8'
}

add-zsh-hook -Uz precmd reset_broken_terminal

zstyle :compinstall filename '~/.zshrc'

