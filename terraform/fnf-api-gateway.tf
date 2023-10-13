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

resource "aws_apigatewayv2_route" "fnf-api-route" {
  api_id = aws_apigatewayv2_api.fnf-api.id
  route_key = "ANY /{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.fnf-api-integration.id}"
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
