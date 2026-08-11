/*
=========================================================
Project : Employee Management Database
File    : 07_Advanced_SQL.sql
Author  : Ayush Kale

Description:
Advanced SQL queries using subqueries and CASE statements.
=========================================================
*/


/*=========================================================
    SUBQUERIES
=========================================================*/

----------------------------------------------------------
-- 1. Employees earning above company average salary
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM Employees
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees
);
GO


----------------------------------------------------------
-- 2. Highest Paid Employee(s)
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM Employees
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employees
);
GO


----------------------------------------------------------
-- 3. Employees earning above their Department Average
-- Correlated Subquery
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.DepartmentID,
    e.Salary
FROM Employees e
WHERE e.Salary > (
    SELECT AVG(e2.Salary)
    FROM Employees e2
    WHERE e2.DepartmentID = e.DepartmentID
);
GO


----------------------------------------------------------
-- 4. Second Highest Salary
-- Nested Subquery
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM Employees
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employees
    WHERE Salary < (
        SELECT MAX(Salary)
        FROM Employees
    )
);
GO


/*=========================================================
    CASE STATEMENTS
=========================================================*/

----------------------------------------------------------
-- 5. Salary Category
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    CASE
        WHEN Salary < 50000 THEN 'Low'
        WHEN Salary BETWEEN 50000 AND 80000 THEN 'Medium'
        ELSE 'High'
    END AS SalaryCategory
FROM Employees;
GO


----------------------------------------------------------
-- 6. Performance Category
----------------------------------------------------------

SELECT
    EmployeeID,
    Rating,
    CASE
        WHEN Rating = 5 THEN 'Excellent'
        WHEN Rating = 4 THEN 'Good'
        WHEN Rating = 3 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS PerformanceCategory
FROM Performance;
GO


----------------------------------------------------------
-- 7. Bonus Category
----------------------------------------------------------

SELECT
    EmployeeID,
    Bonus,
    CASE
        WHEN Bonus = 0 THEN 'No Bonus'
        WHEN Bonus < 10000 THEN 'Low Bonus'
        WHEN Bonus BETWEEN 10000 AND 20000 THEN 'Medium Bonus'
        ELSE 'High Bonus'
    END AS BonusCategory
FROM Performance;
GO


----------------------------------------------------------
-- 8. Salary Category with Sorting
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    CASE
        WHEN Salary < 50000 THEN 'Low'
        WHEN Salary BETWEEN 50000 AND 80000 THEN 'Medium'
        ELSE 'High'
    END AS SalaryCategory
FROM Employees
ORDER BY Salary DESC;
GO


----------------------------------------------------------
-- 9. Employee + Department + Salary Category
-- CASE + JOIN
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    e.Salary,
    CASE
        WHEN e.Salary < 50000 THEN 'Low'
        WHEN e.Salary BETWEEN 50000 AND 80000 THEN 'Medium'
        ELSE 'High'
    END AS SalaryCategory
FROM Employees e
INNER JOIN Departments d
    ON e.DepartmentID = d.DepartmentID;
GO


----------------------------------------------------------
-- 10. Department Average Salary + Category
-- CASE + JOIN + GROUP BY
----------------------------------------------------------

SELECT
    d.DepartmentName,
    AVG(e.Salary) AS AverageSalary,
    CASE
        WHEN AVG(e.Salary) < 50000 THEN 'Low'
        WHEN AVG(e.Salary) BETWEEN 50000 AND 80000 THEN 'Medium'
        ELSE 'High'
    END AS SalaryCategory
FROM Departments d
LEFT JOIN Employees e
    ON d.DepartmentID = e.DepartmentID
GROUP BY
    d.DepartmentID,
    d.DepartmentName;
GO


----------------------------------------------------------
-- 11. Departments Above ₹60,000 Average Salary
-- CASE + JOIN + GROUP BY + HAVING
----------------------------------------------------------

SELECT
    d.DepartmentName,
    AVG(e.Salary) AS AverageSalary,
    CASE
        WHEN AVG(e.Salary) <= 80000 THEN 'Medium'
        ELSE 'High'
    END AS SalaryCategory
FROM Departments d
LEFT JOIN Employees e
    ON d.DepartmentID = e.DepartmentID
GROUP BY
    d.DepartmentID,
    d.DepartmentName
HAVING AVG(e.Salary) > 60000
ORDER BY AverageSalary DESC;
GO

/*=========================================================
    CTEs — COMMON TABLE EXPRESSIONS
=========================================================*/

----------------------------------------------------------
-- 12. High Salary Employees
----------------------------------------------------------

WITH HighSalaryEmployees AS
(
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        Salary
    FROM Employees
    WHERE Salary > 70000
)
SELECT
    *
FROM HighSalaryEmployees;
GO


----------------------------------------------------------
-- 13. Department Average Salary
----------------------------------------------------------

WITH DepartmentSalary AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT
    *
FROM DepartmentSalary
WHERE AverageSalary > 70000;
GO


----------------------------------------------------------
-- 14. Department Employee Count
----------------------------------------------------------

WITH DepartmentEmployeeCount AS
(
    SELECT
        DepartmentID,
        COUNT(EmployeeID) AS TotalEmployees
    FROM Employees
    GROUP BY DepartmentID
)
SELECT
    d.DepartmentName,
    e.TotalEmployees
FROM Departments d
LEFT JOIN DepartmentEmployeeCount e
    ON d.DepartmentID = e.DepartmentID;
GO


----------------------------------------------------------
-- 15. Department Total Salary
----------------------------------------------------------

WITH DepartmentSalary AS
(
    SELECT
        DepartmentID,
        SUM(Salary) AS TotalSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT
    d.DepartmentName,
    s.TotalSalary
FROM Departments d
LEFT JOIN DepartmentSalary s
    ON d.DepartmentID = s.DepartmentID
ORDER BY s.TotalSalary DESC;
GO


----------------------------------------------------------
-- 16. Departments with More Than 3 Employees
----------------------------------------------------------

WITH DepartmentEmployeeCount AS
(
    SELECT
        DepartmentID,
        COUNT(EmployeeID) AS TotalEmployees
    FROM Employees
    GROUP BY DepartmentID
)
SELECT
    d.DepartmentName,
    e.TotalEmployees
FROM Departments d
INNER JOIN DepartmentEmployeeCount e
    ON d.DepartmentID = e.DepartmentID
WHERE e.TotalEmployees > 3
ORDER BY e.TotalEmployees DESC;
GO


----------------------------------------------------------
-- 17. Departments with Average Salary > ₹70,000
----------------------------------------------------------

WITH DepartmentAverageSalary AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT
    d.DepartmentName,
    a.AverageSalary
FROM Departments d
INNER JOIN DepartmentAverageSalary a
    ON d.DepartmentID = a.DepartmentID
WHERE a.AverageSalary > 70000
ORDER BY a.AverageSalary DESC;
GO


----------------------------------------------------------
-- 18. Total Project Hours by Employee
----------------------------------------------------------

WITH EmployeeHours AS
(
    SELECT
        EmployeeID,
        SUM(HoursWorked) AS TotalHoursWorked
    FROM EmployeeProjects
    GROUP BY EmployeeID
)
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    h.TotalHoursWorked
FROM Employees e
INNER JOIN EmployeeHours h
    ON e.EmployeeID = h.EmployeeID
ORDER BY h.TotalHoursWorked DESC;
GO


----------------------------------------------------------
-- 19. Employees Working on Multiple Projects
----------------------------------------------------------

WITH EmployeeProjectCount AS
(
    SELECT
        EmployeeID,
        COUNT(ProjectID) AS TotalProjects
    FROM EmployeeProjects
    GROUP BY EmployeeID
)
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    p.TotalProjects
FROM Employees e
INNER JOIN EmployeeProjectCount p
    ON e.EmployeeID = p.EmployeeID
WHERE p.TotalProjects > 1
ORDER BY p.TotalProjects DESC;
GO


----------------------------------------------------------
-- 20. Highest Salary in Each Department
----------------------------------------------------------

WITH DepartmentMaxSalary AS
(
    SELECT
        DepartmentID,
        MAX(Salary) AS HighestSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT
    d.DepartmentName,
    m.HighestSalary
FROM Departments d
INNER JOIN DepartmentMaxSalary m
    ON d.DepartmentID = m.DepartmentID
ORDER BY m.HighestSalary DESC;
GO


----------------------------------------------------------
-- 21. Employees Earning Above Department Average
----------------------------------------------------------

WITH DepartmentAverageSalary AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.DepartmentID,
    e.Salary,
    a.AverageSalary
FROM Employees e
INNER JOIN DepartmentAverageSalary a
    ON e.DepartmentID = a.DepartmentID
WHERE e.Salary > a.AverageSalary
ORDER BY e.Salary DESC;
GO


----------------------------------------------------------
-- 22. Complete Department Salary Report
----------------------------------------------------------

WITH DepartmentSalaryReport AS
(
    SELECT
        DepartmentID,
        COUNT(EmployeeID) AS TotalEmployees,
        SUM(Salary) AS TotalSalary,
        AVG(Salary) AS AverageSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT
    d.DepartmentName,
    r.TotalEmployees,
    r.TotalSalary,
    r.AverageSalary
FROM Departments d
LEFT JOIN DepartmentSalaryReport r
    ON d.DepartmentID = r.DepartmentID
ORDER BY r.TotalSalary DESC;
GO

----------------------------------------------------------
-- 23. UNION
-- Employees from IT and HR
----------------------------------------------------------

SELECT
    FirstName,
    LastName
FROM Employees
WHERE DepartmentID = 2

UNION

SELECT
    FirstName,
    LastName
FROM Employees
WHERE DepartmentID = 1;
GO


----------------------------------------------------------
-- 24. UNION ALL
-- Employees from IT and HR
----------------------------------------------------------

SELECT
    FirstName,
    LastName
FROM Employees
WHERE DepartmentID = 2

UNION ALL

SELECT
    FirstName,
    LastName
FROM Employees
WHERE DepartmentID = 1;
GO


----------------------------------------------------------
-- 25. UNION
-- Employees with Salary > ₹80,000
-- OR Performance Rating = 5
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName
FROM Employees e
WHERE e.Salary > 80000

UNION

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName
FROM Employees e
INNER JOIN Performance p
    ON e.EmployeeID = p.EmployeeID
WHERE p.Rating = 5;
GO


/*=========================================================
    PART 5 — INTERVIEW PROBLEMS
=========================================================*/


----------------------------------------------------------
-- 26. Highest Salary per Department
----------------------------------------------------------

WITH DepartmentMaxSalary AS
(
    SELECT
        DepartmentID,
        MAX(Salary) AS HighestSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.DepartmentID,
    e.Salary
FROM Employees e
INNER JOIN DepartmentMaxSalary d
    ON e.DepartmentID = d.DepartmentID
    AND e.Salary = d.HighestSalary;
GO


----------------------------------------------------------
-- 27. Employees Earning More Than Their Manager
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName AS EmployeeName,
    e.Salary AS EmployeeSalary,
    m.FirstName AS ManagerName,
    m.Salary AS ManagerSalary
FROM Employees e
INNER JOIN Employees m
    ON e.ManagerID = m.EmployeeID
WHERE e.Salary > m.Salary;
GO


----------------------------------------------------------
-- 28. Third Highest Distinct Salary
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM Employees
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employees
    WHERE Salary < (
        SELECT MAX(Salary)
        FROM Employees
        WHERE Salary < (
            SELECT MAX(Salary)
            FROM Employees
        )
    )
);
GO


----------------------------------------------------------
-- 29. Employees Without Any Project
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName
FROM Employees e
LEFT JOIN EmployeeProjects ep
    ON e.EmployeeID = ep.EmployeeID
WHERE ep.ProjectID IS NULL;
GO