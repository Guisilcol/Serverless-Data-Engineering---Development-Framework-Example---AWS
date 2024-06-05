
resource "aws_s3_bucket" "source_code_bucket" {
    bucket = var.source_code_bucket_name
    force_destroy = false
    
}