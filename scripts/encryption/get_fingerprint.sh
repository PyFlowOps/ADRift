#!/usr/bin/env bash

# Author: Philip De Lorenzo
# Date: 2023-07-14

# This script creates a GPG key for signing the repository.
#set -eou pipefail

# The name of the repository.
#_INFO="{{ cookicutter.__service_title }}"
_INFO="Adrift Application"
#_INFO_NAME="{{ cookicutter.__service_name }}"
_INFO_NAME="adrift"
_REPOLOCATION="$(git rev-parse --show-toplevel)"
_REPO="$(basename "${_REPOLOCATION}")"
#_NAME="{{ cookicutter.__service_name }}.application"
_NAME="adrift.application"

function get_fingerprint() {
    set +e
    local _FINGERPRINT
    _FINGERPRINT="$(gpg --list-keys --quiet "${_NAME}" | xargs | cut -d' ' -f 5)" 2>&1>/dev/null || { echo "No Fingerprint Found..." >&2; exit 1; }
    echo "${_FINGERPRINT}"
    set -e
}

FINGERPRINT=$(get_fingerprint) # Setting the fingerprint value from the function.

if [[ -z ${FINGERPRINT} ]]; then
    echo "[INFO] - There is no GPG key for: ${_INFO}"
else
    printf "[INFO] - FINGERPRINT: %s\n" "${FINGERPRINT}"
fi

unset_data()
{
    unset _INFO
    unset _INFO_NAME
    unset _REPOLOCATION
    unset _REPO
    unset _NAME
    unset _FINGERPRINT
    unset FINGERPRINT
}

# Let's clean up the data.
unset_data

exit 0
