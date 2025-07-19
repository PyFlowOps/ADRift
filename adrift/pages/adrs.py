import os
import json
import time
import uuid
import requests
import threading
import datetime
import streamlit as st
import extra_streamlit_components as stx
import pandas as pd
from streamlit_dynamic_filters import DynamicFilters
from config.app import Config as AppConfig
from st_pages import Page, add_page_title
from components.tables import table_container, two_table_container

# Let's set the configuration(s)
app_config = AppConfig()
#st.logo("logo.png") # This is the logo for the app

def create_form():
    st.title("Create ADR Form")
    st.write("Use this form to create an ADR")


    with st.form("my_form"):
        _date = datetime.date.today().strftime('%d, %b %Y')
        adr_title = st.text_input("ADR Title")
        st.write("Created Date: ", _date)
        status = st.selectbox("Status", ("proposed", "rejected", "deprecated", "accepted", "superseded"))
        decision_makers = st.multiselect("Decision Makers", ["Person 1", "Person 2", "Person 3"])
        consulted = st.multiselect("Consulted", ["Person 1", "Person 2", "Person 3"])
        informed = st.multiselect("Informed", ["Person 1", "Person 2", "Person 3"])
        context = st.text_area("Context", "What is the issue that we're seeing that is motivating this decision or change?", max_chars=1000)
        decision = st.text_area("Decision", "What is the change that we're proposing and/or doing?", max_chars=1000)
        consequences = st.text_area("Consequences", "What becomes easier or more difficult to do because of this change?", max_chars=1000)

        # Every form must have a submit button.
        submitted = st.form_submit_button("Create ADR")

        if submitted:
            st.write("ADR Title", adr_title)
