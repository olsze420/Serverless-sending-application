import boto3 # type: ignore

client = boto3.client("ses")
def lambda_handler(event, context):
    response = client.send_email(
    Source='olsze420@gmail.com',
    Destination={
        'ToAddresses': [
            event['destinationEmail'],
        ],
        'CcAddresses': [
            'michal.olszewski@autonomik.pl',
        ]
    },
    Message={
        'Subject': {
            'Data': 'Test email for project 2',
        },
        'Body': {
            'Text': {
                'Data': event['message'],
                
            }
        }
    })

    return event['message']

