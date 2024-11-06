#!/bin/bash -i

set -e

source ./lib/library_scripts.sh
source ./lib/homebrew-package.sh

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-contrib/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations,
# and if missing - will download a temporary copy that automatically get deleted at the end
# of the script
# TODO: Centralize nanolayer location var
ensure_nanolayer nanolayer_location "v0.5.6"

# Additional apt packages
# TODO: gate to apt using distros
$nanolayer_location \
  install \
  apt \
  "ghcr.io/devcontainers-contrib/features/homebrew-package" \
  --option packages="gum, pre-commit"

chezmoi --version || brew install chezmoi

# Install brew packages
# https://medium.com/@linuxadminhacks/understanding-mapfile-command-in-linux-9a13a2e2008a
mapfile -t brew_features < <(chezmoi data --format json | jq -r '.homebrew.packages[]')

install_many_via_homebrew "${brew_features[@]}"

echo 'Done!'
