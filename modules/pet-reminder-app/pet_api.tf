resource "aws_api_gateway_rest_api" "pet_api_gateway" {
  name = "pet_api_gateway"
  endpoint_configuration {
    types = [ "REGIONAL" ]
  }
}

resource "aws_api_gateway_resource" "pet_api_gateway" {
  parent_id   = aws_api_gateway_rest_api.pet_api_gateway.root_resource_id
  path_part   = "petcuddleotron"
  rest_api_id = aws_api_gateway_rest_api.pet_api_gateway.id
  
}

resource "aws_api_gateway_method" "pet_api_gateway" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.pet_api_gateway.id
  rest_api_id   = aws_api_gateway_rest_api.pet_api_gateway.id
}

resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.pet_api_gateway.id
  resource_id = aws_api_gateway_resource.pet_api_gateway.id
  http_method = aws_api_gateway_method.pet_api_gateway.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration" "pet_api_gateway" {
  http_method = aws_api_gateway_method.pet_api_gateway.http_method
  resource_id = aws_api_gateway_resource.pet_api_gateway.id
  rest_api_id = aws_api_gateway_rest_api.pet_api_gateway.id
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri = aws_lambda_function.pet_api_lambda_function.invoke_arn
}

resource "aws_api_gateway_integration_response" "options_integration_200" {
  rest_api_id = aws_api_gateway_rest_api.pet_api_gateway.id
  resource_id = aws_api_gateway_resource.pet_api_gateway.id
  http_method = aws_api_gateway_method.pet_api_gateway.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'*'"
  }
}

resource "aws_api_gateway_deployment" "pet_api_gateway" {
  rest_api_id = aws_api_gateway_rest_api.pet_api_gateway.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.pet_api_gateway.id,
      aws_api_gateway_method.pet_api_gateway.id,
      aws_api_gateway_integration.pet_api_gateway.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "pet_api_gateway" {
  deployment_id = aws_api_gateway_deployment.pet_api_gateway.id
  rest_api_id   = aws_api_gateway_rest_api.pet_api_gateway.id
  stage_name    = "prod"
}

output "apigw_invoke_url" {
    value = aws_api_gateway_stage.pet_api_gateway.invoke_url
  
}