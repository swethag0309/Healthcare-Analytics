Create database health_care;
use health_care;

alter table appointments
add constraint fk_patientid_appointment
foreign key (patient_id)
references patients (patient_id); 

alter table appointments
add constraint fk_doctorid_appointment
foreign key (doctor_id)
references doctors (doctor_id);

alter table diagnoses
add constraint fk_patientid_diagnoses
foreign key (patient_id)
references patients (patient_id);

alter table diagnoses
add constraint fk_doctorid_diagnoses
foreign key (doctor_id)
references doctors (doctor_id);

alter table medications
add constraint fk_diagnoseid_medications
foreign key (diagnosis_id)
references diagnoses (diagnosis_id);

select * from health_care.appointments;
select * from health_care.diagnoses;
select * from health_care.doctors;
select * from health_care.medications;
select * from health_care.patients;


-- Task 1 ---------------- "Inner and equi join"

select p.name, d.name, d.specialization from health_care.appointments as a
inner join health_care.patients as p on a.patient_id = p.patient_id
inner join health_care.doctors as d on a.doctor_id = d.doctor_id
where a.status = "Completed";

-- Task 2 ----------------- "Left Join with Null Handling"

select p.name, p.contact_number, p.address from health_care.appointments as a
left join health_care.patients as p on a.patient_id = p.patient_id 
where a.patient_id is null;

-- Task 3 ------------------ "Right Join and aggregate functions"

select d.name, d.specialization, count(dg.diagnosis) as totalDiagnosis from health_care.doctors as d
right join health_care.diagnoses as dg
on d.doctor_id = dg.doctor_id
group by d.name, d.specialization;

-- Task 4 ------------------- "Full Join for overlapping data"

Select *  from health_care.appointments as a inner join health_care.diagnoses as dg
on a.doctor_id = dg.doctor_id
where a.appointment_date <> dg.diagnosis_date;

-- Task 5 ------------------- "WIndow FUnctions (Ranking and Aggregation)"

select doctor_id, doc_name, patient_id, patient_name, appointmentcount, 
rank() over(partition by doctor_id order by appointmentcount desc) as PatientRank  from 
(select d.doctor_id, d.name as doc_name, p.patient_id, p.name as patient_name, Count(a.appointment_id) as appointmentcount
from health_care.appointments as a inner join health_care.doctors as d on a.doctor_id = d.doctor_id
inner join health_care.patients as p on a.patient_id = p.patient_id
group by d.doctor_id, d.name, p.patient_id, p.name) as t
order by doctor_id, patient_id; 

-- Task 6 ------------------ "Conditional Expressions"

select age_group ,count(age) as count_AgeGroup from (select age, 
case
	when age >= 51 then "Senior Citizen"
    when age >= 31 then "Middle Aged"
    else "Adults"
end as age_group
from health_care.patients) t
group by age_group;

-- Task 7 ------------------- "Numeric and string functions"

select Upper(name), contact_number from health_care.patients
where contact_number like '%1234' ;

-- Task 8 ------------------ "Subqueries for Filtering"

select patient_name, diagnosis_num, prescription from 
(Select p.name as patient_name, m.medication_name as prescription, dg.diagnosis_id as Diagnosis_num  
from health_care.medications as m
inner join health_care.diagnoses as dg on m.diagnosis_id = dg.diagnosis_id
inner join health_care.patients as p on dg.patient_id = p.patient_id) t
where prescription = "Insulin";

-- Task 9 --------------------- "Date and Time Functions"

select diagnosis_id, avg(datediff(end_date, start_date)) as Avg_duration 
from health_care.medications
group by diagnosis_id;

-- Task 10 --------------------- "Complex Joins and Aggregation"

select d.name, d.specialization, count(distinct(p.Patient_id)) as num_patient
from health_care.doctors as d inner join health_care.diagnoses as dg
on d.doctor_id = dg.doctor_id 
inner join health_care.patients as p on dg.patient_id = p.patient_id 
group by d.name, d.specialization;
    


