/*
=========================================================
Project : Employee Management Database
File    : 11_Real_World_Queries.sql
Author  : Ayush Kale

Description:
Day 9 - Real-World SQL and Interview Problems

Tables Used:
- Employees
- Departments
- Performance

Concepts:
- CTE
- Subqueries
- JOINs
- Self JOIN
- GROUP BY
- HAVING
- CASE
- Window Functions
- Aggregation
- NULL Handling
=========================================================
*/


/*=========================================================
    PART 1 — DEPARTMENT SALARY ANALYSIS
=========================================================*/


----------------------------------------------------------
-- 1. Find Employees Earning More Than Their
--    Department Average Salary
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
    a.DepartmentAverageSalary
FROM Employees e
LEFT JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
INNER JOIN DepartmentAverage a
    ON e.DepartmentID = a.DepartmentID
WHERE e.Salary > a.DepartmentAverageSalary;
GO


----------------------------------------------------------
-- 2. Find Salary Amounts Shared by More Than One Employee
----------------------------------------------------------

SELECT
    Salary,
    COUNT(EmployeeID) AS EmployeeCount
FROM Employees
GROUP BY Salary
HAVING COUNT(EmployeeID) > 1;
GO


----------------------------------------------------------
-- 3. Find Employees Who Are Not Assigned to Any Department
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName AS EmployeeName,
    DepartmentID
FROM Employees
WHERE DepartmentID IS NULL;
GO


----------------------------------------------------------
-- 4. Find Departments With No Employees
----------------------------------------------------------

SELECT
    d.DepartmentID,
    d.DepartmentName
FROM Departments d
LEFT JOIN Employees e
    ON d.DepartmentID = e.DepartmentID
GROUP BY
    d.DepartmentID,
    d.DepartmentName
HAVING COUNT(e.EmployeeID) = 0;
GO


----------------------------------------------------------
-- 5. Find Employees With No Performance Review
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName AS EmployeeName,
    e.DepartmentID
FROM Employees e
LEFT JOIN Performance p
    ON e.EmployeeID = p.EmployeeID
WHERE p.PerformanceID IS NULL;
GO


/*=========================================================
    PART 2 — BONUS ANALYSIS
=========================================================*/


----------------------------------------------------------
-- 6. Find All Employees Who Received the Highest Bonus
--    Including Employees Tied for the Highest Bonus
----------------------------------------------------------

WITH BonusRanking AS
(
    SELECT
        EmployeeID,
        Bonus,
        RANK() OVER (
            ORDER BY Bonus DESC
        ) AS BonusRank
    FROM Performance
)
SELECT
    e.EmployeeID,
    e.FirstName AS EmployeeName,
    b.Bonus
FROM BonusRanking b
INNER JOIN Employees e
    ON b.EmployeeID = e.EmployeeID
WHERE b.BonusRank = 1;
GO


----------------------------------------------------------
-- 7. Find Employees With the Highest Bonus
--    In Each Department
--    Including Ties
----------------------------------------------------------

WITH BonusRanking AS
(
    SELECT
        p.EmployeeID,
        e.FirstName,
        p.Bonus,
        e.DepartmentID,
        RANK() OVER (
            PARTITION BY e.DepartmentID
            ORDER BY p.Bonus DESC
        ) AS BonusRank
    FROM Performance p
    INNER JOIN Employees e
        ON p.EmployeeID = e.EmployeeID
)
SELECT
    b.EmployeeID,
    b.FirstName AS EmployeeName,
    d.DepartmentName,
    b.Bonus
FROM BonusRanking b
INNER JOIN Departments d
    ON b.DepartmentID = d.DepartmentID
WHERE b.BonusRank = 1;
GO


/*=========================================================
    PART 3 — PERFORMANCE VS SALARY
=========================================================*/


----------------------------------------------------------
-- 8. Find Employees With Excellent Performance
--    But Below-Average Department Salary
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
    p.Rating
FROM Employees e
INNER JOIN DepartmentAverage a
    ON e.DepartmentID = a.DepartmentID
INNER JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
INNER JOIN Performance p
    ON e.EmployeeID = p.EmployeeID
WHERE p.Rating = 5
  AND e.Salary < a.DepartmentAverageSalary;
GO


/*=========================================================
    PART 4 — MANAGER ANALYSIS
=========================================================*/


----------------------------------------------------------
-- 9. Find Managers With More Than 3 Employees
----------------------------------------------------------

SELECT
    m.EmployeeID AS ManagerID,
    m.FirstName AS ManagerName,
    COUNT(e.EmployeeID) AS TotalEmployees
FROM Employees m
INNER JOIN Employees e
    ON m.EmployeeID = e.ManagerID
GROUP BY
    m.EmployeeID,
    m.FirstName
HAVING COUNT(e.EmployeeID) > 3;
GO


----------------------------------------------------------
-- 10. Find Employees Whose Salary Is Greater Than
--     Their Manager's Salary
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName AS EmployeeName,
    e.Salary AS EmployeeSalary,
    m.FirstName AS ManagerName,
    m.Salary AS ManagerSalary,
    e.Salary - m.Salary AS SalaryDifference
FROM Employees e
INNER JOIN Employees m
    ON e.ManagerID = m.EmployeeID
WHERE e.Salary > m.Salary;
GO


/*=========================================================
    PART 5 — DEPARTMENT ANALYSIS
=========================================================*/


----------------------------------------------------------
-- 11. Find Departments With Above-Company-Average Salary
----------------------------------------------------------

SELECT
    d.DepartmentName,
    AVG(e.Salary) AS DepartmentAverageSalary
FROM Departments d
INNER JOIN Employees e
    ON d.DepartmentID = e.DepartmentID
GROUP BY
    d.DepartmentID,
    d.DepartmentName
HAVING AVG(e.Salary) >
(
    SELECT AVG(Salary)
    FROM Employees
);
GO


----------------------------------------------------------
-- 12. Find the Department With the Highest Total Payroll
----------------------------------------------------------

WITH DepartmentPayroll AS
(
    SELECT
        DepartmentID,
        SUM(Salary) AS TotalPayroll
    FROM Employees
    GROUP BY DepartmentID
)
SELECT
    d.DepartmentName,
    p.TotalPayroll
FROM DepartmentPayroll p
INNER JOIN Departments d
    ON p.DepartmentID = d.DepartmentID
WHERE p.TotalPayroll =
(
    SELECT MAX(TotalPayroll)
    FROM DepartmentPayroll
);
GO


/*=========================================================
    PART 6 — PERFORMANCE ANALYSIS
=========================================================*/


----------------------------------------------------------
-- 13. Find Employees With Excellent Performance
--     and High Bonus
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName AS EmployeeName,
    d.DepartmentName,
    p.Rating,
    p.Bonus
FROM Employees e
INNER JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
INNER JOIN Performance p
    ON e.EmployeeID = p.EmployeeID
WHERE p.Rating = 5
  AND p.Bonus > 15000;
GO


----------------------------------------------------------
-- 14. Find Departments With Average Rating >= 4
----------------------------------------------------------

SELECT
    d.DepartmentName,
    AVG(p.Rating) AS AverageRating,
    COUNT(p.PerformanceID) AS TotalReviews
FROM Departments d
INNER JOIN Employees e
    ON d.DepartmentID = e.DepartmentID
INNER JOIN Performance p
    ON e.EmployeeID = p.EmployeeID
GROUP BY
    d.DepartmentID,
    d.DepartmentName
HAVING AVG(p.Rating) >= 4;
GO


/*=========================================================
    PART 7 — FINAL INTERVIEW PROBLEM
=========================================================*/


----------------------------------------------------------
-- 15. Find Employees Who:
--     1. Earn More Than Their Department Average
--     2. Have Performance Rating >= 4
--     3. Have Bonus Above the Average Bonus
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
  AND p.Bonus >
  (
      SELECT AVG(Bonus)
      FROM Performance
  );
GO