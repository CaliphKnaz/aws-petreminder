
resource "aws_lambda_permission" "pet_apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pet_api_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.pet_api_gateway.id}/*/${aws_api_gateway_method.pet_api_gateway.http_method}${aws_api_gateway_resource.pet_api_gateway.path}"
}
output "lambda_permission_source_arn" {
    value = aws_lambda_permission.pet_apigw_lambda.source_arn
  
}
resource "aws_lambda_function" "pet_api_lambda_function" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "modules/pet-reminder-app/pet_api_lambda_code.zip"
  function_name = "api_lambda"
  role          = aws_iam_role.pet_lambda_role.arn
  handler       = "pet_api_lambda_code.lambda_handler"


  runtime = "python3.9" 
  
  depends_on = [ aws_iam_role.pet_lambda_role ]
  }


output "api_lambda_arn" {
  value = aws_lambda_function.pet_api_lambda_function.arn
  
}
  