resource "aws_cognito_user_pool" "fnf-user-pool" {
    name = "fnf-user-pool"
    username_attributes        = ["email", "phone_number"]
    auto_verified_attributes  = ["email"]

    account_recovery_setting {
      recovery_mechanism {
        priority = 1
        name = "verified_email"
      }
    }
    password_policy {
        minimum_length    = 8
        require_lowercase = true
        require_numbers   = true
        require_symbols   = true
        require_uppercase = true
    }
    
    schema {
      name                = "cpf"
      attribute_data_type = "String"
      required            = false
      mutable             = false
      
      string_attribute_constraints {
        min_length = 0
        max_length = 11
      }
    }

    schema {
      name                = "anonimo"
      attribute_data_type = "Boolean"
      required            = false
      mutable             = false
    }

    lambda_config {
      pre_token_generation = aws_lambda_function.fnf-lambda-pre-token-authorizer.arn
    }
}

resource "aws_cognito_user" "fnf-anonymouns-user" {
  user_pool_id = aws_cognito_user_pool.fnf-user-pool.id
  username     = "anonymous@fnf.com"
  password = "@${random_id.ramdom-domain-number.hex}-${random_id.ramdom-domain-number.hex}-${random_id.ramdom-domain-number.hex}!FnF"
  enabled = true
  attributes = {
    email          = "anonymous@fnf.com"
    anonimo = true
    email_verified = true
  }

  depends_on = [ aws_cognito_user_pool.fnf-user-pool ]
}

resource "aws_cognito_user_pool_client" "fnf-client" {
  name                                  = "fnf-client"
  user_pool_id                          = aws_cognito_user_pool.fnf-user-pool.id
  allowed_oauth_scopes                  = ["fnf-resource-server/read", "fnf-resource-server/write"]
  allowed_oauth_flows                   = [ "client_credentials"]
  generate_secret                       = true
  explicit_auth_flows                   = ["ALLOW_USER_SRP_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  prevent_user_existence_errors         = "ENABLED"

  access_token_validity                 = 1
  id_token_validity                     = 1
  refresh_token_validity                = 30
  enable_token_revocation               = true
  allowed_oauth_flows_user_pool_client = true
  read_attributes                       = ["email"]
  supported_identity_providers = ["COGNITO"]
  depends_on = [ aws_cognito_resource_server.fnf-resource-server ]
}

resource "aws_cognito_resource_server" "fnf-resource-server" {
  user_pool_id       = aws_cognito_user_pool.fnf-user-pool.id
  identifier         = "fnf-resource-server"
  name               = "fnf-resource-server"
  scope {
    scope_name       = "read"
    scope_description= "Read access"
  }
  scope {
    scope_name       = "write"
    scope_description= "Write access"
  }
}

resource "aws_cognito_user_pool_domain" "fnf-domain" {
  domain        = "fast-n-foodious-${random_id.ramdom-domain-number.hex}"
  user_pool_id  = aws_cognito_user_pool.fnf-user-pool.id
  # lifecycle {
  #   ignore_changes = [domain]
  # }
}

# resource "null_resource" "update_lambda_environment" {
#   triggers = {
#     always_run = "${timestamp()}"
#   }

#   depends_on = [aws_cognito_user_pool_domain.fnf-domain]

#   provisioner "local-exec" {
#     command = <<EOT
#       aws lambda update-function-configuration --function-name ${aws_lambda_function.fnf-lambda-pre-token-authorizer.function_name} --environment "Variables={API_COGNITO_URL=https://${aws_cognito_user_pool_domain.fnf-domain.domain}.auth.us-east-1.amazoncognito.com/,API_GATEWAY_URL=${aws_apigatewayv2_stage.fnf-api-deployment.invoke_url}}"
#     EOT
#   }
# }

resource "random_id" "ramdom-domain-number" {
  keepers = {
    first = "${timestamp()}"
  }     
  byte_length = 4
}

output "client_id" {
  value = aws_cognito_user_pool_client.fnf-client.id
}