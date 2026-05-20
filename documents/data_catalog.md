# Data Catalog for Gold Layer

## Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases for **Clicks Pharmacy retail operations**. It consists of dimension tables and a fact table designed using the star schema model.

---

### 1. gold.dim_patient

**Purpose:** Stores patient/customer details enriched with demographic, geographic, and loyalty program data from Clicks ClubCard.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| patient_key | INT | Surrogate key uniquely identifying each patient record in the dimension table. |
| clubcard_id | NVARCHAR(20) | Unique alphanumeric identifier for the Clicks ClubCard loyalty member. |
| first_name | NVARCHAR(50) | The patient's first name, as recorded in the ClubCard system. |
| last_name | NVARCHAR(50) | The patient's last name or family name. |
| id_number | NVARCHAR(13) | South African ID number (13 digits) for identity verification. |
| gender | NVARCHAR(10) | The gender of the patient (e.g., 'Male', 'Female', 'Other'). |
| cellphone | NVARCHAR(15) | Primary mobile phone number for SMS notifications and OTPs. |
| email | NVARCHAR(100) | Email address for digital receipts and marketing communications. |
| city | NVARCHAR(50) | City of residence (e.g., 'Johannesburg', 'Cape Town', 'Durban'). |
| postal_code | NVARCHAR(10) | South African postal code (e.g., '2001', '8001', '4001'). |
| province | NVARCHAR(30) | Province of residence (e.g., 'Gauteng', 'Western Cape', 'KwaZulu-Natal'). |
| loyalty_tier | NVARCHAR(20) | ClubCard loyalty tier indicating spending level ('Platinum', 'Gold', 'Silver', 'Bronze'). |
| language_pref | NVARCHAR(10) | Preferred language for communications ('English', 'Afrikaans', 'isiZulu'). |
| last_visit_date | DATE | The date of the patient's most recent pharmacy visit. |
| effective_date | DATE | The date when the patient record became active. |
| is_active | BOOLEAN | Flag indicating whether the patient is currently active (TRUE/FALSE). |

---

### 2. gold.dim_drug

**Purpose:** Provides comprehensive information about pharmaceutical products, including South African scheduling, pricing, and classification.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| drug_key | INT | Surrogate key uniquely identifying each drug record in the product dimension table. |
| prod_code | NVARCHAR(20) | Unique product code assigned to each drug in the Clicks inventory system. |
| brand_name | NVARCHAR(100) | The brand name of the medication (e.g., 'Adco-Lipitor', 'Panado', 'Augmentin'). |
| generic_name | NVARCHAR(100) | The generic/international non-proprietary name of the active ingredient. |
| manufacturer | NVARCHAR(100) | The pharmaceutical company that manufactures the drug. |
| unit_price | DECIMAL(10,2) | The standard retail price per unit in South African Rand (ZAR). |
| schedule | INT | South African drug schedule classification (1=OTC, 2=Pharmacy, 3=Prescription, 4-6=Controlled). |
| category | NVARCHAR(20) | Therapeutic category of the medication ('Chronic', 'Acute', 'OTC'). |
| requires_prescription | BOOLEAN | Flag indicating whether a doctor's prescription is required. |
| is_controlled | BOOLEAN | Flag indicating whether the drug is a controlled substance under SA law. |
| vat_exempt | BOOLEAN | Flag indicating whether the drug is exempt from VAT. |
| stock_qty | INT | Current inventory quantity available across all stores. |
| ndc | NVARCHAR(20) | National Drug Code (NDC) identifier for regulatory tracking. |

---

### 3. gold.dim_store

**Purpose:** Stores information about Clicks pharmacy store locations across South Africa.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| store_key | INT | Surrogate key uniquely identifying each store location. |
| store_code | NVARCHAR(10) | Unique store identifier code (e.g., 'JHB-02', 'CPT-03', 'DBN-01'). |
| store_name | NVARCHAR(100) | Official name of the store (e.g., 'Clicks Sandton City'). |
| city | NVARCHAR(50) | City where the store is located. |
| province | NVARCHAR(30) | Province where the store operates. |
| region | NVARCHAR(30) | Geographic region grouping for reporting. |
| store_type | NVARCHAR(20) | Type of store ('Mall', 'Street', 'Hospital-based', 'Wellness'). |
| opening_date | DATE | Date when the store first opened for business. |
| is_active | BOOLEAN | Flag indicating whether the store is currently operating. |

---

### 4. gold.dim_date

**Purpose:** Time dimension for date-based analysis and trend reporting.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| date_key | INT | Surrogate key in integer format (YYYYMMDD) for efficient joining. |
| full_date | DATE | The complete calendar date (e.g., '2025-10-06'). |
| year | INT | Four-digit year (e.g., '2024', '2025'). |
| quarter | INT | Calendar quarter number (1, 2, 3, 4). |
| month | INT | Month number (1-12). |
| month_name | NVARCHAR(10) | Full month name (e.g., 'January', 'February'). |
| week_num | INT | Week number within the year (1-53). |
| day_of_week | INT | Day of week number (1=Monday, 7=Sunday). |
| day_name | NVARCHAR(10) | Full day name (e.g., 'Monday', 'Tuesday'). |
| is_weekend | BOOLEAN | Flag indicating whether the date falls on a weekend. |
| is_public_holiday | BOOLEAN | Flag indicating South African public holidays. |

---

### 5. gold.dim_medical_scheme

**Purpose:** Stores medical scheme enrollment details for claims processing and reimbursement analysis.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| scheme_key | INT | Surrogate key uniquely identifying each medical scheme enrollment. |
| member_id | NVARCHAR(20) | Unique identifier for the medical scheme member. |
| clubcard_id | NVARCHAR(20) | Reference to the patient's ClubCard ID. |
| scheme_name | NVARCHAR(100) | Name of the medical scheme (e.g., 'Discovery Health', 'Momentum Health'). |
| plan_name | NVARCHAR(100) | Specific plan type within the scheme (e.g., 'Classic Smart', 'Ingwe'). |
| plan_type | NVARCHAR(50) | High-level plan category ('PPO', 'HMO', 'Hospital Plan', 'Saver'). |
| employer_group | NVARCHAR(50) | Employer or corporate group identifier for the member. |
| member_relation | NVARCHAR(20) | Relationship to the principal member ('Principal', 'Spouse', 'Dependant'). |
| effective_date | DATE | The start date of medical scheme coverage. |
| termination_date | DATE | The end date of medical scheme coverage (NULL if currently active). |
| is_active | BOOLEAN | Flag indicating whether the member is currently covered. |

---

### 6. gold.dim_prescriber

**Purpose:** Stores information about doctors and healthcare providers who issue prescriptions.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| prescriber_key | INT | Surrogate key uniquely identifying each prescriber. |
| prescriber_id | NVARCHAR(20) | Unique identifier for the prescriber from the source system. |
| prescriber_name | NVARCHAR(100) | Full name of the doctor or healthcare provider. |
| practice_number | NVARCHAR(20) | SA Health Professions Council (HPCSA) practice number. |
| specialty | NVARCHAR(50) | Medical specialty of the prescriber (e.g., 'General Practitioner'). |
| practice_city | NVARCHAR(50) | City where the practice is located. |
| practice_province | NVARCHAR(30) | Province where the practice operates. |
| contact_number | NVARCHAR(15) | Practice contact phone number. |

---

### 7. gold.fact_dispensing

**Purpose:** Stores transactional pharmacy dispensing data for analytical purposes, linking patients, drugs, stores, dates, medical schemes, and prescribers.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| dispensing_key | INT | Surrogate key uniquely identifying each dispensing transaction record. |
| patient_key | INT | FK to dim_patient. Surrogate key linking to the patient dimension. |
| drug_key | INT | FK to dim_drug. Surrogate key linking to the drug dimension. |
| store_key | INT | FK to dim_store. Surrogate key linking to the store dimension. |
| date_key | INT | FK to dim_date. Surrogate key linking to the date dimension. |
| scheme_key | INT | FK to dim_medical_scheme. Surrogate key linking to the medical scheme dimension. |
| prescriber_key | INT | FK to dim_prescriber. Surrogate key linking to the prescriber dimension. |
| txn_id | NVARCHAR(20) | Unique transaction identifier from the source dispensing system. |
| prod_code | NVARCHAR(20) | Product code of the dispensed medication. |
| dispense_date | DATE | The date when the medication was dispensed to the patient. |
| quantity | INT | The number of units of medication dispensed (e.g., 30, 60, 90). |
| paid_amount | DECIMAL(10,2) | The total amount paid by the patient in South African Rand (ZAR). |
| copay_amount | DECIMAL(10,2) | The patient's co-payment portion. |
| medical_aid_amount | DECIMAL(10,2) | The amount covered by the patient's medical scheme. |
| claim_id | NVARCHAR(20) | Reference to the corresponding medical aid claim. |
| claim_approved_amount | DECIMAL(10,2) | The amount approved by the medical scheme. |
| denial_reason | NVARCHAR(200) | Reason for claim denial (e.g., 'Prior auth required', 'Non-formulary'). |
| refill_number | INT | The refill number for the prescription (0 = first fill). |
| chronic_authorization_num | NVARCHAR(50) | Chronic medication authorization number for repeat prescriptions. |
| chronic_flag | BOOLEAN | Flag indicating whether the medication is for a chronic condition. |
| days_supply | INT | Number of days the dispensed medication is expected to last. |
| store_code | NVARCHAR(10) | Store code where the dispensing occurred (e.g., 'JHB-02', 'CPT-03'). |
| created_timestamp | DATETIME | The timestamp when the dispensing record was created in the data warehouse. |

---

## Summary of Relationships

| Table | Type | Foreign Keys |
|-------|------|--------------|
| gold.dim_patient | Dimension | None |
| gold.dim_drug | Dimension | None |
| gold.dim_store | Dimension | None |
| gold.dim_date | Dimension | None |
| gold.dim_medical_scheme | Dimension | None |
| gold.dim_prescriber | Dimension | None |
| gold.fact_dispensing | Fact | patient_key → dim_patient, drug_key → dim_drug, store_key → dim_store, date_key → dim_date, scheme_key → dim_medical_scheme, prescriber_key → dim_prescriber |
