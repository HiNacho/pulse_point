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


# 🏥 Day 001: Relationship Mapping & ERD Architecture
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