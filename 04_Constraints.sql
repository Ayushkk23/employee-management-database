/*
=========================================================
Project : Employee Database Analytics System
File    : 04_Constraints.sql
Author  : Ayush Kale

Description:
Adds CHECK, DEFAULT and UNIQUE constraints.
=========================================================
*/
-- Employee Salary
ALTER TABLE Employees
ADD CONSTRAINT CK_Employees_Salary
CHECK (Salary > 0);
GO


-- Employee Gender
ALTER TABLE Employees
ADD CONSTRAINT CK_Employees_Gender
CHECK (Gender IN ('M', 'F', 'O'));
GO

-- Performance rating
ALTER TABLE Performance
ADD CONSTRAINT CK_Performance_Rating
CHECK (Rating BETWEEN 1 AND 5);
GO

-- Project Budget
ALTER TABLE Projects
ADD CONSTRAINT CK_Projects_Budget
CHECK (Budget > 0);
GO

-- Hours Worked
ALTER TABLE EmployeeProjects
ADD CONSTRAINT CK_EmployeeProjects_HoursWorked
CHECK (HoursWorked >= 0);
GO

-- Performance Bonus
ALTER TABLE Performance
ADD CONSTRAINT CK_Performance_Bonus
CHECK (Bonus >= 0);
GO

-- Salary History
ALTER TABLE SalaryHistory
ADD CONSTRAINT CK_SalaryHistory_OldSalary
CHECK (OldSalary > 0);

ALTER TABLE SalaryHistory
ADD CONSTRAINT CK_SalaryHistory_NewSalary
CHECK (NewSalary > 0);
GO

/* DEFAULT CONSTRAINTS */

-- Attendance Status
ALTER TABLE Attendance
ADD CONSTRAINT DF_Attendance_Status
DEFAULT 'Present' FOR Status;
GO

ALTER TABLE Attendance
ADD CONSTRAINT CK_Attendance_Status
CHECK (Status IN ('Present','Absent','Leave','WFH','Half Day'));
GO

-- Employee Project Hours
ALTER TABLE EmployeeProjects
ADD CONSTRAINT DF_EmployeeProjects_HoursWorked
DEFAULT 0.00 FOR HoursWorked;
GO

-- Performance Bonus
ALTER TABLE Performance
ADD CONSTRAINT DF_Performance_Bonus
DEFAULT 0.00 FOR Bonus;
GO

-- Employee Audit Changed Date
ALTER TABLE EmployeeAudit
ADD CONSTRAINT DF_EmployeeAudit_ChangedDate
DEFAULT GETDATE() FOR ChangedDate;
GO


ALTER TABLE Attendance
ADD CONSTRAINT UQ_Attendance_Employee_Date
UNIQUE (EmployeeID, AttendanceDate);
GO