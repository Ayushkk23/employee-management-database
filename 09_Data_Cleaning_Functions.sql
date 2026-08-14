/*
=========================================================
Project : Employee Management Database
File    : 09_Data_Cleaning_Functions.sql
Author  : Ayush Kale

Description:
Day 7 - Data Cleaning, String Functions, Date Functions
and Conditional Aggregation.

Actual Employees columns:
- EmployeeID
- FirstName
- LastName
- Gender
- DOB
- HireDate
- Salary
- ManagerID
- DepartmentID
=========================================================
*/


/*=========================================================
    PART 1 — NULL HANDLING
=========================================================*/


----------------------------------------------------------
-- 1. Replace NULL ManagerID with 0
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    ManagerID,
    ISNULL(ManagerID, 0) AS ManagerIDValue
FROM Employees;
GO


----------------------------------------------------------
-- 2. Display Manager Status Using COALESCE()
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    COALESCE(
        CAST(ManagerID AS VARCHAR(20)),
        'No Manager'
    ) AS ManagerInformation
FROM Employees;
GO


----------------------------------------------------------
-- 3. Employee Salary with NULL Safety
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    Salary,
    ISNULL(Salary, 0) AS SalaryAmount
FROM Employees;
GO


----------------------------------------------------------
-- 4. Employee + Manager Information
-- COALESCE() used for employees without managers
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    COALESCE(
        m.FirstName + ' ' + m.LastName,
        'No Manager'
    ) AS ManagerName
FROM Employees e
LEFT JOIN Employees m
    ON e.ManagerID = m.EmployeeID;
GO


/*=========================================================
    PART 2 — STRING FUNCTIONS
=========================================================*/


----------------------------------------------------------
-- 5. Full Employee Name
----------------------------------------------------------

SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS FullName
FROM Employees;
GO


----------------------------------------------------------
-- 6. Uppercase and Lowercase Names
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    UPPER(FirstName) AS UpperName,
    LOWER(FirstName) AS LowerName
FROM Employees;
GO


----------------------------------------------------------
-- 7. Name Length and Character Extraction
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    LEN(FirstName) AS NameLength,
    LEFT(FirstName, 2) AS FirstTwoCharacters,
    RIGHT(FirstName, 2) AS LastTwoCharacters
FROM Employees;
GO


----------------------------------------------------------
-- 8. Clean First Name
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    TRIM(FirstName) AS CleanFirstName
FROM Employees;
GO


----------------------------------------------------------
-- 9. Full Name in Uppercase
----------------------------------------------------------

SELECT
    EmployeeID,
    UPPER(
        CONCAT(FirstName, ' ', LastName)
    ) AS FullNameUpper
FROM Employees;
GO


/*=========================================================
    PART 3 — DATE FUNCTIONS
=========================================================*/


----------------------------------------------------------
-- 10. Extract Hire Year and Hire Month
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    HireDate,
    YEAR(HireDate) AS HireYear,
    MONTH(HireDate) AS HireMonth
FROM Employees;
GO


----------------------------------------------------------
-- 11. Years with Company
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    HireDate,
    DATEDIFF(
        YEAR,
        HireDate,
        GETDATE()
    ) AS YearsWithCompany
FROM Employees;
GO


----------------------------------------------------------
-- 12. Employees Hired in 2024
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    HireDate
FROM Employees
WHERE YEAR(HireDate) = 2024;
GO


----------------------------------------------------------
-- 13. Five Years After Hire Date
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    HireDate,
    DATEADD(
        YEAR,
        5,
        HireDate
    ) AS FiveYearDate
FROM Employees;
GO


----------------------------------------------------------
-- 14. Months with Company
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    HireDate,
    DATEDIFF(
        MONTH,
        HireDate,
        GETDATE()
    ) AS MonthsWithCompany
FROM Employees;
GO


----------------------------------------------------------
-- 15. Employees Hired Before 2020
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    LastName,
    HireDate
FROM Employees
WHERE HireDate < '2020-01-01';
GO


----------------------------------------------------------
-- 16. Employees Hired in the Last 5 Years
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    LastName,
    HireDate
FROM Employees
WHERE HireDate >= DATEADD(
    YEAR,
    -5,
    GETDATE()
);
GO


/*=========================================================
    PART 4 — CONDITIONAL AGGREGATION
=========================================================*/


----------------------------------------------------------
-- 17. Salary Category Count by Department
----------------------------------------------------------

SELECT
    DepartmentID,

    SUM(
        CASE
            WHEN Salary < 50000 THEN 1
            ELSE 0
        END
    ) AS LowSalaryEmployees,

    SUM(
        CASE
            WHEN Salary BETWEEN 50000 AND 80000 THEN 1
            ELSE 0
        END
    ) AS MediumSalaryEmployees,

    SUM(
        CASE
            WHEN Salary > 80000 THEN 1
            ELSE 0
        END
    ) AS HighSalaryEmployees

FROM Employees
GROUP BY DepartmentID;
GO


----------------------------------------------------------
-- 18. Department Payroll Report
----------------------------------------------------------

SELECT
    d.DepartmentName,
    COUNT(e.EmployeeID) AS TotalEmployees,
    SUM(e.Salary) AS TotalPayroll,
    AVG(e.Salary) AS AverageSalary
FROM Departments d
LEFT JOIN Employees e
    ON d.DepartmentID = e.DepartmentID
GROUP BY
    d.DepartmentID,
    d.DepartmentName;
GO


----------------------------------------------------------
-- 19. Department Salary Analysis
----------------------------------------------------------

SELECT
    d.DepartmentName,

    COUNT(e.EmployeeID) AS TotalEmployees,

    SUM(e.Salary) AS TotalPayroll,

    AVG(e.Salary) AS AverageSalary,

    SUM(
        CASE
            WHEN e.Salary > 80000 THEN 1
            ELSE 0
        END
    ) AS HighSalaryEmployees,

    SUM(
        CASE
            WHEN e.Salary < 50000 THEN 1
            ELSE 0
        END
    ) AS LowSalaryEmployees

FROM Departments d
LEFT JOIN Employees e
    ON d.DepartmentID = e.DepartmentID

GROUP BY
    d.DepartmentID,
    d.DepartmentName;
GO


/*=========================================================
    PART 5 — MANAGER ANALYTICS
=========================================================*/


----------------------------------------------------------
-- 20. Employee and Manager Information
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName AS EmployeeFirstName,
    e.LastName AS EmployeeLastName,
    m.EmployeeID AS ManagerID,
    m.FirstName AS ManagerFirstName,
    m.LastName AS ManagerLastName
FROM Employees e
LEFT JOIN Employees m
    ON e.ManagerID = m.EmployeeID;
GO


----------------------------------------------------------
-- 21. Employees Without a Manager
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    LastName,
    ManagerID
FROM Employees
WHERE ManagerID IS NULL;
GO


/*=========================================================
    PART 6 — COMBINED BUSINESS REPORT
=========================================================*/


----------------------------------------------------------
-- 22. Complete Employee Analytics Report
----------------------------------------------------------

SELECT
    e.EmployeeID,
    CONCAT(
        e.FirstName,
        ' ',
        e.LastName
    ) AS EmployeeName,

    d.DepartmentName,

    e.Salary,

    ISNULL(e.Salary, 0) AS SalaryAmount,

    CASE
        WHEN e.Salary < 50000 THEN 'Low'
        WHEN e.Salary BETWEEN 50000 AND 80000 THEN 'Medium'
        ELSE 'High'
    END AS SalaryCategory,

    YEAR(e.HireDate) AS HireYear,

    DATEDIFF(
        YEAR,
        e.HireDate,
        GETDATE()
    ) AS YearsWithCompany,

    COALESCE(
        m.FirstName + ' ' + m.LastName,
        'No Manager'
    ) AS ManagerName

FROM Employees e

LEFT JOIN Departments d
    ON e.DepartmentID = d.DepartmentID

LEFT JOIN Employees m
    ON e.ManagerID = m.EmployeeID;
GO


/*=========================================================
    PART 7 — FINAL DAY 7 REPORT
=========================================================*/


----------------------------------------------------------
-- 23. Department HR Summary
----------------------------------------------------------

SELECT
    d.DepartmentName,

    COUNT(e.EmployeeID) AS TotalEmployees,

    SUM(e.Salary) AS TotalPayroll,

    AVG(e.Salary) AS AverageSalary,

    SUM(
        CASE
            WHEN e.Salary > 80000 THEN 1
            ELSE 0
        END
    ) AS HighSalaryEmployees,

    SUM(
        CASE
            WHEN e.Salary < 50000 THEN 1
            ELSE 0
        END
    ) AS LowSalaryEmployees,

    SUM(
        CASE
            WHEN e.Salary BETWEEN 50000 AND 80000 THEN 1
            ELSE 0
        END
    ) AS MediumSalaryEmployees

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
    PART 8 — PERFORMANCE ANALYTICS
=========================================================*/


----------------------------------------------------------
-- 24. Employee Performance and Bonus
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    p.Rating,
    p.Bonus,
    p.ReviewDate
FROM Employees e
LEFT JOIN Performance p
    ON e.EmployeeID = p.EmployeeID;
GO


----------------------------------------------------------
-- 25. Replace NULL Bonus with 0
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    p.Bonus,
    ISNULL(p.Bonus, 0) AS BonusAmount
FROM Employees e
LEFT JOIN Performance p
    ON e.EmployeeID = p.EmployeeID;
GO


----------------------------------------------------------
-- 26. Bonus Category
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    p.Bonus,

    CASE
        WHEN p.Bonus IS NULL THEN 'No Bonus'
        WHEN p.Bonus = 0 THEN 'No Bonus'
        WHEN p.Bonus < 10000 THEN 'Low Bonus'
        WHEN p.Bonus BETWEEN 10000 AND 20000 THEN 'Medium Bonus'
        ELSE 'High Bonus'
    END AS BonusCategory

FROM Employees e
LEFT JOIN Performance p
    ON e.EmployeeID = p.EmployeeID;
GO


----------------------------------------------------------
-- 27. Performance Category
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    p.Rating,

    CASE
        WHEN p.Rating = 5 THEN 'Excellent'
        WHEN p.Rating = 4 THEN 'Good'
        WHEN p.Rating = 3 THEN 'Average'
        WHEN p.Rating IS NULL THEN 'Not Rated'
        ELSE 'Needs Improvement'
    END AS PerformanceCategory

FROM Employees e
LEFT JOIN Performance p
    ON e.EmployeeID = p.EmployeeID;
GO


----------------------------------------------------------
-- 28. Total Compensation
-- Salary + Bonus
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    e.Salary,
    ISNULL(p.Bonus, 0) AS Bonus,

    e.Salary + ISNULL(p.Bonus, 0)
        AS TotalCompensation

FROM Employees e
LEFT JOIN Performance p
    ON e.EmployeeID = p.EmployeeID;
GO


----------------------------------------------------------
-- 29. Performance Summary by Department
----------------------------------------------------------

SELECT
    d.DepartmentName,

    COUNT(e.EmployeeID) AS TotalEmployees,

    AVG(p.Rating) AS AverageRating,

    SUM(ISNULL(p.Bonus, 0)) AS TotalBonus

FROM Departments d

LEFT JOIN Employees e
    ON d.DepartmentID = e.DepartmentID

LEFT JOIN Performance p
    ON e.EmployeeID = p.EmployeeID

GROUP BY
    d.DepartmentID,
    d.DepartmentName;
GO


----------------------------------------------------------
-- 30. Excellent and Low-Rated Employees by Department
----------------------------------------------------------

SELECT
    d.DepartmentName,

    SUM(
        CASE
            WHEN p.Rating = 5 THEN 1
            ELSE 0
        END
    ) AS ExcellentEmployees,

    SUM(
        CASE
            WHEN p.Rating <= 3 THEN 1
            ELSE 0
        END
    ) AS LowRatedEmployees

FROM Departments d

LEFT JOIN Employees e
    ON d.DepartmentID = e.DepartmentID

LEFT JOIN Performance p
    ON e.EmployeeID = p.EmployeeID

GROUP BY
    d.DepartmentID,
    d.DepartmentName;
GO


----------------------------------------------------------
-- 31. Employees with High Performance and High Bonus
----------------------------------------------------------

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    p.Rating,
    p.Bonus

FROM Employees e

LEFT JOIN Departments d
    ON e.DepartmentID = d.DepartmentID

INNER JOIN Performance p
    ON e.EmployeeID = p.EmployeeID

WHERE p.Rating >= 4
  AND p.Bonus > 15000;
GO


----------------------------------------------------------
-- 32. Complete Employee Performance Report
----------------------------------------------------------

SELECT
    e.EmployeeID,

    CONCAT(
        e.FirstName,
        ' ',
        e.LastName
    ) AS EmployeeName,

    d.DepartmentName,

    e.Salary,

    p.Rating,

    CASE
        WHEN p.Rating = 5 THEN 'Excellent'
        WHEN p.Rating = 4 THEN 'Good'
        WHEN p.Rating = 3 THEN 'Average'
        WHEN p.Rating IS NULL THEN 'Not Rated'
        ELSE 'Needs Improvement'
    END AS PerformanceCategory,

    ISNULL(p.Bonus, 0) AS Bonus,

    CASE
        WHEN p.Bonus IS NULL OR p.Bonus = 0 THEN 'No Bonus'
        WHEN p.Bonus < 10000 THEN 'Low Bonus'
        WHEN p.Bonus BETWEEN 10000 AND 20000 THEN 'Medium Bonus'
        ELSE 'High Bonus'
    END AS BonusCategory,

    e.Salary + ISNULL(p.Bonus, 0)
        AS TotalCompensation,

    p.ReviewDate,

    p.Comments

FROM Employees e

LEFT JOIN Departments d
    ON e.DepartmentID = d.DepartmentID

LEFT JOIN Performance p
    ON e.EmployeeID = p.EmployeeID;
GO