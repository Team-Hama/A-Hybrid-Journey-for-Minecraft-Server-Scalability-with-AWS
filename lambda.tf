resource "aws_lambda_layer_version" "mysql2_layer" {
  layer_name          = "mysql2-layer"
  compatible_runtimes = ["nodejs18.x"]
  filename            = "${path.module}/layer/mysql2_layer.zip"
}

resource "aws_lambda_function" "Ranking_to_RDS" {
  architectures = ["x86_64"]

  environment {
    variables = {
      RDS_DATABASE = "xconomy"
      RDS_HOST     = module.rdsdb.db_instance_address  # RDS 엔드포인트 동적 참조
      RDS_PASSWORD = var.db_password
      RDS_USER     = var.db_username
    }
  }

  ephemeral_storage {
    size = "512"
  }

  function_name = "Ranking_to_RDS"
  handler       = "index.handler"
  layers        = [aws_lambda_layer_version.mysql2_layer.arn]

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/Ranking_to_RDS"
  }

  filename = "${path.module}/lambda_function/Ranking_to_RDS.zip"

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.lambda_role.arn
  runtime                        = "nodejs18.x"
  timeout                        = 3

  tracing_config {
    mode = "PassThrough"
  }

  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [aws_security_group.all_traffic_allow.id]
    subnet_ids                  = module.vpc.public_subnets
  }

  depends_on = [
    aws_security_group.all_traffic_allow,
    aws_iam_role.lambda_role,
    aws_lambda_layer_version.mysql2_layer
  ]
}

resource "aws_lambda_function" "User_Data" {
  architectures = ["x86_64"]

  ephemeral_storage {
    size = "512"
  }

  function_name = "User_Data"
  handler       = "index.handler"
  layers        = [aws_lambda_layer_version.mysql2_layer.arn]

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/User_Data"
  }

  filename = "${path.module}/lambda_function/User_Data.zip"

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.lambda_role.arn
  runtime                        = "nodejs18.x"
  timeout                        = 3

  tracing_config {
    mode = "PassThrough"
  }

  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [aws_security_group.all_traffic_allow.id]
    subnet_ids                  = module.vpc.public_subnets
  }

  depends_on = [
    aws_security_group.all_traffic_allow,
    aws_iam_role.lambda_role,
    aws_lambda_layer_version.mysql2_layer
  ]
}

resource "aws_lambda_function" "hama_simpleboard" {
  architectures = ["x86_64"]

  ephemeral_storage {
    size = "512"
  }

  function_name = "hama-simpleboard"
  handler       = "index.handler"
  layers        = [aws_lambda_layer_version.mysql2_layer.arn]

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/hama-simpleboard"
  }

  filename = "${path.module}/lambda_function/hama_simpleboard.zip"

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.lambda_role.arn
  runtime                        = "nodejs18.x"
  timeout                        = 3

  tracing_config {
    mode = "PassThrough"
  }

  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [aws_security_group.all_traffic_allow.id]
    subnet_ids                  = module.vpc.public_subnets
  }

  depends_on = [
    aws_security_group.all_traffic_allow,
    aws_iam_role.lambda_role,
    aws_lambda_layer_version.mysql2_layer
  ]
}

resource "aws_lambda_function" "Hama_xconomy_RDS" {
  architectures = ["x86_64"]

  environment {
    variables = {
      DB_NAME     = "xconomy"
      DB_PASSWORD = "test1234"
      DB_USERNAME = "admin"
      RDS_HOST    = "${module.rdsdb.db_instance_address}"
    }
  }

  ephemeral_storage {
    size = "512"
  }

  function_name = "Hama_xconomy_RDS"
  handler       = "index.handler"
  layers        = [aws_lambda_layer_version.mysql2_layer.arn]

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/Hama_xconomy_RDS"
  }

  filename = "${path.module}/lambda_function/Hama_xconomy_RDS.zip"

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.lambda_role.arn
  runtime                        = "nodejs18.x"
  timeout                        = 3

  tracing_config {
    mode = "PassThrough"
  }

  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [aws_security_group.all_traffic_allow.id]
    subnet_ids                  = module.vpc.public_subnets
  }

  depends_on = [
    aws_security_group.all_traffic_allow,
    aws_iam_role.lambda_role,
    aws_lambda_layer_version.mysql2_layer
  ]
}

resource "aws_lambda_function" "Scale_up_by_over_CPU" {
  architectures = ["x86_64"]

  environment {
    variables = {
      GITHUB_TOKEN = "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"
    }
  }

  ephemeral_storage {
    size = "512"
  }

  function_name = "Scale-up-by-over-CPU"
  handler       = "lambda_function.lambda_handler"
  layers        = ["arn:aws:lambda:ap-northeast-2:553035198032:layer:git-lambda2:8"]

  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/Scale-up-by-over-CPU"
  }

  filename = "${path.module}/lambda_function/Scale-up-by-over-CPU.zip"

  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.lambda_role.arn
  runtime                        = "python3.8"
  timeout                        = 10

  tracing_config {
    mode = "PassThrough"
  }

  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [aws_security_group.all_traffic_allow.id]
    subnet_ids                  = module.vpc.public_subnets
  }

  depends_on = [
    aws_security_group.all_traffic_allow,
    aws_iam_role.lambda_role,
  ]
}























resource "aws_iam_role" "lambda_role" {
  name               = "Hama_xconomy_RDS_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}