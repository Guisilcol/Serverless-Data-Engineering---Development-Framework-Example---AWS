from setuptools import setup, find_packages
 
setup(
    name='lambda_layer_duckdb_helper',
    version='0.0.1',
    description='A helper package for duckdb.',
    packages=find_packages(),
    install_requires=[
        'duckdb==0.10.3',
        'numpy==1.26.4'
    ],
)