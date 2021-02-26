```
import psycopg2 as pg
```   
```
def db_connect_slave(user,pwd):
    db_user=user
    db_password=pwd
    db_name=""
    db_host=""

    connection_string = "dbname='" + db_name + "' user='"+ db_user +"' host='" + db_host + "' password='" + db_password +"'"
    try:
        connection = pg.connect(connection_string)
    except:
        print 'error, no connection.'
    return(connection)
```
    
```
    connection=db_connect_slave(db_user,db_pwd)
```	
```
 def baz():
	"""WITH zip_count AS (SELECT zip from targets
	JOIN demographics on demographics.unique_id = targets.unique_id
	WHERE zip = 36003 AND persuasion_target = 1)
	SELECT zip,
	       count(*) from zip_count
	GROUP BY zip;""" 
```
```
read_query=pd.read_sql(baz.__doc__,con=connection)
connection.close()