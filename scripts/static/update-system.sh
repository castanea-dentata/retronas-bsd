#!/usr/bin/env bash

set -u

_CONFIG=/usr/local/retronas-bsd/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
source /etc/os-release

CHECK_ROOT

case $ID in
    freebsd)
        pkg update
        pkg upgrade -y
        pkg autoremove -y
        # NOTE: this updates packages only. Base system updates are
        # `freebsd-update fetch install`, deliberately left out - it can
        # require a reboot and shouldn't fire from a menu item unattended.
        PAUSE
        ;;
    debian|ubuntu)
        apt-get update
        apt-get -y upgrade
        apt-get -y dist-upgrade
        apt-get -y autoremove
        PAUSE
        ;;
    *)
        echo "Unsupported OS type $ID"
        PAUSE
        EXIT_CANCEL
        ;;
esac