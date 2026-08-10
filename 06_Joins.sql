/*
=========================================================
Project : Employee Management Database
File    : 06_Joins.sql
Author  : Ayush Kale

Description:
JOIN queries for employee database analytics.
=========================================================
*/

----------------------------------------------------------
-- 1. INNER JOIN
-- Employee with Department Name
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Salary,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d
    ON e.DepartmentID = d.DepartmentID;
GO


----------------------------------------------------------
-- 2. INNER JOIN + WHERE
-- Employees earning more than ₹70,000
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Salary,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 70000;
GO


----------------------------------------------------------
-- 3. LEFT JOIN
-- All Employees with Department Name
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentName
FROM Employees e
LEFT JOIN Departments d
    ON e.DepartmentID = d.DepartmentID;
GO


----------------------------------------------------------
-- 4. LEFT JOIN + IS NULL
-- Employees without a matching Department
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentName
FROM Employees e
LEFT JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IS NULL;
GO


----------------------------------------------------------
-- 5. RIGHT JOIN
-- All Departments with Employees
----------------------------------------------------------

SELECT
    d.DepartmentID,
    d.DepartmentName,
    e.EmployeeID,
    e.FirstName,
    e.LastName
FROM Employees e
RIGHT JOIN Departments d
    ON e.DepartmentID = d.DepartmentID;
GO


----------------------------------------------------------
-- 6. FULL OUTER JOIN
-- All Employees and All Departments
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentID,
    d.DepartmentName
FROM Employees e
FULL OUTER JOIN Departments d
    ON e.DepartmentID = d.DepartmentID;
GO


----------------------------------------------------------
-- 7. SELF JOIN
-- Employee and Manager
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName AS EmployeeFirstName,
    e.LastName AS EmployeeLastName,
    m.FirstName AS ManagerFirstName,
    m.LastName AS ManagerLastName
FROM Employees e
LEFT JOIN Employees m
    ON e.ManagerID = m.EmployeeID;
GO


----------------------------------------------------------
-- 8. THREE-TABLE JOIN
-- Employees with their Projects
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    ep.ProjectID,
    p.ProjectName,
    ep.HoursWorked
FROM Employees e
INNER JOIN EmployeeProjects ep
    ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p
    ON ep.ProjectID = p.ProjectID;
GO


----------------------------------------------------------
-- 9. THREE-TABLE LEFT JOIN
-- All Employees including those without Projects
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    ep.ProjectID,
    p.ProjectName,
    ep.HoursWorked
FROM Employees e
LEFT JOIN EmployeeProjects ep
    ON e.EmployeeID = ep.EmployeeID
LEFT JOIN Projects p
    ON ep.ProjectID = p.ProjectID;
GO


----------------------------------------------------------
-- 10. CROSS JOIN
-- Every possible Department + Project combination
----------------------------------------------------------

SELECT
    d.DepartmentName,
    p.ProjectName
FROM Departments d
CROSS JOIN Projects p;
GO


----------------------------------------------------------
-- 11. Employee Count by Department
----------------------------------------------------------

SELECT
    d.DepartmentName,
    COUNT(e.EmployeeID) AS TotalEmployees
FROM Departments d
LEFT JOIN Employees e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY TotalEmployees DESC;
GO


----------------------------------------------------------
-- 12. Total Salary by Department
----------------------------------------------------------

SELECT
    d.DepartmentName,
    SUM(e.Salary) AS TotalSalary
FROM Departments d
LEFT JOIN Employees e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY TotalSalary DESC;
GO


----------------------------------------------------------
-- 13. Average Salary by Department
----------------------------------------------------------

SELECT
    d.DepartmentName,
    AVG(e.Salary) AS AverageSalary
FROM Departments d
LEFT JOIN Employees e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AverageSalary DESC;
GO


----------------------------------------------------------
-- 14. Departments with Average Salary > ₹70,000
----------------------------------------------------------

SELECT
    d.DepartmentName,
    AVG(e.Salary) AS AverageSalary
FROM Departments d
LEFT JOIN Employees e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
HAVING AVG(e.Salary) > 70000
ORDER BY AverageSalary DESC;
GO


----------------------------------------------------------
-- 15. Departments with More Than 3 Employees
----------------------------------------------------------

SELECT
    d.DepartmentName,
    COUNT(e.EmployeeID) AS TotalEmployees
FROM Departments d
LEFT JOIN Employees e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
HAVING COUNT(e.EmployeeID) > 3
ORDER BY TotalEmployees DESC;
GO


----------------------------------------------------------
-- 16. Project Count by Project
----------------------------------------------------------

SELECT
    p.ProjectID,
    p.ProjectName,
    COUNT(ep.EmployeeID) AS TotalEmployees
FROM Projects p
LEFT JOIN EmployeeProjects ep
    ON p.ProjectID = ep.ProjectID
GROUP BY
    p.ProjectID,
    p.ProjectName
ORDER BY TotalEmployees DESC;
GO


----------------------------------------------------------
-- 17. Projects with More Than 2 Employees
----------------------------------------------------------

SELECT
    p.ProjectID,
    p.ProjectName,
    COUNT(ep.EmployeeID) AS TotalEmployees
FROM Projects p
LEFT JOIN EmployeeProjects ep
    ON p.ProjectID = ep.ProjectID
GROUP BY
    p.ProjectID,
    p.ProjectName
HAVING COUNT(ep.EmployeeID) > 2
ORDER BY TotalEmployees DESC;
GO


----------------------------------------------------------
-- 18. Total Project Hours by Employee
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    SUM(ep.HoursWorked) AS TotalHoursWorked
FROM Employees e
LEFT JOIN EmployeeProjects ep
    ON e.EmployeeID = ep.EmployeeID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
ORDER BY TotalHoursWorked DESC;
GO


----------------------------------------------------------
-- 19. Employees Working on Multiple Projects
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    COUNT(ep.ProjectID) AS TotalProjects
FROM Employees e
INNER JOIN EmployeeProjects ep
    ON e.EmployeeID = ep.EmployeeID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
HAVING COUNT(ep.ProjectID) > 1
ORDER BY TotalProjects DESC;
GO


----------------------------------------------------------
-- 20. Employees Without Any Project
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