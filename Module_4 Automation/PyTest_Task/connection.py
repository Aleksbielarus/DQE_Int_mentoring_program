import pymssql

def mssql_connect(server, user, password, database, port):
    conn = pymssql.connect(server=server,
                           user=user,
                           password=password,
                           database=database,
                           port=port)
    cursor = conn.cursor()
    return cursor, conn


