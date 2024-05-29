

module "external_libs_duckdb_helper" {
  source                            = "./external_libs_module"
  layer_name                        = "lambda_layer_duckdb_helper"
  glue_extra_pyfiles_s3_object_key  = "glue_extra_pyfiles_lambda_layer_duckdb_helper-0.0.0-py3-none-any.whl"
  aws_s3_source_code_bucket_name    = "exemplo-de-spark-join-e-estrategias-de-melhoria-de-performance"
  python_module_path                = "${local.external_libs_path}/lambda_layer_duckdb_helper"
  prebuild_folder                   = local.prebuild_folder
  build_folder                      = local.build_folder
}




