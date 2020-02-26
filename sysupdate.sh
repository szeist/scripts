#!/bin/bash

SCRIPTS_SRC="$(dirname "${BASH_SOURCE[0]}")"
DOTFILES_SRC="${HOME}/src/dotfiles"

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

function update_gems {
  cd ${DOTFILES_SRC}
  bundle update
  cd -
}

function update_pip {
  cd ${DOTFILES_SRC}
  pip install -U --user -r python2-requirements.txt
  pip3 install -U --user -r python3-requirements.txt
  cd ${SCRIPTS_SRC}
  pip install -U --user -r requirements.txt
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


update_system
update_snap
update_pip
update_gems
update_R
update_stack
update_nvim
update_calibre
update_go
