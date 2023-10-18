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
  depends_on = [ data.archive_file.fnf-lambda-authorizer-zip, aws_cognito_user.fnf-user]
    
  environment {
    variables = {
      COGNITO_FNF_USER_NAME = aws_cognito_user.fnf-user.username
      COGNITO_FNF_USER_PASSWORD = aws_cognito_user.fnf-user.password
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

# configuracao de layer axios necessaria no lambda
resource "aws_lambda_layer_version" "fnf-lambda-authorizer-layer" {
  layer_name = "axios"
  compatible_runtimes = ["nodejs14.x"]
  compatible_architectures = [ "x86_64" ]
  source_code_hash   = filebase64sha256("fnf-lambda-authorizer-layer.zip") 
  filename           = "fnf-lambda-authorizer-layer.zip"
}