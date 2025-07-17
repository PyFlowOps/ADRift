import os
import json
import time
import uuid
import requests
import threading
import streamlit as st
import extra_streamlit_components as stx
import pandas as pd
from streamlit_dynamic_filters import DynamicFilters

from config.app import Config as AppConfig
from st_pages import Page, Section, add_page_title, get_nav_from_toml
from components.tables import table_container, two_table_container

from pages import adrs, configuration, home

st.set_page_config(layout="wide")

BASE = os.path.abspath(os.path.dirname(__file__))
toml_location = os.path.join(BASE, ".streamlit")

# Let's set the configuration(s)
app_config = AppConfig()

#st.logo("logo.png") # This is the logo for the app

# Let's set the asynchonous function
#t1 = threading.Thread(function)
#t1.start()

def main():
    # Pages
    main_home = st.Page(home.main_home, title="Home")
    create_adr = st.Page(adrs.create_form, title="Create ADR")
    
    # Configuration for the application
    configuration_page = st.Page(configuration.database, title="Config")

    pg = st.navigation([main_home, create_adr, configuration_page]) # This sets the pages for the app
    pg.run()

if __name__ == "__main__":
    main()   
