
resource "aws_s3_object" "source_code" {
    bucket = var.source_code_bucket
    key    = var.source_code_object_key
    source = var.source_path

    source_hash = filebase64sha256(var.source_path)
}

resource "aws_glue_job" "this" {
    name                = var.job_name
    description         = var.job_description
    role_arn            = var.role_arn
    max_retries         = 0
    number_of_workers   = var.number_of_workers
    worker_type         = var.worker_type
    glue_version        = var.glue_version

    command {
        name            = var.glue_job_type
        script_location = "s3://${var.source_code_bucket}/${aws_s3_object.source_code.key}"
        python_version  = var.python_version
    }

    default_arguments = {
      "--extra-py-files"    = length(var.additional_python_packages) > 0 ? join(",", var.additional_python_packages) : null
    }

    execution_property {
        max_concurrent_runs = 1
    }
    
}
