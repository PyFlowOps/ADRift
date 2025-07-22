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
class AppTab():
    title: str
    name: str
    id: int
    description: str
    type: str
    number_of_tables: int
    number_of_cols: int

@dataclass
class ConfigTab():
    title: str
    name: str
    id: int
    description: str
    type: str
    number_of_tables: int
    number_of_cols: int

tab_objects: list[AppTab] = [] # This is the list of tabs, which will be populated by the Tab class

# Let's populate the tabs list
for _tab in _config["app"]["tabs"]:
    _this_tab = _config["app"]["tabs"][_tab]
    # Let's create a temporary Tab object
    __temptab = AppTab(
        id=_this_tab["id"],
        name=_this_tab["name"],
        title=_this_tab["title"],
        description=_this_tab["description"],
        type=_this_tab["type"],
        number_of_tables=_this_tab["number_of_tables"],
        number_of_cols=_this_tab["number_of_cols"]
        )
    # Let's append the temporary Tab object to the tabs list
    tab_objects.append(__temptab)

# Let's get the tabs

class Config():
    """Class for maintaining the configuration"""
    _host: str = _config["api"]["host"]
    _port: str = _config["api"]["port"]
    
    # This is the URL for the API
    # The _host variable will be different depending on whether we are running in Docker Compose or not
    api_url: str = f"http://{_host}:{_port}"
    tabs: List[str] = [_tab.title for _tab in tab_objects]
    tab_data: list[AppTab] = tab_objects

    # This is the configuration tabs for the application

