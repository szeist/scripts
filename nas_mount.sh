#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

source "${SCRIPT_DIR}/.env"

MOUNT_POINT=/mnt/NAS

if [ "$1" == "-u" ]; then
  sudo umount ${MOUNT_POINT};
else
  [ -d ${MOUNT_POINT} ] || sudo mkdir -p ${MOUNT_POINT}

  NAS_PASS=$(bw --raw get password $NAS_BW_SECRET_ID)
  sudo mount -t cifs -o username=${NAS_USER},password=${NAS_PASS},file_mode=0600,dir_mode=0700,vers=3.0,uid=$(id -u),gid=$(id -g) //${NAS_IP}/${NAS_SHARE} ${MOUNT_POINT};
fi
