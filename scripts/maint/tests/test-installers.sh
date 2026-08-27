#!/usr/bin/env bash

#set -e

MODE="all"
PLAYBOOK="install_*.yml"

while getopts "m:p:" OPT
do
  case ${OPT} in
    m)
      MODE=${OPTARG}
      ;;
    p)
      PLAYBOOK=$(basename ${OPTARG})
      ;;
    *)
      usage
      ;;
  esac
done

OUTPATH=/tmp/rtrn_inst_test
KNOWN=/usr/local/retronas-bsd/scripts/maint/tests/test-installers.known

cd /usr/local/retronas-bsd/ansible
[ ! -d ${OUTPATH} ] && mkdir -p $OUTPATH

usage() {
  echo " -m mode [report-only, all]"
  echo " -p playbook [install_playbook.yml]"
  exit 1
}

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
  rm -f $OUTPATH/*.log &> /dev/null
  echo "TESTING Started $(date +'%Y-%m-%d %H:%M:%S')"
  for PLAY in `find -maxdepth 1 -type f -iname "${PLAYBOOK}"`
  do
    echo $PLAY
    ansible-playbook -Cvv "${PLAY}" &> "${OUTPATH}/${PLAY}.log"
    #[ $? -ne 0 ] && echo "Failed on ${PLAY}"
  done
  echo "TESTING Ended $(date +'%Y-%m-%d %H:%M:%S')"
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
