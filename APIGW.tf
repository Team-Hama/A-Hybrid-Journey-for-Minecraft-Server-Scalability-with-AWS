# API Gateway REST API 생성
resource "aws_api_gateway_rest_api" "hama_web_api" {
  name        = "hama-web-api"
  description = "API Gateway for various Lambda integrations"
}

# Root 리소스 가져오기
data "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.hama_web_api.id
  path        = "/"
}

# 각 리소스 생성 및 Lambda와 통합 설정
# 1. /Ranking 리소스 및 메소드 설정
resource "aws_api_gateway_resource" "ranking_resource" {
  rest_api_id = aws_api_gateway_rest_api.hama_web_api.id
  parent_id   = data.aws_api_gateway_resource.root.id
  path_part   = "Ranking"
}

resource "aws_api_gateway_method" "ranking_method" {
  rest_api_id   = aws_api_gateway_rest_api.hama_web_api.id
  resource_id   = aws_api_gateway_resource.ranking_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "ranking_integration" {
  rest_api_id             = aws_api_gateway_rest_api.hama_web_api.id
  resource_id             = aws_api_gateway_resource.ranking_resource.id
  http_method             = aws_api_gateway_method.ranking_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.Ranking_to_RDS.invoke_arn
}

# 2. /User_Data 리소스 및 메소드 설정
resource "aws_api_gateway_resource" "user_data_resource" {
  rest_api_id = aws_api_gateway_rest_api.hama_web_api.id
  parent_id   = data.aws_api_gateway_resource.root.id
  path_part   = "User_Data"
}

resource "aws_api_gateway_method" "user_data_method" {
  rest_api_id   = aws_api_gateway_rest_api.hama_web_api.id
  resource_id   = aws_api_gateway_resource.user_data_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "user_data_integration" {
  rest_api_id             = aws_api_gateway_rest_api.hama_web_api.id
  resource_id             = aws_api_gateway_resource.user_data_resource.id
  http_method             = aws_api_gateway_method.user_data_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.User_Data.invoke_arn
}

# 3. /article_resource 리소스 및 메소드 설정
resource "aws_api_gateway_resource" "article_resource" {
  rest_api_id = aws_api_gateway_rest_api.hama_web_api.id
  parent_id   = data.aws_api_gateway_resource.root.id
  path_part   = "article_resource"
}

resource "aws_api_gateway_method" "article_method" {
  rest_api_id   = aws_api_gateway_rest_api.hama_web_api.id
  resource_id   = aws_api_gateway_resource.article_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "article_integration" {
  rest_api_id             = aws_api_gateway_rest_api.hama_web_api.id
  resource_id             = aws_api_gateway_resource.article_resource.id
  http_method             = aws_api_gateway_method.article_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hama_simpleboard.invoke_arn
}

# 4. /get_xconomy 리소스 및 메소드 설정
resource "aws_api_gateway_resource" "get_xconomy_resource" {
  rest_api_id = aws_api_gateway_rest_api.hama_web_api.id
  parent_id   = data.aws_api_gateway_resource.root.id
  path_part   = "get_xconomy"
}

resource "aws_api_gateway_method" "get_xconomy_method" {
  rest_api_id   = aws_api_gateway_rest_api.hama_web_api.id
  resource_id   = aws_api_gateway_resource.get_xconomy_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_xconomy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.hama_web_api.id
  resource_id             = aws_api_gateway_resource.get_xconomy_resource.id
  http_method             = aws_api_gateway_method.get_xconomy_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.Hama_xconomy_RDS.invoke_arn
}

# API Gateway 배포 설정
resource "aws_api_gateway_deployment" "hama_web_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.ranking_integration,
    aws_api_gateway_integration.user_data_integration,
    aws_api_gateway_integration.article_integration,
    aws_api_gateway_integration.get_xconomy_integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.hama_web_api.id
  stage_name  = "prod"
}

# Lambda에 API Gateway 호출 권한 추가
resource "aws_lambda_permission" "allow_apigw_invoke_ranking" {
  statement_id  = "AllowAPIGatewayInvokeRanking"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Ranking_to_RDS.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hama_web_api.execution_arn}/*/*/Ranking"
}

resource "aws_lambda_permission" "allow_apigw_invoke_user_data" {
  statement_id  = "AllowAPIGatewayInvokeUserData"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.User_Data.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hama_web_api.execution_arn}/*/*/User_Data"
}

resource "aws_lambda_permission" "allow_apigw_invoke_article" {
  statement_id  = "AllowAPIGatewayInvokeArticle"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hama_simpleboard.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hama_web_api.execution_arn}/*/*/article_resource"
}

resource "aws_lambda_permission" "allow_apigw_invoke_get_xconomy" {
  statement_id  = "AllowAPIGatewayInvokeGetXconomy"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Hama_xconomy_RDS.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hama_web_api.execution_arn}/*/*/get_xconomy"
}

###########################################################
## option
###########################################################

# CORS 설정을 위한 공통 변수
variable "cors_headers" {
  default = {
    Access_Control_Allow_Headers = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    Access_Control_Allow_Methods = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    Access_Control_Allow_Origin  = "'*'"
  }
}

# CORS 설정을 위한 Integration Response Mapping Template
locals {
  cors_integration_response_template = <<EOF
{
  "statusCode": 200,
  "headers": {
    "Access-Control-Allow-Headers": ${var.cors_headers["Access_Control_Allow_Headers"]},
    "Access-Control-Allow-Methods": ${var.cors_headers["Access_Control_Allow_Methods"]},
    "Access-Control-Allow-Origin": ${var.cors_headers["Access_Control_Allow_Origin"]}
  }
}
EOF
}

# OPTIONS 메서드와 통합 응답을 추가하는 함수
locals {
  api_resources = {
    "ranking"         = aws_api_gateway_resource.ranking_resource.id
    "user_data"       = aws_api_gateway_resource.user_data_resource.id
    "article"         = aws_api_gateway_resource.article_resource.id
    "get_xconomy"     = aws_api_gateway_resource.get_xconomy_resource.id
  }
}

# OPTIONS 메서드 및 Integration 설정
resource "aws_api_gateway_method" "options" {
  for_each     = local.api_resources
  rest_api_id  = aws_api_gateway_rest_api.hama_web_api.id
  resource_id  = each.value
  http_method  = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  for_each                  = local.api_resources
  rest_api_id               = aws_api_gateway_rest_api.hama_web_api.id
  resource_id               = each.value
  http_method               = aws_api_gateway_method.options[each.key].http_method
  type                      = "MOCK"
  request_templates         = { "application/json" = "{\"statusCode\": 200}" }
  passthrough_behavior      = "WHEN_NO_MATCH"
  content_handling          = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method_response" "options_method_response" {
  for_each                = local.api_resources
  rest_api_id             = aws_api_gateway_rest_api.hama_web_api.id
  resource_id             = each.value
  http_method             = aws_api_gateway_method.options[each.key].http_method
  status_code             = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  for_each                = local.api_resources
  rest_api_id             = aws_api_gateway_rest_api.hama_web_api.id
  resource_id             = each.value
  http_method             = aws_api_gateway_method.options[each.key].http_method
  status_code             = "200"
  response_templates      = { "application/json" = local.cors_integration_response_template }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = var.cors_headers["Access_Control_Allow_Headers"]
    "method.response.header.Access-Control-Allow-Methods" = var.cors_headers["Access_Control_Allow_Methods"]
    "method.response.header.Access-Control-Allow-Origin"  = var.cors_headers["Access_Control_Allow_Origin"]
  }

  depends_on = [aws_api_gateway_integration.options_integration]
}
