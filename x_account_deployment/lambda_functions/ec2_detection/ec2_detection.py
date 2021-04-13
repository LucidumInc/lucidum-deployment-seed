import boto3
import json
import time
import os



def lambda_handler(event, context):

    instance_id = event['detail']['instance-id']
    state = event['detail']['state']

    ec2_client = boto3.client('ec2')
    instance_info = ec2_client.describe_instances(InstanceIds=[instance_id])
    instance = instance_info['Reservations'][0]['Instances'][0]

    s3 = boto3.client('s3')
    json_object = str(instance_info)

    s3.put_object(
        Body=str(json.dumps(json_object)),
        Bucket=os.environ['s3_bucket'],
        # /lucidum/ec2/yyyy-mm-dd/<instanceId>-created.json
        Key=f"/lucidum/ec2/{time.strftime('%Y%m%d')}/{str(instance_id)}-{str(state)}.json"
    )
