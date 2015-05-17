WITH Factorial (N, Factorial) AS 
( 
  SELECT 1, cast(1 as BIGINT) -- Cast to BIGINT to avoid overflow
   UNION ALL -- here is where it gets recursive
  SELECT N + 1, (N + 1) * Factorial
    FROM Factorial -- reference back to the CTE
  WHERE N < 5 -- abort when we get to 20!
) 
 
 select * from 
 (
 SELECT N, Factorial
   FROM Factorial
 union
select 0, 1
 union
select 1, 1
  ) a order by N  
  
