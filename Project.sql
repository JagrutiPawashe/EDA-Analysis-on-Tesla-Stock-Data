Create database hospital;

use hospital;

#1.write a SQL query to identify the physicians who are the department heads.
# Return Department name as “Department” and Physician name as “Physician”.

SELECT 
d.name AS "Department",
p.name AS "Physician"
FROM department d
INNER JOIN physician p
ON d.head=p.employeeid;


#2. write a SQL query to locate the floor and block where room number 212 is located. 
#Return block floor as "Floor" and block code as "Block".
SELECT blockfloor AS "Floor",
       blockcode AS "Block"
FROM room
WHERE roomnumber=212;

#3. write a SQL query to count the number of unavailable rooms. Return count as "Number of unavailable rooms".
SELECT count(*) AS "Number of unavailable rooms"
FROM room
WHERE unavailable='t';

#4. write a SQL query to identify the physician and the department with which he or she is affiliated. 
#Return Physician name as "Physician", and department name as "Department". 

SELECT p.name AS "Physician",
       d.name AS "Department"
FROM physician p,
     department d,
     affiliated_with a
WHERE p.employeeid=a.physician
  AND a.department=d.departmentid;
  
#5. write a SQL query to find those physicians who have received special training.
# Return Physician name as “Physician”, treatment procedure name as "Treatment".
SELECT p.name AS "Physician",
c.name AS "Treatment"
FROM physician p,
     procedures c,
trained_in t
WHERE t.physician=p.employeeid
  AND t.treatment=c.code;
  
  
#6. write a SQL query to find those physicians who are yet to be affiliated.
# Return Physician name as "Physician", Position, and department as "Department". 
SELECT p.name AS "Physician",
       p.position,
       d.name AS "Department"
FROM physician p
INNER JOIN affiliated_with a ON a.physician=p.employeeid
INNER JOIN department d ON a.department=d.departmentid
WHERE primaryaffiliation='f';

#7. write a SQL query to identify physicians who are not specialists. Return Physician name as "Physician", position as "Designation".

SELECT p.name AS "Physician",
       p.position "Designation"
FROM physician p
LEFT JOIN trained_in t ON p.employeeid=t.physician
WHERE t.treatment IS NULL
ORDER BY employeeid;

#8. write a SQL query to identify the patients and the number of physicians with whom they have scheduled appointments. 
#Return Patient name as "Patient", number of Physicians as "Appointment for No. of Physicians".
SELECT p.name "Patient",
       count(t.patient) "Appointment for No. of Physicians"
FROM appointment t
JOIN patient p ON t.patient=p.ssn
GROUP BY p.name
HAVING count(t.patient)>=1;

#9. write a SQL query to count the number of unique patients who have been scheduled for examination room 'C'.
# Return unique patients as "No. of patients got appointment for room C". 
SELECT count(DISTINCT patient) AS "No. of patients got appointment for room C"
FROM appointment
WHERE examinationroom='C';

#10. write a SQL query to identify the nurses and the room in which they will assist the physicians. 
#Return Nurse Name as "Name of the Nurse" and examination room as "Room No.". 
SELECT n.name AS "Name of the Nurse",
       a.examinationroom AS "Room No."
FROM nurse n
JOIN appointment a ON a.prepnurse=n.employeeid;
 

#10. write a SQL query to locate the patients' treating physicians and medications. 
#Return Patient name as "Patient", Physician name as "Physician", Medication name as "Medication". 

SELECT t.name AS "Patient",
       p.name AS "Physician",
       m.name AS "Medication"
FROM patient t
JOIN prescribes s ON s.patient=t.ssn
JOIN physician p ON s.physician=p.employeeid
JOIN medication m ON s.medication=m.code;

#11. write a SQL query to count the number of available rooms in each block. Sort the result-set on ID of the block. 
#Return ID of the block as "Block", count number of available rooms as "Number of available rooms".
SELECT blockcode AS "Block",
       count(*) "Number of available rooms"
FROM room
WHERE unavailable='f'
GROUP BY blockcode
ORDER BY blockcode;

#12. write a SQL query to count the number of available rooms for each floor in each block. Sort the result-set on floor ID, ID of the block. 
#Return the floor ID as "Floor", ID of the block as "Block", and number of available rooms as "Number of available rooms".
SELECT blockfloor AS "Floor",
       blockcode AS "Block",
       count(*) "Number of available rooms"
FROM room
WHERE unavailable='f'
GROUP BY blockfloor,
        blockcode
ORDER BY blockfloor,
        blockcode;
        
# 13. write a SQL query to count the number of rooms that are unavailable in each block and on each floor. Sort the result-set on block floor, block code. 
# Return the floor ID as "Floor", block ID as "Block", and number of unavailable as “Number of unavailable rooms"
SELECT blockfloor AS "Floor",
blockcode AS "Block",
count(*) "Number of unavailable rooms"
FROM room
WHERE unavailable='t'
GROUP BY blockfloor,
blockcode
ORDER BY blockfloor,
blockcode;

#14. write a SQL query to find the name of the patients, their block, floor, and room number where they admitted.
SELECT p.name AS "Patient",
       s.room AS "Room",
       r.blockfloor AS "Floor",
       r.blockcode AS "Block"
FROM stay s
JOIN patient p ON s.patient=p.ssn
JOIN room r ON s.room=r.roomnumber;

#15. write a SQL query to find all physicians who have performed a medical procedure but are not certified to do so.
# Return Physician name as "Physician".
SELECT name AS "Physician"
FROM physician
WHERE employeeid IN
    ( SELECT undergoes.physician
     FROM undergoes
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician
     AND undergoes.procedure=trained_in.treatment
     WHERE treatment IS NULL );

#16. write a SQL query to determine which patients have been prescribed medication by their primary care physician.
# Return Patient name as "Patient", and Physician Name as "Physician".
SELECT pt.name AS "Patient",
       p.name AS "Physician"
FROM patient pt
JOIN prescribes pr ON pr.patient=pt.ssn
JOIN physician p ON pt.pcp=p.employeeid
WHERE pt.pcp=pr.physician
  AND pt.pcp=p.employeeid;
  
#17.write a SQL query to find those patients who have undergone a procedure costing more than $5,000, as well as the name of the physician who has provided primary care, should be identified. 
#Return name of the patient as "Patient", name of the physician as "Primary Physician", and cost for the procedure as "Procedure Cost".
SELECT pt.name AS " Patient ",
p.name AS "Primary Physician",
pd.cost AS " Procedure Cost"
FROM patient pt
JOIN undergoes u ON u.patient=pt.ssn
JOIN physician p ON pt.pcp=p.employeeid
JOIN procedures pd ON u.procedure=pd.code
WHERE pd.cost>5000;

#18. write a SQL query to identify those patients whose primary care is provided by a physician who is not the head of any department. 
# Return Patient name as "Patient", Physician Name as "Primary care Physician".
SELECT pt.name AS "Patient",
       p.name AS "Primary care Physician"
FROM patient pt
JOIN physician p ON pt.pcp=p.employeeid
WHERE pt.pcp NOT IN
    (SELECT head
     FROM department);
