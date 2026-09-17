import streamlit as st
import sqlite3
import pandas as pd



DB_NAME = "database.db"




def get_connection():
    return sqlite3.connect(DB_NAME)




st.set_page_config(
    page_title="Bug Bounty Tracking System",
    page_icon="🛡️",
    layout="wide"
)




st.title("🛡️ Vulnerability & Bug Bounty Tracking System")

st.markdown(
    """
    **Provenance-Enabled RDBMS**

    A database system for tracking vulnerabilities,
    bug bounty payouts, administrators, and complete
    data provenance history.
    """
)




st.sidebar.title("Navigation")

page = st.sidebar.radio(
    "Select a section:",
    [
        "Database Overview",
        "Vulnerability Tracker",
        "Provenance & Audit Logs"
    ]
)




if page == "Database Overview":

    st.header("📊 Database Overview")

    connection = get_connection()

    hackers = pd.read_sql_query(
        "SELECT * FROM Hackers",
        connection
    )

    assets = pd.read_sql_query(
        "SELECT * FROM Assets",
        connection
    )

    vulnerabilities = pd.read_sql_query(
        "SELECT * FROM Vulnerabilities",
        connection
    )

    payouts = pd.read_sql_query(
        "SELECT * FROM BountyPayouts",
        connection
    )

    connection.close()

    # Metrics

    col1, col2, col3, col4 = st.columns(4)

    col1.metric(
        "Hackers",
        len(hackers)
    )

    col2.metric(
        "Assets",
        len(assets)
    )

    col3.metric(
        "Vulnerabilities",
        len(vulnerabilities)
    )

    col4.metric(
        "Bounty Payouts",
        len(payouts)
    )

    st.divider()

    # Vulnerability table

    st.subheader("Vulnerabilities")

    st.dataframe(
        vulnerabilities,
        use_container_width=True
    )

    st.subheader("Assets")

    st.dataframe(
        assets,
        use_container_width=True
    )



elif page == "Vulnerability Tracker":

    st.header("🔎 Vulnerability Tracker")

    connection = get_connection()

    vulnerabilities = pd.read_sql_query(
        """
        SELECT
            v.vuln_id,
            v.title,
            h.handle AS hacker,
            a.asset_name,
            v.severity_score,
            v.severity_level,
            v.status,
            v.date_reported
        FROM Vulnerabilities v
        JOIN Hackers h
            ON v.hacker_id = h.hacker_id
        JOIN Assets a
            ON v.asset_id = a.asset_id
        ORDER BY v.severity_score DESC
        """,
        connection
    )

    connection.close()



    search = st.text_input(
        "Search vulnerability:"
    )

    if search:

        vulnerabilities = vulnerabilities[
            vulnerabilities["title"]
            .str.contains(
                search,
                case=False,
                na=False
            )
        ]

    st.dataframe(
        vulnerabilities,
        use_container_width=True
    )

  

    st.subheader("📈 Severity Score")

    chart_data = vulnerabilities[
        ["vuln_id", "severity_score"]
    ].set_index("vuln_id")

    st.bar_chart(chart_data)




elif page == "Provenance & Audit Logs":

    st.header("🔐 Provenance & Audit Logs")

    connection = get_connection()

    audit_vulnerabilities = pd.read_sql_query(
        """
        SELECT *
        FROM Audit_Vulnerabilities
        ORDER BY timestamp DESC
        """,
        connection
    )

    audit_bounties = pd.read_sql_query(
        """
        SELECT *
        FROM Audit_BountyPayouts
        ORDER BY timestamp DESC
        """,
        connection
    )

    connection.close()

    st.subheader("Vulnerability Audit")

    st.dataframe(
        audit_vulnerabilities,
        use_container_width=True
    )

    st.subheader("Bounty Audit")

    st.dataframe(
        audit_bounties,
        use_container_width=True
    )