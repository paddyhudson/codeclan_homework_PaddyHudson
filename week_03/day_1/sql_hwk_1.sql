/* MVP 1 */

SELECT *
FROM employees
WHERE department = 'Human Resources';

/* MVP 2 */

SELECT first_name, last_name, country
FROM employees
WHERE department = 'Legal';

/* MVP 3 */

SELECT count(*) AS count_portugal
FROM employees
WHERE country = 'Portugal';

/* MVP 4 */

SELECT count(*) AS count_portugal_spain
FROM employees
WHERE country IN ('Portugal', 'Spain');

/* MVP 5 */

SELECT count(*) AS missing_local_acc
FROM pay_details
WHERE local_account_no IS NULL;

/* MVP 6 */

SELECT count(*) AS missing_local_acc_iban
FROM pay_details
WHERE local_account_no IS NULL
AND iban IS NULL;

/* MVP 7 */

SELECT first_name, last_name
FROM employees
ORDER BY last_name NULLS LAST;

/* MVP 8 */

SELECT first_name, last_name, country
FROM employees
ORDER BY country, last_name NULLS LAST;

/* MVP 9 */

SELECT *
FROM employees
ORDER BY salary DESC NULLS last
LIMIT 10;

/* MVP 10 */

SELECT first_name, last_name, salary
FROM employees
WHERE country = 'Hungary'
ORDER BY salary
LIMIT 1;

/* MVP 11 */

SELECT count(*) AS count_first_name_F
FROM employees
WHERE first_name ILIKE 'F%';

/* MVP 12 */

SELECT *
FROM employees
WHERE email ILIKE '%yahoo%';

/* MVP 13 */

SELECT count(*) AS pension_enrolled_not_fra_ger
FROM employees
WHERE pension_enrol IS TRUE
AND country NOT IN ('France', 'Germany');

/* MVP 14 */

SELECT max(salary) AS max_engineering_fte1_salary
FROM employees
WHERE department = 'Engineering'
AND fte_hours = 1;

/* MVP 15 */

SELECT first_name, last_name, fte_hours, salary,
	fte_hours*salary AS effective_yearly_salary
FROM employees 

/* EXT 16 */

SELECT CONCAT(first_name, ' ', last_name, ' - ', department) AS badge_label
FROM employees
WHERE first_name||last_name||department IS NOT NULL;

/* EXT 17 */

SELECT CONCAT(
	first_name,
	' ',
	last_name,
	' - ',
	department,
	' (Joined ',
	EXTRACT (YEAR FROM start_date),
	')'
	) AS badge_label
FROM employees
WHERE first_name||last_name||department||start_date IS NOT NULL;

/* EXT 18 */

SELECT 	first_name,
		last_name,
		salary,
		CASE WHEN salary < 40000 THEN 'Low'
			WHEN salary IS NULL THEN NULL
			ELSE 'High'
		END AS salary_class
FROM employees;