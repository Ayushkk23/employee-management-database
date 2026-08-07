/*
=========================================================
Project : Employee Management Database
File    : 05_Basic_Analytics.sql
Author  : Ayush Kale

Description:
Basic analytical queries for HR and management reporting.

=========================================================
*/


----------------------------------------------------------
-- 1. Total Number of Employees
----------------------------------------------------------

SELECT COUNT(EmployeeID) AS TotalEmployees
FROM Employees;
GO

----------------------------------------------------------
-- 2. Total Monthly Salary Expense
----------------------------------------------------------

SELECT SUM(Salary) AS TotalMonthlySalaryExpense
FROM Employees;
GO

----------------------------------------------------------
-- 3. Average Employee Salary
----------------------------------------------------------

SELECT AVG(Salary) AS AverageSalary
FROM Employees;
GO

----------------------------------------------------------
-- 4. Highest Salary in the Company
----------------------------------------------------------

SELECT MAX(Salary) AS HighestSalary
FROM Employees;
GO

----------------------------------------------------------
-- 5. Highest Paid Employee
----------------------------------------------------------

SELECT
    FirstName,
    LastName,
    Salary
FROM Employees
WHERE Salary =
(
    SELECT MAX(Salary)
    FROM Employees
);
GO

----------------------------------------------------------
-- 6. Employees Sorted by Salary (Highest to Lowest)
----------------------------------------------------------

SELECT
    FirstName,
    LastName,
    Salary
FROM Employees
ORDER BY Salary DESC;
GO

----------------------------------------------------------
-- 7. Employees Earning More Than ₹70,000
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM Employees
WHERE Salary > 70000
ORDER BY Salary DESC;
GO

----------------------------------------------------------
-- 8. Employees from Department 2
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    DepartmentID
FROM Employees
WHERE DepartmentID = 2;
GO

----------------------------------------------------------
-- 9. Employees from Department 2
--    AND Salary Greater Than ₹60,000
----------------------------------------------------------

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    DepartmentID
FROM Employees
WHERE DepartmentID = 2
AND Salary > 60000
ORDER BY Salary DESC;
GO


----------------------------------------------------------
-- OR
----------------------------------------------------------

-- 10. Employees from Department 2 OR Department 3

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    DepartmentID
FROM Employees
WHERE DepartmentID = 2
OR DepartmentID = 3
ORDER BY
    DepartmentID ASC,
    Salary DESC;
GO

----------------------------------------------------------
-- IN
----------------------------------------------------------

-- 11. Employees from Department 2,3 and 5

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    DepartmentID
FROM Employees
WHERE DepartmentID IN (2,3,5)
AND Salary >= 60000
ORDER BY Salary DESC;
GO

----------------------------------------------------------
-- NOT IN
----------------------------------------------------------

-- 12. Employees NOT in Department 2 or 3

SELECT
    EmployeeID,
    FirstName,
    LastName,
    DepartmentID
FROM Employees
WHERE DepartmentID NOT IN (2,3)
ORDER BY DepartmentID;
GO


----------------------------------------------------------
-- OR
----------------------------------------------------------

-- 10. Employees from Department 2 OR Department 3

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    DepartmentID
FROM Employees
WHERE DepartmentID = 2
OR DepartmentID = 3
ORDER BY
    DepartmentID ASC,
    Salary DESC;
GO

----------------------------------------------------------
-- IN
----------------------------------------------------------

-- 11. Employees from Department 2,3 and 5

SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    DepartmentID
FROM Employees
WHERE DepartmentID IN (2,3,5)
AND Salary >= 60000
ORDER BY Salary DESC;
GO

----------------------------------------------------------
-- NOT IN
----------------------------------------------------------

-- 12. Employees NOT in Department 2 or 3

SELECT
    EmployeeID,
    FirstName,
    LastName,
    DepartmentID
FROM Employees
WHERE DepartmentID NOT IN (2,3)
ORDER BY DepartmentID;
GO

----------------------------------------------------------
-- 23. List all Departments having Employees
----------------------------------------------------------

SELECT DISTINCT DepartmentID
FROM Employees
ORDER BY DepartmentID;
GO

----------------------------------------------------------
-- 24. List Department Names having Employees
----------------------------------------------------------

SELECT DISTINCT
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentName;
GO

----------------------------------------------------------
-- 25. Top 5 Highest Paid Employees
----------------------------------------------------------

SELECT TOP 5
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM Employees
ORDER BY Salary DESC;
GO

----------------------------------------------------------
-- 26. Top 5 Lowest Paid Employees
----------------------------------------------------------

SELECT TOP 5
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM Employees
ORDER BY Salary ASC;
GO

----------------------------------------------------------
-- 27. Five Most Recently Hired Employees
----------------------------------------------------------

SELECT TOP 5
    EmployeeID,
    FirstName,
    LastName,
    HireDate
FROM Employees
ORDER BY HireDate DESC;
GO


/*=========================================================
    GROUP BY
=========================================================*/

----------------------------------------------------------
-- 28. Total Employees in Each Department
----------------------------------------------------------

SELECT
    DepartmentID,
    COUNT(EmployeeID) AS TotalEmployees
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID;
GO

----------------------------------------------------------
-- 29. Average Salary by Department
----------------------------------------------------------

SELECT
    DepartmentID,
    AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY AverageSalary DESC;
GO

----------------------------------------------------------
-- 30. Highest Salary by Department
----------------------------------------------------------

SELECT
    DepartmentID,
    MAX(Salary) AS HighestSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY HighestSalary DESC;
GO

----------------------------------------------------------
-- 31. Lowest Salary by Department
----------------------------------------------------------

SELECT
    DepartmentID,
    MIN(Salary) AS LowestSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY LowestSalary DESC;
GO

----------------------------------------------------------
-- 32. Total Salary Paid by Each Department
----------------------------------------------------------

SELECT
    DepartmentID,
    SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY TotalSalary DESC;
GO

----------------------------------------------------------
-- 33. Total Employees by Gender
----------------------------------------------------------

SELECT
    Gender,
    COUNT(EmployeeID) AS TotalEmployees
FROM Employees
GROUP BY Gender
ORDER BY TotalEmployees DESC;
GO

----------------------------------------------------------
-- 34. Average Salary by Gender
----------------------------------------------------------

SELECT
    Gender,
    AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Gender
ORDER BY AverageSalary DESC;
GO

----------------------------------------------------------
-- 35. Employees Hired Each Year
----------------------------------------------------------

SELECT
    YEAR(HireDate) AS HireYear,
    COUNT(EmployeeID) AS TotalEmployees
FROM Employees
GROUP BY YEAR(HireDate)
ORDER BY HireYear;
GO

----------------------------------------------------------
-- 36. Total Salary by Gender
----------------------------------------------------------

SELECT
    Gender, 
    SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Gender
ORDER BY TotalSalary DESC;
GO

----------------------------------------------------------
-- 37. Highest Salary by Gender
----------------------------------------------------------

SELECT
    Gender,
    MAX(Salary) AS HighestSalary
FROM Employees
GROUP BY Gender
ORDER BY HighestSalary DESC;
GO

/*=========================================================
    HAVING
=========================================================*/

----------------------------------------------------------
-- 38. Departments having more than 3 Employees
----------------------------------------------------------

SELECT
    DepartmentID,
    COUNT(EmployeeID) AS TotalEmployees
FROM Employees
GROUP BY DepartmentID
HAVING COUNT(EmployeeID) > 3
ORDER BY TotalEmployees DESC;
GO

----------------------------------------------------------
-- 39. Departments having Average Salary > ₹70,000
----------------------------------------------------------

SELECT
    DepartmentID,
    AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY DepartmentID
HAVING AVG(Salary) > 70000
ORDER BY AverageSalary DESC;
GO

----------------------------------------------------------
-- 40. Departments having Total Salary > ₹300,000
----------------------------------------------------------

SELECT
    DepartmentID,
    SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
HAVING SUM(Salary) > 300000
ORDER BY TotalSalary DESC;
GO

----------------------------------------------------------
-- 41. Departments having Maximum Salary > ₹100,000
----------------------------------------------------------

SELECT
    DepartmentID,
    MAX(Salary) AS HighestSalary
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) > 100000
ORDER BY HighestSalary DESC;
GO

----------------------------------------------------------
-- 42. Departments having Minimum Salary > ₹50,000
----------------------------------------------------------

SELECT
    DepartmentID,
    MIN(Salary) AS LowestSalary
FROM Employees
GROUP BY DepartmentID
HAVING MIN(Salary) > 50000
ORDER BY LowestSalary DESC;
GO

----------------------------------------------------------
-- 43. Gender groups having more than 5 Employees
----------------------------------------------------------

SELECT
    Gender,
    COUNT(EmployeeID) AS TotalEmployees
FROM Employees
GROUP BY Gender
HAVING COUNT(EmployeeID) > 5
ORDER BY TotalEmployees DESC;
GO

----------------------------------------------------------
-- 44. Hiring Years having more than 2 Employees
----------------------------------------------------------

SELECT
    YEAR(HireDate) AS HireYear,
    COUNT(EmployeeID) AS TotalEmployees
FROM Employees
GROUP BY YEAR(HireDate)
HAVING COUNT(EmployeeID) > 2
ORDER BY HireYear;
GO

----------------------------------------------------------
-- 45. Gender groups having Average Salary > ₹65,000
----------------------------------------------------------

SELECT
    Gender,
    AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Gender
HAVING AVG(Salary) > 65000
ORDER BY AverageSalary DESC;
GO