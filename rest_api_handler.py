import boto3 # type: ignore
import json

sfn_client = boto3.client('stepfunctions')
ssm_client = boto3.client('ssm')

state_machine_parameter = ssm_client.get_parameter(Name = "state_function_arn_sms_email")["Parameter"]["Value"]

def lambda_handler(event, context): 
    sfn_client.start_execution(
        stateMachineArn = state_machine_parameter,
        input = event['body']
    )
    return {
        "statusCode" : 200, 
        "body" : json.dumps(
            {"Status" : "Instruction sent to the REST API Handler"}
        )
    }