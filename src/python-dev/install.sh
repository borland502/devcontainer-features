#!/bin/bash -i

set -e

USERNAME="${_REMOTE_USER:-"vscode"}"
VERSION="${VERSION:-"3.13"}"
user_home=/home/"${USERNAME}"

source ./lib/library_scripts.sh

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-contrib/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations,
# and if missing - will download a temporary copy that automatically get deleted at the end
# of the script
if ! [[ -d ${XDG_DATA_HOME:-$user_home/.local/share}/pyenv ]]; then

  # Install pyenv
  temp_script=$(mktemp)
  echo "PYENV_ROOT=$user_home/.pyenv" >"$temp_script"
  # shellcheck disable=SC2129
  echo "HOME=${user_home}" >>"$temp_script"
  echo "VERSION=${VERSION}" >>"$temp_script"
  cat <<'EOF' >>"$temp_script"
  sudo chown -R "${USERNAME}":"${USERNAME}" "${HOME}"
  echo "export PYENV_ROOT=$PYENV_ROOT" >> ~/.zshrc
  echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(pyenv init -)"' >> ~/.zshrc
  echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
  source ~/.zshrc

  curl https://pyenv.run | zsh

  export PATH="${PYENV_ROOT}/bin:${HOME}/.local/bin:${PATH}"
  eval "$(pyenv init -)"

  pyenv install ${VERSION} --skip-existing
  pyenv global ${VERSION}

  pip install --upgrade pip

  python3 -m pip install --user pipx
  pipx ensurepath

  pipx install pytest \
    poetry 

EOF

  chown "${USERNAME}":"${USERNAME}" "${user_home}"/.profile
  chown "${USERNAME}" "$temp_script"
  su "${USERNAME}" -c "zsh $temp_script"
  rm -f "$temp_script"
fi

if [[ $(command -v poetry) ]]; then
  $nanolayer_location \
    install \
    devcontainer-feature \
    "ghcr.io/nikobockerman/devcontainer-features/poetry-persistent-cache"
fi

echo 'Done!'
