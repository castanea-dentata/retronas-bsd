#!/usr/bin/env bash

set -u

_CONFIG=/usr/local/retronas-bsd/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
source /etc/os-release

CHECK_ROOT

case $ID in
    freebsd)
        # pkg keeps its own history; there's no apt history.log equivalent
        pkg query -a '%t %n-%v' | sort -rn | head -100 | more
        PAUSE
        ;;
    debian|ubuntu)
        more /var/log/apt/history.log
        PAUSE
        ;;
    *)
        echo "Unsupported OS type $ID"
        PAUSE
        EXIT_CANCEL
        ;;
esac