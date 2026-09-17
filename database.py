import sqlite3
import os


DB_NAME = "database.db"
SQL_FILE = "schema.sql"

try:


    if os.path.exists(DB_NAME):
        os.remove(DB_NAME)
        print("Old database deleted successfully.\n")


    connection = sqlite3.connect(DB_NAME)
    cursor = connection.cursor()


    with open(SQL_FILE, "r", encoding="utf-8") as file:
        cursor.executescript(file.read())

    connection.commit()

    print("=" * 60)
    print(" Bug Bounty Tracking Database Created Successfully ")
    print("=" * 60)


    tables = [
        "Hackers",
        "Assets",
        "Vulnerabilities",
        "Patches",
        "BountyPayouts"
    ]

    print("\nTable Summary\n")

    for table in tables:

        cursor.execute(f"SELECT COUNT(*) FROM {table}")

        count = cursor.fetchone()[0]

        print(f"{table:<20} : {count} records")

    print("\n" + "=" * 60)
    print("Database is Ready!")
    print("=" * 60)

except Exception as e:

    print("\nError while creating database:\n")
    print(e)

finally:

    if "connection" in locals():
        connection.close()