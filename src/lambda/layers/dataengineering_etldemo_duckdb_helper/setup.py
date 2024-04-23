from setuptools import setup, find_packages

setup(
    name='duckdb_helper',
    version='1.0',
    author='silcol',
    packages=find_packages(),
    install_requires=[
        'duckdb==0.10.1',
    ]
)
