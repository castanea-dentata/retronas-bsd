#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

cd ${RNDIR}

git config pull.rebase false
git reset --hard HEAD
git pull

PAUSE
