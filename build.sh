#!/bin/bash
#
############
# Build script used to kick off the build servers for macOS builds.  This can also be used to build directly
# in a developer environment.
#
# ----------------------
# USAGE
# ----------------------
# You can specify one (or both) of "Debug" and/or "Release" to the script to specify building debug or release
# builds.  Default is to build both debug and release.
#
# NOTE: Running this script with build server variables set will *FULLY CLEAN* any previous build and all cached
# intermediates.  To do this on a non-build server build, add the option of "--clean"
#
# ----------------------
# ENVIRONMENT VARIABLES
# ----------------------
# The following environment variables are honored by the build system.  Most of these should ONLY be set by the
# official build server:
#
# XCODE=/Path/To/Xcode.app
#   Default: /Applications/Xcode.app
#
# The following variable is used by the Windows script, but is documented here for completeness
#
# MSBUILD=c:\Path\To\MSBuild\Version
#   Default: c:\Program Files (x86)\MSBuild\14.0
#
cd "$(dirname "${0}")"
ROOT_DIR="$(pwd)"
cd ->/dev/null

: ${XCODE:="/Applications/Xcode.app"}
: ${PROJ_NAME:="__qp_template__"}
DOCLEAN="no"

: ${XCODE:="/Applications/Xcode.app"}
CONFS=
CLEANONLY="no"
while [ $# -gt 0 ]; do
    shopt -s nocasematch
	if [[ "${1}" == "--clean" ]]; then DOCLEAN="yes"; fi
    if [[ "${1}" == "Debug" ]]; then CONFS="${CONFS} Debug"; fi
    if [[ "${1}" == "Release" ]]; then CONFS="${CONFS} Release"; fi
	if [[ "${1}" == "Clean" ]]; then CLEANONLY="yes"; DOCLEAN="yes"; fi
    shopt -u nocasematch
    shift
done
if [ "${CONFS}" == "" ]; then CONFS=" Debug Release"; fi

cd "${ROOT_DIR}/${PROJ_NAME}_xcode" || exit $?

if [ "${DOCLEAN}" == "yes" ]; then
	echo "===================="
	echo "Cleaning previous builds..."
	rm -rf "${HOME}/Library/Developer/Xcode/DerivedData/${PROJ_NAME}-"* "${ROOT_DIR}/build"
	echo ""
fi

if [ "${CLEANONLY}" == "yes" ]; then
	exit 0
fi

echo "===================="
echo "Building configurations (${CONFS} ) with ${XCODE}..."
for T in ${CONFS}; do
    "${XCODE}/Contents/Developer/usr/bin/xcodebuild" -project ${PROJ_NAME}.xcodeproj -configuration ${T} build || {
	    exit $?
	}
done
