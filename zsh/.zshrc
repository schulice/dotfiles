# ZSH profile

# @p10k
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# @Env
export EDITOR="nvim"

if [[ "$OSTYPE" == "darwin"* ]]; then
	## MacOS
	### env
	[ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
	[ -f "/Users/chenzaixi/.ghcup/env" ] && . "/Users/chenzaixi/.ghcup/env" # ghcup-env
	export FZF_DEFAULT_COMMAND='fd --hidden --no-ignore'
	PATH="/opt/homebrew/opt/libpq/bin:$PATH" # pq
  PATH="/opt/homebrew/opt/riscv-gnu-toolchain/bin$PATH"
  PATH="/opt/homebrew/opt/binutils/bin:$PATH"
	alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
	alias ls="ls --color"
	alias vim='nvim'
	[ ! -z $KITTY_PID ] && alias ssh="kitten ssh"
	eval "$(fzf --zsh)"
	eval "$(zoxide init --cmd cd zsh)"

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	## Linux
	alias ls='ls --color'
	alias vim='nvim'
	alias c='clear'
	#PATH="$HOME/opt/qemu-7.2.12/bin:$PATH"
	eval "$(fzf --zsh)"
	eval "$(zoxide init --cmd cd zsh)"
	eval "$(direnv hook zsh)"
else
## other system
fi

# toolchain binary
[ -d "$HOME/go/bin" ] && PATH="$HOME/go/bin:$PATH"
[ -d "$HOME/.cargo/bin" ] && PATH="$HOME/.cargo/bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
export PATH


# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# @Function
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function ssh-tmux() {
  ssh "$1" -t -- "/bin/sh -c 'if tmux has-session 2>/dev/null; then exec tmux attach; else exec tmux; fi'"
}

function proxy-clash() {
  export ALL_PROXY="http://127.0.0.1:7897"
  export HTTP_PROXY="http://127.0.0.1:7897"
  export HTTPS_PROXY="http://127.0.0.1:7897"
}

function proxy-stop() {
  unset ALL_PROXY=
  unset HTTP_PROXY=
  unset HTTPS_PROXY=
}

# headless
function nvim-server() {
  nvim --headless --listen "0.0.0.0:$1"
}

function nvim-attach() {
  nvim --remote-ui --server "$1:$2"
}

function ssh-nvim-listen() {
  ssh -L 16666:localhost:16666 "$1" nvim --headless --listen localhost:16666
}

# attach
function ssh-nvim-attach() {
  nvim --remote-ui --server "localhost:16666"
}

# @Mess
# pnpm
export PNPM_HOME="/Users/chenzaixi/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

