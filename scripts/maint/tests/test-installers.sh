#!/bin/bash

#set -e

OUTPATH=/tmp/rtrn_inst_test
MODE=${1:-all}
KNOWN=/opt/retronas/scripts/maint/tests/test-installers.known

cd /opt/retronas/ansible
[ ! -d ${OUTPATH} ] && mkdir -p $OUTPATH

fail_report(){
  local FAILMSG="${1:-fatal}"
  for FILE in `ls $OUTPATH/*.log`
  do
    BASENAME=$(basename $FILE .yml.log)
    FAILURE=$(grep "${FAILMSG}" $FILE)
    if [ ! -z "$FAILURE" ]
    then
      REGEX=$(grep $BASENAME $KNOWN | cut -d',' -f2-)
      echo "|-> [${BASENAME}] ${FAILURE}" | grep -E "$REGEX"
    fi
  done

}


if [ $MODE == "all" ]
then

  for PLAY in `find -maxdepth 1 -type f -iname "install_*.yml"`
  do
    ansible-playbook -Cvv "${PLAY}" | tee "${OUTPATH}/${PLAY}.log"
    [ $? -ne 0 ] && echo "Failed on ${PLAY}" && exit 1
  done

fi

echo -e "\n\n"
echo "REPORT"
echo "- fatal ---------------------------------------------------------------------"
echo "|"
fail_report fatal
echo "-----------------------------------------------------------------------------"


echo "- task failed ---------------------------------------------------------------"
echo "|"
fail_report "Task failed"
echo "-----------------------------------------------------------------------------"
echo REPORT END
