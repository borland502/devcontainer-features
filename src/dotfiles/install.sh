#!/bin/bash -i

set -e

source ./library_scripts.sh

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-contrib/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations, 
# and if missing - will download a temporary copy that automatically get deleted at the end 
# of the script
ensure_nanolayer nanolayer_location "v0.5.6"

declare -ar brew_features=(
  chezmoi
  zinit  
)

source ./active_os.sh && active_operating_system_uname

for feature in "${brew_features[@]}"; do
  $nanolayer_location \
      install \
      devcontainer-feature \
      "ghcr.io/devcontainers-contrib/features/homebrew-package:1.0.7" \
      --option package="$feature" --option version="$VERSION"
done

declare -ar npm_features=(
  nx
  express-generator
  express-generator-typescript
)

for feature in "${npm_features[@]}"; do
  $nanolayer_location \
      install \
      devcontainer-feature \
      "ghcr.io/devcontainers-contrib/features/npm-package:1.0.3" \
      --option package="$feature" --option version="$VERSION"
done

echo 'Done!'