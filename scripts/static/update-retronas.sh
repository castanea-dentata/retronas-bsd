#!/usr/bin/env bash

_CONFIG=/usr/local/retronas-bsd/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

cd ${RNDIR}

git config pull.rebase false
git reset --hard HEAD
git pull

PAUSE
