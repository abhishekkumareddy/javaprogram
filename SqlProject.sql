create database Employee;

use Employee;

CREATE TABLE Employees (
employee_id INT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
department VARCHAR(100),
designation VARCHAR(100),
salary DECIMAL(10,2),
joining_date DATE
);



CREATE TABLE Departments (
department_id INT PRIMARY KEY,
department_name VARCHAR(100),
location VARCHAR(100)
);




CREATE TABLE Attendance (
attendance_id INT PRIMARY KEY,
employee_id INT,
attendance_date DATE,
status VARCHAR(20),
FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);


CREATE TABLE Leaves (
leave_id INT PRIMARY KEY,
employee_id INT,
leave_type VARCHAR(50),
start_date DATE,
end_date DATE,
status VARCHAR(20),
FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);


CREATE TABLE Payroll (
payroll_id INT PRIMARY KEY,
employee_id INT,
basic_salary DECIMAL(10,2),
bonus DECIMAL(10,2),
deductions DECIMAL(10,2),
net_salary DECIMAL(10,2),
payment_date DATE,
FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);


INSERT INTO Employees VALUES
(1, 'Abhi', 'IT', 'Developer', 60000, '2023-05-10'),
(2, 'Ravi', 'HR', 'Manager', 80000, '2022-03-15'),
(3, 'Sita', 'IT', 'Tester', 45000, '2024-01-01'),
(4, 'John', 'Finance', 'Manager', 90000, '2021-07-20'),
(5, 'Anu', 'IT', 'Developer', 70000, '2023-08-25'),
(6, 'Kiran', 'HR', 'Executive', 40000, '2023-06-12'),
(7, 'Meena', 'Finance', 'Analyst', 55000, '2022-11-30'),
(8, 'Raj', 'IT', 'Manager', 95000, '2021-02-18'),
(9, 'Priya', 'HR', 'Recruiter', 48000, '2024-02-10'),
(10, 'Arjun', 'Finance', 'Clerk', 35000, '2023-09-05');


INSERT INTO Departments VALUES
(1, 'IT', 'Hyderabad'),
(2, 'HR', 'Mumbai'),
(3, 'Finance', 'Delhi'),
(4, 'Sales', 'Chennai'),
(5, 'Marketing', 'Bangalore'),
(6, 'Support', 'Pune'),
(7, 'Admin', 'Kolkata'),
(8, 'Legal', 'Ahmedabad'),
(9, 'R&D', 'Noida'),
(10, 'Operations', 'Jaipur');



INSERT INTO Attendance VALUES
(1,1,'2025-03-01','Present'),
(2,2,'2025-03-01','Absent'),
(3,3,'2025-03-01','Present'),
(4,4,'2025-03-01','Present'),
(5,5,'2025-03-01','Absent'),
(6,6,'2025-03-02','Present'),
(7,7,'2025-03-02','Present'),
(8,8,'2025-03-02','Absent'),
(9,9,'2025-03-02','Present'),
(10,10,'2025-03-02','Present');



INSERT INTO Leaves VALUES
(1,2,'Sick','2025-03-05','2025-03-06','Approved'),
(2,3,'Casual','2025-03-07','2025-03-08','Pending'),
(3,5,'Sick','2025-03-10','2025-03-11','Approved'),
(4,1,'Casual','2025-03-12','2025-03-12','Rejected'),
(5,4,'Emergency','2025-03-15','2025-03-16','Approved'),
(6,6,'Sick','2025-03-18','2025-03-19','Pending'),
(7,7,'Casual','2025-03-20','2025-03-21','Approved'),
(8,8,'Emergency','2025-03-22','2025-03-23','Approved'),
(9,9,'Sick','2025-03-24','2025-03-25','Pending'),
(10,10,'Casual','2025-03-26','2025-03-27','Approved');



INSERT INTO Payroll VALUES
(1,1,50000,5000,2000,53000,'2025-03-31'),
(2,2,70000,10000,5000,75000,'2025-03-31'),
(3,3,40000,3000,1000,42000,'2025-03-31'),
(4,4,80000,12000,6000,86000,'2025-03-31'),
(5,5,60000,7000,3000,64000,'2025-03-31'),
(6,6,35000,2000,1000,36000,'2025-03-31'),
(7,7,50000,4000,2000,52000,'2025-03-31'),
(8,8,85000,15000,7000,93000,'2025-03-31'),
(9,9,45000,3000,1500,46500,'2025-03-31'),
(10,10,30000,1000,500,30500,'2025-03-31');





-- Salary > 50000
SELECT * FROM Employees WHERE salary > 50000;

-- IT department
SELECT * FROM Employees WHERE department = 'IT';

-- Managers
SELECT * FROM Employees WHERE designation = 'Manager';

-- Joined after 2023
SELECT * FROM Employees WHERE joining_date > '2023-01-01';




-- Employee + Payroll
SELECT e.name, p.*
FROM Employees e
JOIN Payroll p ON e.employee_id = p.employee_id;

-- Attendance with name
SELECT e.name, a.attendance_date, a.status
FROM Employees e
JOIN Attendance a ON e.employee_id = a.employee_id;

-- Leaves with employee info
SELECT e.name, l.*
FROM Employees e
JOIN Leaves l ON e.employee_id = l.employee_id;

-- Employee + Department
SELECT e.name, d.department_name
FROM Employees e
JOIN Departments d ON e.department = d.department_name;

-- Salary details
SELECT name, salary FROM Employees;


SELECT COUNT(*) FROM Employees;

SELECT AVG(salary) FROM Employees;

SELECT SUM(net_salary) FROM Payroll;

SELECT COUNT(*) FROM Leaves;

SELECT MAX(salary) FROM Employees;


-- No leaves
SELECT * FROM Employees 
WHERE employee_id NOT IN (SELECT employee_id FROM Leaves);

-- No attendance
SELECT * FROM Employees
WHERE employee_id NOT IN (SELECT employee_id FROM Attendance);

-- Above average salary
SELECT * FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

-- Above department avg
SELECT * FROM Employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
    WHERE department = e.department
);

-- Payroll above avg
SELECT * FROM Payroll
WHERE net_salary > (SELECT AVG(net_salary) FROM Payroll);




-- Update salary
UPDATE Employees SET salary = 75000 WHERE employee_id = 1;

-- Change designation
UPDATE Employees SET designation = 'Senior Developer' WHERE employee_id = 1;

-- Update leave status
UPDATE Leaves SET status = 'Approved' WHERE leave_id = 1;

-- Delete inactive employees
DELETE FROM Employees WHERE employee_id NOT IN (SELECT employee_id FROM Attendance);

-- Delete payroll of resigned employees
DELETE FROM Payroll 
WHERE employee_id NOT IN (SELECT employee_id FROM Employees);






CREATE VIEW emp_payroll AS
SELECT e.name, p.net_salary
FROM Employees e JOIN Payroll p ON e.employee_id = p.employee_id;


select * from emp_payroll;

CREATE VIEW attendance_view AS
SELECT e.name, a.status
FROM Employees e JOIN Attendance a ON e.employee_id = a.employee_id;

CREATE VIEW emp_dept AS
SELECT e.name, d.department_name
FROM Employees e JOIN Departments d ON e.department = d.department_name;

CREATE VIEW total_salary AS
SELECT employee_id, SUM(net_salary) AS total
FROM Payroll GROUP BY employee_id;

CREATE VIEW top_paid AS
SELECT * FROM Employees ORDER BY salary DESC;




-- 1. Insert Employee
DELIMITER //
CREATE PROCEDURE addEmployee(
IN n VARCHAR(100),
IN d VARCHAR(100),
IN des VARCHAR(100),
IN sal DECIMAL(10,2),
IN jd DATE
)
BEGIN
INSERT INTO Employees(name, department, designation, salary, joining_date)
VALUES(n,d,des,sal,jd);
END //
DELIMITER ;

-- 2. Update Salary
DELIMITER //
CREATE PROCEDURE updateSalary(IN id INT, IN sal DECIMAL(10,2))
BEGIN
UPDATE Employees SET salary = sal WHERE employee_id = id;
END //
DELIMITER ;

-- 3. Payroll of Employee
DELIMITER //
CREATE PROCEDURE getPayroll(IN id INT)
BEGIN
SELECT * FROM Payroll WHERE employee_id = id;
END //
DELIMITER ;

call getPayroll(1);
--- 4. Total Payroll Expense
DELIMITER //
CREATE PROCEDURE totalPayroll()
BEGIN
SELECT SUM(net_salary) FROM Payroll;
END //
DELIMITER ;

-- 5. Employees by Department
DELIMITER //
CREATE PROCEDURE empByDept(IN dept VARCHAR(100))
BEGIN
SELECT * FROM Employees WHERE department = dept;
END //
DELIMITER ;



-- Top 5 salaries
SELECT * FROM Employees ORDER BY salary DESC LIMIT 5;

-- Most regular employees
SELECT employee_id, COUNT(*) AS present_days
FROM Attendance
WHERE status = 'Present'
GROUP BY employee_id
ORDER BY present_days DESC;

-- Monthly payroll
SELECT MONTH(payment_date), SUM(net_salary)
FROM Payroll GROUP BY MONTH(payment_date);

-- Department highest expense
SELECT department, SUM(salary) AS total
FROM Employees GROUP BY department
ORDER BY total DESC;

-- Salary distribution
SELECT department, AVG(salary)
FROM Employees GROUP BY department;

-- Highest bonuses
SELECT * FROM Payroll ORDER BY bonus DESC;