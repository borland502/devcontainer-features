#!/bin/bash -i

set -e

source ./lib/library_scripts.sh

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-contrib/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations, 
# and if missing - will download a temporary copy that automatically get deleted at the end 
# of the script
ensure_nanolayer nanolayer_location "v0.5.6"

declare -ar pipx_features=(
  bandit
  cookiecutter
  cruft
  djlint
  jinja2-cli
  nox
  playwright
  pyright
  pytest
  pyupgrade
  poetry
)

for feature in "${pipx_features[@]}"; do
  if [[ $(command -v $feature) ]]; then
    echo "skipping installed feature $feature"
    continue
  fi

  $nanolayer_location \
      install \
      devcontainer-feature \
      "ghcr.io/devcontainers-contrib/features/pipx-package:1.1.7" \
      --option package="$feature" --option version="$VERSION"
done

echo 'Done!'