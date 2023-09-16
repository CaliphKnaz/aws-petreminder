resource "aws_lambda_function" "pet_lambda_function" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "modules/pet-reminder-app/pet_lambda_code.zip"
  function_name = "email_reminder_function"
  role          = aws_iam_role.pet_lambda_role.arn
  handler       = "index.handler"


  runtime = "python3.9" 
  
  depends_on = [ aws_iam_role.pet_lambda_role ]
  }

  