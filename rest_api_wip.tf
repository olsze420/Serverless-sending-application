resource "aws_api_gateway_rest_api" "rest_api_email_sms_wip" {
    name = "sending_api_tf" 
    description = "api for sending email & sms done through terraform"
    endpoint_configuration {
        types = ["REGIONAL"]
        }
}

resource "aws_api_gateway_resource" "rest_api_email_sms_sending_wip" {
    rest_api_id = aws_api_gateway_rest_api.rest_api_email_sms_wip.id
    parent_id = aws_api_gateway_rest_api.rest_api_email_sms_wip.root_resource_id
    path_part = "sending"
}

resource "aws_api_gateway_method" "post_for_lambda" {
    rest_api_id = aws_api_gateway_rest_api.rest_api_email_sms_wip.id
    resource_id = aws_api_gateway_resource.rest_api_email_sms_sending_wip.id
    http_method = "POST"
    authorization = "NONE"
    api_key_required = false
}

resource "aws_api_gateway_method_response" "email_sms_200" {
    rest_api_id = aws_api_gateway_rest_api.rest_api_email_sms_wip.id
    resource_id = aws_api_gateway_resource.rest_api_email_sms_sending_wip.id
    http_method = aws_api_gateway_method.post_for_lambda.http_method 
    status_code = 200 
    response_models = {
        "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration" "lambda_api_handler_integration" { 
    rest_api_id = aws_api_gateway_rest_api.rest_api_email_sms_wip.id 
    resource_id = aws_api_gateway_resource.rest_api_email_sms_sending_wip.id
    http_method = aws_api_gateway_method.post_for_lambda.http_method
    integration_http_method = aws_api_gateway_method.post_for_lambda.http_method 
    type = "AWS_PROXY"
    uri = aws_lambda_function.rest_api_handler.invoke_arn 
}

resource "aws_api_gateway_deployment" "sending_api_deployment" {
    rest_api_id = aws_api_gateway_rest_api.rest_api_email_sms_wip.id
}

resource "aws_api_gateway_stage" "sending_api_stage" {
    rest_api_id = aws_api_gateway_rest_api.rest_api_email_sms_wip.id
    deployment_id = aws_api_gateway_deployment.sending_api_deployment.id
   stage_name = "sending_stage"
}


