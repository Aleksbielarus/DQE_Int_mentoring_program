def hr_employee_duplicate_by_keys_query():
    query_text = (f'SELECT employee_id, count(*) ' 
                  f'FROM [hr].[employees] '
                  f'GROUP BY employee_id '
                  f'HAVING count(*) > 1')
    return query_text


def hr_empl_salary_validation_query():
    query_text = (f'SELECT employee_id, employees.job_id, salary, min_salary, max_salary '
                  f'FROM [hr].[employees] '
                  f'   LEFT JOIN [hr].[jobs] on jobs.job_id = employees.job_id '
                  f'WHERE salary < min_salary or salary > max_salary')
    return query_text


def hr_empl_email_validity_query():
    query_text = (f"SELECT employee_id, email "
                  f"FROM hr.employees "
                  f"WHERE email NOT LIKE '%@%';")
    return query_text


def hr_empl_manager_id_consistancy_query():
    query_text = (f"SELECT em.employee_id, em.manager_id "
                  f"FROM [hr].[employees] em"
                  f"WHERE manager_id NOT IN (SELECT employee_id FROM [hr].[employees])")
    return query_text


def hr_location_postal_code_validity_query():
    query_text = (f"SELECT location_id, postal_code "
                  f"FROM [hr].[locations] "
                  f"WHERE LEN(postal_code) != 5")
    return query_text


def hr_empl_hire_date_completeness_query():
    query_text = (f" SELECT * "
                  f"FROM[hr].[employees] " 
                  f"WHERE hire_date IS NULL;")
    return query_text

print(hr_location_postal_code_validity_query())