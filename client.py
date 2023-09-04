import os
import psycopg2

# Replace with your PostgreSQL database credentials
db_params = {
    "dbname": "postgres",
    "user": "postgres",
    "password": "postgres",
    "host": os.environ["POSTGRES_HOST"],  # Change this to your PostgreSQL host
    "port": os.environ["POSTGRES_PORT"],  # Default PostgreSQL port is 5432
}

# Connect to the PostgreSQL server
try:
    connection = psycopg2.connect(**db_params)
    connection.autocommit = True  # Set autocommit to True for database creation

    # Create a new database
    new_database_name = "ci"
    with connection.cursor() as cursor:
        cursor.execute(f"CREATE DATABASE {new_database_name}")

    print(f"Database '{new_database_name}' created successfully.")

except (Exception, psycopg2.Error) as error:
    print(f"Error while connecting to PostgreSQL: {error}")

finally:
    # Close the database connection
    if connection:
        connection.close()
