----------------------------------------------------------
-- 1. Complete Employee Analytics Report
--
-- Includes:
-- Employee information
-- Department information
-- Manager information
-- Salary category
-- Department average salary
-- Salary rank within department
-- Performance rating
-- Bonus
-- Total compensation
-- Years with company
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

    CONCAT(
        e.FirstName,
        ' ',
        e.LastName
    ) AS EmployeeName,

    d.DepartmentName,

    COALESCE(
        CONCAT(m.FirstName, ' ', m.LastName),
        'No Manager'
    ) AS ManagerName,

    e.Salary,

    CASE
        WHEN e.Salary < 50000 THEN 'Low'
        WHEN e.Salary BETWEEN 50000 AND 80000 THEN 'Medium'
        ELSE 'High'
    END AS SalaryCategory,

    a.DepartmentAverageSalary,

    RANK() OVER (
        PARTITION BY e.DepartmentID
        ORDER BY e.Salary DESC
    ) AS SalaryRank,

    p.Rating,

    ISNULL(p.Bonus, 0) AS Bonus,

    e.Salary + ISNULL(p.Bonus, 0)
        AS TotalCompensation,

    DATEDIFF(
        YEAR,
        e.HireDate,
        GETDATE()
    ) AS YearsWithCompany

FROM Employees e

LEFT JOIN Departments d
    ON e.DepartmentID = d.DepartmentID

LEFT JOIN Employees m
    ON e.ManagerID = m.EmployeeID

LEFT JOIN DepartmentAverage a
    ON e.DepartmentID = a.DepartmentID

LEFT JOIN Performance p
    ON e.EmployeeID = p.EmployeeID;
GO


----------------------------------------------------------
-- 2. Department Executive Summary
--
-- Shows:
-- Total Employees
-- Total Payroll
-- Average Salary
-- Highest Salary
-- Lowest Salary
-- Average Performance Rating
-- Total Bonus
----------------------------------------------------------

SELECT
    d.DepartmentName,
    COUNT(e.EmployeeID) AS TotalEmployees,
    SUM(e.Salary) AS TotalPayroll,
    AVG(e.Salary) AS AverageSalary,
    MAX(e.Salary) AS HighestSalary,
    MIN(e.Salary) AS LowestSalary,
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
-- 3. Find Employees With the Highest Performance Rating
--    In Each Department
--    Including Ties
----------------------------------------------------------

WITH PerformanceRanking AS
(
    SELECT
        e.EmployeeID,
        e.FirstName AS EmployeeName,
        d.DepartmentName,
        d.DepartmentID,
        p.Rating,
        p.Bonus,
        RANK() OVER (
            PARTITION BY d.DepartmentID
            ORDER BY p.Rating DESC
        ) AS RatingRank
    FROM Performance p
    INNER JOIN Employees e
        ON e.EmployeeID = p.EmployeeID
    INNER JOIN Departments d
        ON e.DepartmentID = d.DepartmentID
)
SELECT
    EmployeeID,
    EmployeeName,
    DepartmentName,
    Rating,
    Bonus
FROM PerformanceRanking
WHERE RatingRank = 1;
GO

----------------------------------------------------------
-- 4. Find the Top 2 Employees in Each Department
--    Based on Total Compensation
--
--    TotalCompensation = Salary + Bonus
--    NULL Bonus is treated as 0
--    Include ties
----------------------------------------------------------

WITH CompensationRanking AS
(
    SELECT
        e.EmployeeID,
        CONCAT(
            e.FirstName,
            ' ',
            e.LastName
        ) AS EmployeeName,
        d.DepartmentName,
        e.DepartmentID,
        e.Salary,
        ISNULL(p.Bonus, 0) AS Bonus,

        e.Salary + ISNULL(p.Bonus, 0)
            AS TotalCompensation,

        RANK() OVER (
            PARTITION BY e.DepartmentID
            ORDER BY
                e.Salary + ISNULL(p.Bonus, 0) DESC
        ) AS CompensationRank

    FROM Employees e

    INNER JOIN Departments d
        ON e.DepartmentID = d.DepartmentID

    LEFT JOIN Performance p
        ON e.EmployeeID = p.EmployeeID
)
SELECT
    EmployeeID,
    EmployeeName,
    DepartmentName,
    Salary,
    Bonus,
    TotalCompensation,
    CompensationRank
FROM CompensationRanking
WHERE CompensationRank <= 2;
GO

----------------------------------------------------------
-- 5. Find Employees Whose Total Compensation Is Greater
--    Than Their Manager's Total Compensation
--
--    TotalCompensation = Salary + Bonus
--    NULL Bonus is treated as 0
----------------------------------------------------------

SELECT
    e.EmployeeID,

    CONCAT(
        e.FirstName,
        ' ',
        e.LastName
    ) AS EmployeeName,

    e.Salary + ISNULL(ep.Bonus, 0)
        AS EmployeeTotalCompensation,

    CONCAT(
        m.FirstName,
        ' ',
        m.LastName
    ) AS ManagerName,

    m.Salary + ISNULL(mp.Bonus, 0)
        AS ManagerTotalCompensation,

    (
        e.Salary + ISNULL(ep.Bonus, 0)
    ) -
    (
        m.Salary + ISNULL(mp.Bonus, 0)
    ) AS CompensationDifference

FROM Employees e

INNER JOIN Employees m
    ON e.ManagerID = m.EmployeeID

LEFT JOIN Performance ep
    ON e.EmployeeID = ep.EmployeeID

LEFT JOIN Performance mp
    ON m.EmployeeID = mp.EmployeeID

WHERE
    e.Salary + ISNULL(ep.Bonus, 0)
    >
    m.Salary + ISNULL(mp.Bonus, 0);
GO


----------------------------------------------------------
-- 6. Rank Departments by Total Payroll
--
--    Also Show:
--    Total Employees
--    Total Payroll
--    Average Salary
--    Average Performance Rating
----------------------------------------------------------

WITH DepartmentSummary AS
(
    SELECT
        d.DepartmentID,
        d.DepartmentName,

        COUNT(DISTINCT e.EmployeeID) AS TotalEmployees,

        SUM(e.Salary) AS TotalPayroll,

        AVG(e.Salary) AS AverageSalary,

        AVG(p.Rating) AS AverageRating

    FROM Departments d

    LEFT JOIN Employees e
        ON d.DepartmentID = e.DepartmentID

    LEFT JOIN Performance p
        ON e.EmployeeID = p.EmployeeID

    GROUP BY
        d.DepartmentID,
        d.DepartmentName
)
SELECT
    DepartmentName,
    TotalEmployees,
    TotalPayroll,
    AverageSalary,
    AverageRating,

    RANK() OVER (
        ORDER BY TotalPayroll DESC
    ) AS PayrollRank

FROM DepartmentSummary;
GO


----------------------------------------------------------
-- 7. Find High-Value Employees
--
--    Conditions:
--    1. Salary is above the company average
--    2. Performance Rating >= 4
--    3. Bonus is above the average bonus
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
    p.Bonus,
    e.Salary + ISNULL(p.Bonus, 0)
        AS TotalCompensation
FROM Employees e
INNER JOIN Departments d
   ON e.DepartmentID = d.DepartmentID
INNER JOIN Performance p
    ON e.EmployeeID = p.EmployeeID
WHERE e.Salary >
(
    SELECT AVG(Salary)
    FROM Employees
)
AND p.Rating >= 4
AND p.Bonus >
(
    SELECT AVG(Bonus)
    FROM Performance
);
GO


----------------------------------------------------------
-- 8. Final Comprehensive Employee Analysis
--
--    Identifies employees who:
--    1. Rank in the top 3 salaries of their department
--    2. Have a performance rating >= 4
--    3. Have total compensation above the company
--       average compensation
----------------------------------------------------------

WITH EmployeeAnalysis AS
(
    SELECT
        e.EmployeeID,
        CONCAT(
            e.FirstName,
            ' ',
            e.LastName
        ) AS EmployeeName,
        d.DepartmentName,
        e.DepartmentID,
        e.Salary,
        ISNULL(p.Bonus, 0) AS Bonus,
        p.Rating,
        e.Salary + ISNULL(p.Bonus, 0)
            AS TotalCompensation,
        RANK() OVER (
            PARTITION BY e.DepartmentID
            ORDER BY e.Salary DESC
        ) AS SalaryRank

    FROM Employees e

    INNER JOIN Departments d
        ON e.DepartmentID = d.DepartmentID

    LEFT JOIN Performance p
        ON e.EmployeeID = p.EmployeeID
),
CompanyAverage AS
(
    SELECT
        AVG(TotalCompensation) AS AverageCompensation
    FROM EmployeeAnalysis
)
SELECT
    ea.EmployeeID,
    ea.EmployeeName,
    ea.DepartmentName,
    ea.Salary,
    ea.Bonus,
    ea.Rating,
    ea.TotalCompensation,
    ea.SalaryRank,
    ca.AverageCompensation
FROM EmployeeAnalysis ea
CROSS JOIN CompanyAverage ca
WHERE ea.SalaryRank <= 3
  AND ea.Rating >= 4
  AND ea.TotalCompensation > ca.AverageCompensation;
GO