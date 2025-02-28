import json
import pymongo
import os

# MongoDB connection string
# MONGO_URI = os.environ['MONGO_URI']
MONGO_URI = "mongodb+srv://shuoliuflybuys:shuoliuflybuys@cluster0.rmy3i.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

client = pymongo.MongoClient(MONGO_URI)
db = client['mydatabase']
collection = db['users']

def lambda_handler(event, context):
    users = list(collection.find({}, {'_id': 0}))  # Exclude the MongoDB internal _id field
    
    return {
        'statusCode': 200,
        'body': json.dumps(users)
    }