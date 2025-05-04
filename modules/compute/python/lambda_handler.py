import boto3
import os

def lambda_handler(event, context):
    ses = boto3.client('ses', region_name='us-east-1') 

    response = ses.send_email(
        Source="ahmedosama21049@gmail.com",
        Destination={
            'ToAddresses': [
                "ahmedosama21049@gmail.com",
            ]
        },
        Message={
            'Subject': {
                'Data': 'Infrastructure Change Notification',
                'Charset': 'UTF-8'
            },
            'Body': {
                'Text': {
                    'Data': 'A change has occurred in your infrastructure. Please review the changes made and verify if everything is functioning as expected.',
                    'Charset': 'UTF-8'
                }
            }
        }
    )
    
    print(f"Email sent! Message ID: {response['MessageId']}")
    return {
        'statusCode': 200,
        'body': 'Email sent!'
    }