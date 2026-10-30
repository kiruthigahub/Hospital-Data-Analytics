
CREATE DATABASE IF NOT EXISTS abc_hospital;
USE abc_hospital;

-- 1. Departments
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(80) NOT NULL UNIQUE,
    floor_no INT,
    annual_budget DECIMAL(12,2) NOT NULL DEFAULT 0
);

-- 2. Doctors
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    department_id INT,
    salary DECIMAL(10,2) NOT NULL,
    hire_date DATE,
    active_status ENUM('Active','Inactive') DEFAULT 'Active',
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

-- 3. Patients
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender ENUM('Female','Male','Other'),
    city VARCHAR(60),
    phone VARCHAR(20),
    registration_date DATE,
    active_status ENUM('Active','Inactive') DEFAULT 'Active'
);

-- 4. Rooms
CREATE TABLE rooms (
    room_id INT PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type ENUM('General','Semi-Private','Private','ICU'),
    daily_charge DECIMAL(9,2) NOT NULL,
    room_status ENUM('Available','Occupied','Maintenance')
        DEFAULT 'Available'
);

-- 5. Appointments
CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    appointment_type ENUM('OPD','Follow-up','Emergency') DEFAULT 'OPD',
    appointment_status ENUM('Completed','Scheduled','Cancelled','No-show')
        DEFAULT 'Completed',
    consultation_fee DECIMAL(9,2) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    INDEX idx_appointments_date (appointment_date),
    INDEX idx_appointments_doctor_date (doctor_id, appointment_date)
);

-- 6. Admissions
CREATE TABLE admissions (
    admission_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    room_id INT,
    admission_date DATE NOT NULL,
    discharge_date DATE,
    admission_reason VARCHAR(150),
    treatment_cost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    INDEX idx_admissions_patient (patient_id)
);

-- 7. Diagnoses
CREATE TABLE diagnoses (
    diagnosis_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT,
    admission_id INT,
    diagnosis_date DATE NOT NULL,
    diagnosis_name VARCHAR(120) NOT NULL,
    severity ENUM('Low','Medium','High') DEFAULT 'Medium',
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id),
    FOREIGN KEY (admission_id) REFERENCES admissions(admission_id)
);

-- 8. Medicines
CREATE TABLE medicines (
    medicine_id INT PRIMARY KEY,
    medicine_name VARCHAR(100) NOT NULL,
    category VARCHAR(60),
    unit_price DECIMAL(8,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0
);

-- 9. Prescriptions
CREATE TABLE prescriptions (
    prescription_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT,
    medicine_id INT NOT NULL,
    prescription_date DATE NOT NULL,
    quantity INT NOT NULL,
    days_supply INT NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id),
    FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id)
);

-- 10. Lab Tests
CREATE TABLE lab_tests (
    lab_test_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT,
    test_name VARCHAR(100) NOT NULL,
    test_date DATE NOT NULL,
    test_cost DECIMAL(9,2) NOT NULL,
    test_status ENUM('Ordered','Completed','Cancelled') DEFAULT 'Completed',
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- 11. Insurance
CREATE TABLE insurance (
    insurance_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    provider_name VARCHAR(100) NOT NULL,
    policy_number VARCHAR(40) NOT NULL UNIQUE,
    coverage_amount DECIMAL(12,2) NOT NULL,
    policy_start DATE,
    policy_end DATE,
    policy_status ENUM('Active','Expired','Pending') DEFAULT 'Active',
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- 12. Payments
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    appointment_id INT,
    admission_id INT,
    bill_date DATE NOT NULL,
    bill_amount DECIMAL(10,2) NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL DEFAULT 0,
    payment_status ENUM('Paid','Partial','Unpaid') NOT NULL,
    payment_method ENUM('Cash','Card','UPI','Insurance','Bank Transfer'),
    CHECK (bill_amount >= 0),
    CHECK (amount_paid >= 0),
    CHECK (amount_paid <= bill_amount),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id),
    FOREIGN KEY (admission_id) REFERENCES admissions(admission_id),
    INDEX idx_payments_date_status (bill_date, payment_status)
);

-- 13. Employees
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    job_title VARCHAR(80),
    department_id INT,
    manager_id INT,
    salary DECIMAL(10,2) NOT NULL,
    hire_date DATE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);


USE abc_hospital;

INSERT INTO departments VALUES
(1,'Cardiology',2,25000000),
(2,'Neurology',3,22000000),
(3,'Orthopedics',4,20000000),
(4,'Pediatrics',2,15000000),
(5,'Oncology',5,30000000),
(6,'General Medicine',1,18000000),
(7,'Dermatology',3,10000000),
(8,'Dental',1,8000000),
(9,'Radiology',0,12000000),
(10,'Emergency',0,25000000);

INSERT INTO doctors VALUES
(1,'Arun Iyer',1,105000,'2020-02-17','Active'),
(2,'Priya Rao',1,120000,'2021-04-05','Active'),
(3,'Karthik Mohan',2,165000,'2019-05-22','Active'),
(4,'Divya Reddy',3,90000,'2022-07-08','Active'),
(5,'Rahul Das',4,120000,'2020-08-24','Active'),
(6,'Meena Singh',5,180000,'2018-10-10','Active'),
(7,'Vijay Sharma',6,120000,'2021-11-26','Active'),
(8,'Sneha Patel',7,135000,'2022-01-12','Active'),
(9,'Ajay Nair',8,165000,'2020-02-28','Active'),
(10,'Kavya Kumar',9,90000,'2023-04-16','Active');

INSERT INTO patients VALUES
(1,'Sneha Das','1995-06-23','Female','Puducherry','9000791357','2024-01-12','Active'),
(2,'Manoj Kumar','1988-12-13','Male','Chennai','9001582714','2024-01-23','Active'),
(3,'Priya Das','1992-06-04','Female','Bengaluru','9002374071','2024-02-03','Active'),
(4,'Ajay Kumar','1985-11-24','Male','Coimbatore','9003165428','2024-02-14','Active'),
(5,'Lakshmi Das','1977-05-16','Female','Madurai','9003956785','2024-02-25','Active'),
(6,'Karthik Kumar','1998-11-05','Male','Salem','9004748142','2024-03-08','Active'),
(7,'Kavya Das','2000-04-26','Female','Villupuram','9005539499','2024-03-19','Active'),
(8,'Hari Kumar','1975-10-16','Male','Cuddalore','9006330856','2024-03-30','Active'),
(9,'Divya Das','1990-04-07','Female','Chennai','9007122213','2024-04-10','Active'),
(10,'Ravi Kumar','1982-09-27','Male','Puducherry','9007913570','2024-04-21','Active');

INSERT INTO rooms VALUES
(1,'G101','General',1000,'Available'),
(2,'G102','General',1000,'Occupied'),
(3,'G103','General',1200,'Available'),
(4,'S201','Semi-Private',2000,'Occupied'),
(5,'S202','Semi-Private',2200,'Available'),
(6,'P301','Private',3500,'Available'),
(7,'P302','Private',4000,'Occupied'),
(8,'I401','ICU',7000,'Occupied'),
(9,'I402','ICU',7500,'Available'),
(10,'G104','General',1100,'Maintenance');

INSERT INTO appointments VALUES
(1,1,1,'2024-05-01 09:00:00','OPD','Completed',500),
(2,2,2,'2024-05-02 10:00:00','OPD','Completed',600),
(3,3,3,'2024-05-03 11:00:00','Follow-up','Completed',400),
(4,4,4,'2024-05-04 12:00:00','OPD','Scheduled',500),
(5,5,5,'2024-05-05 09:30:00','Emergency','Completed',800),
(6,6,6,'2024-05-06 10:30:00','OPD','Cancelled',600),
(7,7,7,'2024-05-07 11:30:00','Follow-up','Completed',350),
(8,8,8,'2024-05-08 12:30:00','OPD','No-show',500),
(9,9,9,'2024-05-09 14:00:00','OPD','Completed',450),
(10,10,10,'2024-05-10 15:00:00','Emergency','Completed',900);

INSERT INTO admissions VALUES
(1,1,1,2,'2024-05-01','2024-05-03','Chest pain',8000),
(2,2,2,4,'2024-05-02','2024-05-05','Migraine',6500),
(3,3,3,3,'2024-05-03','2024-05-06','Knee injury',7000),
(4,4,4,5,'2024-05-04','2024-05-07','Fever',4500),
(5,5,5,6,'2024-05-05','2024-05-09','Cancer treatment',15000),
(6,6,6,7,'2024-05-06','2024-05-08','Infection',5500),
(7,7,7,1,'2024-05-07','2024-05-09','Diabetes',4000),
(8,8,8,8,'2024-05-08',NULL,'Breathing difficulty',12000),
(9,9,9,9,'2024-05-09','2024-05-10','Dental surgery',3000),
(10,10,10,10,'2024-05-10','2024-05-12','Accident injury',9000);

INSERT INTO diagnoses VALUES
(1,1,1,1,1,'2024-05-01','Hypertension','Medium'),
(2,2,2,2,2,'2024-05-02','Migraine','Low'),
(3,3,3,3,3,'2024-05-03','Knee injury','High'),
(4,4,4,4,4,'2024-05-04','Viral fever','Low'),
(5,5,5,5,5,'2024-05-05','Tumor','High'),
(6,6,6,6,6,'2024-05-06','Infection','Medium'),
(7,7,7,7,7,'2024-05-07','Diabetes','Medium'),
(8,8,8,8,8,'2024-05-08','Asthma','High'),
(9,9,9,9,9,'2024-05-09','Tooth decay','Low'),
(10,10,10,10,10,'2024-05-10','Fracture','High');

INSERT INTO medicines VALUES
(1,'Paracetamol','Pain Relief',25,100),
(2,'Amoxicillin','Antibiotic',80,60),
(3,'Cetirizine','Allergy',15,120),
(4,'Metformin','Diabetes',40,90),
(5,'Amlodipine','Blood Pressure',35,75),
(6,'Omeprazole','Digestive',50,80),
(7,'Ibuprofen','Pain Relief',30,100),
(8,'Azithromycin','Antibiotic',95,50),
(9,'Vitamin C','Supplement',20,150),
(10,'Insulin','Diabetes',250,40);

INSERT INTO prescriptions VALUES
(1,1,1,1,1,'2024-05-01',10,5),
(2,2,2,2,2,'2024-05-02',6,3),
(3,3,3,3,7,'2024-05-03',10,5),
(4,4,4,4,3,'2024-05-04',5,5),
(5,5,5,5,6,'2024-05-05',10,10),
(6,6,6,6,8,'2024-05-06',3,3),
(7,7,7,7,4,'2024-05-07',30,15),
(8,8,8,8,5,'2024-05-08',10,10),
(9,9,9,9,9,'2024-05-09',15,15),
(10,10,10,10,10,'2024-05-10',2,7);

INSERT INTO lab_tests VALUES
(1,1,1,1,'Blood Test','2024-05-01',500,'Completed'),
(2,2,2,2,'MRI Scan','2024-05-02',3000,'Completed'),
(3,3,3,3,'X-Ray','2024-05-03',800,'Completed'),
(4,4,4,4,'Urine Test','2024-05-04',300,'Ordered'),
(5,5,5,5,'Biopsy','2024-05-05',2500,'Completed'),
(6,6,6,6,'Blood Culture','2024-05-06',1200,'Completed'),
(7,7,7,7,'Glucose Test','2024-05-07',400,'Completed'),
(8,8,8,8,'ECG','2024-05-08',700,'Ordered'),
(9,9,9,9,'Dental X-Ray','2024-05-09',600,'Completed'),
(10,10,10,10,'CT Scan','2024-05-10',3500,'Completed');

INSERT INTO insurance VALUES
(1,1,'Star Health','POL001',200000,'2024-01-01','2025-01-01','Active'),
(2,2,'HDFC Ergo','POL002',150000,'2024-02-01','2025-02-01','Active'),
(3,3,'ICICI Lombard','POL003',250000,'2024-03-01','2025-03-01','Active'),
(4,4,'Care Health','POL004',100000,'2024-01-15','2025-01-15','Expired'),
(5,5,'Niva Bupa','POL005',300000,'2024-04-01','2025-04-01','Active'),
(6,6,'Star Health','POL006',175000,'2024-05-01','2025-05-01','Active'),
(7,7,'HDFC Ergo','POL007',125000,'2024-06-01','2025-06-01','Pending'),
(8,8,'ICICI Lombard','POL008',225000,'2024-07-01','2025-07-01','Active'),
(9,9,'Care Health','POL009',90000,'2024-08-01','2025-08-01','Active'),
(10,10,'Niva Bupa','POL010',275000,'2024-09-01','2025-09-01','Active');

INSERT INTO payments VALUES
(1,1,1,1,'2024-05-01',8500,8500,'Paid','UPI'),
(2,2,2,2,'2024-05-02',7100,5000,'Partial','Card'),
(3,3,3,3,'2024-05-03',7400,7400,'Paid','Cash'),
(4,4,4,4,'2024-05-04',5000,0,'Unpaid',NULL),
(5,5,5,5,'2024-05-05',15800,15800,'Paid','Insurance'),
(6,6,6,6,'2024-05-06',6100,3000,'Partial','Bank Transfer'),
(7,7,7,7,'2024-05-07',4350,4350,'Paid','UPI'),
(8,8,8,8,'2024-05-08',12500,0,'Unpaid',NULL),
(9,9,9,9,'2024-05-09',3450,3450,'Paid','Card'),
(10,10,10,10,'2024-05-10',9900,9900,'Paid','Cash');

INSERT INTO employees VALUES
(1,'Ramesh Kumar','Hospital Manager',1,NULL,100000,'2018-01-01'),
(2,'Anitha Ravi','Nurse',2,1,45000,'2019-02-01'),
(3,'Suresh Babu','Lab Technician',9,1,40000,'2020-03-01'),
(4,'Meena Devi','Receptionist',10,1,30000,'2021-04-01'),
(5,'Kumar Raj','Pharmacist',6,1,35000,'2022-05-01'),
(6,'Priya Mohan','Accountant',1,1,42000,'2020-06-01'),
(7,'Arun Prakash','Nurse',3,1,44000,'2021-07-01'),
(8,'Divya Suresh','Radiology Technician',9,1,41000,'2022-08-01'),
(9,'Vijay Anand','Security Officer',10,1,28000,'2023-09-01'),
(10,'Lakshmi Devi','HR Executive',4,1,38000,'2023-10-01');


USE abc_hospital;

SELECT * FROM departments;

SELECT * FROM doctors;

SELECT * FROM patients;

SELECT * FROM rooms;

SELECT * FROM appointments;

SELECT * FROM admissions;

SELECT * FROM diagnoses;

SELECT * FROM medicines;

SELECT * FROM prescriptions;

SELECT * FROM lab_tests;

SELECT * FROM insurance;

SELECT * FROM payments;

SELECT * FROM employees;

# Question 1: Find the highest-paid doctor.
select * from doctors 
order by salary desc
limit 1;

# Question 2: Find the second-highest salary
SELECT *
FROM doctors
ORDER BY salary DESC
LIMIT 1 OFFSET 1;

# Question 3: Find the third-highest salary.
SELECT DISTINCT salary
FROM doctors
ORDER BY salary DESC
LIMIT 1 OFFSET 2;

# Question 4: Find the top 3 doctors by salary in every department.
select * from (
select department_id ,doctor_name,salary,
dense_rank() over (partition by department_id order by salary desc) as ranked
from doctors) as t
where ranked <= 3;

# Question 5: Find doctors earning above the hospital's average salary.
select * from doctors where salary > (select avg(salary) from doctors);

# Question 6: Find doctors earning above their department's average salary.
SELECT *
FROM doctors 
WHERE salary > (
    SELECT AVG(e.salary)
    FROM doctors AS e
    WHERE e.department_id = department_id
);

# Question 7: Find the average salary for each department.
select department_id,avg(salary) from doctors 
group  by department_id ;

# Question 8: Find the department with the highest average salary
select department_id,avg(salary) from doctors 
group  by department_id 
order by avg(salary) desc
limit 1;

# Question 9: Find doctors who have never treated a patient.
SELECT d.*
FROM doctors AS d
LEFT JOIN appointments AS a
    ON d.doctor_id = a.doctor_id
WHERE a.doctor_id IS NULL;

# Question 10: Find the doctor who treated the maximum number of patients.
SELECT d.doctor_id, d.doctor_name,
       COUNT(DISTINCT a.patient_id) AS total_patients
FROM doctors AS d
JOIN appointments AS a
    ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.doctor_name
ORDER BY total_patients DESC
LIMIT 1;

# Question 11: Find patients who have never booked an appointment.
select p.patient_name from appointments as a left join
patients as p 
on p.patient_id = a.patient_id 
where a.patient_id is null;

# Question 12: Find patients who have more than 3 appointments.
select p.patient_id,p.patient_name ,count(p.patient_id) from patients as p join
appointments as a 
on p.patient_id = a.patient_id 
group by p.patient_id 
having count(p.patient_id)  > 3;

# Question 13: Find patients who have been admitted more than once.
SELECT p.patient_id, p.patient_name,
       COUNT(a.admission_id) AS total_admissions
FROM patients AS p
JOIN admissions AS a
    ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.patient_name
HAVING COUNT(a.admission_id) > 1;

# Question 14: Find the oldest patient.
select * from patients where date_of_birth = (select min(date_of_birth) from patients);

# Question 15: Find patients from the same city.
SELECT city, COUNT(*) AS total_patients
FROM patients
GROUP BY city
HAVING COUNT(*) > 1;

# Question 16: Find patients who had both appointments and admissions.
SELECT DISTINCT p.patient_id, p.patient_name
FROM patients AS p
JOIN appointments AS a
    ON p.patient_id = a.patient_id
JOIN admissions AS ad
    ON p.patient_id = ad.patient_id;
    
# Question 17: Find patients who had appointments but no admissions.
SELECT DISTINCT p.patient_id, p.patient_name
FROM patients AS p
JOIN appointments AS a
    ON p.patient_id = a.patient_id
left JOIN admissions AS ad
    ON p.patient_id = ad.patient_id
    where ad.admission_id is null;
    
# Question 18: Find the top 5 patients by medical spending.
SELECT p.patient_id, p.patient_name,
       SUM(pay.bill_amount) AS total_spending
FROM patients AS p
JOIN payments AS pay
    ON p.patient_id = pay.patient_id
GROUP BY p.patient_id, p.patient_name
ORDER BY total_spending DESC
LIMIT 5;

# Question 19: Which department has the highest number of doctors?
select d.department_id,count(doc.doctor_id) as counts from departments as d
join doctors as doc 
on d.department_id = doc.department_id
group by d.department_id
order by counts desc
limit 1;

# Question 20: Which department has the highest number of patients?
SELECT d.department_id, d.department_name,
       COUNT(DISTINCT a.patient_id) AS total_patients
FROM departments AS d
JOIN doctors AS doc
    ON d.department_id = doc.department_id
JOIN appointments AS a
    ON doc.doctor_id = a.doctor_id
GROUP BY d.department_id, d.department_name
ORDER BY total_patients DESC
LIMIT 1;

# Question 21: Find departments whose average salary is greater than the hospital's average salary.
SELECT d.department_id, d.department_name, AVG(doc.salary) AS avg_salary
FROM departments AS d
JOIN doctors AS doc
    ON d.department_id = doc.department_id
GROUP BY d.department_id, d.department_name
HAVING AVG(doc.salary) > (
    SELECT AVG(salary)
    FROM doctors
);

# Question 22: Which department generates the highest revenue?
SELECT d.department_id, d.department_name,
       SUM(p.bill_amount) AS total_revenue
FROM departments AS d
JOIN doctors AS doc
    ON d.department_id = doc.department_id
JOIN appointments AS a
    ON doc.doctor_id = a.doctor_id
JOIN payments AS p
    ON a.appointment_id = p.appointment_id
GROUP BY d.department_id, d.department_name
ORDER BY total_revenue DESC
LIMIT 1;

# Question 23: Find departments that have no doctors.
select d.department_name from departments as d left join
doctors as doc 
on d.department_id = doc.department_id 
where doc.doctor_id is null;

# Question 24: Find departments that have no appointments.
SELECT d.department_id, d.department_name
FROM departments AS d
LEFT JOIN doctors AS doc
    ON d.department_id = doc.department_id
LEFT JOIN appointments AS a
    ON doc.doctor_id = a.doctor_id
WHERE a.appointment_id IS NULL;

# Question 25: Calculate the total hospital revenue.
SELECT SUM(bill_amount) AS total_revenue
FROM payments;

# Question 26: Calculate monthly hospital revenue.
select year(bill_date),
month(bill_date),sum(bill_amount) as monthly_revenue 
from payments 
group by year(bill_date),
month(bill_date);

# Question 27: Find the month with the highest revenue.
SELECT
    YEAR(bill_date) AS year,
    MONTH(bill_date) AS month,
    SUM(bill_amount) AS monthly_revenue
FROM payments
GROUP BY YEAR(bill_date), MONTH(bill_date)
ORDER BY monthly_revenue DESC
LIMIT 1;

# Question 28: Find the average bill amount.
SELECT AVG(bill_amount) AS average_bill
FROM payments;

# Question 29: Find unpaid bills.
select * from payments where amount_paid  = 0;

# Question 30: Find patients with outstanding balances.
SELECT p.patient_id, p.patient_name,
       SUM(pay.bill_amount - pay.amount_paid) AS outstanding_balance
FROM patients AS p
JOIN payments AS pay
    ON p.patient_id = pay.patient_id
GROUP BY p.patient_id, p.patient_name
HAVING SUM(pay.bill_amount - pay.amount_paid) > 0;

# Question 31: Find the highest-paid doctor in each department.
SELECT department_id, doctor_name, salary
FROM (
    SELECT doc.department_id, doc.doctor_name, doc.salary,
           DENSE_RANK() OVER (
               PARTITION BY doc.department_id
               ORDER BY doc.salary DESC
           ) AS rnk
    FROM doctors AS doc
) AS t
WHERE rnk = 1;

# Question 32: Find duplicate patients.
SELECT patient_name, phone, COUNT(*) AS total
FROM patients
GROUP BY patient_name, phone
HAVING COUNT(*) > 1;

# Question 33: Find the second-highest salary.
SELECT DISTINCT salary
FROM doctors
ORDER BY salary DESC
LIMIT 1 OFFSET 1;

# Question 34: Find all active patients.
SELECT *
FROM patients
WHERE active_status = 'Active';

# Question 35: Find doctors earning above ₹1 lakh.
SELECT *
FROM doctors
WHERE salary > 100000;

# Question 36: Find patients from Chennai.
SELECT *
FROM patients
WHERE city = 'Chennai';

# Question 37: Find unique patient cities.
SELECT DISTINCT city
FROM patients;

# Question 38: Find the five highest-paid doctors.
SELECT *
FROM doctors
ORDER BY salary DESC
LIMIT 5;

# Question 39: Find the average salary for each department.
SELECT department_id, AVG(salary) AS avg_salary
FROM doctors
GROUP BY department_id;

# Question 40: Find departments having more than 5 doctors.
SELECT department_id, COUNT(*) AS total_doctors
FROM doctors
GROUP BY department_id
HAVING COUNT(*) > 5;

# Question 41: Find doctors without appointments.
SELECT d.*
FROM doctors AS d
LEFT JOIN appointments AS a
    ON d.doctor_id = a.doctor_id
WHERE a.appointment_id IS NULL;

# Question 42: Find patients with more than 3 appointments.
SELECT p.patient_id, p.patient_name,
       COUNT(a.appointment_id) AS total_appointments
FROM patients AS p
JOIN appointments AS a
    ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.patient_name
HAVING COUNT(a.appointment_id) > 3;

# Question 43: Find doctors earning above their department's average salary.
SELECT *
FROM doctors AS d
WHERE salary > (
    SELECT AVG(e.salary)
    FROM doctors AS e
    WHERE e.department_id = d.department_id
);

# Question 44: Find the second-highest salary using DENSE_RANK()
SELECT DISTINCT salary
FROM (
    SELECT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM doctors
) AS t
WHERE rnk = 2;

# Question 45: Find duplicate patients by name and phone number.
SELECT patient_name, phone, COUNT(*) AS total
FROM patients
GROUP BY patient_name, phone
HAVING COUNT(*) > 1;

# Question 46: Calculate monthly running revenue
SELECT
    YEAR(bill_date) AS year,
    MONTH(bill_date) AS month,
    SUM(bill_amount) AS monthly_revenue,
    SUM(SUM(bill_amount)) OVER (
        PARTITION BY YEAR(bill_date)
        ORDER BY MONTH(bill_date)
    ) AS running_revenue
FROM payments
GROUP BY YEAR(bill_date), MONTH(bill_date)
ORDER BY year, month;

# Question 47: Find month-over-month revenue change using LAG().
WITH monthly_revenue AS (
    SELECT
        YEAR(bill_date) AS year,
        MONTH(bill_date) AS month,
        SUM(bill_amount) AS revenue
    FROM payments
    GROUP BY YEAR(bill_date), MONTH(bill_date)
)
SELECT *,
       revenue - LAG(revenue) OVER (
           ORDER BY year, month
       ) AS revenue_change
FROM monthly_revenue
ORDER BY year, month;

# Question 48: Find the doctor who generated the highest revenue from appointments
SELECT d.doctor_id, d.doctor_name,
       SUM(p.bill_amount) AS total_revenue
FROM doctors AS d
JOIN appointments AS a
    ON d.doctor_id = a.doctor_id
JOIN payments AS p
    ON a.appointment_id = p.appointment_id
GROUP BY d.doctor_id, d.doctor_name
ORDER BY total_revenue DESC
LIMIT 1;
