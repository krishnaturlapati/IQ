
source https://lagunita.stanford.edu/c4x/DB/OLAP/asset/opt-olap.html

``` sql
/*
Student( studID, name, major )   // dimension table, studID is key
Instructor( instID, dept );   // dimension table, instID is key
Class( classID, univ, region, country );   // dimension table, classID is key
Took( studID, instID, classID, score );   // fact table, foreign key references to dimension tables
*/
```

*  __Problem1:__ Find all students who took a class in California from an instructor not in the student's major department and got a score over 80. Return the student name, university, and score.

``` sql
select s.name, c.univ, t.score
from took t 
join student s 
on  t.studid = s.studid
join class c
on t.classid = c.classid
join Instructor i
on i.instid = t.instid
where t.score > 80 
and c.region = 'CA'
and dept <> major;
```

*  __Problem2:__Find average scores grouped by student and instructor for courses taught in Quebec.

``` sql
select t.studid, t.instID, avg(t.score)
from took t 
join class c
on t.classid = c.classid
where  c.region = 'Quebec'
group by studid, instid;
```

* __Problem3:__ "Roll up" your result from problem 2 so it's grouping by instructor only.

``` sql
select t.instID, avg(t.score)
from took t 
join class c
on t.classid = c.classid
where  c.region = 'Quebec'
group by instid
with rollup;
```

* __Problem4:__ Find average scores grouped by student major.
``` sql
select major, avg(t.score)
from took t 
join student s
on t.studid = s.studid
group by major;
```


* __Problem5:__ "Drill down" on your result from problem 4 so it's grouping by instructor's department as well as student's major.
``` sql
select major, i.dept, avg(t.score)
from took t 
join student s
on t.studid = s.studid
join Instructor i
on t.instid = i.instid
group by major, dept;
```

* __Problem6:__ Use "WITH ROLLUP" on attributes of table Class to get average scores for all geographical granularities: by country, region, and university, as well as the overall average.
``` sql
select country, region, univ, avg(t.score)
from class c
join took t
on t.classid = c.classid
group by  country, region, univ
with rollup;
```

* __Problem7:__ Create a table containing the result of your query from problem 6. Then use the table to determine by how much students from USA outperform students from Canada in their average score.

``` sql
drop table class_avg;
-- table creation
CREATE TABLE `class_avg` (
  `country` text,
  `region` text,
  `univ` text,
  `avg_score` float(9,4)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into class_avg 

select country, region, univ, avg(t.score), count(*)
from class c
join took t
on t.classid = c.classid
group by  country, region, univ
with rollup;


select max(avg_score) - min(avg_score)
from class_avg
where region is null and univ is null

-- 1.4027



/* -- average of averages
select country, region, univ, avg(t.score), count(*), sum(score)
from class c
join took t
on t.classid = c.classid
group by  country, region, univ


select country,  avg(t.score), count(*), sum(score)
from class c
join took t
on t.classid = c.classid
group by  country


select country, region, univ, avg(t.score)
from class c
join took t
on t.classid = c.classid
group by  country, region, univ;
*/

```

*  __Problem8:__ Verify your result for problem 7 by writing the same query over the original tables without using "WITH ROLLUP".
``` sql
drop table class_avg;
-- table creation
CREATE TABLE `class_avg` (
  `country` text,
  `region` text,
  `univ` text,
  `avg_score` float(9,4)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into class_avg 
select country, region, univ, avg(t.score)
from class c
join took t
on t.classid = c.classid
group by  country, region, univ;
-- with rollup;
```
* __Problem9:__ Create the following table that simulates the unsupported "WITH CUBE" operator.
Using table Cube instead of table Took, and taking advantage of the special tuples with NULLs, 
find the average score of CS major students taking a course at MIT.
``` sql
create table Cube as
select studID, instID, classID, avg(score) as s from Took
group by studID, instID, classID with rollup
union
select studID, instID, classID, avg(score) as s from Took
group by instID, classID, studID with rollup
union
select studID, instID, classID, avg(score) as s from Took
group by classID, studID, instID with rollup;


select avg(s)
from cube c
join class c1
on c.classid = c1.classid
join student s
on s.studid = c.studid
where c1.univ = 'MIT' and s.major = 'CS'
and instid is null

-- 80.33334

```

* __Problem10:__  Verify your result for problem 9 by writing the same query over the original tables.

```
select avg(score)
from took c
join class c1
on c.classid = c1.classid
join student s
on s.studid = c.studid
where c1.univ = 'MIT' and s.major = 'CS';

-- 80.0000
```

* __Problem11:__ Whoops! Did you get a different answer for problem 10 than you got for problem 9? 
What went wrong? Assuming the answer on the original tables is correct, 
create a slightly different data cube that allows you to get the correct answer 
using the special NULL tuples in the cube. 
Hint: Change what dependent value(s) you store in the cells of the cube; 
no change to the overall structure of the query or the cube is needed.
``` sql
DROP TABLE IF EXISTS cube;

create table Cube as
select studID, instID, classID, avg(score) as s from Took
group by studID, instID, classID with rollup
union
select studID, instID, classID, avg(score) as s from Took
group by instID, classID, studID with rollup
union
select studID, instID, classID, avg(score) as s from Took
group by classID, studID, instID with rollup;


select  avg(s)
from cube c
join class c1
on c.classid = c1.classid
join student s
on s.studid = c.studid
where c1.univ = 'MIT' 
and s.major = 'CS'
and c.instid is null
and c.classid is null
and c.studid is  not null

select * from cube c
where c.instid is null
and c.classid is null
and c.studid is not null

```

*  __Problem12:__ Continuing with your revised cube from problem 11, compute the same value but this time don't 
use the NULL tuples (but don't use table Took either). 
Hint: The syntactic change is very small and of course the answer should not change.
```sql
```
