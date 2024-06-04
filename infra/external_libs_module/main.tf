
resource "aws_lambda_layer_version" "layer" {
  layer_name          = var.layer_name
  filename            = "${local.build_folder}/${var.zip_filename}"
  compatible_runtimes = var.compatible_runtimes
  source_code_hash    = filebase64sha256("${local.build_folder}/${var.zip_filename}")
}

resource "aws_s3_object" "glue_extra_pyfiles_on_s3" {
    bucket      = var.source_code_s3_bucket
    key         = "${var.source_code_s3_folder}/${var.wheel_filename}"
    source      = "${local.build_folder}/${var.wheel_filename}"

    source_hash = filebase64sha256("${local.build_folder}/${var.wheel_filename}")
}
 