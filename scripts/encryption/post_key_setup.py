import os
import yaml
import subprocess

CWD = os.path.dirname(os.path.abspath(__file__))
ENCDIR = os.path.join(CWD, "encryption")

_fp_script = os.path.join(ENCDIR, "get_fingerprint.sh")
_config_file = os.path.abspath(os.path.join(CWD, "..", ".sops.yaml"))

# Get the fingerprint
_init = subprocess.run(["bash", _fp_script], capture_output=True).stdout.decode("utf-8")
_current_fingerprint = _init.split(":")[1].strip()

with open(_config_file, "r") as _c:
    _cfg_data = yaml.safe_load(_c)

def fp_info():
    """Function to get the fingerprint information
    
    Returns:
    - _ind: Index of the fingerprint in the list
    - _fingerprint: The fingerprint itself
    """
    _fingerprint = None
    for i in _cfg_data['creation_rules']:
        _ind = _cfg_data['creation_rules'].index(i)
        for k, v in i.items():
            _fingerprint = v if k == "pgp" else None
            break

    return _ind, _fingerprint

def write_configfile(_cfg_data: dict):
    """Function to write the configuration file
    
    Args:
        _cfg_data: The configuration data to write.
    """
    with open(_config_file, "w") as _c:
        yaml.safe_dump(_cfg_data, _c)

# Let's get the fingerprint from the .sops.yaml file, and the index of the list that it is in (it returns a list)
_ind, _fingerprint = fp_info()

if not _fingerprint:
    _cfg_data['creation_rules'][_ind]['pgp'] = _current_fingerprint
    write_configfile(_cfg_data)
    print("[INFO] - Added the fingerprint in the configuration file.")
# Set the fingerprint
elif _current_fingerprint != _fingerprint:
    # We want to assert that the configurations are NOT currently encrypted
    _cfg_data['creation_rules'][_ind]['pgp'] = _current_fingerprint
    write_configfile(_cfg_data)
    print("[INFO] - Updated the fingerprint in the configuration file.")
else:
    print("[INFO] - Fingerprint is already set correctly.")
