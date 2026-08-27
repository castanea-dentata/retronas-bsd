#!/usr/bin/env bash

set -u

# NOTE: this MUST point at your fork, not upstream retronas/retronas.
# retronas.sh re-runs `git reset --hard HEAD && git pull` against this
# repo's origin on every single launch, so pointing it upstream will
# destroy the FreeBSD patches. Change YOURUSER below.
GITREPO='https://github.com/castanea-dentata/retronas-bsd.git'
FORCE=0
TARGET=/usr/local/retronas-bsd

MYID=$( whoami )

_usage() {
  echo "Usage $0" 
  echo "-h this help"
  echo "-o override git repo/branch to install from"
  echo "-f force re-installation (EXPERT)"
  exit 0
}

if [ "${MYID}" != "root" ]
then
  echo "This script needs to be run as sudo/root"
  echo "Please re-run:"
  echo "sudo $0"
  exit 1
fi

OPTSTRING="fho:"
while getopts $OPTSTRING ARG
do
  case $ARG in
    h)
      _usage
      ;;
    o)
      GITREPO="${OPTARG}"
      ;;
    f)
      FORCE=1
      ;;
  esac
done

# handle existing installations
[ -f ${TARGET}/.git/config ] && [ $FORCE -eq 0 ] && echo "Existing installation pass -f to overwrite" && exit 1
[ -f ${TARGET}/.git/config ] && [ $FORCE -eq 1 ] && echo "Installation exists, -f passed, removing" && rm -rf "${TARGET}/"


echo
echo "Updating package catalogue..."
pkg update

echo
echo "Installing necessary tools..."
# NOTE: FreeBSD's dialog(1) build is packaged as "cdialog" (the binary it
# installs is still literally named `dialog`, so nothing downstream needs
# to change). bsddialog, which replaced dialog(1) in FreeBSD base, is
# explicitly NOT a drop-in replacement per FreeBSD's own UPDATING notes -
# cdialog is the officially recommended path for exactly this situation.
# hs-pandoc pulls in a full Haskell toolchain (~200MB); drop it here if you'd
# rather skip that and just accept that documentation rendering won't work
# until installed separately.
pkg install -y sysutils/ansible git cdialog jq hs-pandoc lynx sudo

if [ ! -f ${TARGET}/.git/config ]
then
  echo
  echo "Downloading RetroNAS...from ${GITREPO}"
  # NOTE: cloning explicitly into ${TARGET}. Upstream relied on `cd /opt &&
  # git clone <repo>` producing /opt/retronas from the repo name, which no
  # longer works now the install dir is named retronas-bsd.
  git clone "$GITREPO" "${TARGET}"
  chmod a+x "${TARGET}/retronas.sh"

  if [ $? -eq 0 ]
  then

    # docs
    if [ ! -f ${TARGET}/doc/.git/config ]
    then
      echo "Downloading RetroNAS documentation ...from ${GITREPO}"
      git clone https://github.com/retronas/retronas.wiki.git  ${TARGET}/doc
    fi

    #installing a simple starup script
    cp "${TARGET}/dist/retronas" /usr/local/bin/retronas
    chmod a+x /usr/local/bin/retronas

    echo
    echo "All done.  You can now run the RetroNAS config tool with the following command:"
    echo
    echo "retronas"
    echo
  else
    echo "Installation FAILED, check previous messages"
  fi
fi
