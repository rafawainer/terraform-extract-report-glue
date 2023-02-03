#################### L A M B D A ##########################
#################### L A M B D A ##########################
#################### L A M B D A ##########################
#################### L A M B D A ##########################
#################### L A M B D A ##########################
#################### L A M B D A ##########################
#################### L A M B D A ##########################
resource "aws_lambda_function" "extract_report" {
  function_name     = "terraform-extract-report-glue"
  role              = aws_iam_role.lambda_role.arn
  handler           = "handler_file.py"
  runtime           = "python3.9"
  timeout           = 180
  filename          = "lambdaextractreportglue.zip"
  source_code_hash  = data.archive_file.archive_file_name.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.bucket_name.bucket,
      ACCOUNT_ID = "266070530669",
      REGION = "us-east-1",
    }
  }   

  tags = {
    Terraform   = "True"
    Environment = "Dev"
  }

  /* vpc_config {
    subnet_ids = [
      aws_subnet.private_subnet_first.vpc_id,
      aws_subnet.private_subnet_second.vpc_id
      ]
    security_group_ids = [
        aws_security_group.example.id
        ]
  } */

  depends_on = [
    aws_s3_bucket_policy.bucket_policy_name,
    aws_iam_role_policy_attachment.role_policy_attachment
  ]
}


data "archive_file" "archive_file_name" { 
  type = "zip"  
  source_file = "../python/handler_file.py" 
  output_path = "lambdaextractreportglue.zip"
}

#################### V P C ##########################
#################### V P C ##########################
#################### V P C ##########################
#################### V P C ##########################
#################### V P C ##########################
#################### V P C ##########################
resource "aws_vpc" "example" {
  cidr_block = "172.31.0.0/16"

  tags = {
    Name = "Example VPC"
  }
}

resource "aws_subnet" "private_subnet_first" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "172.31.16.0/20"

  tags = {
    Name = "Example Public Subnet"
  }
}

resource "aws_subnet" "private_subnet_second" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "172.31.0.0/20"

  tags = {
    Name = "Example Public Subnet"
  }
}

#################### S E C U R I T Y  G R O U P ##########################
#################### S E C U R I T Y  G R O U P ##########################
#################### S E C U R I T Y  G R O U P ##########################
#################### S E C U R I T Y  G R O U P ##########################
#################### S E C U R I T Y  G R O U P ##########################
#################### S E C U R I T Y  G R O U P ##########################
#################### S E C U R I T Y  G R O U P ##########################
#################### S E C U R I T Y  G R O U P ##########################
resource "aws_security_group" "example" {
  name        = "example_sg"
  description = "Example security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#################### S 3  B U C K E T ##########################
#################### S 3  B U C K E T ##########################
#################### S 3  B U C K E T ##########################
#################### S 3  B U C K E T ##########################
#################### S 3  B U C K E T ##########################
#################### S 3  B U C K E T ##########################
#################### S 3  B U C K E T ##########################
resource "aws_s3_bucket" "bucket_name" {
  bucket = "terraform-s3-extract-report"
}

resource "aws_s3_bucket_policy" "bucket_policy_name" {
  bucket = aws_s3_bucket.bucket_name.bucket

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "PolicyAllowS3",
  "Statement": [
    {
      "Sid": "AllowS3ToLambda",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.lambda_role.arn}"
      },
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.bucket_name.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.bucket_name.bucket}/*"
      ]
    }
  ]
}
EOF
}

#################### I A M  R O L E ##########################
#################### I A M  R O L E ##########################
#################### I A M  R O L E ##########################
#################### I A M  R O L E ##########################
#################### I A M  R O L E ##########################
#################### I A M  R O L E ##########################
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#################### I A M  P O L I C Y ##########################
#################### I A M  P O L I C Y ##########################
#################### I A M  P O L I C Y ##########################
#################### I A M  P O L I C Y ##########################
#################### I A M  P O L I C Y ##########################
#################### I A M  P O L I C Y ##########################
#################### I A M  P O L I C Y ##########################
resource "aws_iam_policy" "policy_name" {
  name = "policy_name"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::bucket_name/*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "glue:GetTable",
        "glue:GetTables",
        "glue:GetDatabase",
        "glue:GetDatabases"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  policy_arn = aws_iam_policy.policy_name.arn
  role       = aws_iam_role.lambda_role.name
}


#################### E V E N T  R U L E ##########################
#################### E V E N T  R U L E ##########################
#################### E V E N T  R U L E ##########################
#################### E V E N T  R U L E ##########################
#################### E V E N T  R U L E ##########################
#################### E V E N T  R U L E ##########################
#################### E V E N T  R U L E ##########################
/* resource "aws_cloudwatch_event_rule" "event_rule_name" {
  name        = "terraform-extract-report-glue"
  description = "Event rule to trigger the Lambda function every 2 minutes"

  schedule_expression = "cron(0/2 * ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_target" "event_target_name" {
  rule      = "${aws_cloudwatch_event_rule.event_rule_name.name}"
  target_id = "CloudwatchToStartExtractReportGlueLambda"
  arn       = "${aws_lambda_function.extract_report.arn}"
}

resource "aws_lambda_permission" "lambda_permission_name" {
  statement_id = "AllowExecutionFromCloudWatchToExtractReportGlueLambda"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.extract_report.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.event_rule_name.arn
} */