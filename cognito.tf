# AWS Cognito Identity Pool
resource "aws_cognito_identity_pool" "hama_identity_pool" {
  allow_classic_flow               = false
  allow_unauthenticated_identities = true
  identity_pool_name               = "hama-user-identity-pool"

  cognito_identity_providers {
    client_id               = "5lgtssohmht73jqrpl259obu1v"
    provider_name           = "cognito-idp.ap-northeast-2.amazonaws.com/ap-northeast-2_IV1XOFUcn"
    server_side_token_check = false
  }

  cognito_identity_providers {
    client_id               = "6jlvvpfhkaqhbc0a6l9avmam2u"
    provider_name           = "cognito-idp.ap-northeast-2.amazonaws.com/ap-northeast-2_X3lYDAFiw"
    server_side_token_check = false
  }
}

# AWS Cognito User Pool
resource "aws_cognito_user_pool" "hama_user_pool" {
  name                = "hama-user-pool"
  mfa_configuration   = "OFF"
  deletion_protection = "INACTIVE"
  auto_verified_attributes = ["email"]
  username_attributes     = ["email"]

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    password_history_size            = 0
    temporary_password_validity_days = 7
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "admin_only"
      priority = 1
    }
  }

  user_attribute_update_settings {
    attributes_require_verification_before_update = ["email"]
  }

  username_configuration {
    case_sensitive = false
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }
}

# AWS Cognito User Pool Client
resource "aws_cognito_user_pool_client" "hama_user_pool_client" {
  user_pool_id                         = aws_cognito_user_pool.hama_user_pool.id
  name                                 = "hama-web-client"
  allowed_oauth_flows_user_pool_client = false
  enable_token_revocation              = true
  prevent_user_existence_errors        = "ENABLED"
  access_token_validity                = 60  # minutes
  id_token_validity                    = 60  # minutes
  refresh_token_validity               = 30  # days

  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  read_attributes  = ["address", "birthdate", "email", "email_verified", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "phone_number_verified", "picture", "preferred_username", "profile", "updated_at", "website", "zoneinfo"]
  write_attributes = ["address", "birthdate", "email", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "picture", "preferred_username", "profile", "updated_at", "website", "zoneinfo"]

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}
