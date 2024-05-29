locals {
  python_module_path    = var.python_module_path
  prebuild_folder       = var.prebuild_folder
  build_folder          = var.build_folder
  module_files          = fileset("${local.python_module_path}", "**/*")
  
  staging_folder_path        = "${local.prebuild_folder}/${var.layer_name}"
  staging_site_packages_folder_path = "${local.prebuild_folder}/${var.layer_name}/python/lib/python3.10/site-packages"

  
}