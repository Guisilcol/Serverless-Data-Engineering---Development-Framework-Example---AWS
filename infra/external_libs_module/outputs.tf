output "layer_arn" {
  description = "The ARN of the created Lambda layer"
  value       = aws_lambda_layer_version.layer.arn
}

output "s3_object_uri" {
  description = "The uri of the S3 object"
  value       = "s3://${var.aws_s3_source_code_bucket_name}/${aws_s3_object.glue_extra_pyfiles_on_s3.key}"
} 