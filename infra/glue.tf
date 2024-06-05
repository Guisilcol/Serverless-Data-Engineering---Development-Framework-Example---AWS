
module "GLUE_ED_PYTHONSHELL_NOPROJECT_PANDAS_TEST" {
    source                      = "./glue_job_module"
    glue_job_type               = "pythonshell"
    source_code_bucket          = aws_s3_bucket.source_code_bucket.bucket
    source_code_object_key      = "src_code/glue_de_python_shell_pandas.py"
    source_path                 = "${local.python_shell_folder_path}/glue_de_python_shell_pandas.py"
    glue_version                = "4.0"
    python_version              = "3.9"
    job_name                    = "GLUE_ED_PYTHONSHELL_NOPROJECT_PANDAS_TEST"
    job_description             = "A Glue job that runs a Python shell script with Pandas"
    role_arn                    = aws_iam_role.general_pipeline_glue_role.arn
    number_of_workers           = null
    worker_type                 = null
    execution_class             = null
    additional_python_packages  = [
        module.external_libs_duckdb_helper.s3_object_uri
    ]
}
