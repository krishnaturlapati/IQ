1. 
DECLARE @Employees TABLE
(
	EmployeeID INT IDENTITY,
	EmployeeName VARCHAR(15),
	Department VARCHAR(15),
	Salary NUMERIC(16,2)

)

INSERT INTO @Employees(EmployeeName, Department, Salary)
VALUES('T Cook','Finance', 40000)

INSERT INTO @Employees(EmployeeName, Department, Salary)
VALUES('D Michael','Finance', 25000)

INSERT INTO @Employees(EmployeeName, Department, Salary)
VALUES('A Smith','Finance', 25000)

INSERT INTO @Employees(EmployeeName, Department, Salary)
VALUES('D Adams','Finance', 15000)

 

INSERT INTO @Employees(EmployeeName, Department, Salary)
VALUES('M Williams','IT', 80000)

INSERT INTO @Employees(EmployeeName, Department, Salary)
VALUES('D Jones','IT', 40000)

INSERT INTO @Employees(EmployeeName, Department, Salary)
VALUES('J Miller','IT', 50000)

INSERT INTO @Employees(EmployeeName, Department, Salary)
VALUES('L Lewis','IT', 50000)

INSERT INTO @Employees(EmployeeName, Department, Salary)
VALUES('A Anderson','Back-Office', 25000)

INSERT INTO @Employees(EmployeeName, Department, Salary)
VALUES('S Martin','Back-Office', 15000)

INSERT INTO @Employees(EmployeeName, Department, Salary)
VALUES('J Garcia','Back-Office', 15000)

INSERT INTO @Employees(EmployeeName, Department, Salary)
VALUES('T Clerk','Back-Office', 10000)


;with empCTE as
(
	select *, DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary desc) AS NthSalary
	from @Employees
)



select * from empCTE where NthSalary = 2
