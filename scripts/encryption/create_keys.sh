#!/usr/bin/env bash

# Author: Philip De Lorenzo
# Date: 2023-07-14
# This script creates a GPG key for signing the repository.
set -eou pipefail

# The current working directory.
BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
_CWD=$(pwd)
_CFG=${BASE}/../../adrift/config.yml
_ENV=${BASE}/../../adrift/postgres.env

pfexists=$(echo "$(bash scripts/encryption/get_fingerprint.sh)" | grep "FINGERPRINT" | cut -d':' -f 2 | xargs)

if [[ -n ${pfexists} ]]; then
    echo "[INFO] - Key already exists, you will have to delete the keys before re-creating them!"
    exit 0
fi

# The name of the repository.
_INFO="{{ cookicutter.__service_title }}"
_INFO_NAME="{{ cookicutter.__service_name }}"
_NAME="{{ cookicutter.__service_name }}.application"
_COMMENT="This is the GPG key for ${_INFO}."

# Passphrase: %echo ""
# Remove the passphrase: %no-protection if you want to password protect the key.
# This is the passphrase for the GPG key.
cat >data <<EOF
     %no-protection
     %echo Generating a SRE ${_INFO} GPG Key
     Key-Type: RSA
     Key-Length: 4096
     Subkey-Type: RSA
     Subkey-Length: 4096
     Name-Real: ${_INFO_NAME}
     Name-Comment: ${_COMMENT}
     Name-Email: ${_NAME}
     Expire-Date: 0
     # Do a commit here, so that we can later print "done" :-)
     %commit
     %echo done
EOF

gpg --batch --gen-key data

unset_data()
{
     unset _CWD
     unset _INFO
     unset _INFO_NAME
     unset _REPOLOCATION
     unset _REPO
     unset _NAME
     unset _COMMENT
}

# Let's clean up the data.
unset_data

echo "[INFO] - Done!"
exit 0
