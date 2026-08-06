/*
=========================================================
Project : Employee Database Analytics System
File    : 03_Insert_Data.sql
Author  : Ayush Kale

Description:
Inserts realistic sample data into all tables.

=========================================================
*/


/* DEPARTMENTS */
INSERT INTO Departments (DepartmentName)
VALUES
('Human Resources'),
('Information Technology'),
('Finance'),
('Marketing'),
('Sales'),
('Operations'),
('Research and Development'),
('Customer Support'),
('Legal'),
('Administration');
GO
--VERIFY
SELECT *
FROM Departments;


/* MANAGERS */
INSERT INTO Employees
(
    FirstName,
    LastName,
    Gender,
    DOB,
    HireDate,
    Salary,
    ManagerID,
    DepartmentID
)
VALUES
('John', 'Smith', 'M', '1980-03-15', '2015-06-01', 120000.00, NULL, 2),
('Sarah', 'Johnson', 'F', '1982-08-21', '2014-09-15', 115000.00, NULL, 3),
('Michael', 'Brown', 'M', '1979-11-10', '2013-04-20', 125000.00, NULL, 5),
('Emily', 'Davis', 'F', '1985-01-30', '2016-02-10', 110000.00, NULL, 4),
('David', 'Wilson', 'M', '1981-07-12', '2012-11-05', 130000.00, NULL, 1);
GO

 --VERIFY
SELECT
    EmployeeID,
    FirstName + ' ' + LastName AS EmployeeName,
    Salary,
    ManagerID,
    DepartmentID
FROM Employees
ORDER BY EmployeeID;

/* EMPLOYEES */
INSERT INTO Employees
(
    FirstName,
    LastName,
    Gender,
    DOB,
    HireDate,
    Salary,
    ManagerID,
    DepartmentID
)
VALUES
('Ayush', 'Kale', 'M', '2003-01-15', '2026-07-01', 55000.00, 1, 2),
('Rahul', 'Patil', 'M', '1998-05-10', '2022-08-01', 60000.00, 1, 2),
('Priya', 'Sharma', 'F', '1997-09-12', '2021-06-15', 65000.00, 2, 3),
('Sneha', 'Joshi', 'F', '1999-03-25', '2023-01-10', 58000.00, 4, 4),
('Rohit', 'Verma', 'M', '1996-11-08', '2020-09-20', 70000.00, 3, 5),
('Anjali', 'Gupta', 'F', '2000-02-18', '2024-04-01', 52000.00, 5, 1),
('Karan', 'Mehta', 'M', '1998-07-14', '2022-03-15', 61000.00, 1, 2),
('Neha', 'Kulkarni', 'F', '1999-12-30', '2023-08-18', 57000.00, 2, 3),
('Vikas', 'Singh', 'M', '1995-10-09', '2019-05-12', 75000.00, 3, 5),
('Pooja', 'Nair', 'F', '1997-04-16', '2021-11-01', 64000.00, 4, 4);
GO

INSERT INTO Employees
(
    FirstName,
    LastName,
    Gender,
    DOB,
    HireDate,
    Salary,
    ManagerID,
    DepartmentID
)
VALUES
('Arjun', 'Reddy', 'M', '1996-06-22', '2020-07-15', 69000.00, 3, 5),
('Meera', 'Iyer', 'F', '1998-08-05', '2022-09-12', 62000.00, 2, 3),
('Aditya', 'Deshmukh', 'M', '1999-01-18', '2023-02-20', 56000.00, 1, 2),
('Komal', 'Shah', 'F', '1997-10-14', '2021-10-10', 63000.00, 4, 4),
('Nikhil', 'Jain', 'M', '1995-04-30', '2019-12-01', 76000.00, 3, 5),
('Sakshi', 'Patel', 'F', '2001-05-28', '2025-01-15', 50000.00, 5, 1),
('Aman', 'Yadav', 'M', '1998-02-09', '2022-06-18', 61000.00, 1, 2),
('Riya', 'Mishra', 'F', '1999-09-01', '2023-07-10', 58000.00, 2, 3),
('Harsh', 'Kulkarni', 'M', '1996-12-12', '2020-05-05', 72000.00, 3, 5),
('Divya', 'Menon', 'F', '1998-03-11', '2022-01-25', 60000.00, 4, 4);
GO

--VERIFY
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    ManagerID,
    DepartmentID
FROM Employees
ORDER BY EmployeeID;


/*  PROJECTS */
INSERT INTO Projects
(
    ProjectName,
    Budget,
    StartDate,
    EndDate
)
VALUES
('HR Management System',        500000.00, '2026-01-01', NULL),
('Employee Portal',             750000.00, '2026-02-15', NULL),
('Sales Dashboard',             300000.00, '2026-03-01', '2026-09-30'),
('Inventory Management',        900000.00, '2026-01-20', NULL),
('Finance Automation',          650000.00, '2026-04-01', NULL),
('Customer Support Portal',     450000.00, '2026-05-10', NULL),
('Payroll System',              400000.00, '2026-03-15', '2026-08-31'),
('Data Warehouse Migration',   1500000.00, '2026-02-01', NULL),
('Mobile Employee App',         800000.00, '2026-06-01', NULL),
('Cyber Security Upgrade',     1200000.00, '2026-01-10', NULL);
GO

--VERIFY
SELECT
    ProjectID,
    ProjectName,
    Budget,
    StartDate,
    EndDate
FROM Projects
ORDER BY ProjectID;

/* ============================================
   EMPLOYEE PROJECTS
============================================ */

INSERT INTO EmployeeProjects
(
    EmployeeID,
    ProjectID,
    HoursWorked
)
VALUES
(1,1,120.50),
(1,2,85.00),
(2,5,140.75),
(2,8,92.50),
(3,4,160.00),
(3,8,180.25),
(4,3,110.50),
(4,9,95.75),
(5,1,130.00),
(5,7,100.00),

(6,2,45.50),
(6,9,32.00),
(7,2,78.25),
(8,5,62.00),
(9,4,55.75),
(10,3,88.00),
(10,10,40.50),

(11,1,25.00),
(12,2,48.50),
(13,5,51.75),
(14,8,70.25),
(15,3,82.00),

(16,4,64.50),
(17,5,60.00),
(18,9,39.75),
(19,6,50.00),
(20,8,73.50),

(21,7,41.25),
(22,2,46.00),
(23,5,58.25),
(24,10,68.50),
(25,9,72.75),

(7,9,30.00),
(8,8,42.50),
(11,10,36.25),
(15,6,44.75),
(18,3,55.50),
(20,4,48.00),
(22,7,34.50),
(24,1,62.00);
GO

SELECT
    EmployeeID,
    ProjectID,
    HoursWorked
FROM EmployeeProjects
ORDER BY EmployeeID;



--VERIFY
SELECT
    AttendanceID,
    EmployeeID,
    AttendanceDate,
    Status
FROM Attendance
ORDER BY AttendanceID;


/* ============================================
   PERFORMANCE
============================================ */

INSERT INTO Performance
(
    EmployeeID,
    ReviewDate,
    Rating,
    Bonus,
    ReviewerID,
    Comments
)
VALUES
(1,'2026-07-31',5,20000.00,NULL,'Excellent leadership'),
(2,'2026-07-31',5,18000.00,NULL,'Outstanding financial planning'),
(3,'2026-07-31',4,15000.00,NULL,'Strong operational performance'),
(4,'2026-07-31',4,14000.00,NULL,'Exceeded expectations'),
(5,'2026-07-31',5,22000.00,NULL,'Exceptional HR management'),

(6,'2026-07-31',4,8000.00,1,'Consistent performer'),
(7,'2026-07-31',3,5000.00,1,'Needs slight improvement'),
(8,'2026-07-31',5,9000.00,2,'Excellent teamwork'),
(9,'2026-07-31',4,7000.00,4,'Reliable employee'),
(10,'2026-07-31',5,10000.00,3,'Exceeded sales targets'),

(11,'2026-07-31',3,3000.00,5,'Average performance'),
(12,'2026-07-31',4,6000.00,1,'Quick learner'),
(13,'2026-07-31',4,6500.00,2,'Good communication'),
(14,'2026-07-31',5,9000.00,3,'Outstanding contribution'),
(15,'2026-07-31',4,7500.00,4,'Very dependable'),

(16,'2026-07-31',5,9500.00,3,'Excellent project delivery'),
(17,'2026-07-31',4,6200.00,2,'Strong analytical skills'),
(18,'2026-07-31',3,4000.00,1,'Improving steadily'),
(19,'2026-07-31',4,7000.00,4,'Good collaboration'),
(20,'2026-07-31',5,11000.00,3,'Top performer'),

(21,'2026-07-31',3,3500.00,5,'Needs mentoring'),
(22,'2026-07-31',4,6500.00,1,'Reliable employee'),
(23,'2026-07-31',5,9500.00,2,'Excellent execution'),
(24,'2026-07-31',4,7200.00,3,'Strong technical skills'),
(25,'2026-07-31',4,6800.00,4,'Consistent performance');
GO


SELECT
    EmployeeID,
    Rating,
    Bonus,
    ReviewerID
FROM Performance
ORDER BY EmployeeID;


/* ============================================
   SALARY HISTORY
============================================ */

INSERT INTO SalaryHistory
(
    EmployeeID,
    OldSalary,
    NewSalary,
    EffectiveDate,
    Reason
)
VALUES
(6,50000.00,55000.00,'2026-07-01','Annual Increment'),
(7,55000.00,60000.00,'2025-08-01','Promotion'),
(8,60000.00,65000.00,'2025-06-15','Performance Review'),
(9,54000.00,58000.00,'2026-01-10','Annual Increment'),
(10,65000.00,70000.00,'2025-09-20','Promotion'),

(11,48000.00,52000.00,'2026-04-01','Annual Increment'),
(12,56000.00,61000.00,'2025-03-15','Performance Review'),
(13,52000.00,57000.00,'2026-02-20','Annual Increment'),
(14,70000.00,75000.00,'2025-05-12','Promotion'),
(15,59000.00,64000.00,'2025-11-01','Annual Increment'),

(16,64000.00,69000.00,'2025-07-15','Promotion'),
(17,57000.00,62000.00,'2025-09-12','Annual Increment'),
(18,51000.00,56000.00,'2026-02-20','Performance Review'),
(19,58000.00,63000.00,'2025-10-10','Annual Increment'),
(20,71000.00,76000.00,'2025-12-01','Promotion');
GO

--VERIFY
SELECT
    EmployeeID,
    OldSalary,
    NewSalary,
    EffectiveDate
FROM SalaryHistory
ORDER BY EmployeeID;


/* ============================================
   EMPLOYEE AUDIT
============================================ */

INSERT INTO EmployeeAudit
(
    EmployeeID,
    ColumnChanged,
    OldValue,
    NewValue,
    ChangedBy
)
VALUES
(6,'Salary','50000','55000','HR Admin'),
(7,'DepartmentID','5','2','HR Admin'),
(8,'ManagerID','1','2','HR Admin'),
(10,'Salary','65000','70000','HR Admin'),
(12,'DepartmentID','1','3','HR Admin'),
(14,'Salary','70000','75000','HR Admin'),
(16,'ManagerID','2','3','HR Admin'),
(18,'Salary','51000','56000','HR Admin'),
(20,'DepartmentID','4','5','HR Admin'),
(24,'Salary','67000','72000','HR Admin');
GO

SELECT
    AuditID,
    EmployeeID,
    ColumnChanged,
    OldValue,
    NewValue,
    ChangedDate
FROM EmployeeAudit
ORDER BY AuditID;



