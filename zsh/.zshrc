if [[ -f "/opt/homebrew/bin/brew" ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

autoload -U compinit && compinit
zinit cdreplay -q
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zmodload zsh/complist
_comp_options+=(globdots)

# plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# completions
zinit snippet OMZP::git
zinit snippet OMZP::uv
zinit snippet OMZP::rust
# zinit snippet OMZP::docker
# zinit snippet OMZP::kubectl

source <(fzf --zsh)
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
command -v opam &>/dev/null && [[ -d "$HOME/.opam" ]] && eval $(opam env)
# source <(kubectl completion zsh)
# autoload -Uz _kubebuilder
# compdef _kubebuilder kubebuilder
# [[ ! -r '/Users/ink/.opam/opam-init/init.zsh' ]] || source '/Users/ink/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null

# path
export GOPATH=$HOME/code/go
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.elan/env:$PATH"
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# command history
HISTSIZE=6000
SAVEHIST=6000
HISTFILE=~/.cache/zsh/.zsh_history
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups

# keybinds
bindkey '^f' forward-word
bindkey '^b' backward-word
bindkey '^y' autosuggest-accept

# alias
alias vi='nvim'
alias ls='eza -1 --icons --group-directories-first'
alias ta='tmux attach'
alias fd='find'
alias cla='claude'
# alias k8s='kubectl'
# alias dockerd='colima start'

_fzf_dark="
  --color=bg+:#2c2525,bg:#101010,spinner:#f38d70,fg:#e6d9db
  --color=header:#fd6883,marker:#adda78,fg+:#f1e5e7,prompt:#f38d70
  --color=info:#f1e5e7,pointer:#f38d70,hl:#a6a6a6,hl+:#a6a6a6
  --color=border:#595959,gutter:#101010,query:#e6d9db"
_fzf_light="
  --color=bg+:#f9eabf,bg:#f9f5d7,spinner:#6c782e,fg:#654735
  --color=header:#c14a4a,marker:#6c782e,fg+:#4f3829,prompt:#6c782e
  --color=info:#7c6f64,pointer:#6c782e,hl:#b47109,hl+:#b47109
  --color=border:#ebdbb2,gutter:#f9f5d7,query:#654735"

# dark unless the desktop explicitly prefers light
if [[ "$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)" != *light* ]]; then
	export FZF_DEFAULT_OPTS="$_fzf_dark"
	zstyle ':fzf-tab:*' fzf-flags \
	  --color=bg+:#2c2525,bg:#101010,spinner:#f38d70,fg:#e6d9db \
	  --color=header:#fd6883,marker:#adda78,fg+:#f1e5e7,prompt:#f38d70 \
	  --color=info:#f1e5e7,pointer:#f38d70,hl:#a6a6a6,hl+:#a6a6a6 \
	  --color=border:#595959,gutter:#101010
	zstyle ':fzf-tab:*' fzf-bindings 'ctrl-y:accept'
	zstyle ':fzf-tab:*' accept-line ctrl-y
else
	export FZF_DEFAULT_OPTS="$_fzf_light"
	zstyle ':fzf-tab:*' fzf-flags \
	  --color=bg+:#f9eabf,bg:#f9f5d7,spinner:#6c782e,fg:#654735 \
	  --color=header:#c14a4a,marker:#6c782e,fg+:#4f3829,prompt:#6c782e \
	  --color=info:#7c6f64,pointer:#6c782e,hl:#b47109,hl+:#b47109 \
	  --color=border:#ebdbb2,gutter:#f9f5d7
fi
unset _fzf_dark _fzf_light
