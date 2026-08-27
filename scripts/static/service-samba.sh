#!/usr/bin/env bash

_CONFIG=/usr/local/retronas-bsd/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

RN_SYSTEMD_STATUS "smbd"
RN_DIRECT_STATUS "smbstatus" "-vv"