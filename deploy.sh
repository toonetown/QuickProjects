#!/bin/bash
cd "$(dirname "${0}")"
SOURCE="$(pwd)"
cd ->/dev/null
TARGET="${1}"

[ -n "${TARGET}" ] || {
    echo "Usage: ${0} [/path/to/poc_output]"
    exit 1
}
[ ! -e "${TARGET}" ] || {
    echo "Cannot copy to existing location ${TARGET}"
    exit 1
}
[ -d "$(dirname "${TARGET}")" ] || {
    echo "Directory $(dirname "${POC_DIR}") does not exist"
    exit 1
}

TGT_NAME="$(basename "${TARGET}")"
: ${SRC_NAME:="__qp_template__"}

echo "Copying to '${TARGET}'..."
cp -R "${SOURCE}" "${TARGET}" || exit $?

echo "Cleaning up unneeded files..."
rm -rf "${TARGET}/.git" "${TARGET}/README.md" "${TARGET}/$(basename "${0}")" || exit $?
find "${TARGET}" -name ".DS_Store" -exec rm -f {} \;

echo "Renaming files..."
find "${TARGET}" -d -name "${SRC_NAME}*" -print0 | while IFS= read -r -d '' _F; do
    mv "${_F}" "$(echo "${_F}" | sed -e "s/${SRC_NAME}\([\._][^\.]*\)$/${TGT_NAME}\1/g")" || exit $?
done

echo "Update project name to ${TGT_NAME}..."
find "${TARGET}" -type f -print0 | while IFS= read -r -d '' _F; do
    sed -i '' -e "s/${SRC_NAME}/${TGT_NAME}/g" "${_F}" || exit $?
done

echo "Done!  POC deployed to '${TARGET}'"
exit 0
