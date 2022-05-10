** Settings **
Resource   ../resources/variables.robot
Resource   ../Resources/credentials.robot

Suite Setup       Connect To Database    pymssql  ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}  ${DBPort}
Suite Teardown  Disconnect From Database


*** Test Cases ***

No duplicate check [hr].[employees]
    [Tags]  Duplicates checks
    [Documentation]
    ...  | *Description:*
    ...  |      Verify that all keys in the table [hr].[employees] are unique
    ...  | *Test Steps:*
    ...  |      1. Query sql script
    ...  |      2. Verifiy that count of result rows is 0
    ...  | *Expected result:*
    ...  |      1. table [hr].[employees] is exists.
    ...  |      2. PK is uniques and execution result show 0 rows.
    [Setup]
        Check If Not Exists In Database    ${HR_EMPL_DUPLICATE_QUERY}

No duplicate check [hr].[countries]
    [Tags]  Duplicates checks
    [Documentation]
    ...  | *Description:*
    ...  |      Verify that all keys in the table [hr].[countries] are unique
    ...  | *Test Steps:*
    ...  |      1. Query sql script
    ...  |      2. Verifiy that count of result rows is 0
    ...  | *Expected result:*
    ...  |      1. table [hr].[countries] is exists.
    ...  |      2. PK is uniques and execution result show 0 rows.
    [Setup]
        Check If Not Exists In Database    ${HR_CNTR_DUPLICATE_QUERY}


No duplicate check [hr].[job]
    [Tags]  Duplicates checks
    [Documentation]
    ...  | *Description:*
    ...  |      Verify that all keys in the table [hr].[job] are unique
    ...  | *Test Steps:*
    ...  |      1. Query sql script
    ...  |      2. Verifiy that count of result rows is 0
    ...  | *Expected result:*
    ...  |      1. table [hr].[job] is exists.
    ...  |      2. PK is uniques and execution result show 0 rows.
    [Setup]
        Check If Not Exists In Database    ${HR_JOB_DUPLICATE_QUERY}


No duplicate check [hr].[locations]
    [Tags]  Duplicates checks
    [Documentation]
    ...  | *Description:*
    ...  |      Verify that all keys in the table [hr].[locations] are unique
    ...  | *Test Steps:*
    ...  |      1. Query sql script
    ...  |      2. Verifiy that count of result rows is 0
    ...  | *Expected result:*
    ...  |      1. table [hr].[locations] is exists.
    ...  |      2. PK is uniques and execution result show 0 rows.
    [Setup]
        Check If Not Exists In Database    ${HR_LOCAT_DUPLICATE_QUERY}


Hire date completeness in the [hr].[employee] table
   [Tags]  Completeness checks
    [Documentation]
    ...  | *Description:*
    ...  |      Hire date column is comletely fill in  [hr].[employees] table
    ...  | *Test Steps:*
    ...  |      1. Query sql script
    ...  |      2. Verify that count of result rows is 0
    ...  | *Expected result:*
    ...  |      1. table [hr].[employees] is exists.
    ...  |      2. Execution result show 0 rows.
    [Setup]
        Check If Not Exists In Database    ${HR_EMPL_hire_date_completeness_check}

Salary is not greater than max_salary and not less than min_salary in the [hr].[employees]
   [Tags]   Validity checks;    Consistency checks
   [Documentation]
    ...  | *Description:*
    ...  |      Validate that there is no salary per employee more than max
    ...  |      salary for job possition or less than min_salary for job possition.
    ...  | *Test Steps:*
    ...  |      1. Query sql script
    ...  |      2. Verify that there is no salary per employee more than max
    ...  |      salary for job possition or less than min_salary for job possition
    ...  | *Expected result:*
    ...  |      1. table [hr].[employees] is exists.
    ...  |      2. Execution result show 0 rows.
   [Setup]
        Check If Not Exists In Database    ${HR_LOCAT_salry_validity_check}

Employees email column validity
   [Tags]   Validity checks
   [Documentation]
    ...  | *Description:*
    ...  |      Validate that employees.email column contain @.
    ...  | *Test Steps:*
    ...  |      1. Query sql script
    ...  |      2. Verify that there are no rows without @ in email column
    ...  | *Expected result:*
    ...  |      1. table [hr].[employee] is exists.
    ...  |      2. Execution result show 0 rows.
   [Setup]
        Check If Not Exists In Database    ${HR_EMPL_email_validity}

Employees manager_id column validity
   [Tags]   Validity checks
   [Documentation]
    ...  | *Description:*
    ...  |      Validate that employees.manager_id exists in employees.employee_id
    ...  | *Test Steps:*
    ...  |      1. Query sql script
    ...  |      2. Verify that manager_id exists in employee_id column
    ...  | *Expected result:*
    ...  |      1. table [hr].[employee] is exists.
    ...  |      2. Execution result show 0 rows.
   [Setup]
        Check If Not Exists In Database    ${HR_EMPL_manager_validity}

Locations postal_code column consists of 5 symbols.( FAIL TEST)
   [Tags]   Validity checks
   [Documentation]
    ...  | *Description:*
    ...  |      Validate that locaxtions.postal_code consists of 5 symbols.
    ...  | *Test Steps:*
    ...  |      1. Query sql script
    ...  |      2. Verify that postal_code column contain only 5 symbols
    ...  | *Expected result:*
    ...  |      1. table [hr].[locations] is exists.
    ...  |      2. Execution result show 0 rows.
   [Setup]
        Check If Not Exists In Database    ${HR_COCAT_postal_code_validity}
