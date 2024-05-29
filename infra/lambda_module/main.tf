data "archive_file" "lambda_artifact" {
  type        = "zip"
  output_path = "${var.output_path}/${var.function_name}.zip"

  source {
    content  = file(var.source_path)
    filename = basename(var.source_path)
  }
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.function_name
  handler          = var.handler
  role             = var.role_arn
  runtime          = var.runtime
  filename         = data.archive_file.lambda_artifact.output_path
  source_code_hash = data.archive_file.lambda_artifact.output_base64sha256
  layers           = var.layers
  timeout          = var.timeout
  memory_size      = var.memory_size
}
