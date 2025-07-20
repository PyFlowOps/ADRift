import os
import time
import yaml
import dotenv
import configparser
from dataclasses import dataclass
from typing import List
from adrift import APP_BASE, PROJECT_BASE, config_file

_configparser = configparser.ConfigParser()
_configparser.read(os.path.join(APP_BASE, "config.ini")) # This is an ini file for the configuration -- depreciated
_config = yaml.safe_load(open(config_file)) # This is the configuration file, in YAML format for ease of use

if os.path.exists(os.path.join(PROJECT_BASE, ".env")):
    dotenv.load_dotenv(os.path.join(PROJECT_BASE, ".env"))

@dataclass
class ADR():
    #id: int
    title: str
    status: str
    decision_makers: List[str]
    consulted: List[str]
    informed: List[str]
    context: str
    decision: str
    consequences: str
    created_date: str
    modified_date: str
