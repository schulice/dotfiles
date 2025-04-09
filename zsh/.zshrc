# ZSH profile

# @p10k
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#@Config Fuction
path_push_front() {
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

# @Previous Funcion
function cli_integration() {
  if command -v fd > /dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --hidden --no-ignore'
  fi
	eval "$(fzf --zsh)"
	eval "$(zoxide init --cmd cd zsh)"
}

function zinit_initial() {
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
}

# @Env
export EDITOR="nvim"
if command -v direnv > /dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
	## MacOS
	### env
  export PNPM_HOME="$HOME/Library/pnpm"
	[ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
	[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env
  path_push_front "/opt/homebrew/opt/libpq/bin" # pq
  path_push_front "/opt/homebrew/opt/riscv-gnu-toolchain/bin" # riscv
  path_push_front "/opt/homebrew/opt/binutils/bin"
	alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
	alias ls="ls --color"
  alias em="emacsclient -t -a ''"
	[ ! -z $KITTY_PID ] && alias ssh="kitten ssh"
  function get_app_id() {
    osascript -e "id of app \"$1\""
  }
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	## Linux
	alias ls='ls --color'
	#PATH="$HOME/opt/qemu-7.2.12/bin:$PATH"
else
## other system
fi

# toolchain binary
[ -n "${PNPM_HOME-}" -a -d "$PNPM_HOME" ] && path_push_front "$PNPM_HOME"
[ -d "$HOME/go/bin" ] && path_push_front "$HOME/go/bin"
[ -d "$HOME/.cargo/bin" ] && path_push_front "$HOME/.cargo/bin"
[ -d "$HOME/.local/bin" ] && path_push_front "$HOME/.local/bin"

if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  zinit_initial
  cli_integration
else
	eval "$(zoxide init --cmd cd zsh)"
fi

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
  if [ "$#" -ne "1" ]; then
    echo "Usage: <command> <ssh_host> <session_name>"
    return 1
  fi
  ssh "$1" -t -- "/bin/sh -c 'if tmux has-session 2>/dev/null; then exec tmux attach; else exec tmux; fi'"
}

function ssh-tmux-into() {
  if [ "$#" -ne "2" ]; then
    echo "Usage: <command> <ssh_host> <session_name>"
    return 1
  fi
  SSH_HOST="$1"
  SESSION_NAME="$2"
  ssh "$SSH_HOST" -t -- "/bin/sh -c 'if tmux has-session -t $SESSION_NAME 2>/dev/null; then exec tmux attach-session -t $SESSION_NAME; else exec tmux new-session -s $SESSION_NAME; fi'"
}

function tmux-into() {
  if [ -z "$1" ]; then
    echo "Usage: <command> <session_name>"
    return 1
  fi
  SESSION_NAME="$1"
  if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux attach -t "$SESSION_NAME"
  else
    tmux new-session -s "$SESSION_NAME"
  fi
}

function proxy-clash() {
  export ALL_PROXY="http://127.0.0.1:7897"
  export HTTP_PROXY="http://127.0.0.1:7897"
  export HTTPS_PROXY="http://127.0.0.1:7897"
}

function proxy-stop() {
  unset ALL_PROXY
  unset HTTP_PROXY
  unset HTTPS_PROXY
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

function cpp_test() {
  if [ -z "$1" ]; then
    echo "Usage <command> <file_name>"
    return 1
  fi
  FILE_NAME="$1"
  FLAGS=(-O2 -std=c++26 -Wall -Wextra -Wshadow -Wnon-virtual-dtor -pedantic -Werror)
  g++ "${FLAGS[@]}" "$FILE_NAME" -o a.out && ./a.out
}

# @Mess
# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

