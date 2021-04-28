import json
import boto3
import time
import datetime
import os

def lambda_handler(event, context):
    
    instance_id = event['detail']['instance-id']
    state = event['detail']['state']

    ec2_client = boto3.client('ec2')
    instance_info = ec2_client.describe_instances(InstanceIds=[instance_id])
    instance = instance_info['Reservations'][0]['Instances'][0]
    instance['lambda_ts'] = int(time.time())
    
    s3 = boto3.client('s3')
    
    s3.put_object(
        Body=json.dumps(instance, default=datetime_handler),
        Bucket=os.environ['s3_bucket'], # is os.environ with respect to where this lambda runs? 
        # /lucidum/ec2/yyyy-mm-dd/ec2<instanceId>-created.json
        Key=f"ec2/{time.strftime('%Y%m%d')}/ec2-{str(instance_id)}-{str(state)}.json"
    )



def datetime_handler(x):
    if isinstance(x, datetime.datetime):
        return x.isoformat()
    raise TypeError("Unknown type")
