## Data Catalog – Gold Layer (Clicks Pharmacy Data Warehouse)
## Overview

The Gold Layer represents the business-ready analytics layer of the Clicks Pharmacy Data Warehouse.

It is structured into:

-- Dimension tables → descriptive business entities (customers, products, schemes, etc.)
-- Fact tables → measurable business transactions (sales, claims, refills, etc.)
This layer is designed for SQL analytics, reporting, and BI dashboards.

---

### 1. **gold.dim_customers**
- **Purpose**

Stores enriched customer (ClubCard member) information including demographics, loyalty, and contact details.

- **Columns:**
  | Column Name  | Data Type     | Description                                                       |
| ------------ | ------------- | ----------------------------------------------------------------- |
| customer_key | INT           | Surrogate key uniquely identifying each customer in the warehouse |
| clubcard_id  | NVARCHAR(50)  | Unique loyalty identifier from CRM system                         |
| first_name   | NVARCHAR(50)  | Customer first name                                               |
| last_name    | NVARCHAR(50)  | Customer last name                                                |
| gender       | NVARCHAR(50)  | Gender standardized (Male, Female, n/a)                           |
| cell_number  | NVARCHAR(50)  | Contact number (standardized format)                              |
| email        | NVARCHAR(100) | Customer email address                                            |
| city         | NVARCHAR(50)  | Customer location (standardized)                                  |
| postal_code  | NVARCHAR(10)  | Area code linked to store region                                  |
| loyalty_tier | NVARCHAR(20)  | Loyalty level (Gold, Silver, Platinum)                            |
| last_visit   | DATE          | Most recent recorded transaction date                             |
| language     | NVARCHAR(20)  | Preferred communication language                                  |

---
