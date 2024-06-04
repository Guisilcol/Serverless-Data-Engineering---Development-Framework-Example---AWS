from setuptools import setup, find_packages
 
setup(
    name='external_lib_boto3_helper',
    version='0.0.1',
    description='A helper package for boto3 in AWS Lambda.',
    packages=find_packages(),
    install_requires=[
        'boto3==1.34.113',
    ],
)