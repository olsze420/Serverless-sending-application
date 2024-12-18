data "archive_file" "ses_zip" {
    type = "zip"
    source_file = "ses_function.py"
    output_path = "ses_function.zip"
}

resource "aws_lambda_function" "email_function" {
    filename = data.archive_file.ses_zip.output_path
    function_name = "email_function"
    role = aws_iam_role.lambda_project2_role.arn
    handler = "ses_function.lambda_handler"
    runtime = "python3.10"
    architectures = ["x86_64"]
}

data "archive_file" "sns_zip" {
    type = "zip"
    source_file = "sns_function.py"
    output_path = "sns_function.zip"
}

resource "aws_lambda_function" "sms_function" { 
    filename = data.archive_file.sns_zip.output_path
    function_name = "sms_function"
    role = aws_iam_role.lambda_project2_role.arn
    handler = "sns_function.lambda_handler"
    runtime = "python3.10"
    architectures = ["x86_64"]
}

data "archive_file" "rest_api_handler_zip" {
    type = "zip"
    source_file = "rest_api_handler.py"
    output_path = "rest_api_handler.zip"
}

resource "aws_lambda_function" "rest_api_handler" {
  filename = data.archive_file.rest_api_handler_zip.output_path
  function_name = "rest_api_handler"
  role = aws_iam_role.lambda_project2_role.arn
  handler = "rest_api_handler.lambda_handler"
  runtime = "python3.10"
  architectures = ["x86_64"]
}