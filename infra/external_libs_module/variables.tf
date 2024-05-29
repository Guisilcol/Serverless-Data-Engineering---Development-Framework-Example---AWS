
variable "layer_name" {
  description = "The name of the Lambda layer"
  type        = string
}

variable "aws_s3_source_code_bucket_name" {
  description = "The name of the S3 bucket to store the Glue extra pyfiles"
  type        = string
}

variable "glue_extra_pyfiles_s3_object_key" {
  description = "The name of the zip file containing the Glue extra pyfiles"
  type        = string
}

variable "python_module_path" {
  description = "Path to the Python module directory containing setup.py"
  type        = string
}

variable "compatible_runtimes" {
  description = "List of compatible runtimes for the Lambda layer"
  type        = list(string)
  default     = ["python3.10"]
}

variable "prebuild_folder" {
  description = "Temporary folder for packaging the module"
  type        = string
  default     = "/tmp"
}

variable "build_folder" {
  description = "Output path for the zipped layer"
  type        = string
}



