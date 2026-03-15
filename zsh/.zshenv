if [[ "$OSTYPE" == "darwin"* ]]; then
  local homebrew_prefix="/opt/homebrew"
  [ -f "${homebrew_prefix}/bin/brew" ] && eval "$(${homebrew_prefix}/bin/brew shellenv)"
fi
