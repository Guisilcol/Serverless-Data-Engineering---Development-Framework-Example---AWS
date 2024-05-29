

resource "null_resource" "package_python_module" {
  provisioner "local-exec" {
    command = <<EOF
    rm -rf ${local.staging_folder_path} && \
    mkdir -p ${local.staging_site_packages_folder_path} && \
    pip install --use-pep517 ${local.python_module_path} -t ${local.staging_site_packages_folder_path} && \
    rm -rf ${local.python_module_path}/build && \
    rm -rf ${local.python_module_path}/*.egg-info \
    EOF
  }

  triggers = {
    python_module_path = "${local.python_module_path}"
    content_hash       = join(",", [for f in local.module_files : filesha256("${local.python_module_path}/${f}")])
  }
}

data "archive_file" "zip_lambda_layer" {
  type        = "zip"
  source_dir  = "${local.prebuild_folder}/${var.layer_name}"
  output_path = "${local.build_folder}/${var.layer_name}.zip"

  depends_on = [ null_resource.package_python_module ]
}

resource "aws_lambda_layer_version" "layer" {
  filename           = data.archive_file.zip_lambda_layer.output_path
  layer_name         = var.layer_name
  compatible_runtimes = var.compatible_runtimes
  source_code_hash   = data.archive_file.zip_lambda_layer.output_base64sha256
  
}

data "archive_file" "zip_glue_extra_pyfiles" {
  type        = "zip"
  source_dir  = local.staging_site_packages_folder_path
  output_path = "${local.build_folder}/${var.glue_extra_pyfiles_s3_object_key}.zip"

  depends_on = [ null_resource.package_python_module ]
}

resource "aws_s3_object" "glue_extra_pyfiles_on_s3" {
    bucket = var.aws_s3_source_code_bucket_name
    key    = var.glue_extra_pyfiles_s3_object_key
    source = "${local.build_folder}/${var.glue_extra_pyfiles_s3_object_key}.zip"

    source_hash = data.archive_file.zip_glue_extra_pyfiles.output_base64sha256
}


