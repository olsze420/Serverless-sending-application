resource "aws_sfn_state_machine" "email_sms_state_machine" { 
    name = "email_sms"
    role_arn = aws_iam_role.states_project2_role.arn
    definition = <<EOF
{
    "Comment": "State machine for sending SMS & email",
    "StartAt": "Select Type of Sending",
    "States": {
        "Select Type of Sending": {
            "Type": "Choice",
            "Choices": [
                {
                    "Variable": "$.typeOfSending",
                    "StringEquals": "email",
                    "Next": "Email"
                },
                {
                    "Variable": "$.typeOfSending",
                    "StringEquals": "sms",
                    "Next": "SMS"
                }
            ]
        },
        "Email": {
            "Type" : "Task",
            "Resource": "${aws_lambda_function.email_function.arn}",
            "End": true
        },
        "SMS": {
            "Type" : "Task",
            "Resource": "${aws_lambda_function.sms_function.arn}",
            "End": true
        }
    }
}
EOF
}