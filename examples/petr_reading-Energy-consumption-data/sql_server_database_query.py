import pandas as pd

# SQL Server library (EMSQL Server application)
import pypyodbc

###

# open the SQL file
with open("sql_final_query.sql", "r") as f:
	sql_query = f.read()	


# Specify connection 
connection_string_address1 = "DRIVER = {ODBC Driver 17 for SQL Server};SERVER=reese.admin.cam.ac.uk:4333;DATABASE=EMSQL;"
connection_string_address2 = "DNS=EMSQLServerDatabase;"
connection_string_credentials = "UID=pd423;PWD=**********"


# Works on one computer
conn1 = pypyodbc.connect(connection_string_address1 + connection_string_credentials)
conn1.close()
# Works on another
conn2 = pypyodbc.connect(connection_string_address2 + connection_string_credentials)


# load data into pandas
df = pandas.read_sql(sql_query,conn2)

#export into csv
df.to_csv("result.csv")

conn2.close()