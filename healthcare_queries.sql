SELECT * FROM patient LIMIT (30)

-- QUERY 1: Patients by City
-- Purpose: Identifies high-risk patient hotspots across cities to help healthcare leaders deploy medical teams and supplies.

SELECT 
    city,
    COUNT(patient_id) AS total_patients,
    SUM(CASE WHEN LOWER(diabetes_risk) = 'high' THEN 1 ELSE 0 END) AS high_risk_count,
    ROUND((SUM(CASE WHEN LOWER(diabetes_risk) = 'high' THEN 1 ELSE 0 END)::NUMERIC / COUNT(patient_id)) * 100, 2) AS high_risk_percentage
FROM patient_clinical_records
GROUP BY city
ORDER BY high_risk_count DESC;



-- QUERY 2: Patient Age and Weight by Gender
-- Purpose: Displays total patient volumes, average age, and BMI split by city and gender to help optimize local clinical staffing.

SELECT 
    city,
    gender,
    COUNT(patient_id) AS patient_count,
    ROUND(AVG(age)::NUMERIC, 1) AS average_age,
    ROUND(AVG(bmi)::NUMERIC, 1) AS average_bmi
FROM patient
GROUP BY city, gender
ORDER BY city ASC, patient_count DESC;


-- QUERY 3: Patients by Income Level
-- Purpose: Shows the distribution and percentage of risk groups across different income brackets to help allocate subsidized care.

SELECT 
    income_bracket,
    diabetes_risk,
    COUNT(patient_id) AS demographic_volume,
    ROUND((COUNT(patient_id)::NUMERIC / SUM(COUNT(patient_id)) OVER(PARTITION BY income_bracket)) * 100, 2) AS category_contribution_ratio_pct
FROM patient
GROUP BY income_bracket, diabetes_risk
ORDER BY income_bracket, demographic_volume DESC;


-- QUERY 4: Inactive Patients by Diet Type
-- purpose: Shows the average blood sugar and weight of completely lazy/inactive patients grouped by their diet types to help plan nutrition campaigns.

SELECT 
    diet_type,
    COUNT(patient_id) AS lazy_patient_count,
    ROUND(AVG(fasting_blood_sugar)::NUMERIC, 2) AS average_blood_sugar,
    ROUND(AVG(bmi)::NUMERIC, 2) AS average_weight_bmi
FROM patient
WHERE LOWER(physical_activity_level) = 'sedentary'
GROUP BY diet_type
ORDER BY average_blood_sugar DESC;

-- QUERY 5: Hidden High-Risk Patients
-- Purpose: Finds patients labeled 'Low Risk' who secretly have dangerous blood sugar numbers, helping doctors catch hidden health threats.

SELECT 
    patient_id,
    age,
    city,
    avg_blood_sugar AS long_term_sugar,
    fasting_blood_sugar AS daily_sugar,
    diabetes_risk
FROM patient
WHERE LOWER(diabetes_risk) = 'low' 
  AND (avg_blood_sugar > 7.0 OR fasting_blood_sugar > 140)
ORDER BY long_term_sugar DESC;

-- QUERY 6: Patients with High Blood Pressure
-- Purpose: Counts how many patients in each risk tier have high blood pressure, helping doctors spot critical heart and diabetes risks together.

SELECT 
    diabetes_risk,
    COUNT(patient_id) AS total_patients_in_group,
    SUM(CASE WHEN blood_pressure_systolic >= 140 OR blood_pressure_diastolic >= 90 THEN 1 ELSE 0 END) AS high_bp_count,
    ROUND((SUM(CASE WHEN blood_pressure_systolic >= 140 OR blood_pressure_diastolic >= 90 THEN 1 ELSE 0 END)::NUMERIC / COUNT(patient_id)) * 100, 2) AS high_bp_percentage
FROM patient
GROUP BY diabetes_risk
ORDER BY high_bp_percentage DESC;

-- QUERY 7: Risk Breakdown for Smokers and Drinkers
-- Purpose: Examines the percentage of high-risk cases among active smokers who also consume alcohol regularly to monitor combined lifestyle dangers.

SELECT 
    smoking_status,
    alcohol_consumption,
    COUNT(patient_id) AS total_patients,
    SUM(CASE WHEN LOWER(diabetes_risk) = 'high' THEN 1 ELSE 0 END) AS high_risk_count,
    ROUND((SUM(CASE WHEN LOWER(diabetes_risk) = 'high' THEN 1 ELSE 0 END)::NUMERIC / COUNT(patient_id)) * 100, 2) AS high_risk_percentage
FROM patient
WHERE LOWER(smoking_status) NOT IN ('never', 'unknown') 
  AND LOWER(alcohol_consumption) NOT IN ('never', 'unrecorded')
GROUP BY smoking_status, alcohol_consumption
ORDER BY high_risk_percentage DESC;


-- QUERY 8: Sudden Blood Sugar Spikes
-- Purpose: Finds patients with a sudden, high daily blood sugar spike but a normal 3-month average, highlighting rapid health changes.

SELECT 
    patient_id,
    city,
    fasting_blood_sugar AS daily_blood_sugar,
    avg_blood_sugar AS three_month_average,
    physical_activity_level,
    diet_type
FROM patient
WHERE fasting_blood_sugar > 160 
  AND avg_blood_sugar < 6.0
ORDER BY fasting_blood_sugar DESC;

-- QUERY 9: Stress Levels by Sleep Hours
-- Purpose: Evaluates how the number of nightly sleep hours directly affects a patient's average stress scores across the population.

SELECT 
    hours_sleep_per_night,
    COUNT(patient_id) AS patient_count,
    ROUND(AVG(stress_level)::NUMERIC, 2) AS average_stress_score,
    MIN(stress_level) AS lowest_stress_score,
    MAX(stress_level) AS highest_stress_score
FROM patient
GROUP BY hours_sleep_per_night
ORDER BY hours_sleep_per_night ASC;

-- QUERY 10: Health Risks by Family History and Activity Level
-- Purpose: Shows average 3-month blood sugar lines when combining a patient's family history against their daily exercise habits.

SELECT 
    family_history_diabetes,
    physical_activity_level,
    COUNT(patient_id) AS total_patients,
    ROUND(AVG(avg_blood_sugar)::NUMERIC, 2) AS average_three_month_sugar
FROM patient
GROUP BY family_history_diabetes, physical_activity_level
ORDER BY family_history_diabetes DESC, average_three_month_sugar DESC;


-- QUERY 11: Top 5 Overweight Cities
-- Purpose: Ranks cities based on the average waist sizes of their high-risk patients to find the top 5 obesity hotspots.

WITH patient AS (
    SELECT 
        city,
        COUNT(patient_id) AS high_risk_count,
        ROUND(AVG(waist_circumference_cm)::NUMERIC, 2) AS avg_waist_cm,
        -- FIXED: Passed the aggregate AVG function inside the Window Order clause
        ROW_NUMBER() OVER (ORDER BY AVG(waist_circumference_cm) DESC) as obesity_rank
    FROM patient
    WHERE LOWER(diabetes_risk) = 'high'
    GROUP BY city
)
SELECT city, high_risk_count, avg_waist_cm, obesity_rank
FROM patient
WHERE obesity_rank <= 5;

-- QUERY 12: High-Priority Senior Patient
-- Purpose: Ranks and lists senior patients (Age > 60) based on their blood sugar and weight to find the top 10 most critical cases needing home care.

WITH senior_patient AS (
    SELECT 
        patient_id,
        age,
        city,
        avg_blood_sugar,
        bmi,
        DENSE_RANK() OVER(ORDER BY avg_blood_sugar DESC, bmi DESC) AS clinical_priority_rank
    FROM patient
    WHERE age > 60
)
SELECT patient_id, age, city, avg_blood_sugar, bmi, clinical_priority_rank
FROM senior_patient
WHERE clinical_priority_rank <= 10;










