resource "aws_api_gateway_rest_api" "fnf-api" {
    name = "fnf-api"
}

resource "aws_api_gateway_resource" "fnf-api-resource" {
    parent_id = aws_api_gateway_rest_api.fnf-api.root_resource_id
    path_part = "/{proxy+}"
    rest_api_id = aws_api_gateway_rest_api.fnf-api.id
}

resource "aws_api_gateway_method" "fnf-api-method" {
  rest_api_id   = aws_api_gateway_rest_api.fnf-api.id
  resource_id   = aws_api_gateway_resource.fnf-api-resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "fnf-api-integration" {
  rest_api_id          = aws_api_gateway_rest_api.fnf-api.id
  resource_id          = aws_api_gateway_resource.fnf-api-resource.id
  http_method          = aws_api_gateway_method.fnf-api-method.http_method
  integration_http_method = "ANY"
  type                 = "HTTP_PROXY"
  uri                  = aws_lb_target_group.fnf-lb-target-group.arn
}

resource "aws_api_gateway_deployment" "fnf-api-deployment" {
  rest_api_id = aws_api_gateway_rest_api.fnf-api.id
  stage_name  = "production"
}

resource "aws_api_gateway_vpc_link" "fnf-vpc-link" {
    name = "fnf-vpc-link"
    target_arns = [ aws_alb.fnf-alb.arn ]
    depends_on = [
        aws_alb.fnf-alb,
        aws_api_gateway_rest_api.fnf-api
    ]
}

output "fnf-api-url" {
  value = "https://${aws_api_gateway_deployment.fnf-api-deployment.invoke_url}"
}