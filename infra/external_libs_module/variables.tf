
variable "layer_name" {
  description = "The name of the Lambda layer"
  type        = string
}

variable "wheel_filename" {
  description = "The name of the module wheel file."
  type        = string
}

variable "zip_filename" {
  description = "The name of the zip file containing the Lambda layer"
  type        = string
}

variable "source_code_s3_bucket" {
  description = "The name of the S3 bucket to store the Glue extra pyfiles"
  type        = string
}

variable "source_code_s3_folder" {
  description = "The name of the S3 folder to store the Glue extra pyfiles"
  type        = string
}

variable "compatible_runtimes" {
  description = "List of compatible runtimes for the Lambda layer"
  type        = list(string)
  default     = ["python3.10"]
}

variable "build_folder" {
  description = "The folder where the build artifacts are stored"
  type        = string
}

