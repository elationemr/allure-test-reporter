import boto3
import os

def generate_report_handler(event, context):
    client = boto3.client('ecs')

    return client.run_task(
        # cluster='arn:aws:ecs:us-west-2:570488747013:cluster/el8-dev-careperformance',
        cluster=os.environ.get('cluster'),
        launchType='FARGATE',
        networkConfiguration={
            'awsvpcConfiguration': {
                'subnets': [
                    'subnet-03e17b0310aa4978b',
                    'subnet-0de20c7cd6fa93cd2,subnet-0bad51598c09f1380',
                ],
                'securityGroups': [
                    'sg-0cc83447363369cc7',
                ],
            }
        },
        taskDefinition='gp-dev-allure-test-reporter'
    )