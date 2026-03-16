import json
import boto3
from boto3.dynamodb.conditions import Key

# Initialize DynamoDB resource
# boto3 is the AWS SDK for Python
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('users')

def lambda_handler(event, context):
    """
    Main entry point for Lambda.
    'event' contains all request data from API Gateway.
    'context' contains Lambda runtime info (we don't use it here).
    """
    
    # Get the HTTP method (GET, POST, PUT, DELETE)
    method = event.get('httpMethod', '')
    
    print(f"Received {method} request")  # This logs to CloudWatch
    
    try:
        # ─── CREATE (POST) ───────────────────────────────────────
        if method == 'POST':
            body = json.loads(event['body'])
            
            # Validate required field
            if 'id' not in body:
                return response(400, {'error': 'id field is required'})
            
            # Put item in DynamoDB (creates or replaces)
            table.put_item(Item=body)
            
            r
