#!/bin/sh

case "$1" in
  "stop")
    sudo systemctl stop mdatp mfetpd mfeespd mcafee.ma
    ;;
  "start")
    sudo systemctl start mdatp mfetpd mfeespd mcafee.ma
    ;;
esac
