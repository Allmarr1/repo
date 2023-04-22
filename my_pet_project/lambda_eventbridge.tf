provider "aws" {
  region = "us-east-1"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda.py"
  output_path = "example_lambda.zip"
}

resource "aws_lambda_function" "example_lambda" {
  filename         = "example_lambda.zip"
  function_name    = "example_lambda"
  role             = aws_iam_role.example_lambda.arn
  handler          = "example_lambda.lambda_handler"
  runtime          = "python3.8"
}

resource "aws_iam_role" "example_lambda" {
  name = "example_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example_lambda" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.example_lambda.name
}

resource "aws_cloudwatch_event_rule" "example_event_rule" {
  name        = "example_event_rule"
  description = "An example EventBridge rule"

  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "example_event_target" {
  target_id = "example_lambda_target"
  arn       = aws_lambda_function.example_lambda.arn
  rule      = aws_cloudwatch_event_rule.example_event_rule.name
}