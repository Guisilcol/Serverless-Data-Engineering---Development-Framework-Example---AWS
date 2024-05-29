import os

import duckdb


def get_connection_with_aws_credentials() -> duckdb.DuckDBPyConnection:
    """
    Get a connection to a DuckDB database with AWS credentials. 
    Uses by default the environment variables AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN and HOME_DIRECTORY. 
    If HOME_DIRECTORY env is not set, it defaults to /tmp/duckdb. If it does not exist, it creates it. 
    
    Returns:
        duckdb.DuckDBPyConnection: Connection to a DuckDB database with AWS credentials.
    """
    
    HOME_DIRECTORY          = os.getenv('HOME_DIRECTORY', '/tmp/duckdb')
    AWS_REGION              = os.getenv('AWS_REGION')
    AWS_ACCESS_KEY_ID       = os.getenv('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY   = os.getenv('AWS_SECRET_ACCESS_KEY')
    AWS_SESSION_TOKEN       = os.getenv('AWS_SESSION_TOKEN')
    
    if None in [AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN]:
        raise ValueError('AWS credentials not set. Be sure to set the environment variables AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_SESSION_TOKEN.')
    
    if not os.path.exists(HOME_DIRECTORY):
        os.makedirs(HOME_DIRECTORY)
    
    connection = duckdb.connect(':memory:')
    connection.execute(f"SET home_directory='{HOME_DIRECTORY}';")
    connection.execute('INSTALL httpfs;')
    connection.execute('LOAD httpfs;')
    connection.execute(f"SET s3_region='{AWS_REGION}';")
    connection.execute(f"SET s3_access_key_id='{AWS_ACCESS_KEY_ID}';")
    connection.execute(f"SET s3_secret_access_key='{AWS_SECRET_ACCESS_KEY}';")
    connection.execute(f"SET s3_session_token='{AWS_SESSION_TOKEN}';")
    
    return connection
    
    