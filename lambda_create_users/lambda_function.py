import json
import pymongo
import uuid
import os

# MongoDB connection string
# MONGO_URI = os.environ['MONGO_URI']
MONGO_URI = "mongodb+srv://shuoliuflybuys:shuoliuflybuys@cluster0.rmy3i.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

client = pymongo.MongoClient(MONGO_URI)
db = client['mydatabase']
collection = db['users']

def lambda_handler(event, context):
    # print json parsed event 
    print(json.dumps(event))
    user_id = str(uuid.uuid4())
    user_data = event
    user_data['userId'] = user_id
    
    collection.insert_one(user_data)
    
    return {
        'statusCode': 201,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json'
        },
        'body': json.dumps({'message': 'User created', 'userId': user_id})
    }