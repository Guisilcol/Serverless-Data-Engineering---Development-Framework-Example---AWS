"""
    Description: This is a lambda function that is used to demonstrate the ETL process using DuckDB. Only uses internal libraries.
"""

import internal_libs.duckdb_helper as duckdb_helper
import internal_libs.env_helper as env_helper
import internal_libs.lambda_response as lambda_response

SQL = """--sql        
    COPY (
        SELECT
            *
        FROM 
            parquet_scan(
                's3://exemplo-de-spark-join-e-estrategias-de-melhoria-de-performance/data/world_cities/*'
            )
        ORDER BY country, subcountry
    ) 
    TO 's3://exemplo-de-spark-join-e-estrategias-de-melhoria-de-performance/data/world_cities_duckdb'
    (FORMAT 'parquet', COMPRESSION 'snappy');
"""
"""SQL to be executed by DuckDB. Read data from a S3 bucket and write it back to another folder."""

def compute_data():
    """
    Execute the SQL in DuckDB.
    """
    
    conn = duckdb_helper.create_duckdb_connection_with_s3_configured()
    conn.execute(SQL)
    
def handler(event = None, context = None):
    env_helper.load_dotenv()
    compute_data()
    
    return lambda_response.new_response(200, "Success") 

if __name__ == '__main__':
    handler()



