import os
import streamlit as st
from config.app import Config as AppConfig
from st_pages import add_page_title
from components.tables import table_container, two_table_container

BASE = os.path.abspath(os.path.dirname(__file__))

# Let's set the configuration(s)
app_config = AppConfig()

def main_home():
    st.title("Home")
    _tabs = st.tabs(app_config.tabs) # This sets the tabs from the config
    _indexes = len(app_config.tabs)

    for _ind in range(0, _indexes):
        with _tabs[_ind]:
            if app_config.tab_data[_ind].type == "table":
                if app_config.tab_data[_ind].number_of_tables == 1:
                    table_container()
                elif app_config.tab_data[_ind].number_of_tables == 2:
                    two_table_container()
