resource "aws_iam_role" "instance_role" {
  name               = "${local.project}-${local.workspace.environment}-${local.service_key}-ir"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

  tags = merge(local.default_tags, {
    Name = "${local.workspace.environment}-${local.service_key}-ir"
  })
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
    }
  }
}


resource "aws_iam_role_policy_attachment" "instance_role_policy_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = aws_iam_policy.instance_policy.arn
}

resource "aws_iam_policy" "task_policy" {
  name   = "${local.project}-${local.workspace.environment}-${local.service_key}-tp"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": [
                "dynamodb:*"
            ],
            "Effect": "Allow",
            "Resource": [
              "arn:aws:dynamodb:${local.workspace.region}:${local.workspace.aws_account_id}:table/*${local.workspace.environment}-insurance-table",
              "arn:aws:dynamodb:${local.workspace.region}:${local.workspace.aws_account_id}:table/*${local.workspace.environment}-insurance-table/index/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "task_role" {
  name               = "${local.workspace.environment}-${local.service_key}-tr"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

  tags = merge(local.default_tags, {
    Name = "${local.workspace.environment}-${local.service_key}-tr"
  })
}

resource "aws_iam_role_policy_attachment" "task_role_policy_attachment" {
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.task_policy.arn
}

resource "aws_iam_policy" "instance_policy" {
  name   = "${local.workspace.environment}-${local.service_key}-ip"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ecs:Describe*",
                "ecs:List*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecs:CreateCluster",
                "ecs:DeregisterContainerInstance",
                "ecs:DiscoverPollEndpoint",
                "ecs:Poll",
                "ecs:RegisterContainerInstance",
                "ecs:StartTelemetrySession",
                "ecs:Submit*",
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "secretsmanager:GetSecretValue"
            ],
            "Resource": "*"
        },
        {
            "Action": [
                "ecs:DeleteCluster",
                "ecs:DeregisterContainerInstance",
                "ecs:ListContainerInstances",
                "ecs:RegisterContainerInstance",
                "ecs:SubmitContainerStateChange",
                "ecs:SubmitTaskStateChange"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:ecs:${local.workspace.region}:${local.workspace.aws_account_id}:cluster/${local.workspace.cluster}"
        },
        {
            "Action": [
                "ecs:DescribeContainerInstances",
                "ecs:DescribeTasks",
                "ecs:ListTasks",
                "ecs:UpdateContainerAgent",
                "ecs:StartTask",
                "ecs:StopTask",
                "ecs:RunTask"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Condition": {
                "ArnEquals": {
                    "ecs:cluster": "arn:aws:ecs:${local.workspace.region}:${local.workspace.aws_account_id}:cluster/${local.workspace.cluster}"
                }
            }
        }
    ]
}
EOF
}