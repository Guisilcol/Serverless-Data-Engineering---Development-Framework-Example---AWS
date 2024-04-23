from setuptools import setup, find_packages

setup(
    name='dataengineering_etldemo_env_helper',
    version='1.0',
    author='silcol',
    packages=find_packages(),
    install_requires=[
        'python-dotenv==1.0.1'
    ]
)