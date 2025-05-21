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
  if check_cli fd; then
    export FZF_DEFAULT_COMMAND='fd --hidden --no-ignore'
  fi
  if check_cli fzf; then
    eval "$(fzf --zsh)"
  fi
  if check_cli zoxide; then
    eval "$(zoxide init --cmd cd zsh)"
  fi
  if check_cli direnv; then
  eval "$(direnv hook zsh)"
  fi
}

function zsh4humans_init() {
  if [ -n "${ZSH_VERSION-}" ]; then
    : ${ZDOTDIR:=~}
    setopt no_global_rcs
    [[ -o no_interactive && -z "${Z4H_BOOTSTRAPPING-}" ]] && return
    setopt no_rcs
    unset Z4H_BOOTSTRAPPING
  fi
  Z4H_URL="https://raw.githubusercontent.com/romkatv/zsh4humans/v5"
  : "${Z4H:=${XDG_CACHE_HOME:-$HOME/.cache}/zsh4humans/v5}"
  umask o-w
  if [ ! -e "$Z4H"/z4h.zsh ]; then
    mkdir -p -- "$Z4H" || return
    >&2 printf '\033[33mz4h\033[0m: fetching \033[4mz4h.zsh\033[0m\n'
    if command -v curl >/dev/null 2>&1; then
      curl -fsSL -- "$Z4H_URL"/z4h.zsh >"$Z4H"/z4h.zsh.$$ || return
    elif command -v wget >/dev/null 2>&1; then
      wget -O-   -- "$Z4H_URL"/z4h.zsh >"$Z4H"/z4h.zsh.$$ || return
    else
      >&2 printf '\033[33mz4h\033[0m: please install \033[32mcurl\033[0m or \033[32mwget\033[0m\n'
      return 1
    fi
    mv -- "$Z4H"/z4h.zsh.$$ "$Z4H"/z4h.zsh || return
  fi
  . "$Z4H"/z4h.zsh || return
  setopt rcs
}

function zsh4humans_conf() {
  # Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.
  zstyle ':z4h:' auto-update      'no'
  zstyle ':z4h:' auto-update-days '28'
  zstyle ':z4h:bindkey' keyboard  'mac'
  # two flags can not be open same time
  #zstyle ':z4h:' start-tmux       no
  zstyle ':z4h:' propagate-cwd yes
  zstyle ':z4h:' term-shell-integration 'yes'
  zstyle ':z4h:autosuggestions' forward-char 'accept'
  zstyle ':z4h:fzf-complete' recurse-dirs 'no'
  # direnv
  zstyle ':z4h:direnv'         enable 'yes'
  zstyle ':z4h:direnv:success' notify 'yes'
  zstyle ':z4h:ssh:*'                   enable 'no'
  # zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
  # zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
  # zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'
  # z4h install ohmyzsh/ohmyzsh || return
  z4h init || return
}
function zsh4humans_specify() {
  # path=(~/bin $path)
  export GPG_TTY=$TTY
  z4h source ~/.env.zsh
  z4h bindkey undo Ctrl+/   Shift+Tab  # undo the last command line change
  z4h bindkey redo Option+/            # redo the last undone command line change
  z4h bindkey z4h-cd-back    Shift+Left   # cd into the previous directory
  z4h bindkey z4h-cd-forward Shift+Right  # cd into the next directory
  z4h bindkey z4h-cd-up      Shift+Up     # cd into the parent directory
  z4h bindkey z4h-cd-down    Shift+Down   # cd into a child directory
  zstyle ':z4h:*' fzf-bindings ctrl-k:up
  # zstyle ':z4h:fzf-complete' fzf-bindings tab:repeat
  zstyle ':z4h:fzf-complete' recurse-dirs yes
  zstyle ':z4h:fzf-complete' fzf-bindings tab:repeat ctrl-k:up
  autoload -Uz zmv
  # Define functions and completions.
  function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
  compdef _directories md
  # Define named directories: ~w <=> Windows home directory on WSL.
  [[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home
  # Define some alias
  alias tree='tree -a -I .git'
  alias ls="${aliases[ls]:-ls} -A"
  # Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
  setopt glob_dots     # no special treatment for file names with a leading dot
  setopt no_auto_menu  # require an extra TAB press to open the completion menu
}

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
  # zsh4humans_init
  zsh4humans_conf
  zsh4humans_specify
  # cli_integration
  # zinit_initial
else
  # @Warp Terminal
  if check_cli zoxide; then
    eval "$(zoxide init --cmd cd zsh)"
  fi
fi

# @Env
export EDITOR="nvim"
# Kitty ssh wrap
[ ! -z "$KITTY_PUBLIC_KEY" ] && alias ssh="kitten ssh"
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

