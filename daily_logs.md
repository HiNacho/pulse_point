# 🏥 Day 000: Setting Up The PulsePoint Lab
**Date:** April 19, 2026
**Status:** COMPLETE ✅

Today was all about preparation. To succeed in the next 100 days, we needed a professional environment where data can breathe and code can be tracked. We aren't just practicing SQL; we are building a clinical data infrastructure.

### 🛠️ Tasks Completed
1. **Repository Setup:** Initialized the `PulsePoint` project on GitHub with a professional directory structure and essential files:
	- `/data`: Home for our raw clinical records (e.g., `PulsePoint_Master_Data.xlsx`).
	- `daily_logs.md`: For daily project updates and documentation.
	- `file_generator.py`: Script to generate synthetic Excel datasets with clinical noise.
	- `pulse_point.sql`: For all SQL schema, DDL, and query scripts.
	- `requirement.txt`: Stores all Python dependencies needed for data generation and analysis.
2. **Toolkit Validation:** Confirmed local installation of the "Big Four":
	- **MySQL Workbench:** Our primary RDBMS.
	- **Excel:** For data dictionary mapping.
	- **Excalidraw:** For visual system design.
	- **GitHub Desktop/CLI:** For version control.
3. **Data Generation:** Engineered the `file_generator.py` script to simulate a high-volume, high-noise hospital database. 

### 🧪 Getting the Data
Followers can choose one of two paths to get their "Lab" ready for Day 001:

* **Option A (The Shortcut):** Download the pre-generated `PulsePoint_Master_Dataset.xlsx` directly from the [`/data`](./data) folder.
* **Option B (The Architect Path):** Run the [`file_generator.py`](file_generator.py) script locally to understand how synthetic clinical noise is created. 
	 *Note: You will need to run `pip install pandas openpyxl numpy` before executing.*

### 💡 Pro-Tip for Today

Don't be tempted to "fix" the Excel file manually tonight. We are keeping the date formats messy and the outliers extreme on purpose. Our goal is to use **SQL Power**, not manual labor, to sanitize this infrastructure starting tomorrow.

**The requirements.txt:** To run file_generator.py, simply install the required Python libraries by running:

```
pip3 install -r requirement.txt
```
The requirements.txt file is already included in the repo with all necessary dependencies.

---


# 🏥 Day 001: Relationship Mapping
**Date:** April 20, 2026
**Status:** COMPLETE ✅

Today’s focus was on "Architectural Blueprinting." Before writing a single line of SQL, I spent the day deconstructing the 7-table schema to map how a patient’s clinical journey flows through the database.

### 🎯 The Goal
To design a normalized Entity Relationship Diagram (ERD) and define the primary/foreign key connections that ensure data integrity across the hospital's infrastructure.

---

### 🏗️ The 3-Layer Architecture

The system is organized into three logical layers to maintain clean data separation and scalability:

#### 1. The Administrative Layer (The Skeleton)
This layer defines the hospital's physical and professional structure.
* **`clinical_departments`**: Stores the hierarchy of hospital units. It uses a **self-referencing relationship** (`parent_dept_id`) to allow for sub-units (e.g., Pediatric Cardiology inside a larger Cardiology department).
* **`providers`**: The master directory of clinicians.
    * **Connection:** Linked to `clinical_departments` via `dept_id` (1:N). One department houses many doctors.

#### 2. The Core Layer (The Heart)
This is where the human element meets the hospital's services.
* **`patients`**: The central registry for all unique individuals visiting the facility.
* **`encounters`**: **The central junction table.** This is the "Heart" of the ERD. It captures a single event in time where a patient, doctor, and department interact.
    * **Connection:** Piles three Foreign Keys (`patient_id`, `provider_id`, `dept_id`) into one record.

#### 3. The Clinical Layer (The Details)
The granular, event-driven data generated during a visit.
* **`clinical_vitals`**: Captures biometric data (BP, Weight, Temperature).
    * **Connection:** Linked strictly to `encounter_id` (1:N). One visit can generate many vital signs.
* **`medications`**: A static catalog of drug types, dosages, and costs.
* **`prescriptions`**: The legal order tying the patient to a specific medication.
    * **Connection:** Connects `patient_id`, `med_id`, and `encounter_id` to provide a 360-degree view of the treatment order.

---

**Next Step:** Tomorrow, we move to **Day 002: ERD Design & Data Relationships.** I will be designing the visual blueprint of the system, breaking down the table connections, and mastering the concepts of Primary Keys (PK) and Foreign Keys (FK) that keep our data synchronized.


# 🏥 Day 002: ERD Architecture & The Blueprint of Reality
**Date:** April 21, 2026  
**Status:** COMPLETE ✅

Today is Day 2 of my #100DaysOfSQL challenge. We are moving from "Problem Insight" to **Architectural Design**. Before we can build a database, we must draw the map. Today, I designed the complete **Entity-Relationship Diagram (ERD)** for the PulsePoint system.

---

### 1. What is an ERD? (First Principles)
Think of a hospital database like a **giant patient chart system**. Each “chart” (table) holds records about one type of thing—patients, doctors, or visits. 

An **ERD (Entity-Relationship Diagram)** is the architect’s blueprint that shows:
- **Entities:** The tables that exist.
- **Attributes:** The information each one holds.
- **Relationships:** How they are connected.



### 2. Why do we need ERDs?
They prevent duplicate data, guarantee accuracy, make queries fast, and ensure the system is scalable. We draw this **before** writing SQL so the "Digital Twin" of our patient remains consistent.

### 3. The PulsePoint ERD
The PulsePoint database consists of exactly **7 tables**. I used **Crow’s Foot Notation** to define the rules of our hospital.

### 4. Primary Keys (PK) & Foreign Keys (FK)
- **Primary Key (PK):** The unique ID card of each record.  
  *Analogy:* A patient’s Medical Record Number (MRN). Every patient has exactly one; it never repeats.
- **Foreign Key (FK):** A pointer that says “this record belongs to that record over there.”  
  *Healthcare analogy:* The patient ID printed at the top of every vital signs sheet. That ID points back to the correct person in the Patients table.



### 5. Crow’s Foot Notation & Cardinality
The symbols at the ends of the lines in my ERD are **Crow’s Foot Notation**. They tell us the **Cardinality** (How many records from one table relate to another).

- `|` = Exactly **One** (Mandatory)  
- `o` = **Zero or One** (Optional)  
- `🔱` (Crow’s Foot) = **Many**

**Key Pattern:** `|-----<` (One-to-Many). One parent record owns many child records.

### 6. Detailed Relationship Breakdown

#### **CLINICAL_DEPARTMENTS (The Hierarchy)**
- **PK:** `dept_id`  
- **Feature:** Self-referencing relationship via `parent_dept_id`.
- **Why?** A big department like **Internal Medicine** (Parent) can have sub-units like **Cardiology** (Child). This hierarchy allows for clean reporting and budgeting.

#### **PROVIDERS (The Staff)**
- **Relationship:** **“employs”** (`|-----<`) — One Department employs Many Providers.
- **Rule:** A doctor is assigned to **one** department to keep accountability clear.

#### **ENCOUNTERS (The Junction)**
- **The Heart of the System.** This table pulls `patient_id`, `provider_id`, and `dept_id` together.
- **“Conducts”**: One provider conducts many visits.
- **“Has”**: One patient has many visits.
- **“Captures”**: One visit captures many vital signs.



---

### 7. The Story: Mr. John’s Journey at PulsePoint
Let’s follow **Mr. John** (patient_id 1001) through our ERD:

1. Mr. John arrives with chest pain. His records are found in the **PATIENTS** table.
2. A new record is created in **ENCOUNTERS** (ID: 9001), linking him to Dr. Morales and the Cardiology department.
3. The nurse records his blood pressure in **CLINICAL_VITALS**, linked specifically to `encounter_id 9001`.
4. Dr. Morales prescribes medication. A new row is created in **PRESCRIPTIONS**, linking Mr. John to the **MEDICATIONS** vault and the current visit.

Every piece of data is perfectly "glued" together by the IDs we mapped out today.

---

### Final Thoughts
This ERD is now the solid foundation for everything that follows. 

**Next Step:** Tomorrow (**Day 003**), I will convert this visual blueprint into real SQL code using `CREATE TABLE` statements, defining the data types and constraints for all 7 tables. 🚀