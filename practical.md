# The vetrinary hospital    

### Creating the tables in our database:

```
create table cats
(
    name varchar DEFAULT NULL,
    breed varchar DEFAULT NULL,
    house_num int DEFAULT NULL,
    owner_id int DEFAULT NULL
);

create table dogs
(
    name varchar DEFAULT NULL,
    breed varchar DEFAULT NULL,
    house_num int DEFAULT NULL,
    owner_id int DEFAULT NULL
);

create table owners
(
    name varchar DEFAULT NULL,
    phone varchar DEFAULT NULL,
    address varchar DEFAULT NULL,
    id int DEFAULT NULL
);


INSERT INTO cats VALUES ('Bell', 'Siameese', 1, 4), ('Jackson', 'Balinese', 2, 3),
                        ('Precious', 'Himalayan', 3, 4),
                        ('Rocky', 'Egyptian Mau', 4, 2),
                        ('Samson', 'Javanese', 4, 1),
                        ('tobi', 'regular', 2, 0),
                        ('tobi', 'regular', 2, 0);

INSERT INTO dogs VALUES ('Rex', 'Chihuahua', 1, 4),
                        ('Clifford', 'German Shepard', 3, 4),
                        ('Lucky', 'Daschund', 4, 2),
                        ('Bobo', 'Shih-Tzu', 4, 1),
                        ('Buddy', 'Golden Retriever', 2, 0),
                        ('Leo', 'English Bulldog', 2, 0),
                        ('Lulu', 'Hound', 2, 0),
                        ('lulu', 'Hound', 2, 0);


INSERT INTO owners VALUES ('Josh', '313-642', '1440 G St.', 1),
                          ('Alison', '214-709', 'None', 2),
                          ('Avi', '469-878', '1776 NY Ave.', 3),
                          ('Justin', '410-333', 'None', 4);

```


### Let's examine our database tables  
```
SELECT * FROM cats;
SELECT * FROM dogs;
SELECT * FROM owners;
```
```*``` 
means return all columns in the table.

##### Check your tables characteristics
##### get # rows
```
SELECT count(*) from cats;
```
#####  get # columns

```
SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_catalog = ‘mydb’ -- the database
   AND table_name = ‘cats’;
```


### <u>Conditionals </u>
When we hear conditionals we should immediately think about the 
```
WHERE
```
command usually with one or more of the following operators:

``` 
>, >=, <, <=, =, != ,IN, NOT IN, LIKE, %, _, AND, OR
``` 
Understanding the use of like and wild cards (%, _) : [like](https://www.w3schools.com/sql/sql_like.asp)



#### After getting a notification from the health administration
#### We need to find  all cats of breed starting with S to vaccinate them

```
SELECT * FROM cats
WHERE  substr(breed ,0, 2) = 'S'
```
Understanding substr: [substr](https://www.w3schools.com/sql/func_mysql_substr.asp)


#### We know that all pets in houses 2 & 4 are already vaccinated so we can filter them out

#### Or if we know all pets are vaccinated in house number 1onwards


### <u> GROUP BY </u>
<b> Notice: Group by has to come together with an aggregate function </b>

#### The vet comes to you and asks: how many animals would I need to vaccinate per house?
- If you need to create groups (per house) you need the ```GROUP BY``` command
- Every ```GROUP BY``` command comes together with an aggregate function/s like:
```count, avg, min, max, sum ```

- The only column/s that could be called in the select statement without an aggregate functions are the ones that are mentioned in the ```GROUP BY```



```
SELECT  house_number,
        count(name) FROM cats
        WHERE substr(breed ,0, 2) = ‘S’
GROUP BY house_number;
```

- how many breeds are in cats? how many in dogs? 

Harder: 
- What is the average age in each state and gender
- Are inactive voters older on average?  



<b> Notice ```WHERE``` conditional will always appear before ```GROUP BY```! </b>


### <u> Joins & WITH </u>
An extreme catenistic organization is protesting about the ratio
of cats to dogs in veterinary facilities. Our vet got stressed
and asks us to check the ratio!

So what do we need? for each house
we want one row with total num cats and total num dogs

- let’s first try for each pet to find the number of animals


<b> Notice: ```ORDER BY``` will always come after ```GROUP BY``` if there is one </b> 

- Use the order by command to find the oldest active female voter
- How many people are in each age group (e.g. 96, 94) --> do not return each age separately

[Joins](https://stackoverflow.com/questions/53949197/isnt-sql-a-left-join-b-just-a/53949327)
#### We would like now to join between the two
- ```WITH``` helps to build multiple tables inside one query
these tables will only exist in our existing query and won't be accessible outside the query.

```
WITH cats_num AS

--- first table 
(SELECT house_number
, count(*) as num_cats FROM cats
         GROUP BY house_number
        ORDER BY num_cats DESC),

--- second table        
dogs_num AS (SELECT house_number
, count(*) as num_dogs FROM dogs
         GROUP BY house_number
        ORDER BY num_dogs DESC)

--- now we have two new tables in our query memory that we can access regularly 
--- with select from statements

SELECT cats_num.house_number
        , CAST(num_cats AS decimal) /  CAST(num_cats + num_dogs AS Decimal) AS cats_ratio
FROM cats_num
LEFT JOIN dogs_num ON 
					cats_num.house_number = dogs_num.house_number
ORDER BY cats_ratio desc;
```

#### Did we choose the correct Join?


#### Let’s see what would happen if dogs were also placed at house number 5

- insert an entry for another dog in house number 5


- Do all cats have an owner?
- What join will you use here?


- let's assume for fun that 0 in the owner_id column (last entry below) means that there is no owner. However we don't know it when we work on the table.

```INSERT INTO cats VALUES (‘tobi’, ‘regular’, 2, 0);```


- Let's start with returning only cats that have an owner first


<b> Remember: left join will keep all cats in the output. i.e. also cats that don't have an owner - so we actually need a different join</b> 


- return only cats that don’t have an owner

- Let's try to (without examining the table) return the owner_id of exactly 2 proud dogs


- let's check how many voters from zip code 36003 could be persuaded


### <u> Window functions </u>
<b> Notice: window functions are one of the best things ever happened in SQL </b>

'A window function performs a calculation across a set of table rows that are somehow related to the current row. This is comparable to the type of calculation that can be done with an aggregate function. But unlike regular aggregate functions, use of a window function does not cause rows to become grouped into a single output row — the rows retain their separate identities.'

Source on window functions: [window functions](https://www.postgresql.org/docs/9.1/tutorial-window.html)

- 

#### Facebook interview question:
Assume we have a table of employee information, which includes salary information.
Write a query to find the names and salaries of the top 5 (if two or more employees have the same salary which is in the top 5, they should all be returned) highest paid employees, in descending order.


- Let's add to all raw columns another column called 'grouping' with all of its values being 1. 

- We will now use the window function (rank()) 
- Notice: we only use the ```rank()``` after we have created the 'grouping' column. This means we need a subquery to create the column 'grouping' and only then can we partition by that.
- The syntax of every window function:

```
window_func() OVER (PARTITION BY col_name_to_partition_data)  
```

#### Our answer to facebook 
```
SELECT salary, rank() over (partition by
        grouping order by salary desc) FROM 
        (SELECT *, 1 AS grouping FROM pick) AS pick_w_group;
```        
        



# <u> More resources: </u>

-  [youtube tutorials](https://www.youtube.com/watch?v=jNq5EAb2biY&list=PLk1kxccoEnNEtwGZW-3KAcAlhI_Guwh8x) 