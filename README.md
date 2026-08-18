# 🗄️ EmployeeDB SQL Analytics Project

A SQL Server project designed to simulate a real-world employee management and analytics system. The project covers database creation, employee and department management, performance tracking, salary analysis, managerial relationships, and advanced business analytics using T-SQL.

**Key Objectives:**
- Handle NULL values safely and effectively.
- Perform advanced string and date manipulation.
- Solve real-world business problems using robust SQL queries.

---

## 🗂️ Database Structure

The project uses three main tables to simulate company data:

### 1. Employees
Stores core employee information.

| Column | Description |
|---|---|
| `EmployeeID` | Unique employee identifier (Primary Key) |
| `FirstName` | Employee first name |
| `LastName` | Employee last name |
| `Gender` | Employee gender |
| `DOB` | Date of birth |
| `HireDate` | Employee joining date |
| `Salary` | Employee salary |
| `ManagerID` | Employee's manager (Foreign Key) |
| `DepartmentID` | Employee's department (Foreign Key) |

### 2. Departments
Stores organizational department information.

| Column | Description |
|---|---|
| `DepartmentID` | Unique department identifier (Primary Key) |
| `DepartmentName` | Name of the department |

### 3. Performance
Stores employee performance review records.

| Column | Description |
|---|---|
| `PerformanceID` | Unique performance record identifier (Primary Key) |
| `EmployeeID` | Employee being reviewed (Foreign Key) |
| `ReviewDate` | Performance review date |
| `Rating` | Performance rating (e.g., 1-5) |
| `Bonus` | Performance-based monetary bonus |
| `ReviewerID` | Identifier of the manager/reviewer |
| `Comments` | Performance comments |

---

## 🔗 Table Relationships

The database relies on relational design to connect employees, departments, and performance metrics:

```text
                 Departments
                      │
                      │ (DepartmentID)
                      ▼
                  Employees
                 /    │        (ManagerID)  /     │      \ (EmployeeID)
               │      │       │
               ▼      │       ▼
           Employees  │   Performance
           (Manager)  │
                      │
```

- **`Employees.DepartmentID` → `Departments.DepartmentID`**: Each employee belongs to a department.
- **`Employees.ManagerID` → `Employees.EmployeeID`**: Self-referencing relationship where an employee reports to another employee (their manager).
- **`Performance.EmployeeID` → `Employees.EmployeeID`**: Each performance record is tied to a specific employee.

---

## 📂 Project Structure

```text
EmployeeDB_Project/
│
├── README.md
├── 01_Create_Database.sql
├── 02_Create_Tables.sql
├── 03_Insert_Data.sql
├── 04_Constraints.sql
├── 05_Basic_Analytics.sql
├── 06_Joins.sql
├── 07_Advanced_SQL.sql
├── 08_Window_Functions.sql
├── 09_Data_Cleaning_Functions.sql
├── 10_Advanced_Analytics.sql
├── 11_Real_World_Queries.sql
└── 12_Final_Project_Queries.sql
```

---

## 📚 SQL Concepts Covered

- **Basic SQL**: `SELECT`, `DISTINCT`, `WHERE`, `ORDER BY`, `GROUP BY`, `HAVING`
- **Aggregate Functions**: `COUNT()`, `SUM()`, `AVG()`, `MIN()`, `MAX()`
- **JOINs**: `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL OUTER JOIN`, `SELF JOIN`
- **Set Operations**: `UNION`, `UNION ALL`
- **Subqueries**: Scalar, Aggregate, and Correlated subqueries
- **Common Table Expressions (CTEs)**: Basic CTEs, JOINs within CTEs, Window Functions in CTEs, Multi-step queries
- **Window Functions**: `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `LAG()`, `LEAD()`, `PARTITION BY`, Windowed `AVG()`
- **NULL Handling**: `ISNULL()`, `COALESCE()`, NULL comparisons
- **String Functions**: `CONCAT()`, `UPPER()`, `LOWER()`, `LEN()`, `LEFT()`, `RIGHT()`, `TRIM()`
- **Date Functions**: `YEAR()`, `MONTH()`, `DATEDIFF()`, `DATEADD()`, `GETDATE()`
- **Conditional Logic**: `CASE` statements, Conditional Aggregation

---

## 📊 Business Analysis Performed

The project is designed to answer critical business questions, including:

**Employee & Department Analysis**
- Who are the highest-paid employees?
- Which employees earn above their department's average salary?
- Which employees earn more (or less) than their managers?
- What is the total payroll and average salary of each department?
- Which departments have no assigned employees?

**Performance & Compensation Analysis**
- Which departments have the highest average performance rating?
- Who are the high-performing employees with below-average salaries?
- What is the total compensation (Salary + Bonus) for each employee?
- Who received the highest bonus in the company and within each department?
- Which employees have yet to receive a performance review?

---

## 🪟 Window Function Examples

Window functions are heavily utilized for advanced analytical insights:

**1. Ranking employees by salary within departments:**
```sql
RANK() OVER (
    PARTITION BY DepartmentID
    ORDER BY Salary DESC
)
```

**2. Finding the top-paid employee in each department:**
```sql
ROW_NUMBER() OVER (
    PARTITION BY DepartmentID
    ORDER BY Salary DESC
)
```

**3. Comparing an employee's salary to the next/previous tier:**
```sql
LAG(Salary) OVER (ORDER BY Salary DESC)
LEAD(Salary) OVER (ORDER BY Salary DESC)
```

---

## 🔍 Example Business Query

**Scenario:** Find employees whose salary is higher than their department's average salary.

```sql
WITH DepartmentAverage AS (
    SELECT
        DepartmentID,
        AVG(Salary) AS DepartmentAverageSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT
    e.EmployeeID,
    e.FirstName,
    e.Salary,
    a.DepartmentAverageSalary
FROM Employees e
INNER JOIN DepartmentAverage a
    ON e.DepartmentID = a.DepartmentID
WHERE e.Salary > a.DepartmentAverageSalary;
```

---

## 🛠️ Technologies Used

- **Microsoft SQL Server**
- **T-SQL**
- **SQL Server Management Studio (SSMS)**
- **Git & GitHub**

---

## ▶️ How to Run the Project

Execute the SQL scripts sequentially in your SQL Server environment to build and query the database:

1. **`01_Create_Database.sql`** — Sets up the raw database.
2. **`02_Create_Tables.sql`** — Builds the schema.
3. **`03_Insert_Data.sql`** — Populates tables with mock data.
4. **`04_Constraints.sql`** — Applies primary/foreign keys and data rules.
5. **`05` through `12`** — Run these sequentially to explore analytics, JOINs, window functions, and business queries.

---

## 💡 Key Learnings

Building this project reinforced my ability to:
- Query relational databases dynamically using T-SQL.
- Navigate hierarchical employee-manager structures using self-joins.
- Aggregate and summarize business data to uncover trends.
- Rank and compare employees against department-level metrics.
- Seamlessly handle `NULL` values to prevent calculation errors.
- Simplify complex operations using Common Table Expressions (CTEs).
- Translate real-world business requirements into optimized SQL code.

---

## 🚀 Future Improvements

- Add employee attendance and leave management tracking.
- Incorporate historical salary changes (SCD Type 2).
- Add monthly payroll analytics.
- Build interactive Power BI dashboards using this SQL database.
- Create stored procedures and SQL views for frequently pulled reports.
- Implement automated data-quality checks.

---

## 👨‍💻 Author

**Ayush Kale**
