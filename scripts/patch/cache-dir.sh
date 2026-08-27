#!/bin/sh

_CONFIG=/usr/local/retronas-bsd/config/retronas.cfg
source $_CONFIG

[ ! -d $ACACHEDIR ] && mkdir -p $ACACHEDIR
