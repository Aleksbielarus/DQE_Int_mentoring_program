*** Settings ***
Documentation   Robot resources and variables for all tests

Library           DatabaseLibrary
Library           OperatingSystem


*** Variables ***

${HR_EMPL_DUPLICATE_QUERY}                      SELECT employee_id, count(*)
                                           ...  FROM [hr].[employees]
                                           ...  GROUP BY employee_id HAVING count(*) > 1;

${HR_CNTR_DUPLICATE_QUERY}                      SELECT country_id, count(*)
                                           ...  FROM [hr].[countries]
                                           ...  GROUP BY country_id HAVING count(*) > 1;

${HR_JOB_DUPLICATE_QUERY}                       SELECT job_id, count(*)
                                           ...  FROM [hr].[jobs]
                                           ...  GROUP BY job_id HAVING count(*) > 1;

${HR_LOCAT_DUPLICATE_QUERY}                     SELECT location_id, count(*)
                                           ...  FROM [hr].[locations]
                                           ...  GROUP BY location_id HAVING count(*) > 1;

${HR_EMPL_hire_date_completeness_check}         SELECT *
                                           ...  FROM [hr].[employees]
                                           ...  WHERE hire_date IS NULL;


${HR_LOCAT_salry_validity_check}                SELECT employee_id, employees.job_id, salary, min_salary, max_salary
                                           ...  FROM [hr].[employees]
                                           ...      LEFT JOIN [hr].[jobs] on jobs.job_id = employees.job_id
                                           ...  WHERE salary < min_salary or salary > max_salary

${HR_EMPL_email_validity}                       SELECT employee_id, email
                                           ...  FROM hr.employees
                                           ...  WHERE email NOT LIKE '%@%'

${HR_EMPL_manager_validity}                     SELECT em.employee_id, em.manager_id
                                           ...  FROM [hr].[employees] em
                                           ...  WHERE manager_id NOT IN (SELECT employee_id FROM [hr].[employees])

${HR_COCAT_postal_code_validity}                SELECT location_id, postal_code
                                           ...  FROM [hr].[locations]
                                           ...  WHERE LEN(postal_code) != 5