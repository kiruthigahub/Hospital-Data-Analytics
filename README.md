# ABC Multispeciality Hospital Data Analysis

## 📌 Project Overview

This project uses **MySQL** to analyze a sample hospital database. It explores doctor salaries, patient activity and spending, department performance, hospital revenue, and payment balances.

The project contains **48 numbered SQL questions**, progressing from basic queries to more advanced SQL analysis.

> **Dataset disclaimer:** This is an educational portfolio project. Use only synthetic or otherwise authorized data in a public repository. Do not publish real patient-identifiable or confidential information.

## 🎯 Project Objectives

- Analyze doctor salaries and compare salaries across departments.
- Explore patient appointments, admissions, and spending.
- Compare department activity and revenue.
- Review hospital billing, unpaid bills, and outstanding balances.
- Practice SQL techniques used in data analysis.

## 🗄️ Database Tables

The database includes 13 tables:

`departments`, `doctors`, `patients`, `rooms`, `appointments`, `admissions`, `diagnoses`, `medicines`, `prescriptions`, `lab_tests`, `insurance`, `payments`, and `employees`.

## 🛠️ Tools and SQL Skills

- **Database:** MySQL
- **Basic queries:** `SELECT`, `WHERE`, `DISTINCT`, `ORDER BY`, `LIMIT`
- **Aggregations:** `COUNT()`, `SUM()`, `AVG()`, `GROUP BY`, `HAVING`
- **Joins:** `INNER JOIN`, `LEFT JOIN`
- **Subqueries:** filtering and comparing values with aggregate results
- **Advanced SQL:** CTEs, `DENSE_RANK()`, `LAG()`, window functions, running totals
- **Analysis areas:** salary analysis, patient spending, department comparisons, revenue trends, and outstanding balances

## 📊 Selected SQL Analysis Screenshots

### Top Doctors by Salary
![Top Doctors by Salary](Screenshots/top-doctors-by-salary.png)

### Top Patients by Spending
![Top Patients by Spending](Screenshots/top-patients-by-spending.png)

### Highest Revenue Doctor
![Highest Revenue Doctor](Screenshots/highest-revenue-doctor.png)

## 💡 Business Questions This Project Explores

- Who are the highest-paid doctors?
- Which doctors earn above the hospital or their department's average salary?
- Which patients have the highest medical spending?
- Which departments have the most doctors or patients?
- Which department and doctor generate the highest recorded revenue?
- What is the monthly revenue, running revenue, and month-over-month revenue change?
- Which bills are unpaid, and which patients have outstanding balances?

## 📈 Business Insights

The SQL queries are designed to help explore:

- **Staffing and compensation:** compare doctor salaries and department-level averages.
- **Patient activity:** examine appointment patterns, admissions, and patient spending.
- **Department performance:** compare patient activity and recorded revenue across departments.
- **Revenue monitoring:** summarize monthly revenue and calculate changes over time.
- **Payment follow-up:** identify unpaid bills and outstanding balances.

These are analysis areas, not claims about real hospital performance. Actual conclusions should be written only after reviewing the query results.

## 🚀 How to Run

1. Download or clone this repository.
2. Open MySQL Workbench and connect to your MySQL server.
3. Open the SQL file in this repository.
4. Review the script before executing it, especially the database creation and data insertion statements.
5. Run the script in order, then execute the analysis queries to review the results.

> **Tip:** Back up important data first and check whether a database with the same name already exists before running the script.

## 📚 What I Practiced

- Writing SQL queries to answer business questions.
- Joining related tables and aggregating records.
- Using subqueries and common table expressions.
- Applying window functions for ranking and revenue trends.
- Analyzing salary, patient spending, revenue, and billing data.

## ⚠️ Disclaimer

This project is for educational and portfolio demonstration only. It is not a clinical or operational decision-making system. Do not upload real patient-identifiable or confidential hospital data to a public repository.

## 👩‍💻 Author

**Kiruthiga Narayanasamy**

Aspiring Data Analyst | MySQL | SQL Analytics
