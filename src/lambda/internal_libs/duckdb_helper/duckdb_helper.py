import duckdb

def create_duckdb_connection_with_s3_configured() -> duckdb.DuckDBPyConnection:
    """
    Create a DuckDB connection with S3 configured.
    
    Returns:
        duckdb.DuckDBPyConnection: A in memory DuckDB connection with httpfs module, aws module and AWS credentials loaded (using "CALL load_aws_credentials()").
    """
    
    statements = [
        'INSTALL httpfs',
        'LOAD httpfs',
        'INSTALL aws',
        'LOAD aws',
        'CALL load_aws_credentials()'
    ]
    
    conn = duckdb.connect()
    for stmt in statements:
        conn = conn.execute(stmt)
        
    return conn
    