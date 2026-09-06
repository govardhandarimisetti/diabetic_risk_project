# Hospital Intelligence & Patient Risk Analytics Pipeline

## 🩺 The Problem
Healthcare databases are often filled with messy, incomplete patient records due to busy doctors or missing forms. In this dataset of **15,000 patients**, columns like smoking habits, alcohol use, and income level had large gaps. 

If an analyst blindly deletes these rows, the hospital loses valuable patient data. If they just guess the missing answers using simple averages, it creates fake data trends and distorts real health statistics. 

This project solves that problem by building an automated, unbiased data cleaning pipeline that preserves all 15,000 patient records and organizes them into a secure SQL database for medical directors to make accurate data-backed decisions.

---

## 🛠️ The Tools Used
*   **Python (Pandas):** For data ingestion, auditing, and automated data cleaning.
*   **Jupyter Notebook:** The workspace environment where the code pipeline was tested.
*   **PostgreSQL:** The relational database used to store and warehouse the clean data.
*   **SQL Engine:** Used to run advanced queries to generate critical patient emergency lists.

---

## 🚀 How We Did It (Step-by-Step Workflow)

### Step 1: Initial Data Ingestion & Audit
We loaded the 15,000 raw patient records into Python and used checking tools to map out exactly where the missing data gaps were located.

### Step 2: Unbiased Cohort Cleaning (Imputation)
Instead of guessing or deleting records, we used smart, professional rules to fix the empty cells:
*   **Smoking Gaps:** Grouped patients by their stress scores and filled blanks with the most common smoking habit of that exact stress profile.
*   **Income Gaps:** Grouped patients by their city and filled blanks with the most common income bracket of that specific city.
*   **Alcohol Gaps:** Because over 25% of this data was missing, guessing would break the statistics. We safely labeled these blanks as `"unrecorded"` to keep the rows alive without inventing fake patient habits.

### Step 3: Text Standardization & Data Safety
We automatically converted all text entries into lowercase and database-compliant formats. This fixed typos and trailing spaces so that systems wouldn't get confused by mixed capitalization. We also audited the maximum and minimum numbers to ensure no impossible data errors slipped through.

### Step 4: Relational Database Storage
We built a robust table structure in **PostgreSQL** and securely streamed all 15,000 perfectly clean patient rows into the database for safe, long-term storage.

### Step 5: Strategic Health Analysis (SQL Queries)
We wrote **13 essential business queries** in SQL to act as an intelligence dashboard for hospital stakeholders. These queries instantly pull critical insights, such as ranking obesity hotspots across India, tracking senior citizen emergency rosters, and catching hidden high-risk diabetic patients.
