#!/bin/bash
cd "$(dirname "${0}")"
SOURCE="$(pwd)"
cd ->/dev/null
TARGET="${1}"

[ -n "${TARGET}" ] || {
    echo "Usage: ${0} [/path/to/proj_output]"
    exit 1
}
[ ! -e "${TARGET}" ] || {
    echo "Cannot copy to existing location ${TARGET}"
    exit 1
}
[ -d "$(dirname "${TARGET}")" ] || {
    echo "Directory $(dirname "${TARGET}") does not exist"
    exit 1
}

TGT_NAME="$(basename "${TARGET}")"
: ${TAG_NAME:="qp_template"}
: ${SRC_NAME:="__${TAG_NAME}__"}

# Tags to replace
TGT_TAGS="name identifier organization"
: ${TGT_name:="${TGT_NAME}"}
: ${TGT_identifier:="com.toonetown.$(echo "${TGT_name}" | sed -e 's/ /-/g')"}
: ${TGT_organization:="Toonetown"}

echo "Copying to '${TARGET}'..."
cp -R "${SOURCE}" "${TARGET}" || exit $?

echo "Cleaning up unneeded files..."
rm -rf "${TARGET}/.git" "${TARGET}/README.md" "${TARGET}/$(basename "${0}")" || exit $?
find "${TARGET}" -name ".DS_Store" -exec rm -f {} \; &>/dev/null
find "${TARGET}" -name "xcuserdata" -type d -exec rm -rf {} \; &>/dev/null

echo "Renaming files..."
find "${TARGET}" -d -name "${SRC_NAME}*" -print0 | while IFS= read -r -d '' _F; do
    mv "${_F}" "$(echo "${_F}" | sed -E "s/${SRC_NAME}([\._][^\.]*)?$/${TGT_NAME}\1/g")" || exit $?
done

echo "Update project name to ${TGT_NAME}..."
find "${TARGET}" -type f -print0 | while IFS= read -r -d '' _F; do
    [[ "$(file -b --mime-encoding "${_F}")" = binary ]] && continue
    sed -i '' -e "s/${SRC_NAME}/${TGT_NAME}/g" "${_F}" || exit $?
done

for _T in ${TGT_TAGS}; do
    _V="TGT_${_T}"
    echo "Update ${_T} to ${!_V}..."
    find "${TARGET}" -type f -print0 | while IFS= read -r -d '' _F; do
        [[ "$(file -b --mime-encoding "${_F}")" = binary ]] && continue
        sed -i '' -e "s|__${TAG_NAME}-${_T}__|${!_V}|g" "${_F}" || exit $?
    done
done

git -C "${TARGET}" init && git -C "${TARGET}" add . && git -C "${TARGET}" commit -m 'First Commit'

echo "Done!  Project deployed to '${TARGET}'"
exit 0
