DECLARE @t TABLE(
	ID INT,
	NAME VARCHAR(MAX)
)

INSERT INTO @t (ID,[NAME]) SELECT 1, 'A'
INSERT INTO @t (ID,[NAME]) SELECT 2, 'B'
INSERT INTO @t (ID,[NAME]) SELECT 2, 'C'
INSERT INTO @t (ID,[NAME]) SELECT 3, 'D'
INSERT INTO @t (ID,[NAME]) SELECT 3, 'E'
INSERT INTO @t (ID,[NAME]) SELECT 3, 'F'
INSERT INTO @t (ID,[NAME]) SELECT 4, 'G'

--select *   
--from @t


select p1.id,
       ( select case when id = 1 then name + ',' when id = 2 then name + ' OR ' when id = 3 then name + ' AND ' else name + ',' end 
           from @t p2
          where p2.id = p1.id
            for xml path('') ) as products
      from @t p1
      group by id ;
 
 
 5. --Closest Number
 declare @t table(numbers int)
insert into @t
select 10 union all
select 12 union all
select 19 union all
select 25 union all
select 25 union all
select 34 union all
select 38

declare @numbertosearch int
set @numbertosearch = 24



-- ClosestNumber
;with cte as
(
select *, dense_rank() over(order by numbers) as r 
from 
(
	select * 
	from @t 
	union 
	select @numbertosearch
 ) a
	
	
) 

select numbers as closestselect 
from cte 
where r = (select r+1  from cte where numbers =  @numbertosearch )

