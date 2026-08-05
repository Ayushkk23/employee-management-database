/*
=========================================================
Project : Employee Database Analytics System
File    : 02_Create_Tables.sql
Author  : Ayush Kale

Description:
Creates all database tables with primary keys and
identity columns.

=========================================================
*/
/*DEPARTMENT TABLE */
CREATE TABLE Departments(
DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
DepartmentName NVARCHAR(100) NOT NULL 
);
GO

/*EMPLOYEES TABLE */
CREATE TABLE Employees
(
    EmployeeID   INT IDENTITY(1,1) PRIMARY KEY,
    FirstName    NVARCHAR(100) NOT NULL,
    LastName     NVARCHAR(100) NOT NULL,
    Gender       CHAR(1) NOT NULL,
    DOB          DATE NOT NULL,
    HireDate     DATE NOT NULL,
    Salary       DECIMAL(10,2) NOT NULL,
    ManagerID    INT NULL,
    DepartmentID INT NOT NULL,

     CONSTRAINT FK_Employees_Departments
     FOREIGN KEY (DepartmentID)
     REFERENCES Departments(DepartmentID),

    CONSTRAINT FK_Employees_Manager
    FOREIGN KEY (ManagerID)
    REFERENCES Employees(EmployeeID)
);
GO

/*PROJECT TABLE */
CREATE TABLE Projects
(
    ProjectID   INT IDENTITY(1,1) PRIMARY KEY,
    ProjectName NVARCHAR(100) NOT NULL,
    Budget      DECIMAL(10,2) NOT NULL,
    StartDate   DATE NOT NULL,
    EndDate     DATE NULL
);
GO

/* EMPLOYEE PROJECTS TABLE */
CREATE TABLE EmployeeProjects
(
    EmployeeID  INT NOT NULL,
    ProjectID   INT NOT NULL,
    HoursWorked DECIMAL(5,2) NOT NULL,

    CONSTRAINT PK_EmployeeProjects
        PRIMARY KEY (EmployeeID, ProjectID),

    CONSTRAINT FK_EmployeeProjects_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID),

    CONSTRAINT FK_EmployeeProjects_Projects
        FOREIGN KEY (ProjectID)
        REFERENCES Projects(ProjectID)
);
GO

/* ATTENDANCE TABLE */
CREATE TABLE Attendance
(
    AttendanceID   INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID     INT NOT NULL,
    AttendanceDate DATE NOT NULL,
    Status         NVARCHAR(20) NOT NULL,

    CONSTRAINT FK_Attendance_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);
GO

/* PERFORMANCE TABLE */
CREATE TABLE Performance
(
    PerformanceID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID    INT NOT NULL,
    ReviewDate    DATE NOT NULL,
    Rating        INT NOT NULL,
    Bonus         DECIMAL(10,2) NOT NULL,
    ReviewerID    INT NULL,
    Comments      NVARCHAR(500) NULL,

    CONSTRAINT FK_Performance_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID),

    CONSTRAINT FK_Performance_Reviewer
        FOREIGN KEY (ReviewerID)
        REFERENCES Employees(EmployeeID)
);
GO

/* SALARY HISTORY TABLE */
CREATE TABLE SalaryHistory
(
    HistoryID     INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID    INT NOT NULL,
    OldSalary     DECIMAL(10,2) NOT NULL,
    NewSalary     DECIMAL(10,2) NOT NULL,
    EffectiveDate DATE NOT NULL,
    Reason        NVARCHAR(255) NULL,

    CONSTRAINT FK_SalaryHistory_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);
GO

/* EMPLOYEE AUDIT TABLE */
CREATE TABLE EmployeeAudit
(
    AuditID        INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID     INT NOT NULL,
    ColumnChanged  NVARCHAR(100) NOT NULL,
    OldValue       NVARCHAR(255) NULL,
    NewValue       NVARCHAR(255) NULL,
    ChangedDate    DATETIME NOT NULL,
    ChangedBy      NVARCHAR(100) NOT NULL,

    CONSTRAINT FK_EmployeeAudit_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);
GO




SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_NAME;
