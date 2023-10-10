#!/bin/bash

SCRIPTS_SRC="$(dirname "${BASH_SOURCE[0]}")"
DOTFILES_SRC="${HOME}/src/dotfiles"
ARTISAN_SRC="${HOME}/src/artisan"

function notify {
  script_name="$(basename "$0")"
  message="${1}"
  urgency="${2:-low}"

  notify-send "${script_name}" "${message}" -u "${urgency}"
}

function update_system {
  os=$(hostnamectl status --json=short | jq -r '.OperatingSystemPrettyName')
  case "$os" in
    Gentoo*)
      update_gentoo
      return $?
      ;;
    Ubuntu*)
      update_ubuntu
      return $?
      ;;
    *)
      echo "Updating ${os} systems is not implemented" >&2
      return 1
    esac
}

function update_dotfiles_dependencies {
  cd ${DOTFILES_SRC}
  pip3 install -U --user -r requirements.txt
  status=$?
  cd -
  return $status
}

function update_script_dependencies {
  cd ${SCRIPTS_SRC}
  pipenv update
  status=$?
  cd -
  return $status
}

function update_nvim {
  nvim -c PlugUpdate -c quitall
  return $?
}

function update_kali {
  cd "${SCRIPTS_SRC}/kali"
  make update
  status=$?
  cd -
  return $status
}

function update_k9s {
  LATEST_VERSION=$(curl --silent 'https://api.github.com/repos/derailed/k9s/releases/latest' | jq -r .tag_name)
  CURRENT_VERSION=$(k9s version -s | grep Version | awk '{print "v"$2}')
  if [ "${LATEST_VERSION}" != "${CURRENT_VERSION}" ]; then
    DOWNLOAD_URL=$(curl --silent 'https://api.github.com/repos/derailed/k9s/releases/latest' | jq -r '.assets[] | select(.name == "k9s_Linux_amd64.tar.gz").browser_download_url')
    curl -L "${DOWNLOAD_URL}" | tar xzvf - -C "$(dirname $(which k9s))" k9s;
    return $?
  fi
  return 0
}

function update_artisan {
  cd "${ARTISAN_SRC}"
  make build-latest
}

function update_ubuntu {
  sudo apt update && \
  sudo apt -y upgrade && \
  sudo apt dist-upgrade && \
  sudo apt -y autoremove
  return $?
}

function update_gentoo {
  sudo emerge --sync && \
  sudo emerge -uaDvN --with-bdeps=y world && \
  sudo emerge --depclean
  sudo eclean distfiles
  sudo eclean packages
  return $?
}

function update_flutter {
  flutter upgrade -f
  return $?
}

function update_android_sdk {
   $HOME/Android/Sdk/cmdline-tools/latest/bin/sdkmanager --update
}

function update_all {
  update_system || notify "System update failed" "critical"
  update_dotfiles_dependencies || notify "dotfiles update failed" "critical"
  update_script_dependencies || notify "scripts update failed" "critical"
  update_nvim || notify "neovim update failed" "critical"
  update_kali || notify "kali update failed" "critical"
  update_k9s || notify "k9s update failed" "critical"
  update_artisan || notify "artisan update failed" "critical"
  update_android_sdk || notify "android sdk update failed" "critical"
  update_flutter || notify "flutter update failed" "critical"
  notify "System update finished"
}

COMMAND="${1-all}"

case "update_${COMMAND}" in
  "update_all")
    update_all
    ;;
  "update_system")
    update_system
    ;;
  "update_dotfiles_dependencies")
    update_dotfiles_dependencies
    ;;
  "update_script_dependencies")
    update_script_dependencies
    ;;
  "update_nvim")
    update_nvim
    ;;
  "update_kali")
    update_kali
    ;;
  "update_k9s")
    update_k9s
    ;;
  "update_artisan")
    update_artisan
    ;;
  "update_android_sdk")
    update_android_sdk
    ;;
  "update_flutter")
    update_flutter
    ;;
  *)
    echo "${COMMAND} is not implemented"
    exit 1
esac
