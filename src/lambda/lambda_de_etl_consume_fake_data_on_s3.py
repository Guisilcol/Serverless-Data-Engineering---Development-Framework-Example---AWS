from duckdb_helper import get_connection_with_aws_credentials 

def compute_fake_data() -> None:
    """Consume fake data writing by 'lambda_de_etl_consume_fake_data_on_s3' ."""
    
    BUCKET_NAME = 'exemplo-de-spark-join-e-estrategias-de-melhoria-de-performance'
    FOLDER = 'fake_data'
    FILENAME = 'data.parquet'
    FULL_PATH = f's3://{BUCKET_NAME}/{FOLDER}/{FILENAME}'
    
    sql = \
    f"""--sql
    SELECT * FROM READ_PARQUET('{FULL_PATH}')
    """
    
    conn = get_connection_with_aws_credentials() 
    conn.sql(sql).show()
    
def main(event: dict = {}, context: dict = {}):
    compute_fake_data()
    
    return {
        'code': 200
    }
    
if __name__ == '__main__':
    main()
    