variable "glue_job_type" {
    description = "The type of Glue job. Can be 'pythonshell' or 'glueetl"
    type        = string
    default     = "pythonshell"
}

variable "source_code_bucket" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "source_code_object_key" {
  description = "The name of the file in the S3 bucket"
  type        = string
}

variable "source_path" {
    description = "The path to the source code file for the Glue job"
    type        = string
} 

variable "glue_version" {
    description = "The version of Glue to use"
    type        = string
    default     = "4.0"
}

variable "python_version" {
    description = "The version of Python to use"
    type        = string
}

variable "job_name" {
    description = "The name of the Glue job"
    type        = string
}

variable "job_description" {
    description = "The description of the Glue job"
    type        = string
}

variable "role_arn" {
    description = "The ARN of the IAM role for the Glue job"
    type        = string
}

variable "number_of_workers" {
    description = "The number of workers to allocate to the Glue job"
    type        = number
}

variable "worker_type" {
    description = "The type of worker to allocate to the Glue job"
    type        = string
}

variable "execution_class" {
    description = "The execution class of the Glue job. Can be FLEX or null"
    type        = string
}

variable "additional_python_packages" {
    description = "A list of additional Python files to include in the Glue job. The files must be on s3 with a .whl extension "
    type        = list(string)
    default     = []
}