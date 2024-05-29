
# ************************* POLICIES AND DOCUMENTS *************************

data "aws_iam_policy_document" "lambda_assume_role_policy_document" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
    }
}

data "aws_iam_policy_document" "glue_assume_role_policy_document" {
    statement {
        sid = ""
        effect = "Allow"

        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["glue.amazonaws.com"]
        }
    
    }
}

data "aws_iam_policy_document" "s3_access_policy_document" {
    statement {

        effect = "Allow"

        actions = [
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:GetObject"
        ]

        resources = [
            "arn:aws:s3:::exemplo-de-spark-join-e-estrategias-de-melhoria-de-performance",
            "arn:aws:s3:::exemplo-de-spark-join-e-estrategias-de-melhoria-de-performance/*"
        ]
    }
}

resource "aws_iam_policy" "s3_access_policy" {
    name        = "S3AccessPolicy"
    description = "Policy to access S3 bucket"
    policy      = data.aws_iam_policy_document.s3_access_policy_document.json
}

data "aws_iam_policy_document" "cloudwatch_logs_policy_document" {
    statement {
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]

        resources = ["*"]
    }
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
    name        = "CloudWatchLogsPolicy"
    description = "Policy to access CloudWatch Logs"
    policy      = data.aws_iam_policy_document.cloudwatch_logs_policy_document.json
}

# ************************* ROLES *************************

# LAMBDA ROLE

resource "aws_iam_role" "general_pipeline_lambda_role" {
    name = "general_pipeline_lambda_role"
    assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "attach_s3_access_policy_on_lambda_role" {
    role       = aws_iam_role.general_pipeline_lambda_role.name
    policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_logs_policy_on_lambda_role" {
    role       = aws_iam_role.general_pipeline_lambda_role.name
    policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}

# GLUE ROLE

resource "aws_iam_role" "general_pipeline_glue_role" {
    name = "general_pipeline_glue_role"
    assume_role_policy = data.aws_iam_policy_document.glue_assume_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "attach_s3_access_policy_on_glue_role" {
    role       = aws_iam_role.general_pipeline_glue_role.name
    policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_logs_policy_on_glue_role" {
    role       = aws_iam_role.general_pipeline_glue_role.name
    policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}