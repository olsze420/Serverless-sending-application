import boto3 # type: ignore


client = boto3.client("sns")
def lambda_handler(event, context):
    client.publish(
        PhoneNumber = event['phoneNumber'],
        Message = event['message']
    )
    return "sms sent"