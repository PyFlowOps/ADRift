#!/usr/bin/env bash

set -eo pipefail

BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BASEDIR="${BASE}/.."
_GROUP=$(groups | awk -F' ' '{print $1}')
_PYVER="$(python --version | awk '{print $2}')"
_VIRENVVER="python${_PYVER}"

asdf_plugin_add()
{
    # Add the plugin in asdf
    asdf plugin add "${1}"
}

install()
{
    cd "${BASE}/.." || exit 1 && brew update && brew bundle
}

plugins()
{
    # Let's iterate over the .tool-versions file and then install the plugin
    echo "[INFO] - Running asdf plugin additions..."
    while IFS= read -r line; do
        if [[ -n $(echo "${line}" | grep -v '^#' || true) ]]; then
            plugin=$(echo "${line}" | cut -d' ' -f 1)
            # If the plugin is not already installed, install it, else pass
            if [[ -z $(asdf list | grep "${plugin}" || true) ]]; then
                echo "[INFO] - Installing plugin ${plugin}"
                asdf_plugin_add "${plugin}"
            else
                echo "[INFO] - Plugin '${plugin}' is installed already..."
            fi
        fi
    done < "${BASE}/../.tool-versions"

    echo "[INFO] - Running asdf plugin installations..."
    asdf install
}

asdf_installation()
{
    # Let's check for an asdf installation and use that locally
    _asdf=$(command -v asdf)
    # shellcheck disable=SC2236
    if [[ -z ${_asdf} ]]; then
        install # Let's run the asdf installs
        plugins # Let's add and install needed plugins, i.e. ~> Python, Terraform, etc.
    else
        plugins # Let's add and install needed plugins, i.e. ~> Python, Terraform, etc.
    fi
}

sops_installation()
{
    # Needed variables
    _INFO_NAME="sre_service"
    _PUBLICFILENAME="${_INFO_NAME}.pub"

    # Let's check gpg and sops installation
    _gpg=$(command -v gpg)
    if [[ -z ${_gpg} ]]; then
        echo "[ERROR] - GPG is not installed, please install it and try again."
        echo "[CRITICAL] - You can install via a 'brew bundle' from the repo root."
        exit 1
    else
        echo "[INFO] - GPG is installed, continuing..."

        # Let's import the SRE Service SOPs GPG key
        bash "${BASE}"/sops_gpg/import_gpg_key.sh
    fi
}   

python_installation()
{
    python -m pip install --upgrade pip
    python -m pip install -r "${BASE}/python.txt"
    python -m virtualenv --python=${_VIRENVVER} "${BASEDIR}/.python"
    "${BASEDIR}"/.python/bin/pip install --upgrade pip
    "${BASEDIR}"/.python/bin/pip install -r requirements.txt
}

completed()
{
    echo "[INFO] - Script complete!"
}

usage() { echo "Usage: $0 [-a asdf] [-s sops] [-p [Python Install Flag]]" 1>&2; exit 1; }

while getopts "as:p" arg; do
    case "${arg}" in
        a)
            asdf_installation
            completed
            ;;
        p)
            python_installation
            completed
            ;;
        s)
            sops_installation
            completed
            ;;
        \?)
            echo "[ERROR] - Unknown flag passed"
            usage
            ;;
        :)
            echo "[ERROR] - Option -${arg} requires an argument." >&2
            exit 1
            ;;
        *)
            usage
    esac
done

unset_data()
{
    unset _GROUP
    unset BASE
    unset _INFO_NAME
    unset LOCATION
    unset _PUBLICFILENAME
}

# Let's clean up the data.
unset_data

shift $((OPTIND-1))
