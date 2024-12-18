resource "aws_api_gateway_rest_api" "rest_api_email_sms" { 
    name = "sending_api"
    description = "api for sending email and sms"
    endpoint_configuration {
        types = ["REGIONAL"]
    }
}

resource "aws_api_gateway_resource" "rest_api_email_sms_sending" { 
    rest_api_id = aws_api_gateway_rest_api.rest_api_email_sms.id
    parent_id = aws_api_gateway_rest_api.rest_api_email_sms.root_resource_id
    path_part = "sending"
}

resource "aws_api_gateway_method" "proxy" { 
    rest_api_id = aws_api_gateway_rest_api.rest_api_email_sms.id
    resource_id = aws_api_gateway_resource.rest_api_email_sms_sending.id
    http_method = "POST"
    authorization = "NONE"
    api_key_required = false
}

resource "aws_api_gateway_integration" "lambda_integration" { 
    rest_api_id = aws_api_gateway_rest_api.rest_api_email_sms.id
    resource_id = aws_api_gateway_resource.rest_api_email_sms_sending.id
    http_method = aws_api_gateway_method.proxy.http_method
    integration_http_method = aws_api_gateway_method.proxy.http_method
    type = "AWS_PROXY"
    uri = aws_lambda_function.rest_api_handler.invoke_arn
}

resource "aws_api_gateway_deployment" "email_sms_deployment" {
    rest_api_id = aws_api_gateway_rest_api.rest_api_email_sms.id
}

resource "aws_api_gateway_stage" "email_sms_stage" {
    deployment_id = aws_api_gateway_deployment.email_sms_deployment.id
    rest_api_id = aws_api_gateway_rest_api.rest_api_email_sms.id
    stage_name = "sending_stage"
}

resource "aws_api_gateway_method_response" "email_sms_response_200" {
    rest_api_id = aws_api_gateway_rest_api.rest_api_email_sms.id
    resource_id = aws_api_gateway_resource.rest_api_email_sms_sending.id
    http_method = aws_api_gateway_method.proxy.http_method
    status_code = "200"
    response_models = {
    "application/json" = "Empty"
  }
} 