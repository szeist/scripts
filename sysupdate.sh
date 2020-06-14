#!/bin/bash

SCRIPTS_SRC="$(dirname "${BASH_SOURCE[0]}")"
DOTFILES_SRC="${HOME}/src/dotfiles"
MINIKUBE_PATH="/usr/local/bin/minikube"

function update_system {
  sudo apt update
  sudo apt -y upgrade
  sudo apt dist-upgrade
  sudo apt -y autoremove
}

function check_new_calibre_version {
    calibre-debug -c "\
from calibre.gui2.update import get_newest_version;\
from calibre.constants import numeric_version;\
raise SystemExit(int(numeric_version < get_newest_version()))\
"
}

function update_calibre {
  check_new_calibre_version
  if [ $? -ne 0 ]; then
      sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()";
  fi
}

function update_dotfiles_dependencies {
  cd ${DOTFILES_SRC}
  pip install -U --user -r python2-requirements.txt
  pip3 install -U --user -r python3-requirements.txt
  bundle update
  cd -
}

function update_script_dependencies {
  cd ${SCRIPTS_SRC}
  pipenv update
  cd -
}

function update_R {
  R e --no-save --no-restore -e 'update.packages(ask = FALSE, lib = "~/R/x86_64-pc-linux-gnu-library")'
}

function update_nvim {
  nvim -c VundleUpdate -c quitall
}

function update_stack {
  stack upgrade --binary-only
}

function update_snap {
  sudo snap refresh
}

function update_go {
  go get -u -v all
}

function update_kali {
  cd "${SCRIPTS_SRC}/kali"
  make update
  cd -
}

function update_k9s {
  LATEST_VERSION=$(curl --silent 'https://api.github.com/repos/derailed/k9s/releases/latest' | jq -r .tag_name)
  CURRENT_VERSION=$(k9s version -s | grep Version | awk '{print "v"$2}')
  if [ "${LATEST_VERSION}" != "${CURRENT_VERSION}" ]; then
    DOWNLOAD_URL=$(curl --silent 'https://api.github.com/repos/derailed/k9s/releases/latest' | jq -r '.assets[] | select(.name == "k9s_Linux_x86_64.tar.gz").browser_download_url')
    curl -L "${DOWNLOAD_URL}" | tar xzvf - -C "$(dirname $(which k9s))" k9s;
  fi
}

function update_minikube {
  UNIQUE_VERSION_COUNT=$(minikube update-check | sed -e 's/^.*: v//' | sort -u | wc -l)
  if [ "${UNIQUE_VERSION_COUNT}" -ne 1 ]; then
    sudo curl -Lo $MINIKUBE_PATH https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && sudo chmod +x $MINIKUBE_PATH
  fi
}

update_system
update_snap
update_dotfiles_dependencies
update_script_dependencies
update_R
update_stack
update_nvim
update_calibre
update_kali
update_k9s
update_minikube
update_go
