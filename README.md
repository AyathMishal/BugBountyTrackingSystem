Provenance-Enabled RDBMS: Vulnerability & Bug Bounty Tracking System
Overview

This project is a database-based Vulnerability and Bug Bounty Tracking System developed as part of a CSE database project. It is designed to manage security vulnerabilities, hackers, assets, patches, and bounty payments while keeping a record of changes made to important data.

The main focus of the project is data provenance. The system keeps track of how vulnerability and bounty information changes over time, including the previous value, new value, time of change, and the administrator responsible for the change.

Features
Manage hackers and their reputation scores
Manage system assets and their criticality levels
Record reported vulnerabilities
Assign severity scores and severity levels
Track vulnerability status:
Reported
Verified
Patched
Closed
Manage vulnerability patches
Manage bug bounty payouts
Track changes made to vulnerability records
Track changes made to bounty records
Record the administrator responsible for changes
View provenance and audit history
Search and view vulnerabilities through a web interface
Display vulnerability severity information using charts
Technologies Used
Python
SQLite
Streamlit
Pandas
SQL
Visual Studio Code
Database Structure

The main database tables are:

Hackers
Admins
Assets
Vulnerabilities
Patches
BountyPayouts
CurrentUser
Audit_Vulnerabilities
Audit_BountyPayouts

The audit tables and SQL triggers are used to maintain the provenance information automatically whenever relevant records are inserted or updated.

Provenance

The provenance part of the project helps answer questions such as:

Why did a vulnerability receive a particular bounty?
How did a vulnerability move from reporting to patching?
Where did a particular modification come from?
Which administrator made a change?
When was a severity score or bounty amount changed?

This makes it possible to investigate the history of important database records instead of only seeing their current values.

Application

The Streamlit application provides three main sections:

Database Overview

Shows the stored hackers, assets, vulnerabilities, and bounty information.

Vulnerability Tracker

Allows users to search and view vulnerability information, including severity, status, hacker, affected asset, and reporting date.

Provenance & Audit Logs

Displays the recorded changes made to vulnerabilities and bounty payouts, including old values, new values, timestamps, and the administrator responsible.

Project Structure
Provenance-Enabled-RDBMS/
│
├── app.py
├── database.py
├── database.db
├── schema.sql
├── queries.sql
└── README.md
How to Run

Install the required Python packages:

pip install streamlit pandas

Create or initialize the database using the project database setup, then start the application:

streamlit run app.py

The application will open in the browser.

Project Purpose

The project demonstrates how a relational database can be used not only to store security-related information but also to preserve the history and origin of important changes through data provenance and auditing.
