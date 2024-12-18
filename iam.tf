data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_project2_role" {
  name               = "lambda_project2_sns_ses_step"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_project2_policy_document" {
  statement {
    effect    = "Allow"
    actions   = ["sns:*", "ses:*", "states:*", "ssm:*"]
    resources = ["*"]
  }
  statement {
        effect = "Allow"
        actions = [
            "sms-voice:DescribeVerifiedDestinationNumbers",
            "sms-voice:CreateVerifiedDestinationNumber",
            "sms-voice:SendDestinationNumberVerificationCode",
            "sms-voice:SendTextMessage",
            "sms-voice:DeleteVerifiedDestinationNumber",
            "sms-voice:VerifyDestinationNumber",
            "sms-voice:DescribeAccountAttributes",
            "sms-voice:DescribeSpendLimits",
            "sms-voice:DescribePhoneNumbers",
            "sms-voice:SetTextMessageSpendLimitOverride",
            "sms-voice:DescribeOptedOutNumbers",
            "sms-voice:DeleteOptedOutNumber"
        ]
        resources = ["*"]
    }
   
}

resource "aws_iam_policy" "lambda_project2_policy" {
  name        = "lambda_project2_policy"
  description = "Allow all access to sns, ses & step functions for Lambda"
  policy      = data.aws_iam_policy_document.lambda_project2_policy_document.json
}

resource "aws_iam_role_policy_attachment" "attach_lambda_project2_policy" {
  role       = aws_iam_role.lambda_project2_role.name
  policy_arn = aws_iam_policy.lambda_project2_policy.arn
}

data "aws_iam_policy_document" "step_assume_role" {
  statement {
    effect = "Allow"
    
    principals {
      type = "Service"
      identifiers = ["states.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "states_project2_role" {
  name = "states_project2_invoke"
  assume_role_policy = data.aws_iam_policy_document.step_assume_role.json
}

data "aws_iam_policy_document" "states_project_2_policy_document" {
  statement {
    effect = "Allow"
    actions = ["lambda:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "states_project2_policy" {
  name = "states_project2_policy"
  description = "Allow all access to lambda for states"
  policy = data.aws_iam_policy_document.states_project_2_policy_document.json
}

resource "aws_iam_role_policy_attachment" "attach_states_project2_policy" { 
  role = aws_iam_role.states_project2_role.name
  policy_arn = aws_iam_policy.states_project2_policy.arn
}


resource "aws_iam_role_policy_attachment" "lambda_basic" { ## NEW!!
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.lambda_project2_role.name
}

resource "aws_lambda_permission" "api_lambda" {
  statement_id = "AllowExecutionFromApiGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rest_api_handler.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.rest_api_email_sms.execution_arn}*"
}

resource "aws_lambda_permission" "tf_api_lambda" {
  statement_id = "AllowExecutionFromTfApiGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rest_api_handler.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.rest_api_email_sms_wip.execution_arn}*"
}