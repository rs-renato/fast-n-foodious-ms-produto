# compactacao do lambda .js em .zip
data "archive_file" "fnf-lambda-authorizer-zip" {
  type        = "zip"
  source_file = "${path.module}/fnf-lambda-authorizer.js"
  output_path = "${path.module}/fnf-lambda-authorizer-${formatdate("MM", timestamp())}.zip"
}

# compactacao do lambda pre auth .js em .zip
data "archive_file" "fnf-lambda-pre-token-authorizer-zip" {
  type        = "zip"
  source_file = "${path.module}/fnf-lambda-pre-token-authorizer.js"
  output_path = "${path.module}/fnf-lambda-pre-token-authorizer-${formatdate("MM", timestamp())}.zip"
}

data "archive_file" "fnf-lambda-create-user-zip" {
  type        = "zip"
  source_file = "${path.module}/fnf-lambda-create-user.js"
  output_path = "${path.module}/fnf-lambda-create-user-${formatdate("MM", timestamp())}.zip"
}

# configuracao de funcao lambda
resource "aws_lambda_function" "fnf-lambda-authorizer" {
  function_name    = "fnf-lambda-authorizer"
  filename         = "${path.module}/${data.archive_file.fnf-lambda-authorizer-zip.output_path}"
  source_code_hash = filebase64sha256("${path.module}/${data.archive_file.fnf-lambda-authorizer-zip.output_path}")
  handler          = "fnf-lambda-authorizer.handler"
  role             = aws_iam_role.fnf-lambda-iam-role.arn
  runtime          = "nodejs14.x"
  architectures    = [ "x86_64" ]
  layers           = [ aws_lambda_layer_version.fnf-lambda-authorizer-layer.arn ]
  depends_on = [ data.archive_file.fnf-lambda-authorizer-zip, aws_cognito_user.fnf-anonymouns-user]
    
  environment {
    variables = {
      COGNITO_FNF_USER_NAME = aws_cognito_user.fnf-anonymouns-user.username
      COGNITO_FNF_USER_PASSWORD = aws_cognito_user.fnf-anonymouns-user.password
      API_GATEWAY_URL = aws_apigatewayv2_stage.fnf-api-deployment.invoke_url
      API_COGNITO_URL = "https://${aws_cognito_user_pool_domain.fnf-domain.domain}.auth.us-east-1.amazoncognito.com/"
    }
  }
}

# configuracao de funcao lambda pre auth
resource "aws_lambda_function" "fnf-lambda-pre-token-authorizer" {
  function_name    = "fnf-lambda-pre-token-authorizer"
  filename         = "${path.module}/${data.archive_file.fnf-lambda-pre-token-authorizer-zip.output_path}"
  source_code_hash = filebase64sha256("${path.module}/${data.archive_file.fnf-lambda-pre-token-authorizer-zip.output_path}")
  handler          = "fnf-lambda-pre-token-authorizer.handler"
  role             = aws_iam_role.fnf-lambda-iam-role.arn
  runtime          = "nodejs14.x"
  architectures    = [ "x86_64" ]
  layers           = [ aws_lambda_layer_version.fnf-lambda-authorizer-layer.arn ]
  depends_on = [ data.archive_file.fnf-lambda-pre-token-authorizer-zip]
}


# configuracao de funcao lambda
resource "aws_lambda_function" "fnf-lambda-create-user" {
  function_name    = "fnf-lambda-create-user"
  filename         = "${path.module}/${data.archive_file.fnf-lambda-create-user-zip.output_path}"
  source_code_hash = filebase64sha256("${path.module}/${data.archive_file.fnf-lambda-create-user-zip.output_path}")
  handler          = "fnf-lambda-create-user.handler"
  role             = aws_iam_role.fnf-lambda-iam-role.arn
  runtime          = "nodejs14.x"
  architectures    = [ "x86_64" ]
  depends_on = [ data.archive_file.fnf-lambda-create-user-zip, aws_cognito_user.fnf-anonymouns-user]
    
  environment {
    variables = {
      POOL_ID = aws_cognito_user_pool.fnf-user-pool.id
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