import json

def lambda_handler(event, context):
    print(event)
    ip_address = event['requestContext']['http']['sourceIp']
    
    return {
        'statusCode': 200,
        'body': json.dumps({'ip_address': ip_address})
    }