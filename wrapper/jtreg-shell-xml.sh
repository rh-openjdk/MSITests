#!/bin/bash
# shellcheck disable=SC2002

function printXmlTest { # classname testname, time, file, jenkins view_dir
  local classname="$1"
  local testname="$2"
  local time="$3"
  local logFile="$4"
  local viewFileStub="$5"
  echo -n "    <testcase classname=\"$classname\" name=\"$testname\" time=\"$time\""
  if [ -z "$logFile" ]; then
    echo "/>"
  else
    echo ">"
    if cat "$logFile" | grep -q "^\!skipped!" ; then
      local skipMessage
      skipMessage=$(cat "$logFile" | grep -e   "^\!skipped!" | tail -n 1)
      echo "<skipped message=\"$skipMessage - see: $viewFileStub\"/>"
    else
      echo "      <failure message=\"see: $viewFileStub\" type=\"non zero sub-shell return code\">"
      echo -n "        <![CDATA["
      echo "----head -n 10----"
      head -n 10 "$logFile" | sed "s/attribute:.\+plugin/attribute: <INVALID CHAR 05 0A>plugin/g" || true
      echo "-------------- grep -n -i -e fail -e error -e \"not ok\" -B 5 -A 5--------------"
      grep -n -i -e fail -e error -e "not ok" -B 5 -A 5 "$logFile" | sed "s/attribute: .\+plugin/attribute: <INVALID CHAR 05 0A>plugin/g" || true
      echo "-------------- tail -n 10 --------------"
      tail -n 10 "$logFile" | sed "s/attribute:.\+plugin/attribute: <INVALID CHAR 05 0A>plugin/g" || true
      echo "]]>
        </failure>" 
    fi
    echo "    </testcase>"
  fi
}

function printXmlHeader { # passed failed tests
  local passed="$1"
  local failed="$2"
  local tests="$3"
  local skipped="$4"
  local classsuite="$5"
  local hostname
  hostname=$(hostname)
  local datetime
  datetime=$(date +%Y-%m-%dT%H:%M:%S)
  echo "<?xml version=\"1.0\"?>"
  echo "<testsuites>" 
  echo "  <testsuite errors=\"0\" failures=\"$failed\" passed=\"$passed\" tests=\"$tests\" skipped=\"$skipped\" name=\"$classsuite\" hostname=\"$hostname\" time=\"0.1\" timestamp=\"$datetime\">" #2018-03-24T22:19:45
}

function printXmlFooter { 
  echo "    <system-out></system-out>"
  echo "    <system-err></system-err>"
  echo "  </testsuite>"
  echo "</testsuites>"
}

function printNextTestsuiteStart {
  local passed="$1"
  local failed="$2"
  local tests="$3"
  local skipped="$4"
  local classsuite="$5"
  local hostname
  hostname=$(hostname)
  local datetime
  datetime=$(date +%Y-%m-%dT%H:%M:%S)
  echo "  </testsuite>" 
  echo "  <testsuite errors=\"0\" failures=\"$failed\" passed=\"$passed\" tests=\"$tests\" skipped=\"$skipped\" name=\"$classsuite\" hostname=\"$hostname\" time=\"0.1\" timestamp=\"$datetime\">" #2018-03-24T22:19:45
}

