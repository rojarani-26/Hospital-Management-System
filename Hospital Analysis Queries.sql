----- BASIC QUERIES ------

-- 1. Total revenue generated

SELECT SUM(amount) AS total_revenue
FROM Billing;

-- 2. Average treatment cost

SELECT CAST(ROUND(AVG(cost),2) AS DECIMAL(10,2)) AS average_treatment_cost
FROM Treatments;

-- 3. Patient Distribution by Gender

SELECT gender,COUNT(*) AS total_patients
FROM Patients
GROUP BY gender
ORDER BY total_patients DESC;

-- 4. Doctors by Specialization

SELECT specialization,COUNT(*) AS total_doctors
FROM Doctors
GROUP BY specialization
ORDER BY total_doctors DESC;

-- 5. Appointment Distribution by status

SELECT status,COUNT(*) AS total_appointments
FROM Appointments
GROUP BY status
ORDER BY total_appointments DESC;

----- INTERMEDIATE QUERIES -----

-- 6. Patient appointments with doctor details

SELECT p.first_name,p.last_name,a.appointment_date,a.status
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
WHERE a.status = 'Scheduled';

-- 7. Top 5 Doctors with Most Appointments

SELECT TOP 5 d.first_name, d.last_name,COUNT(a.appointment_id) AS total_appointments
FROM Doctors d
JOIN Appointments a
ON d.doctor_id = a.doctor_id
GROUP BY d.first_name, d.last_name
ORDER BY total_appointments DESC;

-- 8. Treatments received by patients

SELECT p.first_name, p.last_name, t.treatment_type, t.cost
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Treatments t ON a.appointment_id = t.appointment_id;

-- 9. Patient billing information

SELECT p.first_name,p.last_name,b.amount,b.payment_status
FROM Billing b
JOIN Patients p
ON b.patient_id = p.patient_id;

-- 10. Treatments performed by specialization

SELECT d.specialization,COUNT(t.treatment_id) AS total_treatments
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
JOIN Treatments t ON a.appointment_id = t.appointment_id
GROUP BY d.specialization
ORDER BY total_treatments DESC;

---- ADVANCED QUERIES ----

-- 11. Rank doctors by appointment volume

SELECT d.first_name,d.last_name,
COUNT(a.appointment_id) AS total_appointments,
RANK() OVER (ORDER BY COUNT(a.appointment_id) DESC) AS doctor_rank
FROM Doctors d
JOIN Appointments a
ON d.doctor_id = a.doctor_id
GROUP BY d.first_name,d.last_name;

-- 12. Top 5 Patients with total spending

SELECT TOP 5 p.first_name,p.last_name,
(
    SELECT SUM(b.amount)
    FROM Billing b
    WHERE b.patient_id = p.patient_id
) AS total_spent
FROM Patients p
ORDER BY total_spent DESC;

-- 13. Running total of hospital revenue

SELECT bill_date,SUM(amount) AS daily_revenue,
SUM(SUM(amount)) OVER (ORDER BY bill_date) AS running_total
FROM Billing
GROUP BY bill_date;


-- 14. Appointment Status Category

SELECT appointment_id,appointment_date,
CASE
    WHEN status = 'Completed' THEN 'Visit Finished'
    WHEN status = 'Scheduled' THEN 'Upcoming Appointment'
    WHEN status = 'Cancelled' THEN 'Missed Appointment'
    ELSE 'Other'
END AS appointment_category
FROM Appointments;

-- 15. Treatments with Cost Higher Than Average

SELECT treatment_type,COUNT(*) AS high_cost_cases
FROM Treatments
WHERE cost > (
    SELECT AVG(cost)
    FROM Treatments
)
GROUP BY treatment_type
ORDER BY high_cost_cases DESC;


