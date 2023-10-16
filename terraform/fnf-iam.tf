resource "aws_iam_role" "fnf-lambda-iam-role" {
  name = "fnf-lambda-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "fnf-lambda-iam-policy" {
  name        = "fnf-lambda-iam-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = ["arn:aws:logs:*:*:*"]
    },
    {
      Effect = "Allow",
      "Action": [
          "apigateway:InvokeApi",
          "apigateway:InvokeResource",
          "apigateway:InvokeMethod",
          "cognito-idp:AdminInitiateAuth",
          "cognito-idp:AdminRespondToAuthChallenge",
          "cognito-idp:AdminUserGlobalSignOut"
      ],
      Resource = ["*"]
    }]
  })
}

resource "aws_lambda_permission" "fnf-lambda-permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fnf-lambda-authorizer.function_name
  principal     = "apigateway.amazonaws.com"
}

# resource "aws_lambda_permission" "fnf-lambda-permission-token" {
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.fnf-lambda-authorizer.function_name
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${aws_apigatewayv2_api.fnf-api.execution_arn}/*/*/oauth2/token"
# }

# resource "aws_lambda_permission" "fnf-lambda-permission-identifica" {
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.fnf-lambda-authorizer.function_name
#   principal     = "apigateway.amazonaws.com"
  
#   source_arn = "${aws_apigatewayv2_api.fnf-api.execution_arn}/*/*/{proxy+}"
# }

# resource "aws_iam_role" "fnf-gateway-iam-role" {
#   name = "api-gateway-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Action = "sts:AssumeRole",
#       Effect = "Allow",
#       Principal = {
#         Service = "apigateway.amazonaws.com"
#       }
#     }]
#   })
# }

# resource "aws_iam_policy" "fnf-gateway-iam-policy" {
#   name        = "api-gateway-policy"
#   description = "Policy for API Gateway"
  
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect   = "Allow",
#       Action   = "lambda:InvokeFunction",
#       Resource = aws_lambda_function.fnf-lambda-authorizer.arn
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "fnf-gateway-iam-policy_attachment" {
#   policy_arn = aws_iam_policy.fnf-gateway-iam-policy.arn
#   role      = aws_iam_role.fnf-gateway-iam-role.name
# }

resource "aws_iam_role_policy_attachment" "fnf-lambda-iam-policy-attachment" {
  policy_arn = aws_iam_policy.fnf-lambda-iam-policy.arn
  role = aws_iam_role.fnf-lambda-iam-role.name
}