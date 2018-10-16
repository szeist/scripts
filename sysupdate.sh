#!/bin/bash

function check_new_calibre_version {
    calibre-debug -c "\
from calibre.gui2.update import get_newest_version;\
from calibre.constants import numeric_version;\
raise SystemExit(int(numeric_version < get_newest_version()))\
"
}

sudo apt update
sudo apt -y upgrade
sudo apt dist-upgrade
sudo apt -y autoremove

R e --no-save --no-restore -e 'update.packages(ask = FALSE, lib = "~/R/x86_64-pc-linux-gnu-library")'

pip freeze --user | cut -d = -f 1  | xargs -n1 pip install -U --user
pip3 freeze --user | cut -d = -f 1  | xargs -n1 pip3 install -U --user

nvim -c VundleUpdate -c quitall

check_new_calibre_version
if [ $? -ne 0 ]; then
    sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()";
fi

