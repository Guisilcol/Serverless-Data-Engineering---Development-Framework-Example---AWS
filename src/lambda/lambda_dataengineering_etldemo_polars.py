"""
    Description: This is a lambda function that uses Polars to perform ETL operations. 
"""

import polars as pl 
import internal_libs.lambda_response as lambda_response

def compute_data():
    """Creates a DataFrame and write it back to a S3 bucket."""
    
    df = pl.DataFrame({
        'a': [1, 2, 3],
        'b': ['zoo', 'foo', 'bar']
    })
    
    df = df.with_columns(
        a = pl.col('a') * 2,
        b = pl.col('b').cast(pl.Utf8),
    )
    
    return df
    
    
def handler(event = None, context = None):
    df = compute_data()
    print(df.head())
    
    return lambda_response.new_response(200, "Success")
    
    
if __name__ == '__main__':
    handler()