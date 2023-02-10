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

echo "$NOT_IMPLEMENTED"


# get jre version from registry. transformation from regisry format [1.8.0_111_1] to file format [1.8.0.111-1]
#jre_reg_version=$(reg query "$JRE_REG" | sed 's/\\/\n/g' | sed -n 6p | tr -d '\r')
#jre_reg_version="${jre_reg_version/_/.}"
#jre_reg_version="${jre_reg_version/_/-}"
#
#JAVA_VERSION_FILE=/mnt/ramdisk/version
#/mnt/ramdisk/java/bin/java -version 2>&1 | tee $JAVA_VERSION_FILE
#
#if ! cat $JAVA_VERSION_FILE | grep $jdk_reg_version; then
#    echo "versions of file and registry do not match [${jdk_reg_version}] [$(ls)]"
#    exit 1
#fi