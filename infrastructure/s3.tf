module "test-data-bucket" {
  source = "git::git@github.com:elationemr/terraform-modules.git//s3"

  project       = local.project
  environment   = local.workspace.environment
  bucket_suffix = "test-data-bucket"

  acl            = "public-read"
  use_encryption = false

  use_versioning = false

  bucket_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3:Put*"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${local.project}-${local.workspace.environment}-test-data-bucket",
                "arn:aws:s3:::${local.project}-${local.workspace.environment}-test-data-bucket/*"
            ],
            "Principal": {
                "AWS": "arn:aws:sts::${local.workspace.aws_account_id}:assumed-role/*allure-test-reporter-tr*"
            }
        }
    ]
}
POLICY
}