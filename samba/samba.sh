#!/bin/bash

SCRIPT_DIR="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"

SAMBA_CONF_SRC_PATH=$SCRIPT_DIR/smb.conf
SAMBA_CONF_DEST_PATH=/etc/samba/smb.conf

sudo pacman -Sy --noconfirm --needed samba

if $(systemctl is-enabled --quiet smb.service); [ "$?" -ne 0 ]; then
  echo "[INFO]: Service 'smb' does not exist. Setting up..."
  sudo smbpasswd -a deck
  sudo systemctl enable smb.service
fi

if $(firewall-cmd --zone=public --query-service=samba --quiet); [ "$?" -ne 0 ]; then
  echo "[INFO]: Setting up firewall for the 'samba' service..."
  firewall-cmd --permanent --zone=public --add-service=samba
  firewall-cmd --reload
fi

if [ ! -f $SAMBA_CONF_DEST_PATH ]; then
  echo "[INFO]: Samba configuration file missing. Copying..."
  sudo cp -rf $SAMBA_CONF_SRC_PATH $SAMBA_CONF_DEST_PATH
fi

if $(systemctl is-active --quiet 'smb.service'); [ "$?" -ne 0 ]; then
  echo "[INFO]: Service 'smb' not running. Starting up..."
  sudo systemctl start smb.service
fi

if $(systemctl is-active --quiet smb.service); [ "$?" -eq 0 ]; then
  echo "[INFO]: Service 'smb' up and running"
fi

