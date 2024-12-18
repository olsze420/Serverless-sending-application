resource "aws_ssm_parameter" "state_function_arn" {
    name = "state_function_arn_sms_email"
    type = "String"
    value = aws_sfn_state_machine.email_sms_state_machine.arn
} 