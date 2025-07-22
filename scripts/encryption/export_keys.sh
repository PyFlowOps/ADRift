#!/usr/bin/env bash

# Author: Philip De Lorenzo
# Date: 2023-07-14

# This script creates a GPG key for signing the repository.
#set -eou pipefail

# The name of the repository.
set -eou pipefail

BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

_INFO="{{ cookicutter.__service_title }}"
_INFO_NAME="{{ cookicutter.__service_name }}"
LOCATION=${HOME}/.{{ cookicutter.__service_name }}/gpg
_PUBLICFILENAME="${_INFO_NAME}.pub"
_PRIVATEFILENAME="${_INFO_NAME}"
_GROUP=$(groups | awk -F' ' '{print $1}')

# Let's create the main directory if it doesn't exist.
if [[ ! -d "${LOCATION}" ]]; then
    mkdir -p "${LOCATION}"
    # Change the owner to this user.
    chown -R "${USER}":"${_GROUP}" "${LOCATION}"
fi

_PUBLIC_KEY="${LOCATION}/${_PUBLICFILENAME}"
_PRIVATE_KEY="${LOCATION}/${_PRIVATEFILENAME}"

if [[ -f ${_PUBLIC_KEY} ]]; then
    rm -f "${_PUBLIC_KEY}"
fi

if [[ -f ${_PRIVATE_KEY} ]]; then
    rm -f "${_PRIVATE_KEY}"
fi

# Let's create the GPG key(s).
gpg --output "${_PUBLIC_KEY}" --armor --export "${_INFO_NAME}"
gpg --output "${_PRIVATE_KEY}" --armour --export-secret-key "${_INFO_NAME}"

# shellcheck disable=SC2002
cat "${_PUBLIC_KEY}" | base64 | tr -d '\n' > "${_PUBLIC_KEY}.key" # This exports the base64 encoded private key to private.key -- this is for use in the CI/CD pipeline (Kubernetes).


echo "[INFO] - Public Key: ${_PUBLIC_KEY}"
echo "[INFO] - Private Key: ${_PRIVATE_KEY}"

unset_data()
{
    unset _INFO
    unset _INFO_NAME
    unset _PUBLICFILENAME
    unset _PRIVATEFILENAME
    unset _PUBLIC_KEY
    unset _PRIVATE_KEY
    unset LOCATION
    unset BASE
    unset _GROUP
}

# Let's clean up the data.
unset_data

exit 0
