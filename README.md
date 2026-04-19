# 🏥 PulsePoint: The Clinical Data Engine
### *Turning Healthcare Chaos into Predictive Insights*

![Database](https://img.shields.io/badge/Database-MySQL-blue?style=for-the-badge&logo=mysql)
![Python](https://img.shields.io/badge/Analysis-Python-yellow?style=for-the-badge&logo=python)
![Status](https://img.shields.io/badge/Challenge-100--Day--Sprint-green?style=for-the-badge)

---

## 📖 Project Overview
**PulsePoint** is a full-stack data engineering and analytics project designed to simulate a real-world hospital data migration. In a landscape where clinical data is often fragmented and "noisy," this project demonstrates the end-to-end journey of building a **normalized relational database**, cleaning **12,000+ rows of messy clinical data**, and building a **predictive engine** to track chronic disease progression.

> **The Mission:** Move beyond simple "Select *" queries to master complex data architecture, longitudinal analysis, and machine learning feature engineering.

---

## 🏗️ The Architecture
We are architecting a **7-table relational schema** that captures the entire patient lifecycle.

* **🏢 Administrative Layer:** Managing Departments and Healthcare Providers.
* **👥 Patient Core:** Centralized demographic data with "Golden Record" logic.
* **🩺 Clinical Layer:** The heartbeat of the system—Encounters, Vitals, and Medications.



---

## 🧪 The "Messy Data" Challenge
Unlike standard tutorials, PulsePoint starts with **intentional data decay**. To succeed, I must resolve:
* **Duplicate Identities:** Patients registered multiple times with slight variations.
* **Temporal Chaos:** 4+ different date formats (DD/MM/YYYY vs YYYY-MM-DD).
* **Clinical Outliers:** Physiological impossibilities (BP of 999, negative heart rates).
* **Unit Variance:** Standardizing weights and dosages across legacy systems.

---

## 🛠️ Tech Stack
* **Design:** `Excalidraw` for Architectural Blueprints (ERDs).
* **Data Warehouse:** `MySQL` for Relational Modeling & Complex Querying.
* **Analysis:** `Python (Pandas)` for Data Wrangling & Quality Audits.
* **Intelligence:** `AI` as the Senior Data Architect & Tutor.
* **Documentation:** `GitHub` for Version Control & Portfolio Hosting.

---

## 📈 The Roadmap

| Phase | Focus | Key Deliverables |
| :--- | :--- | :--- |
| **Phase 1 (Day 1-20)** | **The Foundation** | Schema Design, Data Dictionary, and DDL scripts. |
| **Phase 2 (Day 21-50)** | **The Deep Clean** | CTEs, Window Functions, and Data Quality Audits. |
| **Phase 3 (Day 51-80)** | **The Analytics** | Cohort Analysis and Patient Risk Scoring. |
| **Phase 4 (Day 81-100)** | **The Predictive Model** | ML integration and Streamlit Dashboard. |

---

## 🤝 Join the Journey
I am documenting every step of this build. Follow the daily progress in the [`daily_logs.md`](./daily_logs.md) or check the `/scripts` folder for the latest SQL builds.

**Developed by:** [HiNacho](https://github.com/HiNacho) 🚀