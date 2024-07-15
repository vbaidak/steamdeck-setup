#!/bin/bash

SCRIPT_DIR="$(dirname -- "$(readlink -f -- "$0";)";)"

if $(systemctl --all --type service | grep -q 'smb.service'); [ "$?" -ne 0 ]; then 
  echo "Service 'smb' does not exist. Setting up"  
  sudo smbpasswd -a deck
  sudo cp -rf $SCRIPT_DIR/smb.conf /etc/samba/smb.conf
  sudo systemctl enable smb.service
fi

if $(systemctl is-active --quiet 'smb.service'); [ "$?" -ne 0 ]; then
  echo "Service 'smb' not running. Starting up"
  sudo systemctl start smb.service
fi
