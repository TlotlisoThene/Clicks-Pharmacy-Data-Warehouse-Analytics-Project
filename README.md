# Clicks Pharmacy Data Warehouse & Analytics Project
Welcome to the **Data Warehouse and Analytics Project** repository.
This project demonstrates a comprehensive data warehouse and analytics solution, covering the full pipeline from building a data warehouse to generating actionable insights. The project is designed as a portfolio project that highlights industry best practices in data engineering and analytics.

The project highlights industry best practices in:
- Data Engineering
- ETL Development
- Data Warehousing
- SQL Analytics
- Dimensional Modeling

---

 ## Project Overview

This project simulates a real-world retail pharmacy analytics environment by integrating data from multiple operational systems:

 ## Front-office (CRM systems)

- Customer loyalty (ClubCard) data
- Pharmacy dispensing and transaction records
- Prescription refill and adherence tracking

 ## Back-office (ERP systems)

- Product catalog and pricing information
- Medical aid claims processing
- Medical scheme membership and enrollment data

The goal is to build a scalable, clean, and analytics-ready data warehouse that enables stakeholders to make data-driven decisions.

## Data Architecture

<img width="1644" height="957" alt="data_architecture" src="https://github.com/user-attachments/assets/be1a2d9d-86e6-4f33-a1f0-3d1295d5cb6a" />
- **Bronze Layer** → Raw ingestion from CRM & ERP CSV source systems
- **Silver Layer** → Data cleansing, standardization, and transformation
- **Gold Layer** → Business-ready dimensional models optimized for analytics
- **Consumption Layer** → Reporting, SQL analytics, dashboards, and machine learning use cases

---

 ## Business Questions Addressed

This project enables analysis of key business questions such as:

- Which medications generate the highest revenue?
- Which medical schemes have the highest claim denial rates?
- Which stores serve the largest number of chronic patients?
- How does loyalty tier affect prescription adherence?
- What are the trends in chronic vs acute medication usage?

 ## Project Requirements

## Building the data warehouse
 ## Objectives
Building a modern data warehouse using SQL Server, Implementing ETL (Extract, Transform, Load) processes, Designing data models for analytical workloads, and Performing data analysis to generate actionable insights.

 ## Specifications
- Data Sources: CRM and ERP CSV-based source systems.
- Data Quality: Handle missing values, inconsistent formats, duplicates, and invalid entries.
- Integration: Consolidate multiple systems into a single analytics-ready model.
- Scope: Latest dataset only (no historization required).
- Context: Simulated South African retail pharmacy environment.
- Documentation: Clear schema and data model documentation for business and technical users.

 ## Analytics & Reporting (Data Analyst Layer)

 ## Customer Analytics
  Prescription refill adherence by loyalty tier
  Chronic vs acute medication patient segmentation
  Cross-sell and behavior pattern analysis
  
 ## Product Performance
  Top-selling medications by store and region
  Brand-name vs generic usage trends
  Controlled medication tracking (Schedule-based analysis)
  
 ## Sales & Financial Analytics
  Monthly revenue per store (JHB-02, CPT-03, DBN-01, etc.)
  Cash vs medical aid payment distribution
  Claim denial rates by medical scheme
  Copay and reimbursement analysis

 ## Data Engineering Concepts Demonstrated

This project demonstrates practical implementation of:

  - SQL Server data warehousing
  - Star schema design (fact & dimension tables)
  - ETL pipeline development
  - Data cleaning and standardization
  - Data integration from multiple source systems
  - Business intelligence reporting using SQL

 ## Data Quality Challenges Handled

The datasets intentionally include realistic inconsistencies such as:

  - Mixed date formats
  - Missing or null values
  - Invalid numeric entries (negative or text quantities)
  - Inconsistent boolean formats (Y/N, TRUE/FALSE, yes/no)
  - Duplicate and incomplete records
  - Inconsistent product and customer identifiers

 ## About This Dataset

This is a simulated retail pharmacy dataset inspired by real-world South African pharmacy operations. It is designed for educational and portfolio purposes and does not contain real customer or medical data.

 ## License
This project is licensed under the (MIT Licenses). You are free to use, modify and share this project with proper attribution.

 ## About Me

Hi, I'm Tlotliso Thene, a final-year BSc Computer Science and Applied Mathematics student with interests in data engineering, analytics, and database systems.

This project demonstrates my practical skills in:
- SQL and ETL development
- Data warehousing and dimensional modeling
- Data cleaning and transformation
- Analytics and business reporting

## Connect with me:
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/tlotliso-thene)
