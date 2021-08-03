/* MVP Q1 */

SELECT
	e.first_name,
	e.last_name,
	t.name AS team_name
FROM employees e INNER JOIN teams t
ON e.team_id = t.id;

SELECT
	e.first_name,
	e.last_name,
	t.name AS team_name
FROM employees e INNER JOIN teams t
ON e.team_id = t.id
WHERE e.pension_enrol IS TRUE;

SELECT
	e.first_name,
	e.last_name,
	t.name AS team_name
FROM employees e INNER JOIN teams t
ON t.charge_cost::int > 80;

/* MVP Q2 */

SELECT
	e.*,
	p.local_account_no,
	p.local_sort_code
FROM employees e LEFT JOIN pay_details p
ON e.id = p.id;

SELECT
	e.*,
	p.local_account_no,
	p.local_sort_code,
	t.name AS team_name
FROM 
	(employees e LEFT JOIN pay_details p
	ON e.id = p.id
	)
	LEFT JOIN teams t
	ON e.team_id = t.id;
	
/* MVP Q3 */

SELECT
	e.id AS employee_id,
	t.name AS team_name
FROM employees e LEFT JOIN teams t
ON e.team_id = t.id;

SELECT
	t.name AS team_name,
	count(*) AS employee_count
FROM employees e LEFT JOIN teams t
ON e.team_id = t.id
GROUP BY t.name;

SELECT
	t.name AS team_name,
	count(*) AS employee_count
FROM employees e LEFT JOIN teams t
ON e.team_id = t.id
GROUP BY t.name
ORDER BY count(*);

/* MVP Q4 */

SELECT
	t.id AS team_id,
	t.name AS team_name,
	count(*) AS employee_count
FROM employees e LEFT JOIN teams t
ON e.team_id = t.id
GROUP BY t.id;

SELECT
	t.id AS team_id,
	t.name AS team_name,
	count(*) AS employee_count,
	count(*) * t.charge_cost::int AS total_day_charge
FROM employees e LEFT JOIN teams t
ON e.team_id = t.id
GROUP BY t.id;

SELECT
	t.id AS team_id,
	t.name AS team_name,
	count(*) AS employee_count,
	count(*) * t.charge_cost::int AS total_day_charge
FROM employees e LEFT JOIN teams t
ON e.team_id = t.id
GROUP BY t.id
HAVING count(*) * t.charge_cost::int > 5000;

/* EXT Q5 */

SELECT
	count(distinct(employee_id)) AS count_on_committee
FROM employees_committees;

/* EXT Q6 */

SELECT
	count(*) AS count_not_on_committee
FROM employees e LEFT JOIN employees_committees ec
ON e.id = ec.employee_id
WHERE ec.employee_id IS NULL;