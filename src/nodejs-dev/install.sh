#!/bin/bash -i

set -e

USERNAME="${USERNAME:-"${_REMOTE_USER:-"vscode"}"}"
FEATURE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
user_home=/home/"${USERNAME}"

# shellcheck disable=SC1091
source "${FEATURE_DIR}/lib/library_scripts.sh"

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-contrib/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations,
# and if missing - will download a temporary copy that automatically get deleted at the end
# of the script
ensure_nanolayer nanolayer_location "v0.5.6"

declare -ar npm_features=(
  nx
  tsx
  express-generator
  express-generator-typescript
)

if ! [[ -d ${XDG_DATA_HOME:-$user_home/.local/share}/nvm ]]; then
  echo "Installing nvm..."
  $nanolayer_location \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers/features/node" \
    --option nvmInstallPath="${XDG_DATA_HOME:-$user_home/.local/share}/nvm"
fi

for feature in "${npm_features[@]}"; do
  if [[ $(command -v "$feature") ]]; then
    echo "Skipping $feature, already installed"
    continue
  fi

  $nanolayer_location \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers-contrib/features/npm-package" \
    --option package="$feature"
done

echo 'Done!'
