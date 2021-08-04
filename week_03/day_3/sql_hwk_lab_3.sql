/* MVP Q1 */

SELECT
	COUNT(*) AS count_null_grade_salary
FROM employees
WHERE
	grade IS NULL
	AND
	salary IS NULL;
	
/* MVP Q2 */

SELECT
	department,
	concat(first_name, ' ', last_name) AS full_name
FROM employees
ORDER BY last_name;

/* MVP Q3 */

SELECT *
FROM employees
WHERE last_name ILIKE 'A%'
ORDER BY salary DESC NULLS LAST
LIMIT 10;

/* MVP Q4 */

SELECT
	department,
	count(*) AS count_2003_starts
FROM employees
WHERE EXTRACT(YEAR FROM start_date) = 2003
GROUP BY department;

/* MVP Q5 */

SELECT
	department,
	fte_hours,
	count(*) AS count_department_fte
FROM employees
GROUP BY department, fte_hours
ORDER BY department, fte_hours;

/* MVP Q6 */

SELECT
	CASE 	WHEN pension_enrol IS NULL THEN 'Unknown'
			WHEN pension_enrol IS TRUE THEN 'Enrolled'
			WHEN pension_enrol IS FALSE THEN 'Not enrolled'
			END AS enrollment_status,
	count(*) AS num_employees
FROM employees
GROUP BY pension_enrol;

/* MVP Q7 */

SELECT *
FROM employees
WHERE
	department = 'Accounting'
	AND
	pension_enrol IS FALSE
ORDER BY salary DESC NULLS LAST
LIMIT 1;

/* MVP Q8 */

SELECT
	country,
	count(*) AS num_employees,
	avg(salary) AS avg_salary
FROM employees
GROUP BY country
HAVING count(*) > 30
ORDER BY avg(salary) DESC;


/* MVP Q9 */

SELECT
	first_name,
	last_name,
	fte_hours,
	salary,
	fte_hours * salary AS effective_yearly_salary
FROM employees
WHERE fte_hours * salary > 30000;

/* MVP Q10 */

SELECT
	e.*,
	t.name
FROM employees e LEFT JOIN teams t
ON e.team_id = t.id
WHERE t.name LIKE 'Data Team %';

/* MVP Q11 */

SELECT
	e.first_name,
	e.last_name
FROM employees e LEFT JOIN pay_details p
ON e.id = p.id
WHERE p.local_tax_code IS NULL;

/* MVP Q12 */

SELECT
	e.first_name,
	e.last_name,
	(48 * 35 * t.charge_cost::int - e.salary) * fte_hours AS expected_profit
FROM employees e LEFT JOIN teams t
ON e.team_id = t.id;

/* MVP Q13 */

SELECT
	first_name,
	last_name,
	salary
FROM employees
WHERE
	country = 'Japan'
	AND
	fte_hours = (SELECT fte_hours
				FROM employees
				GROUP BY fte_hours
				ORDER BY count(*)
				LIMIT 1)
ORDER BY salary
LIMIT 1;

/* MVP Q14 */

SELECT
	department,
	count(*)
FROM employees
WHERE
	first_name IS NULL
GROUP BY department
HAVING count(*) >= 2
ORDER BY count(*) DESC, department;

/* MVP Q15 */

SELECT
	first_name,
	count(*)
FROM employees
WHERE
	first_name IS NOT NULL
GROUP BY first_name
HAVING count(*) > 1
ORDER BY count(*) DESC, first_name;

/* MVP Q16 */

SELECT
	department,
	count(CASE WHEN grade = 1 THEN 1 END)::real/count(*)::real AS prop_grade_1
FROM employees
GROUP BY department;

/* EXT Q1 */
	
WITH dept_avg_salary_fte AS (
	SELECT
		department,
		avg(salary) AS avg_salary,
		avg(fte_hours) AS avg_fte
	FROM employees
	GROUP BY department
	)
SELECT
	e.id,
	e.first_name,
	e.last_name,
	e.department,
	e.salary,
	e.fte_hours,
	round(e.salary / d.avg_salary, 2) AS salary_dep_ratio,
	round(e.fte_hours / d.avg_fte, 2) AS fte_dep_ratio
FROM employees e LEFT JOIN dept_avg_salary_fte d
ON e.department = d.department
WHERE e.department IN (SELECT department
						FROM (	SELECT
									department,
									RANK () OVER (ORDER BY count(*) DESC)
								FROM employees
								GROUP BY department
								) AS dep_rank
						WHERE RANK = 1
						);

/* EXT Q2 */
					
SELECT
	CASE 	WHEN pension_enrol IS NULL THEN 'Unknown'
			WHEN pension_enrol IS TRUE THEN 'Enrolled'
			WHEN pension_enrol IS FALSE THEN 'Not enrolled'
			END AS enrollment_status,
	count(*) AS num_employees
FROM employees
GROUP BY pension_enrol;

/* EXT Q3 */

SELECT
	e.first_name,
	e.last_name,
	e.email,
	e.start_date
FROM employees e LEFT JOIN (SELECT *
							FROM employees_committees ec LEFT JOIN committees c
							ON ec.committee_id = c.id) AS ecc
ON e.id = ecc.employee_id
WHERE ecc.name = 'Equality and Diversity'
ORDER BY e.start_date;

/* EXT Q4 */

WITH salary_class_added AS (
	SELECT
		*,
		CASE	WHEN salary >= 40000 THEN 'high'
				WHEN salary < 40000 THEN 'low'
				WHEN salary IS NULL THEN 'none'
		END AS salary_class
	FROM employees
	)
SELECT
	s.salary_class,
	count(*) AS employee_count
FROM salary_class_added s INNER JOIN employees_committees ec
ON s.id = ec.employee_id
GROUP BY s.salary_class;