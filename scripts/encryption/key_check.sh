#!/usr/bin/env bash

# Author: Philip De Lorenzo
# Date: 2023-07-14

# This script checks for a key.
#set -eou pipefail

# The name of the repository.
_INFO="{{ cookicutter.__service_title }}"
_INFO_NAME="{{ cookicutter.__service_name }}"
_REPOLOCATION="$(git rev-parse --show-toplevel)"
_REPO="$(basename "${_REPOLOCATION}")"

function get_fingerprint() {
    local _FINGERPRINT
    _FINGERPRINT="$(gpg --list-keys | grep "${_INFO_NAME}")"
    echo "${_FINGERPRINT}"
}

FINGERPRINT=$(get_fingerprint) # Setting the fingerprint value from the function.

if [[ -z ${FINGERPRINT} ]]; then
    echo "[INFO] - There is no GPG key for: ${_INFO}"
    printf "[INFO] - Please run the following command to create a GPG key: bash create_keys.sh\n"
else
    printf "[INFO] - Key already exists!\n"
fi

unset_data()
{
    unset _INFO
    unset _INFO_NAME
    unset _REPOLOCATION
    unset _REPO
    unset _FINGERPRINT
    unset FINGERPRINT
}

# Let's clean up the data.
unset_data

exit 0
