import streamlit as st

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
