#!/usr/bin/env bash

# https://gist.github.com/JoeyBurzynski/cb738cbc6a9f866d9f84c2f94e126778

# * Determine operating system using uname
function active_operating_system_uname() {
  local uname_output
  local active_os

  uname_output="$(uname -s)"

  echo
  echo "Determining active operating system via uname -s"
  echo " » uname output: $uname_output"

  case "${uname_output}" in
    Linux*)     active_os=Linux;;
    Darwin*)    active_os=MacOS;;
    CYGWIN*)    active_os=Cygwin;;
    MINGW*)     active_os=MinGw;;
    FreeBSD*)     active_os=FreeBSD;;
    *)          active_os="UNKNOWN:${uname_output}"
  esac

  echo " ✔ Active Operating System: ${active_os}"

  # * Linux
  if [[ "$active_os" == "Linux" ]]; then
    echo " » Executing Linux logic.."
    
    # Now unshallow for other installs / updates from cache
    git -C /home/linuxbrew/.linuxbrew/homebrew/homebrew-core fetch --unshallow

  # * MacOS
  elif [[ "$active_os" == "MacOS" ]]; then
    echo " » Executing Mac logic.."
    # Now unshallow for other installs / updates from cache
    git -C /usr/local/homebrew/homebrew-core fetch --unshallow

  else
    echo " » Unknown operating system.  Aborting."
    exit 1
  fi
}

active_operating_system_uname