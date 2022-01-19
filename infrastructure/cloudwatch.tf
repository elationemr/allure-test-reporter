resource "aws_cloudwatch_event_rule" "test_data_upload" {
  name        = "test-data-upload"
  description = "Capture uploads to test data S3"

  event_pattern = <<EOF
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "eventName": [
      "PutObject"
    ],
    "requestParameters": {
      "bucketName": [
        "${local.project}-${local.workspace.environment}-test-data-bucket"
      ]
    }
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "ecstask" {
  target_id = "SendToECSTask"
  arn       = local.workspace.cluster
  rule      = aws_cloudwatch_event_rule.test_data_upload.name
  role_arn  = aws_iam_role.instance_role.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.test_reporter.arn
  }
}
