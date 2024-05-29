module "lambda_de_etl_consume_fake_data_on_s3" {
  source          = "./lambda_module"
  function_name   = "lambda_de_etl_consume_fake_data_on_s3"
  handler         = "lambda_de_etl_consume_fake_data_on_s3.main"
  role_arn        = aws_iam_role.general_pipeline_lambda_role.arn
  source_path     = "${local.lambdas_path}/lambda_de_etl_consume_fake_data_on_s3.py"
  output_path     = local.build_folder
  layers          = [module.external_libs_duckdb_helper.layer_arn]
  timeout         = 15
  memory_size     = 128
}

module "lambda_de_utility_create_fake_data_on_s3" {
  source          = "./lambda_module"
  function_name   = "lambda_de_utility_create_fake_data_on_s3"
  handler         = "lambda_de_utility_create_fake_data_on_s3.main"
  role_arn        = aws_iam_role.general_pipeline_lambda_role.arn
  source_path     = "${local.lambdas_path}/lambda_de_utility_create_fake_data_on_s3.py"
  output_path     = local.build_folder
  layers          = [module.external_libs_duckdb_helper.layer_arn]
  timeout         = 15
  memory_size     = 128
}