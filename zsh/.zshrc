# ZSH profile

#@Config Fuction
function path_push_front() {
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

function check_cli() {
  local cli_name="$1"
  if command -v "$cli_name" > /dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

# @Previous Funcion
function cli_integration() {
  check_cli "fd" && export FZF_DEFAULT_COMMAND='fd --hidden --no-ignore'
  check_cli "fzf" && eval "$(fzf --zsh)"
  check_cli "zoxide" && eval "$(zoxide init --cmd cd zsh)"
  check_cli "direnv" && eval "$(direnv hook zsh)"
}

function zimfw_init() {
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
  # Remove older command from the history if a duplicate is to be added.
  setopt HIST_IGNORE_ALL_DUPS
  # Set editor default keymap to emacs (`-e`) or vi (`-v`)
  bindkey -e
  # Prompt for spelling correction of commands.
  #setopt CORRECT
  # Customize spelling correction prompt.
  #SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '
  # Remove path separator from WORDCHARS.
  WORDCHARS=${WORDCHARS//[\/]}
  # Use degit instead of git as the default tool to install and update modules.
  #zstyle ':zim:zmodule' use 'degit'
  # Set a custom prefix for the generated aliases. The default prefix is 'G'.
  #zstyle ':zim:git' aliases-prefix 'g'
  # Append `../` to your input for each `.` you type after an initial `..`
  #zstyle ':zim:input' double-dot-expand yes
  # Set a custom terminal title format using prompt expansion escape sequences.
  # See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
  # If none is provided, the default '%n@%m: %~' is used.
  #zstyle ':zim:termtitle' format '%1~'
  # Disable automatic widget re-binding on each precmd. This can be set when
  # zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
  ZSH_AUTOSUGGEST_MANUAL_REBIND=1
  # Customize the style that the suggestions are shown with.
  # See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
  #ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
  # Set what highlighters will be used.
  # See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
  # Customize the main highlighter styles.
  # See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
  #typeset -A ZSH_HIGHLIGHT_STYLES
  #ZSH_HIGHLIGHT_STYLES[comment]='fg=242'
  ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
  # Download zimfw plugin manager if missing.
  if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
    if (( ${+commands[curl]} )); then
      curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
          https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
    else
      mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
          https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
    fi
  fi
  # Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
  if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
    source ${ZIM_HOME}/zimfw.zsh init
  fi
  # Initialize modules.
  source ${ZIM_HOME}/init.zsh
  # zsh-history-substring-search
  zmodload -F zsh/terminfo +p:terminfo
  # Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
  for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
  for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
  for key ('k') bindkey -M vicmd ${key} history-substring-search-up
  for key ('j') bindkey -M vicmd ${key} history-substring-search-down
  unset key
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
}

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }

# Main

# @PATH
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
	[ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
	[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env
  path_push_front "/opt/homebrew/opt/libpq/bin" # pq
  path_push_front "/opt/homebrew/opt/riscv-gnu-toolchain/bin" # riscv
  path_push_front "/opt/homebrew/opt/binutils/bin"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then

else
fi

# @Prompt And Framework
if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  zimfw_init
  setopt rcs
fi

# @Env
[[ -z "$EDITOR" || "$EDITOR" != "code" ]] && export EDITOR="nvim"
# Kitty ssh wrap
[ ! -z "$KITTY_PUBLIC_KEY" ] && alias ssh="kitten ssh"

command -v lazygit > /dev/null 2>&1 && alias lg="lazygit"

if [[ "$OSTYPE" == "darwin"* ]]; then
	## MacOS
	### env
	# for nvm
	# alias ls="ls --color"
	alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
  alias em="emacsclient -t -a ''"
  function get_app_id() {
    osascript -e "id of app \"$1\""
  }
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	## Linux
	# alias ls='ls --color'
	# PATH="$HOME/opt/qemu-7.2.12/bin:$PATH"
else
## other system
fi

# toolchain binary
[ -n "${PNPM_HOME-}" -a -d "$PNPM_HOME" ] && path_push_front "$PNPM_HOME"
[ -d "$HOME/go/bin" ] && path_push_front "$HOME/go/bin"
[ -d "$HOME/.cargo/bin" ] && path_push_front "$HOME/.cargo/bin"
[ -d "$HOME/.local/bin" ] && path_push_front "$HOME/.local/bin"

# local env
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

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
  if [ "$#" -lt "2" ]; then
    echo "Usage: <command> <ssh_command_args...> <session_name>"
    return 1
  fi
  SESSION_NAME="${@:-1}"
  SSH_ARGS=("${@:1:$#-1}")
  ssh "${SSH_ARGS[@]}" -t -- "/bin/sh -c 'if tmux has-session -t \"${SESSION_NAME}\" 2>/dev/null; then exec tmux attach-session -t \"${SESSION_NAME}\"; else exec tmux new-session -s \"${SESSION_NAME}\"; fi'"
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

