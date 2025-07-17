#!/usr/bin/env bash

# Author: Philip De Lorenzo
# Date: 2023-07-14
# This script creates a GPG key for signing the repository.

BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

LOCATION=${HOME}/.{{ cookicutter.__service_name }}

_INFO="{{ cookicutter.__service_title }}"
_INFO_NAME="{{ cookicutter.__service_name }}"
_PUBLICFILENAME="${_INFO_NAME}.pub"
_PRIVATEFILENAME="${_INFO_NAME}"
_PUBLIC_KEY="${LOCATION}/${_PUBLICFILENAME}"
_PRIVATE_KEY="${LOCATION}/${_PRIVATEFILENAME}"

if [[ "$(bash "${BASE}/key_check.sh")" == *"Key already exists!"* ]]; then
    echo "[INFO] - Key already exists!"
else
    gpg --import "${_PUBLIC_KEY}"
fi

unset_data()
{
    unset _INFO
    unset _INFO_NAME
    unset LOCATION
    unset _PUBLICFILENAME
    unset _PRIVATEFILENAME
    unset _PUBLIC_KEY
    unset _PRIVATE_KEY
    unset _FINGERPRINT
    unset _PUBLICFILENAME
}

# Let's clean up the data.
unset_data

exit 0
