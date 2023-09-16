resource "aws_iam_role" "pet_lambda_role" {
  name                = "email_reminder_role"
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role_policy.json 
  managed_policy_arns = [aws_iam_policy.allow_sns_ses.arn, aws_iam_policy.allow_cloudwatch_logs.arn]
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "allow_sns_ses" {
  name = "allow_sns_ses"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ses:*", "sns:*", "states:*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "allow_cloudwatch_logs" {
  name = "cloudwatch_logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}