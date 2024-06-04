

module "external_libs_duckdb_helper" {
  source                = "./external_libs_module"
  layer_name            = "lambda_layer_external_libs_duckdb_helper"
  wheel_filename        = "external_lib_duckdb_helper-0.0.1-py3-none-any.whl"
  zip_filename          = "external_lib_duckdb_helper.zip"
  source_code_s3_bucket = "exemplo-de-spark-join-e-estrategias-de-melhoria-de-performance"
  source_code_s3_folder = "src_code"
  compatible_runtimes   = ["python3.10"]
  build_folder          = "./../build"
}