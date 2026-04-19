import pandas as pd
import numpy as np
from faker import Faker
import random

fake = Faker()
num_patients = 1000

# --- 1. DEPARTMENTS ---
depts = [
    [1, 'Internal Medicine', None, 500000],
    [2, 'Surgery', None, 850000],
    [3, 'Cardiology', 1, 250000],
    [4, 'Orthopedics', 2, 300000],
    [5, 'Pediatrics', 1, 200000]
]
df_depts = pd.DataFrame(depts, columns=['dept_id', 'dept_name', 'parent_dept_id', 'budget'])

# --- 2. PROVIDERS ---
providers = []
for i in range(501, 521):
    providers.append({
        'provider_id': i,
        'first_name': fake.first_name(),
        'last_name': fake.last_name(),
        'specialty': random.choice(['GP', 'Surgeon', 'Cardiologist', 'Nurse Practitioner']),
        'dept_id': random.randint(1, 5)
    })
df_providers = pd.DataFrame(providers)

# --- 3. PATIENTS (The Messy Part) ---
patients = []
for i in range(1, num_patients + 1):
    dob_messy = random.choice([
        fake.date_of_birth(minimum_age=1, maximum_age=90).strftime('%Y-%m-%d'),
        fake.date_of_birth(minimum_age=1, maximum_age=90).strftime('%m/%d/%Y'),
        fake.date_of_birth(minimum_age=1, maximum_age=90).strftime('%d-%b-%y')
    ])
    patients.append({
        'patient_id': 1000 + i,
        'first_name': fake.first_name(),
        'last_name': fake.last_name(),
        'dob': dob_messy,
        'gender': random.choice(['M', 'F', 'Male', 'Female', 'm', 'f', None]),
        'insurance_provider': random.choice(['BlueShield', 'Aetna', 'Medicare', 'Cigna', None])
    })
# Add 15 duplicates with slight variations
for _ in range(15):
    idx = random.randint(0, 999)
    dup = patients[idx].copy()
    dup['patient_id'] = 3000 + _ 
    patients.append(dup)
df_patients = pd.DataFrame(patients)

# --- 4. ENCOUNTERS ---
encounters = []
enc_id = 9000
for p_id in df_patients['patient_id']:
    for _ in range(random.randint(10, 15)):
        enc_id += 1
        encounters.append({
            'encounter_id': enc_id,
            'patient_id': p_id,
            'provider_id': random.randint(501, 520),
            'dept_id': random.randint(1, 5),
            'encounter_date': fake.date_time_between(start_date='-3y', end_date='now'),
            'visit_type': random.choice(['Outpatient', 'Inpatient', 'ER', 'Telehealth'])
        })
df_encounters = pd.DataFrame(encounters)

# --- 5. VITALS (The Outliers) ---
vitals = []
v_id = 1
for e_id in df_encounters['encounter_id']:
    vitals.append({
        'vital_id': v_id,
        'encounter_id': e_id,
        'vital_name': 'BP_Systolic',
        'vital_value': random.choice([random.randint(90, 180), 999, -20]),
        'vital_unit': 'mmHg'
    })
    v_id += 1
    vitals.append({
        'vital_id': v_id,
        'encounter_id': e_id,
        'vital_name': 'Weight',
        'vital_value': random.uniform(45, 120),
        'vital_unit': random.choice(['kg', 'lbs', 'kgs'])
    })
    v_id += 1
df_vitals = pd.DataFrame(vitals)

# --- 6. MEDICATIONS ---
meds = [
    [1, 'Metformin', 'Tablet', 10.50],
    [2, 'Lisinopril', 'Tablet', 15.00],
    [3, 'Amoxicillin', 'Capsule', 12.00],
    [4, 'Insulin', 'Injection', 150.00]
]
df_meds = pd.DataFrame(meds, columns=['med_id', 'med_name', 'dosage_form', 'unit_cost'])

# --- 7. PRESCRIPTIONS ---
prescriptions = []
for p_id in df_patients['patient_id'].unique():
    for _ in range(random.randint(1, 5)):
        prescriptions.append({
            'rx_id': random.randint(100000, 999999),
            'patient_id': p_id,
            'med_id': random.randint(1, 4),
            'encounter_id': random.choice(df_encounters[df_encounters['patient_id']==p_id]['encounter_id'].values),
            'start_date': fake.date_between(start_date='-2y', end_date='today'),
            'end_date': fake.date_between(start_date='today', end_date='+1y')
        })
df_prescriptions = pd.DataFrame(prescriptions)

# --- SAVE EVERYTHING ---
file_name = 'PulsePoint_Master_Data.xlsx'
with pd.ExcelWriter(file_name) as writer:
    df_depts.to_excel(writer, sheet_name='Departments', index=False)
    df_providers.to_excel(writer, sheet_name='Providers', index=False)
    df_patients.to_excel(writer, sheet_name='Patients', index=False)
    df_encounters.to_excel(writer, sheet_name='Encounters', index=False)
    df_vitals.to_excel(writer, sheet_name='Vitals', index=False)
    df_meds.to_excel(writer, sheet_name='Medications', index=False)
    df_prescriptions.to_excel(writer, sheet_name='Prescriptions', index=False)

print(f"Success! '{file_name}' has been created with all 7 tables.")

