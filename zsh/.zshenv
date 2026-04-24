if [[ "$OSTYPE" == "darwin"* ]]; then
  local homebrew_prefix="/opt/homebrew"
  [ -f "${homebrew_prefix}/bin/brew" ] && eval "$(${homebrew_prefix}/bin/brew shellenv)"
elif [[ "$OSTYPE" == "linux"* ]]; then
  local homebrew_prefix="/home/linuxbrew/.linuxbrew"
  [ -f "${homebrew_prefix}/bin/brew" ] && eval "$(${homebrew_prefix}/bin/brew shellenv)"
fi

# prompt env
export AGKOZAK_PROMPT_DIRTRIM=0
# export AGKOZAK_FORCE_ASYNC_METHOD="usr1" # subst-async zsh-async usr1 none
export AGKOZAK_LEFT_PROMPT_ONLY=1
