variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "handler" {
  description = "The function entry point in the code"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role for the Lambda function"
  type        = string
}

variable "runtime" {
  description = "The runtime environment for the Lambda function"
  type        = string
  default     = "python3.10"
}

variable "source_path" {
  description = "The path to the source code file for the Lambda function"
  type        = string
}

variable "output_path" {
  description = "The output path for the zipped Lambda function"
  type        = string
}

variable "layers" {
  description = "List of Lambda layer ARNs"
  type        = list(string)
  default     = []
}

variable "timeout" {
  description = "The amount of time that Lambda allows a function to run before stopping it"
  type        = number
  default     = 15
}

variable "memory_size" {
  description = "The amount of memory available to the function at runtime"
  type        = number
  default     = 128
}
