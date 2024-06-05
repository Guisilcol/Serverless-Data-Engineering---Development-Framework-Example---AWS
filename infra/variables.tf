variable "aws_region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "The AWS profile to use"
  default     = "dev"
}

variable "source_code_bucket_name" {
  description = "The S3 bucket to store source code"
  default     = "source-code-bucket-1c87e8a0-a389-47fd-be53-26d27e633263"
}

