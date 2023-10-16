# compactacao do lambda .js em .zip
data "archive_file" "fnf-lambda-authorizer-zip" {
  type        = "zip"
  source_file = "${path.module}/fnf-lambda-authorizer.js"
  output_path = "${path.module}/fnf-lambda-authorizer.zip"
}

# configuracao de funcao lambda
resource "aws_lambda_function" "fnf-lambda-authorizer" {
  function_name    = "fnf-lambda-authorizer"
  filename         = "${path.module}/fnf-lambda-authorizer.zip"
  source_code_hash = filebase64sha256("${path.module}/fnf-lambda-authorizer.zip")
  handler          = "fnf-lambda-authorizer.handler"
  role             = aws_iam_role.fnf-lambda-iam-role.arn
  runtime          = "nodejs14.x"
  architectures    = [ "x86_64" ]
  layers           = [ aws_lambda_layer_version.fnf-lambda-authorizer-layer.arn ]
  depends_on = [ data.archive_file.fnf-lambda-authorizer-zip, aws_iam_role.fnf-lambda-iam-role]
    
  environment {
    variables = {
      API_GATEWAY_URL = aws_apigatewayv2_stage.fnf-api-deployment.invoke_url
      API_COGNITO_URL = "https://fast-n-foodious.auth.us-east-1.amazoncognito.com/"
    }
  }
}

# configuracao de layer axios necessaria no lambda
resource "aws_lambda_layer_version" "fnf-lambda-authorizer-layer" {
  layer_name = "axios"
  compatible_runtimes = ["nodejs14.x"]
  compatible_architectures = [ "x86_64" ]
  source_code_hash   = filebase64sha256("fnf-lambda-authorizer-layer.zip") 
  filename           = "fnf-lambda-authorizer-layer.zip"
}