## resolve folder of this script, following all symlinks,
## http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SCRIPT_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"
    SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
    # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    [[ $SCRIPT_SOURCE != /* ]] && SCRIPT_SOURCE="$SCRIPT_DIR/$SCRIPT_SOURCE"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"
readonly SCRIPT_DIR

# shellcheck disable=SC1091
source "$SCRIPT_DIR/testlib.bash"

parseArguments "$@"
processArguments

if [[ $OTOOL_JDK_VERSION -eq 8 ]]; then
  jdk_reg_version=$(reg query "$JDK_REG" | tail -1 | sed 's/.*\\//' | tr -d '\r')
else
  jdk_reg_version=$(reg query "$JDK_REG" | sed 's/\\/\n/g' | sed -n 6p | tr -d '\r')
  jdk_reg_version="${jdk_reg_version/_/.}"
 jdk_reg_version="${jdk_reg_version/_/-}"
fi

JAVA_VERSION_FILE=/home/$CURRENT_USER_NAME/version
$JAVA_INSTALL_DIR/bin/java -version 2>&1 | tee $JAVA_VERSION_FILE

if ! cat $JAVA_VERSION_FILE | grep $jdk_reg_version; then
    echo "versions of file and registry do not match [${jdk_reg_version}] [$(ls)]"
    exit 1
fi
