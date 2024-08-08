#!/bin/bash -i

set -e

source ./library_scripts.sh

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-contrib/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations, 
# and if missing - will download a temporary copy that automatically get deleted at the end 
# of the script
ensure_nanolayer nanolayer_location "v0.5.6"

source ./active_os.sh && active_operating_system_uname

declare -ar brew_features=(
  chezmoi
  curl
  eza
  fzf
  gh
  git
  go-task
  jq
  prettier
  shellcheck
  shfmt
  sqlite
  starship
  tldr
  vim
  yq
  zinit
  )

for feature in "${brew_features[@]}"; do
  if [[ $(command -v $feature) ]]; then
    echo "skipping installed feature $feature"
    continue
  fi

  $nanolayer_location \
      install \
      devcontainer-feature \
      "ghcr.io/devcontainers-contrib/features/homebrew-package:1.0.7" \
      --option package="$feature" --option version="$VERSION"
done


echo 'Done!'