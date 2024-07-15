#!/bin/bash

if $(systemctl --all --type service | grep -q 'smb.service'); [ "$?" -ne 0 ]; then 
  echo "Service 'smb' does not exist. Setting up"  
  sudo smbpasswd -a deck
  sudo cp -rf smb.conf /etc/samba/smb.conf
  sudo systemctl enable smb.service
fi

if $(systemctl is-active --quiet 'smb.service'); [ "$?" -ne 0 ]; then
  echo "Service 'smb' not running. Starting up"
  sudo systemctl start smb.service
fi
