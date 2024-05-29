from duckdb_helper import get_connection_with_aws_credentials 

def compute_fake_data() -> None:
    """Generate fake data and save it on S3."""
    
    BUCKET_NAME = 'exemplo-de-spark-join-e-estrategias-de-melhoria-de-performance'
    FOLDER = 'fake_data'
    FILENAME = 'data.parquet'
    FULL_PATH = f's3://{BUCKET_NAME}/{FOLDER}/{FILENAME}'
    
    sql = \
    f"""--sql
    COPY (
        SELECT 
            HASH(i * 10 + j) AS id, 
            IF (j % 2, TRUE, FALSE) AS flag
        FROM 
            GENERATE_SERIES(1, 100000) s(i)
            CROSS JOIN GENERATE_SERIES(1, 2) t(j)
    ) 
    
    TO '{FULL_PATH}' ( FORMAT PARQUET, OVERWRITE_OR_IGNORE TRUE )
    """
    
    get_connection_with_aws_credentials().sql(sql)
    
def main(event: dict = {}, context: dict = {}):
    compute_fake_data()
    
    return {
        'code': 200
    }
    
if __name__ == '__main__':
    main()
    