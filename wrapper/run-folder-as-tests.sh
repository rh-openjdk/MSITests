#!/bin/bash
# shellcheck disable=SC2219,SC2002,SC2004

set -x
set -e
set -o pipefail

## resolve folder of this script, following all symlinks,
## http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SCRIPT_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  SCRIPT_DIR="$( cd -P "$( dirname "$SCRIPT_SOURCE" )" && pwd )"
  SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
  # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  [[ $SCRIPT_SOURCE != /* ]] && SCRIPT_SOURCE="$SCRIPT_DIR/$SCRIPT_SOURCE"
done
SCRIPT_DIR="$( cd -P "$( dirname "$SCRIPT_SOURCE" )" && pwd )"
readonly SCRIPT_DIR

DIR=$1

if [ "$DIR" == "" ] ; then
 echo "dir with tests reqired"
fi

SUITE=$(basename "$DIR")

FAILED_TESTS=0
ALL_TESTS=0
PASSED_TESTS=0
SKIPPED_TESTS=0
tmpXmlBodyFile=$(mktemp)
export RESULTS_FOLDER="$( readlink -m "$RESULTS_FOLDER" )"
export INPUT_FOLDER="$( readlink -m "$INPUT_FOLDER" )"

rm -rf "${SCRIPT_DIR:?}"/"$SUITE"
set -x
mkdir "$RESULTS_FOLDER"
if [ "$?" -ne "0" ]; then
  let FAILED_TESTS=$FAILED_TESTS+1
fi

TESTS=$(ls "$DIR" | grep "\\.sh$" | sort)
echo -n "" > "${RESULTS_FOLDER}"/results.txt

 # shellcheck disable=SC1091
source "$SCRIPT_DIR"/jtreg-shell-xml.sh

function isIgnored() {
  cat "$RESULTS_FOLDER"/"$TEST"-result/global-stdouterr.log | grep -e "^\!skipped!"
}

function failOrIgnore() {
  printXmlTest "$SUITE.test" "$TEST" "0.01" "$RESULTS_FOLDER/$TEST-result/global-stdouterr.log" "../artifact/results/$TEST-result/global-stdouterr.log and ../artifact/results/$TEST-result/report.txt" >> $tmpXmlBodyFile
}

if [ "$RFAT_RERUNS" == "" ] ; then
  RFAT_RERUNS=5
fi

for TEST in $TESTS ; do
  cd "$SCRIPT_DIR"/
  TTDIR=$RESULTS_FOLDER/$TEST-result
  set +e
  for x in $(seq "$RFAT_RERUNS") ; do
    if [ "$x" = "1" ] ; then
      echo  "--------ATTEMPT $x/$RFAT_RERUNS of $TEST ----------"
    else
      echo  "https://gitlab.cee.redhat.com/java-qa/TckScripts/-/merge_requests/88/"
      echo  "--------ATTEMPT $x/$RFAT_RERUNS of $TEST ----------"
    fi
    rm -rf "$TTDIR"
    mkdir "$TTDIR"
    bash "$DIR"/"$TEST"  --jdk="$ENFORCED_JDK" --report-dir="$TTDIR"   2>&1 | tee "$TTDIR"/global-stdouterr.log
    RES=$?
    if [ $RES -eq 0 ] ; then
      break
    fi
  done
  echo "Attempt: $x/$RFAT_RERUNS" >> "$RESULTS_FOLDER"/"$TEST"-result/global-stdouterr.log
  set -e
  if [ "${RES}" -eq 0 ]; then
    if isIgnored ; then
      SKIPPED_TESTS=$(($SKIPPED_TESTS+1))
      echo -n "Ignored" >> "${RESULTS_FOLDER}"/results.txt
      failOrIgnore
    else
      echo -n "Passed" >> "${RESULTS_FOLDER}"/results.txt
      PASSED_TESTS=$(($PASSED_TESTS + 1))
      printXmlTest "$SUITE".test "$TEST" 0.01 >> "$tmpXmlBodyFile"
   fi
  else
    if isIgnored ; then
      SKIPPED_TESTS=$(($SKIPPED_TESTS+1))
      echo -n "Ignored" >> "${RESULTS_FOLDER}"/results.txt
      failOrIgnore
    else
      FAILED_TESTS=$(($FAILED_TESTS+1))
      echo -n "FAILED" >> "${RESULTS_FOLDER}"/results.txt
      failOrIgnore
    fi
  fi
  echo " $TEST" >> "${RESULTS_FOLDER}"/results.txt
  ALL_TESTS=$(($ALL_TESTS+1))
done

printXmlHeader $PASSED_TESTS $FAILED_TESTS $ALL_TESTS $SKIPPED_TESTS "$SUITE" >  "$RESULTS_FOLDER"/"$SUITE".jtr.xml
cat "$tmpXmlBodyFile" >>  "$RESULTS_FOLDER"/"$SUITE".jtr.xml
printXmlFooter >>  "$RESULTS_FOLDER"/"$SUITE".jtr.xml
rm "$tmpXmlBodyFile"
pushd "$RESULTS_FOLDER"
  tar -czf  "$SUITE".tar.gz "$SUITE".jtr.xml
popd

echo "Failed: $FAILED_TESTS"

# returning 0 to allow unstable state
exit 0
