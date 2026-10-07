-- Task 1: Write 10 SQL Queries 
-- Query 1: Select all students from Nairobi 
SELECT id, name, email, age, town FROM students
WHERE town = 'Nairobi';

-- Query 2: Select all courses with more than 3 credits, ordered by name alphabetically.
SELECT id, name, code, credits FROM courses
WHERE credits > 3
ORDER BY name;

-- Query 3: Select student names and their enrolled course names using JOIN.
SELECT 
  students.name AS student_name,
  courses.name AS course_name
FROM enrollments
INNER JOIN students ON enrollments.student_id = students.id
INNER JOIN courses ON enrollments.course_id = courses.id
LIMIT 5;

-- Query 4: Count how many students are enrolled in each course. Order by count descending.
SELECT 
  courses.name as course_name,
  COUNT(enrollments.id) AS student_count
FROM courses
LEFT JOIN enrollments ON courses.id = enrollments.course_id
GROUP BY courses.name
ORDER BY student_count DESC;

-- Query 5: Find all students older than 22, sorted by age descending.
SELECT name, age, town FROM students
WHERE age > 22
ORDER BY AGE DESC;

-- Query 6: Find the average grade across all enrollments.
SELECT avg(grade) AS avg_grade FROM enrollments;

-- Query 7: Find the highest and lowest grade in the enrollments table.
SELECT 
  MAX(grade) AS highest_grade,
  MIN(grade) AS lowest_grade
FROM enrollments;

-- Query 8: Select students whose names start with a vowel (A, E, I, O, U)
SELECT name FROM students 
WHERE ( name LIKE 'A%' OR 
        name LIKE 'E%' OR 
        name LIKE 'I%' OR
        name LIKE 'O%' OR 
        name LIKE 'U%')
ORDER BY name;

-- Query 9: Find all courses in the Computer Science department (join courses with teachers).
SELECT 
  courses.name AS course_name,
  teachers.name AS teacher_name
FROM teachers
INNER JOIN courses ON courses.teacher_id = teachers.id
LIMIT 5;

-- Query 10: Count how many students are from each town, only showing towns with more than 1 student.
SELECT town, COUNT(*) AS student_count
FROM students
GROUP BY town
HAVING COUNT(*) > 1
ORDER by town DESC;



-- TASK 2: Answer Business Questions 
-- Question 1: Which teacher has the most students across all their courses? Display the teacher name and total number of unique students.
SELECT 
  teachers.name AS teacher_name,
  COUNT (DISTINCT enrollments.student_id) AS total_students
FROM teachers
INNER JOIN courses ON teachers.id = courses.teacher_id
INNER JOIN enrollments ON courses.id = enrollments.course_id
GROUP BY teachers.id, teachers.name
ORDER BY total_students DESC 
LIMIT 1;

-- Question 2: What is the average grade per course? Display course name and average grade, sorted by average grade descending.
SELECT 
  courses.name AS course_name,
  ROUND(AVG(enrollments.grade), 2) AS avg_grade
FROM courses
INNER JOIN enrollments ON courses.id = enrollments.course_id
GROUP BY courses.id, courses.name
ORDER BY avg_grade DESC;

-- Question 3: Which students are enrolled in more than 3 courses? Display student name and course count.
SELECT 
  students.name AS student_name,
  COUNT(courses.id) AS course_count
FROM students
INNER JOIN enrollments ON students.id = enrollments.student_id
INNER JOIN courses ON enrollments.course_id = courses.id
GROUP BY students.name
HAVING COUNT(courses.id) > 3;


-- Task 3: Data Modifications 
-- 3a: INSERT 5 new students with Kenyan names and towns. Use these values:
INSERT INTO students (name, email, age, town)
VALUES 
-- Insert these 5 students
  ('Njeri Maina', 'njeri@student.ac.ke', 20, 'Nyeri'),
  ('Kamau Githuku', 'kamau.g@student.ac.ke', 22, 'Kiambu'),
  ('Atieno Owino', 'atieno@student.ac.ke', 21, 'Homa Bay'),
  ('Baraka Mwiti', 'baraka@student.ac.ke', 23, 'Meru'),
  ('Zawadi Chebet', 'zawadi@student.ac.ke', 19, 'Kericho')

-- 3b: UPDATE the grades for all enrollments in course_id 1 (Introduction to Programming) -- increase each grade by 5 points (but cap at 100).
UPDATE enrollments
SET grade = least(grade + 5, 100)
WHERE course_id = 1;

-- 3c: DELETE all students who have no enrollments (the 5 students you just inserted have no enrollments).
DELETE FROM students s
WHERE NOT EXISTS (
    SELECT 1
    FROM enrollments e
    WHERE e.student_id = s.id
);
