Data Catalog for Gold Layer
Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases for Clicks Pharmacy retail operations. It consists of dimension tables and a fact table designed using the star schema model.

1. gold.dim_patient
Purpose: Stores patient/customer details enriched with demographic, geographic, and loyalty program data from Clicks ClubCard.

Columns:

Column Name	Data Type	Description
patient_key	INT	Surrogate key uniquely identifying each patient record in the dimension table.
clubcard_id	NVARCHAR(20)	Unique alphanumeric identifier for the Clicks ClubCard loyalty member.
first_name	NVARCHAR(50)	The patient's first name, as recorded in the ClubCard system.
last_name	NVARCHAR(50)	The patient's last name or family name.
id_number	NVARCHAR(13)	South African ID number (13 digits) for identity verification.
gender	NVARCHAR(10)	The gender of the patient (e.g., 'Male', 'Female', 'Other').
cellphone	NVARCHAR(15)	Primary mobile phone number for SMS notifications and OTPs.
email	NVARCHAR(100)	Email address for digital receipts and marketing communications.
city	NVARCHAR(50)	City of residence (e.g., 'Johannesburg', 'Cape Town', 'Durban').
postal_code	NVARCHAR(10)	South African postal code (e.g., '2001', '8001', '4001').
province	NVARCHAR(30)	Province of residence (e.g., 'Gauteng', 'Western Cape', 'KwaZulu-Natal').
loyalty_tier	NVARCHAR(20)	ClubCard loyalty tier indicating spending level ('Platinum', 'Gold', 'Silver', 'Bronze').
language_pref	NVARCHAR(10)	Preferred language for communications ('English', 'Afrikaans', 'isiZulu').
last_visit_date	DATE	The date of the patient's most recent pharmacy visit.
effective_date	DATE	The date when the patient record became active.
is_active	BOOLEAN	Flag indicating whether the patient is currently active (TRUE/FALSE).
