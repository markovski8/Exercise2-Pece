import json
import boto3

sns_client = boto3.client('sns')
SNS_TOPIC_ARN = 'arn:aws:sns:eu-central-1:471112871708:ordertopic'

def lambda_handler(event, context):
    # Check if the request method is POST
    if event['requestContext']['http']['method'] == 'POST':
        try:
            body = json.loads(event.get('body', '{}'))
        except json.JSONDecodeError:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Invalid JSON format'})
            }

        # Publish any content received to SNS
        try:
            sns_client.publish(
                TopicArn=SNS_TOPIC_ARN,
                Message=json.dumps(body),  # Send the entire body
                Subject='New Message from Lambda'
            )
            return {
                'statusCode': 200,
                'body': json.dumps({'message': 'Message received and sent to SNS'})
            }
        except Exception as sns_error:
            return {
                'statusCode': 500,
                'body': json.dumps({'error': 'Failed to send message to SNS'})
            }

    return {
        'statusCode': 400,
        'body': json.dumps({'error': 'Invalid request method'})
    }
