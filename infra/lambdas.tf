module "LAMBDA_DE_ETL_CONSUME_FAKE_DATA_ON_S3" {
  source          = "./lambda_module"
  function_name   = "LAMBDA_DE_ETL_CONSUME_FAKE_DATA_ON_S3"
  handler         = "lambda_de_etl_consume_fake_data_on_s3.main"
  role_arn        = aws_iam_role.general_pipeline_lambda_role.arn
  source_path     = "${local.lambdas_folder_path}/lambda_de_etl_consume_fake_data_on_s3.py"
  output_path     = local.build_folder
  layers          = [module.external_libs_duckdb_helper.layer_arn]
  timeout         = 15
  memory_size     = 128
}

module "LAMBDA_DE_UTILITY_CREATE_FAKE_DATA_ON_S3" {
  source          = "./lambda_module"
  function_name   = "LAMBDA_DE_UTILITY_CREATE_FAKE_DATA_ON_S3"
  handler         = "lambda_de_utility_create_fake_data_on_s3.main"
  role_arn        = aws_iam_role.general_pipeline_lambda_role.arn
  source_path     = "${local.lambdas_folder_path}/lambda_de_utility_create_fake_data_on_s3.py"
  output_path     = local.build_folder
  layers          = [module.external_libs_duckdb_helper.layer_arn]
  timeout         = 15
  memory_size     = 128
}