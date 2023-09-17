resource "aws_iam_role" "pet_step_function_role" {
  name                = "pet_step_function_role"
  assume_role_policy  = data.aws_iam_policy_document.step_function_assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.invoke_lambda.arn, aws_iam_policy.cloudwatch_logs_step_function.arn]
}

data "aws_iam_policy_document" "step_function_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "invoke_lambda" {
  name = "invoke_lambda_send_SNS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["sns:*", "lambda:InvokeFunction"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_logs_step_function" {
  name = "cloudwatch_logs_step_function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:CreateLogDelivery",
                "logs:GetLogDelivery",
                "logs:UpdateLogDelivery",
                "logs:DeleteLogDelivery",
                "logs:ListLogDeliveries",
                "logs:PutResourcePolicy",
                "logs:DescribeResourcePolicies",
                "logs:DescribeLogGroups"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}