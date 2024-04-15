#%% Modules
from os import getenv as env

import awswrangler as wr
import pandas as pd 
import polars as pl

from internal_libs.glue_helper import get_args

#%% Arguments 
ARGS = get_args({
    "SOURCE_PATH": env("AWS_S3_SOURCE_PATH")
})

#%% Compute functions
def compute_cep_with_wrangler(source_path: str):
    FILEPATH = f"{source_path}/TB_CEP_BR_2018.csv"
    COLUMNS = ["CEP", "UF", "CIDADE", "BAIRRO", "RUA"]
    DTYPES = {
        "CEP": "str", 
        "UF": "str", 
        "CIDADE": "str", 
        "BAIRRO": "str", 
        "RUA": "str"
    }
    
    df = wr.s3.read_csv(FILEPATH, sep=";", header=None, names=COLUMNS, dtype=DTYPES)
    return pl.from_dataframe(df)

def load_cep_in_iceberg_table(df: pl.DataFrame):
    TABLE_NAME = "cep"
    DATABASE = "compras"
    

    return df

#%% Main Execution

if __name__ == "__main__":
    df = compute_cep_with_wrangler(ARGS["SOURCE_PATH"])
