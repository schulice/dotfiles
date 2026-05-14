function check_and_push_path_front() {
    local dir
    for dir in "$@"; do
        [ -d "$dir" ] && PATH="$dir:$PATH"
    done
    export PATH
}

if [[ "$OSTYPE" == "darwin"* ]]; then
  local homebrew_prefix="/opt/homebrew"
  [ -f "${homebrew_prefix}/bin/brew" ] && eval "$(${homebrew_prefix}/bin/brew shellenv)"
  export PNPM_HOME="$HOME/Library/pnpm"
  local homebrew_prefix="/opt/homebrew"
  [ -f "${homebrew_prefix}/bin/brew" ] && eval "$(${homebrew_prefix}/bin/brew shellenv)"
  [ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env
  export BUN_INSTALL="$HOME/.bun"
  # [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
  check_and_push_path_front \
    "/opt/homebrew/opt/libpq/bin" \
    "/opt/homebrew/opt/riscv-gnu-toolchain/bin" \
    "/opt/homebrew/opt/binutils/bin" \
    "$BUN_INSTALL/bin"
elif [[ "$OSTYPE" == "linux"* ]]; then
  local homebrew_prefix="/home/linuxbrew/.linuxbrew"
  [ -f "${homebrew_prefix}/bin/brew" ] && eval "$(${homebrew_prefix}/bin/brew shellenv)"
fi

[ -n "${PNPM_HOME-}" -a -d "$PNPM_HOME" ] && export PATH="$PNPM_HOME:$PATH"
check_and_push_path_front \
    "$HOME/go/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/.local/bin"

# prompt env
export AGKOZAK_PROMPT_DIRTRIM=0
export AGKOZAK_FORCE_ASYNC_METHOD="zsh-async" # subst-async zsh-async usr1 none
export AGKOZAK_LEFT_PROMPT_ONLY=1
# export AGKOZAK_COLORS_BRANCH_STATUS=default
export AGKOZAK_COLORS_CMD_EXEC_TIME=yellow
