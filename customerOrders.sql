-- udemy section 12
-- new DB, new tables 1

CREATE DATABASE customer_app;

-- Customers table 
CREATE TABLE customers(
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100)
);

-- Orders table
CREATE TABLE orders(
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE,
    amount DECIMAL(8,2),
    customer_id INT,
    FOREIGN KEY(customer_id) REFERENCES customers(id)
);

-- Customer table values
INSERT INTO customers (first_name, last_name, email) 
VALUES ('Boy', 'George', 'george@gmail.com'),
       ('George', 'Michael', 'gm@gmail.com'),
       ('David', 'Bowie', 'david@gmail.com'),
       ('Blue', 'Steele', 'blue@gmail.com'),
       ('Bette', 'Davis', 'bette@aol.com');
       
-- Order table values     
INSERT INTO orders (order_date, amount, customer_id)
VALUES ('2016/02/10', 99.99, 1),
       ('2017/11/11', 35.50, 1),
       ('2014/12/12', 800.67, 2),
       ('2015/01/03', 12.50, 2),
       ('1999/04/11', 450.25, 5);

-- Trying to run this will show how the foriegn keys are working because this wont be added to the table.
INSERT INTO orders (order_date, amount, customer_id)
VALUES ('2016/06/06', 33.67, 98);

-- CROSS JOIN 
-- not commonly used, not efficient, just a basic join 
SELECT * FROM customers, orders;

-- IMPLICIT INNER JOIN, this can be thought of as a Venn diagram 
-- format is 'table.tableKey = table2.table2Key 
SELECT * FROM customers, orders WHERE customers.id = orders.customer_id;

-- Cleaner way
-- EXPLICIT INNER JOIN, much more common type of join, and simpler way of writing an implicit join, the order of the joins only affects how the data is printed out and displayed. 
SELECT * FROM customers 
JOIN orders
    ON customers.id = orders.customer_id;

-- Arbitrary join, do not do this 
SELECT * FROM customers
JOIN orders ON customers.id = orders.id;

-- Left Join 
SELECT first_name, last_name, order_date, SUM(amount) AS 'Total Spent' FROM customers 
JOIN orders
    ON customers.id = orders.customer_id
GROUP BY orders.customer_id;

-- WRITING out left join 
SELECT * FROM customers 
LEFT JOIN orders
    ON customers.id = orders.customer_id;

SELECT first_name, last_name, order_date, amount FROM customers 
LEFT JOIN orders
    ON customers.id = orders.customer_id;

-- IFNULL 
SELECT first_name, last_name, order_date, IFNULL(SUM(amount), 0) 
FROM customers 
LEFT JOIN orders
    ON customers.id = orders.customer_id
GROUP BY customers.id; 

-- Right Join 
SELECT * FROM customers
RIGHT JOIN orders
    ON customers.id = orders.customer_id;
-- Same, just not right verbage 
SELECT * FROM customers
JOIN orders
    ON customers.id = orders.customer_id;

-- Frequently asked question about right and left join 
SELECT * FROM customers
LEFT JOIN orders
    ON customers.id = orders.customer_id;

SELECT * FROM customers
RIGHT JOIN customers
    ON customers.id = orders.customer_id;

-- Join exercises for section 12

-- Exercise 1, manipulate a student and papers table 
-- Solution:
CREATE TABLE students(
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100)
);
CREATE TABLE papers(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    grade INT,
    student_id INT,
    FOREIGN KEY(student_id) REFERENCES students(id)
);
INSERT INTO students (first_name) VALUES 
('Caleb'), ('Samantha'), ('Raj'), ('Carlos'), ('Lisa');

INSERT INTO papers (student_id, title, grade ) VALUES
(1, 'My First Book Report', 60),
(1, 'My Second Book Report', 75),
(2, 'Russian Lit Through The Ages', 94),
(2, 'De Montaigne and The Art of The Essay', 98),
(4, 'Borges and Magical Realism', 89);

SELECT first_name, title, grade FROM students
JOIN papers 
    ON students.id = papers.student_id;


-- Exercise 2, left join that shows null assignments 
-- Solution:
SELECT first_name, title, grade FROM students
RIGHT JOIN papers 
    ON students.id = papers.student_id;

-- Exercise 3 display missing if null 
-- Solution:
SELECT first_name, IFNULL(title, 'MISSING'), IFNULL(grade, '0') FROM students
LEFT JOIN papers 
    ON students.id = papers.student_id;

-- Exercise 4 average the grades for the students papers 
-- Solution:
SELECT first_name, IFNULL(AVG(grade), '0') AS 'average' FROM students
LEFT JOIN papers 
    ON students.id = papers.student_id
GROUP BY students.id
ORDER BY average DESC;
    
-- Exercise 5 
-- Solution:
SELECT first_name, IFNULL(AVG(grade), '0') AS 'average',
CASE 
    WHEN AVG(grade) IS NULL THEN 'FAILING'
    WHEN AVG(grade) >= 75 THEN 'PASSING'
    ELSE 'FAILING'
END AS passing_status
FROM students
LEFT JOIN papers 
    ON students.id = papers.student_id
GROUP BY students.id
ORDER BY average DESC;
