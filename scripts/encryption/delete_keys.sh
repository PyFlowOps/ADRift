#!/usr/bin/env bash
#!/usr/bin/env bash

# Author: Philip De Lorenzo
# Date: 2023-07-14

# This script creates a GPG key for signing the repository.
set -eou pipefail
BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
_CFG=${BASE}/../../adrift/config.yml
_ENV=${BASE}/../../adrift/postgres.env

# The name of the repository.
_INFO="Adrift Application"
_INFO_NAME="adrift"
LOCATION=${HOME}/.adrift

#_INFO="{{ cookicutter.__service_title }}"
#_INFO_NAME="{{ cookicutter.__service_name }}"
#LOCATION=${HOME}/.{{ cookicutter.__service_name }}
_PUBLICFILENAME="${_INFO_NAME}_public_key.pgp"
_PRIVATEFILENAME="${_INFO_NAME}_private_key.rsa"

# Before we delete any keys, let's make sure that the keys exist.
pfexists=$(echo "$(bash scripts/encryption/get_fingerprint.sh)" | grep "FINGERPRINT" | cut -d':' -f 2 | xargs)

if [[ -n ${pfexists} ]]; then
    # If the ['sops'] key is in the config file, then this config is currently encrypted.
    if [[ -n $(grep -Fxq '[sops]' ${_CFG}) ]] || [[ -n $(grep -Fxq '[sops]' ${_ENV}) ]]; then
        echo "Decrypting Configs..."
        make decrypt-configs
    else
        echo "[INFO] - Configs not encrypted currently!"
        exit 0
    fi
fi

if [ -z "$(gpg --list-secret-keys | grep "${_INFO_NAME}")" ]; then
    echo "There is no secret key, checking public key for encrypting..."
else
    gpg --delete-secret-key "${_INFO_NAME}"
fi

if [ -z "$(gpg --list-keys | grep "${_INFO_NAME}")" ]; then
    echo "There is no public key..."
else
    gpg --delete-key "${_INFO_NAME}"
fi

unset_data()
{
    unset _INFO
    unset _INFO_NAME
    unset LOCATION 
    unset _PRIVATEFILENAME
    unset _PUBLICFILENAME
}

# Let's clean up the data.
unset_data

echo "[INFO] - Done!"
exit 0
