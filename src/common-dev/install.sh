#!/bin/bash -i

set -e

USERNAME="${USERNAME:-"${_REMOTE_USER:-"vscode"}"}"

source ./lib/library_scripts.sh
source ./lib/homebrew-package.sh

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-contrib/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations,
# and if missing - will download a temporary copy that automatically get deleted at the end
# of the script
# TODO: Centralize nanolayer location var
ensure_nanolayer nanolayer_location "v0.5.6"

$nanolayer_location \
  install \
  devcontainer-feature \
  "ghcr.io/devcontainers/features/common" \
  --option username="${USERNAME}" --option configureZshAsDefaultShell="true" \
  --option installOhMyZsh="false" --option installOhMyZshConfig="false" \
  --option "upgradePackages=true" --option "nonFreePackages=true"

sudo $nanolayer_location \
  install \
  devcontainer-feature \
  "ghcr.io/devcontainers/features/docker-outside-of-docker" \
  --option version="latest" --option moby="true" \
  --option mobyBuildxVersion="latest" --option dockerComposeVersion="latest" \
  --option dockerDashComposeVersion="latest"

declare -ar brew_features=(
  curl
  gum
  gh
  git
  go-task
  jq
  rsync
  unison
  vim
  wget
  yq
)

install_many_via_homebrew "${brew_features[@]}"

echo 'Done!'
