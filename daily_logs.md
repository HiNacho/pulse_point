# 🏥 Day 000: Setting Up The PulsePoint Lab
**Date:** April 19, 2026
**Status:** COMPLETE ✅

Today was all about preparation. To succeed in the next 100 days, we needed a professional environment where data can breathe and code can be tracked. We aren't just practicing SQL; we are building a clinical data infrastructure.

### 🛠️ Tasks Completed
1. **Repository Setup:** Initialized the `PulsePoint` project on GitHub with a professional directory structure:
	- `/data`: Home for our raw clinical records.
	- `/scripts`: The engine room for SQL builds and Python automation.
	- `/docs`: The vault for architecture blueprints (ERDs) and Data Dictionaries.
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
pip install -r requirements.txt
```
The requirements.txt file is already included in the repo with all necessary dependencies.

---
