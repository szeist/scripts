#!/bin/bash

KERNEL_DIR="/usr/src/linux-$(uname -r)"
MODULE_DIR="/lib/modules/$(uname -r)"

for module in $(ls "${MODULE_DIR}/misc/vbox"*.ko); do
  sudo "${KERNEL_DIR}/scripts/sign-file" sha512 "${KERNEL_DIR}/certs/signing_key.pem" "${KERNEL_DIR}/certs/signing_key.pem" "${module}"
done
