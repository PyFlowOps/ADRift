import streamlit as st
import pandas as pd
from awesome_table import AwesomeTable
from awesome_table.column import (Column, ColumnDType)

def table_container():
    # Let's set the container for two tables, one left, one right
    _container = st.container()
    tables1, tables2 = _container.columns([1,1])

    with tables1:
        tables1.title("Table Title 1")
        c1, c2, c3 = tables1.columns([1,1,1])
        with c1:
            c1.write("Column 1")
        with c2:
            c2.write("Column 2")
        with c3:
            c3.write("Column 3")

    # Let's add a separator
    _container.markdown("""<hr style="height:px;border:none;color:#333;background-color:#333;" /> """, unsafe_allow_html=True)

def two_table_container():
    # Let's set the container for two tables, one left, one right
    _container = st.container()
    tables1, tables2 = _container.columns([1,1])

    with tables1:
        tables1.title("Table Title 1")
        c1, c2, c3 = tables1.columns([1,1,1])
        with c1:
            c1.write("Column 1")
        with c2:
            c2.write("Column 2")
        with c3:
            c3.write("Column 3")

    with tables2:
        tables2.title("Table Title 2")
        c1, c2, c3 = tables2.columns([1,1,1])
        with c1:
            c1.write("Column 1")
        with c2:
            c2.write("Column 2")
        with c3:
            c3.write("Column 3")

    # Let's add a separator
    _container.markdown("""<hr style="height:px;border:none;color:#333;background-color:#333;" /> """, unsafe_allow_html=True)

def test_table_with_search():
    sample_data = {
        "id": 1,
        "adr_title": "Test ADR Title",
        "status": "proposed",
        "_date": "01, Jan 2023",
        "decision_makers": ["Person 1", "Person 2"],
        "consulted": ["Person 3", "Person 4"],
        "informed": ["Person 5", "Person 6"],
        "context": "This is the context of the ADR.",
        "decision": "This is the decision made.",
        "consequences": "These are the consequences of the decision."
    }

    _table = AwesomeTable(pd.json_normalize(sample_data), columns=[
        Column(name='id', label='ID'),
        Column(name='adr_title', label='ADR Title'),
        Column(name='status', label='Status'),
        Column(name='_date', label='Date'),
        Column(name='decision_makers', label='Decision Makers'),
        Column(name='consulted', label='Consulted'),
        Column(name='informed', label='Informed'),
        Column(name='context', label='Context'),
        Column(name='decision', label='Decision'),
        Column(name='consequences', label='Consequences'),
        #Column(name='_url.social_media', label='Social Media', dtype=ColumnDType.ICONBUTTON, icon='fa-solid fa-share-nodes'), ## From FontAwesome v6.0.0
        #Column(name='_url.document', label='Document', dtype=ColumnDType.DOWNLOAD),
    ], show_search=True, key="test_table_with_search")

    return _table

def table_with_search(data: dict | None = None):
    """
    Function to display a table with search functionality.
    """
    if data is None or not data:
        st.warning("No data available to display.")
        return

    # This is a test function to show how the table with search works
    AwesomeTable(pd.json_normalize(data), columns=[
        Column(name='adr_title', label='ADR Title'),
        Column(name='status', label='Status'),
        Column(name='_date', label='Date'),
        Column(name='decision_makers', label='Decision Makers'),
        Column(name='consulted', label='Consulted'),
        Column(name='informed', label='Informed'),
        Column(name='context', label='Context'),
        Column(name='decision', label='Decision'),
        Column(name='consequences', label='Consequences'),
        #Column(name='_url.social_media', label='Social Media', dtype=ColumnDType.ICONBUTTON, icon='fa-solid fa-share-nodes'), ## From FontAwesome v6.0.0
        #Column(name='_url.document', label='Document', dtype=ColumnDType.DOWNLOAD),
    ], show_search=True, key="table_with_search")
