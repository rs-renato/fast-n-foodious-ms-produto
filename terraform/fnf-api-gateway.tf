resource "aws_apigatewayv2_api" "fnf-api" {
  name = "fnf-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "fnf-api-integration" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  integration_type = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri = aws_lb_listener.fnf-alb-http.arn
  connection_type = "VPC_LINK"
  connection_id = aws_apigatewayv2_vpc_link.fnf-vpc-link.id
}

# Integração para a rota POST /oauth2/token
resource "aws_apigatewayv2_integration" "fnf-api-integration-oauth" {
  api_id           = aws_apigatewayv2_api.fnf-api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.fnf-lambda-authorizer.invoke_arn
  integration_method = "POST" 
  passthrough_behavior = "WHEN_NO_MATCH"
  depends_on = [ aws_lambda_function.fnf-lambda-authorizer ]
}

resource "aws_apigatewayv2_route" "fnf-api-route" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  route_key = "ANY /{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.fnf-api-integration.id}"
  authorizer_id = aws_apigatewayv2_authorizer.fnf-api-authorizer.id
  depends_on = [ aws_apigatewayv2_authorizer.fnf-api-authorizer ]
  authorization_type = "JWT"
}

resource "aws_apigatewayv2_route" "fnf-api-route-token" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  route_key = "POST /oauth2/token"
  target = "integrations/${aws_apigatewayv2_integration.fnf-api-integration-oauth.id}"
}

# Authorizer JWT para a Rota JWT
resource "aws_apigatewayv2_authorizer" "fnf-api-authorizer" {
  api_id             = aws_apigatewayv2_api.fnf-api.id
  authorizer_type    = "JWT"
  identity_sources    = ["$request.header.Authorization"]
  name                = "fnf-authorizer"
  jwt_configuration {
    issuer = "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_PlukopjcO"
    audience = ["4g8l0kqfl9dpa080ep5bir7lp0"]
  }
}

resource "aws_apigatewayv2_vpc_link" "fnf-vpc-link" {
  name = "fnf-vpc-link"
  security_group_ids = [aws_security_group.fnf-lb-security-group.id]
  subnet_ids = [aws_subnet.fnf-subnet-private1-us-east-1a.id, aws_subnet.fnf-subnet-private2-us-east-1b.id]
}

resource "aws_apigatewayv2_stage" "fnf-api-deployment" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  name = "$default"
  auto_deploy = true
}

output "fnf-api-url" {
  value = aws_apigatewayv2_stage.fnf-api-deployment.invoke_url
}
