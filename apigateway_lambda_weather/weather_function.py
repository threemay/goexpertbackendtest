import json
import requests

def lambda_handler(event, context):
    latitude = event['body']['latitude']
    longitude = event['body']['longitude']
    base_url = f"https://api.open-meteo.com/v1/forecast?latitude={latitude}&longitude={longitude}&current_weather=true"
    
    response = requests.get(base_url)
    weather_data = response.json()
    
    return {
        'statusCode': 200,
        'body': json.dumps(weather_data)
    }