import connection
import Credentials
import pandas as pd
from src.enums import global_enums
from src.verifiecation_scripts import SQL_scripts


def test_hr_empl_duplicates_by_key_checks():
    cursor, conn = connection.mssql_connect(Credentials.server,
                                            Credentials.user,
                                            Credentials.password,
                                            Credentials.database,
                                            Credentials.port)
    cursor.execute(SQL_scripts.hr_employee_duplicate_by_keys_query())
    results = len(pd.DataFrame(cursor.fetchall()).index)
    assert results == 0


def test_hr_empl_salary_validation():
    cursor, conn = connection.mssql_connect(Credentials.server,
                                            Credentials.user,
                                            Credentials.password,
                                            Credentials.database,
                                            Credentials.port)
    cursor.execute(SQL_scripts.hr_empl_salary_validation_query())
    results = len(pd.DataFrame(cursor.fetchall()).index)
    assert results == 0


def test_hr_empl_email_validity():
    cursor, conn = connection.mssql_connect(Credentials.server,
                                            Credentials.user,
                                            Credentials.password,
                                            Credentials.database,
                                            Credentials.port)
    cursor.execute(SQL_scripts.hr_empl_email_validity_query())
    results = len(pd.DataFrame(cursor.fetchall()).index)
    assert results == 0


def test_hr_empl_manager_id_consistency():
    cursor, conn = connection.mssql_connect(Credentials.server,
                                            Credentials.user,
                                            Credentials.password,
                                            Credentials.database,
                                            Credentials.port)
    cursor.execute(SQL_scripts.hr_empl_manager_id_consistancy_query())
    results = len(pd.DataFrame(cursor.fetchall()).index)
    assert results == 0


def test_hr_location_postal_code_validity():
    cursor, conn = connection.mssql_connect(Credentials.server,
                                            Credentials.user,
                                            Credentials.password,
                                            Credentials.database,
                                            Credentials.port)
    cursor.execute(SQL_scripts.hr_location_postal_code_validity_query())
    results = len(pd.DataFrame(cursor.fetchall()).index)
    assert results == 0, global_enums.WRONG_COUNT_OF_ROWS(results)


def test_hr_empl_hire_date_completeness():
    cursor, conn = connection.mssql_connect(Credentials.server,
                                            Credentials.user,
                                            Credentials.password,
                                            Credentials.database,
                                            Credentials.port)
    cursor.execute(SQL_scripts.hr_empl_hire_date_completeness_query())
    results = len(pd.DataFrame(cursor.fetchall()).index)
    assert results == 0, global_enums.WRONG_COUNT_OF_ROWS(results)

