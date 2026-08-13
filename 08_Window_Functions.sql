/*
=========================================================
Project : Employee Management Database
File    : 08_Window_Functions.sql
Author  : Ayush Kale

Description:
Window Functions using:
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- PARTITION BY
- Window Aggregates
- CTE + Window Functions
=========================================================
*/


/*=========================================================
    PART 1 — ROW_NUMBER()
=========================================================*/


----------------------------------------------------------
-- 1. Rank All Employees by Salary
-- Highest Salary = 1
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    ROW_NUMBER() OVER (
        ORDER BY Salary DESC
    ) AS SalaryRank
FROM Employees;
GO


----------------------------------------------------------
-- 2. Rank All Employees by Salary
-- Lowest Salary = 1
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    Salary,
    ROW_NUMBER() OVER (
        ORDER BY Salary ASC
    ) AS SalaryRank
FROM Employees;
GO


/*=========================================================
    PART 2 — RANK()
=========================================================*/


----------------------------------------------------------
-- 3. Rank Employees by Salary
-- Ties Receive Same Rank
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    Salary,
    RANK() OVER (
        ORDER BY Salary DESC
    ) AS SalaryRank
FROM Employees;
GO


/*=========================================================
    PART 3 — DENSE_RANK()
=========================================================*/


----------------------------------------------------------
-- 4. Dense Rank Employees by Salary
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    Salary,
    DENSE_RANK() OVER (
        ORDER BY Salary DESC
    ) AS SalaryRank
FROM Employees;
GO


/*=========================================================
    PART 4 — PARTITION BY
=========================================================*/


----------------------------------------------------------
-- 5. Rank Employees Within Each Department
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    DepartmentID,
    Salary,
    RANK() OVER (
        PARTITION BY DepartmentID
        ORDER BY Salary DESC
    ) AS DepartmentSalaryRank
FROM Employees;
GO


/*=========================================================
    PART 5 — TOP EMPLOYEES PER DEPARTMENT
=========================================================*/


----------------------------------------------------------
-- 6. Highest-Paid Employee in Each Department
-- Using RANK()
----------------------------------------------------------

WITH HighestSalary AS
(
    SELECT
        EmployeeID,
        FirstName,
        DepartmentID,
        Salary,
        RANK() OVER (
            PARTITION BY DepartmentID
            ORDER BY Salary DESC
        ) AS DepartmentSalaryRank
    FROM Employees
)
SELECT
    *
FROM HighestSalary
WHERE DepartmentSalaryRank = 1;
GO


----------------------------------------------------------
-- 7. Top 2 Employees Per Department
-- Using RANK()
----------------------------------------------------------

WITH HighestSalary AS
(
    SELECT
        EmployeeID,
        FirstName,
        DepartmentID,
        Salary,
        RANK() OVER (
            PARTITION BY DepartmentID
            ORDER BY Salary DESC
        ) AS DepartmentSalaryRank
    FROM Employees
)
SELECT
    *
FROM HighestSalary
WHERE DepartmentSalaryRank <= 2;
GO


----------------------------------------------------------
-- 8. Top 3 Distinct Salary Levels Per Department
-- Using DENSE_RANK()
----------------------------------------------------------

WITH HighestSalary AS
(
    SELECT
        EmployeeID,
        FirstName,
        DepartmentID,
        Salary,
        DENSE_RANK() OVER (
            PARTITION BY DepartmentID
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM Employees
)
SELECT
    *
FROM HighestSalary
WHERE SalaryRank <= 3;
GO


/*=========================================================
    PART 6 — WINDOW AGGREGATE FUNCTIONS
=========================================================*/


----------------------------------------------------------
-- 9. Department Average Salary Beside Each Employee
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    DepartmentID,
    Salary,
    AVG(Salary) OVER (
        PARTITION BY DepartmentID
    ) AS DepartmentAverageSalary
FROM Employees;
GO


----------------------------------------------------------
-- 10. Salary Difference from Department Average
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    DepartmentID,
    Salary,
    AVG(Salary) OVER (
        PARTITION BY DepartmentID
    ) AS DepartmentAverageSalary,
    Salary - AVG(Salary) OVER (
        PARTITION BY DepartmentID
    ) AS SalaryDifference
FROM Employees;
GO


/*=========================================================
    PART 7 — ROW_NUMBER() + PARTITION BY + CTE
=========================================================*/


----------------------------------------------------------
-- 11. Highest-Paid Employee in Each Department
-- Using ROW_NUMBER()
----------------------------------------------------------

WITH HighestSalary AS
(
    SELECT
        EmployeeID,
        FirstName,
        DepartmentID,
        Salary,
        ROW_NUMBER() OVER (
            PARTITION BY DepartmentID
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM Employees
)
SELECT
    *
FROM HighestSalary
WHERE SalaryRank = 1;
GO
/*=========================================================
    PART 8 — LAG()
=========================================================*/


----------------------------------------------------------
-- 12. Previous Employee Salary
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    Salary,
    LAG(Salary) OVER (
        ORDER BY Salary DESC
    ) AS PreviousSalary
FROM Employees;
GO


----------------------------------------------------------
-- 13. Salary Difference from Previous Employee
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    Salary,
    LAG(Salary) OVER (
        ORDER BY Salary DESC
    ) AS PreviousSalary,
    Salary - LAG(Salary) OVER (
        ORDER BY Salary DESC
    ) AS SalaryDifference
FROM Employees;
GO


/*=========================================================
    PART 9 — LEAD()
=========================================================*/


----------------------------------------------------------
-- 14. Next Employee Salary
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    Salary,
    LEAD(Salary) OVER (
        ORDER BY Salary DESC
    ) AS NextSalary
FROM Employees;
GO


----------------------------------------------------------
-- 15. Salary Difference from Next Employee
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    Salary,
    LEAD(Salary) OVER (
        ORDER BY Salary DESC
    ) AS NextSalary,
    Salary - LEAD(Salary) OVER (
        ORDER BY Salary DESC
    ) AS SalaryDifference
FROM Employees;
GO


/*=========================================================
    PART 10 — INTERVIEW PROBLEMS
=========================================================*/


----------------------------------------------------------
-- 16. Top 2 Highest-Paid Employees Per Department
-- Using ROW_NUMBER()
----------------------------------------------------------

WITH HighestSalary AS
(
    SELECT
        EmployeeID,
        FirstName,
        DepartmentID,
        Salary,
        ROW_NUMBER() OVER (
            PARTITION BY DepartmentID
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM Employees
)
SELECT
    *
FROM HighestSalary
WHERE SalaryRank <= 2;
GO