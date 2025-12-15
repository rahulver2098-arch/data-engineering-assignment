# Data Engineering Assignment

## Overview
This project demonstrates an end-to-end **data engineering pipeline** built to analyse **user behaviour, revenue trends, and order failure rates**. The solution follows industry best practices including layered data architecture, data cleaning, star schema modelling, and SQL-based analytics.

The project was implemented using **Python (Pandas)** for ingestion and transformation, and **SQLite** for data modelling and analytical querying.

---

## Tech Stack
- **Python 3** – Data ingestion & transformation
- **Pandas** – Data cleaning and feature engineering
- **SQLite (Online)** – Data modelling & SQL analytics
- **Jupyter Notebooks** – Development environment
- **GitHub** – Version control & submission

---

## Project Structure
```
data-engineering-assignment/
│
├── data/
│   ├── raw/                # Original CSV files
│   ├── processed/          # Staging layer (ingested data)
│   └── warehouse/          # Cleaned & modelled data
│
├── notebooks/
│   ├── ingestion.ipynb
│   └── transformations.ipynb
│
├── sql/
│   └── analytics.sql
│
├── docs/
│   ├── ERD.png
│   └── README.md
│
└── requirements.txt
```

---

## Data Sources
Two CSV datasets were used:

### Users Data
- `user_id`
- `name`
- `email`
- `city`
- `signup_date`

### Orders Data
- `order_id`
- `user_id`
- `product`
- `price`
- `order_date`
- `status`

The datasets intentionally contain data quality issues (nulls, invalid dates, negative prices, inconsistent formatting) to demonstrate cleaning logic.

---

## Step 1: Data Ingestion
**Goal:** Load raw CSV files into a staging layer without modifying the data.

- Implemented using Python (Pandas)
- Raw files stored in `data/raw/`
- Ingested copies written to `data/processed/`

**Why this step is important:**
- Preserves raw data for auditing and reprocessing
- Enables idempotent pipeline execution
- Mimics real-world data lake ingestion patterns

---

## Step 2: Data Cleaning & Transformations
**Goal:** Prepare analytics-ready data.

### Cleaning Performed
- Trimmed string columns
- Standardized emails to lowercase
- Parsed dates with invalid values coerced to NULL
- Removed records with:
  - Invalid prices (≤ 0)
  - Null user references

### Transformations Added
- `order_month` – derived from order date
- `account_age_days` – days since user signup
- `ltv` (Lifetime Value) – total spend per user

Cleaned outputs were loaded into the warehouse layer for modelling.

---

## Step 3: Data Modelling (Star Schema)
The warehouse follows a **star schema** design for optimized analytics.

### Fact Table
**fact_orders**
- order_id
- user_id
- price
- status
- order_date
- order_month

### Dimension Tables
**dim_users**
- user_id
- name
- email
- city
- signup_date
- account_age_days
- ltv

**dim_date**
- date_key
- date
- month
- year
- day_of_week

### Why Star Schema?
- Simplifies analytical queries
- Improves performance
- Industry-standard for BI and reporting

---

## Step 4: SQL Analytics
SQL queries were written on SQLite to answer key business questions:

- Top 10 customers by revenue
- Monthly revenue trend
- Cities with highest failed orders
- Repeat purchase / retention metrics

Queries are available in `sql/analytics.sql` with output screenshots.

---

## ER Diagram
The ER diagram illustrates relationships between fact and dimension tables.

- **User places orders** → relationship between `dim_users` and `fact_orders`
- **Order occurs on date** → relationship between `dim_date` and `fact_orders`

These labels describe business meaning and do not represent table names.

---

## Key Learnings & Best Practices
- Separation of ingestion and transformation layers
- Handling real-world dirty data
- Designing analytical data models
- Writing business-focused SQL queries
- Building scalable, re-runnable pipelines

---

## Author
**Rahul Verma**

This project was created as part of a data engineering assignment to demonstrate practical ETL, data modelling, SQL analytics skills AND Power BI skills.


