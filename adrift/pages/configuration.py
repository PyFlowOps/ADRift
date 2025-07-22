import os
import time
import yaml
import dotenv
import configparser
from dataclasses import dataclass
from typing import List

import streamlit as st
import extra_streamlit_components as stx
from streamlit_dynamic_filters import DynamicFilters
from config.app import Config as AppConfig
from st_pages import Page, add_page_title
from components.tables import table_container, two_table_container
from adrift import APP_BASE, PROJECT_BASE, config_file

if os.path.exists(os.path.join(PROJECT_BASE, ".env")):
    dotenv.load_dotenv(os.path.join(PROJECT_BASE, ".env"))

_cfg = yaml.safe_load(open(config_file))
_database_data = _cfg["database"]

# Let's set the tabs for configuration data
#_tabs = st.tabs(["Database Configuration"])

def database():
    """Function to return the database configuration"""
    st.title("Database Configuration")
    st.write(f"_Configuration for the database. Please adjust the config.yml file to change the database connection._")
    _db = st.container()

    with _db:
        for key, value in _database_data.items():
            st.write(f"**{key.title()}**: _{value}_")
