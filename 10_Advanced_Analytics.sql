/*
=========================================================
Project : Employee Management Database
File    : 10_Advanced_Analytics.sql
Author  : Ayush Kale

Description:
Day 8 - Advanced Analytics
=========================================================
*/


/*=========================================================
    PART 1 — EMPLOYEES ABOVE DEPARTMENT AVERAGE
=========================================================*/


----------------------------------------------------------
-- 1. Employees Earning More Than Their Department Average
----------------------------------------------------------

WITH avg_salary AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS DepartmentAverageSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT
    e.EmployeeID,
    e.FirstName,
    e.DepartmentID,
    e.Salary,
    a.DepartmentAverageSalary
FROM Employees e
LEFT JOIN avg_salary a
    ON e.DepartmentID = a.DepartmentID
WHERE e.Salary > a.DepartmentAverageSalary;
GO


----------------------------------------------------------
-- 2. Employees Above Department Average
-- And Performance Rating >= 4
----------------------------------------------------------

WITH avg_salary AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS DepartmentAverageSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT
    e.EmployeeID,
    e.FirstName,
    e.DepartmentID,
    e.Salary,
    a.DepartmentAverageSalary,
    p.Rating
FROM Employees e
LEFT JOIN avg_salary a
    ON e.DepartmentID = a.DepartmentID
INNER JOIN Performance p
    ON e.EmployeeID = p.EmployeeID
WHERE e.Salary > a.DepartmentAverageSalary
  AND p.Rating >= 4;
GO


----------------------------------------------------------
-- 4. Find Employees Who Earn More Than Their Manager
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName AS EmployeeName,
    e.Salary AS EmployeeSalary,
    e.ManagerID,
    m.FirstName AS ManagerName,
    m.Salary AS ManagerSalary
FROM Employees e
INNER JOIN Employees m
    ON e.ManagerID = m.EmployeeID
WHERE e.Salary > m.Salary;
GO

----------------------------------------------------------
-- 5. Find Employees Who Earn Less Than Their Manager
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName AS EmployeeName,
    e.Salary AS EmployeeSalary,
    e.ManagerID,
    m.FirstName AS ManagerName,
    m.Salary AS ManagerSalary
FROM Employees e
INNER JOIN Employees m
    ON e.ManagerID = m.EmployeeID
WHERE e.Salary < m.Salary;
GO

----------------------------------------------------------
-- 6. Find Employees Who Earn Less Than Their Manager
--    And Calculate the Salary Difference
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName AS EmployeeName,
    e.Salary AS EmployeeSalary,
    m.FirstName AS ManagerName,
    m.Salary AS ManagerSalary,
    m.Salary - e.Salary AS SalaryDifference
FROM Employees e
INNER JOIN Employees m
    ON e.ManagerID = m.EmployeeID
WHERE e.Salary < m.Salary;
GO


----------------------------------------------------------
-- 7. Find the Number of Employees Reporting to Each Manager
----------------------------------------------------------

SELECT
    e.ManagerID,
    m.FirstName AS ManagerName,
    COUNT(e.EmployeeID) AS TotalEmployees
FROM Employees e
INNER JOIN Employees m
    ON e.ManagerID = m.EmployeeID
GROUP BY
    e.ManagerID,
    m.FirstName;
GO


----------------------------------------------------------
-- 8. Find the Highest-Paid Employee in Each Department
----------------------------------------------------------

WITH HighestPaid AS
(
    SELECT
        EmployeeID,
        FirstName,
        Salary,
        DepartmentID,
        ROW_NUMBER() OVER (
            PARTITION BY DepartmentID
            ORDER BY Salary DESC
        ) AS HighestSalary
    FROM Employees
)
SELECT
    h.EmployeeID,
    h.FirstName AS EmployeeName,
    d.DepartmentName,
    h.Salary,
    h.HighestSalary
FROM Departments d
LEFT JOIN HighestPaid h
    ON d.DepartmentID = h.DepartmentID
WHERE h.HighestSalary = 1;
GO

/*=========================================================
    PART 4 — TOP EMPLOYEES BY DEPARTMENT
=========================================================*/


----------------------------------------------------------
-- 9. Find the Top 3 Highest-Paid Employees Per Department
----------------------------------------------------------

WITH TopEmployees AS
(
    SELECT
        EmployeeID,
        FirstName,
        Salary,
        DepartmentID,
        ROW_NUMBER() OVER (
            PARTITION BY DepartmentID
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM Employees
)
SELECT
    t.EmployeeID,
    t.FirstName AS EmployeeName,
    d.DepartmentName,
    t.Salary,
    t.SalaryRank
FROM TopEmployees t
INNER JOIN Departments d
    ON t.DepartmentID = d.DepartmentID
WHERE t.SalaryRank <= 3;
GO


/*=========================================================
    PART 5 — HIGHEST PAYROLL DEPARTMENT
=========================================================*/


----------------------------------------------------------
-- 10. Find the Department with the Highest Total Payroll
----------------------------------------------------------

SELECT TOP 1
    d.DepartmentName,
    COUNT(e.EmployeeID) AS TotalEmployees,
    SUM(e.Salary) AS TotalPayroll
FROM Departments d
LEFT JOIN Employees e
    ON d.DepartmentID = e.DepartmentID
GROUP BY
    d.DepartmentID,
    d.DepartmentName
ORDER BY
    TotalPayroll DESC;
GO


/*=========================================================
    PART 6 — PERFORMANCE + SALARY ANALYSIS
=========================================================*/


----------------------------------------------------------
-- 11. Find Employees with High Salary and High Performance
--     Salary > 80,000
--     Rating >= 4
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName AS EmployeeName,
    d.DepartmentName,
    e.Salary,
    p.Rating,
    p.Bonus
FROM Employees e
INNER JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
INNER JOIN Performance p
    ON e.EmployeeID = p.EmployeeID
WHERE e.Salary > 80000
  AND p.Rating >= 4;
GO


/*=========================================================
    PART 7 — FINAL INTERVIEW-STYLE BUSINESS PROBLEM
=========================================================*/


----------------------------------------------------------
-- 12. Find Employees Who:
--     1. Earn More Than Their Department Average
--     2. Have a Performance Rating >= 4
--     3. Have a Bonus > 15,000
----------------------------------------------------------

WITH DepartmentAverage AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS DepartmentAverageSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT
    e.EmployeeID,
    e.FirstName AS EmployeeName,
    d.DepartmentName,
    e.Salary,
    a.DepartmentAverageSalary,
    p.Rating,
    p.Bonus
FROM Employees e
INNER JOIN DepartmentAverage a
    ON e.DepartmentID = a.DepartmentID
INNER JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
INNER JOIN Performance p
    ON e.EmployeeID = p.EmployeeID
WHERE e.Salary > a.DepartmentAverageSalary
  AND p.Rating >= 4
  AND p.Bonus > 15000;
GO