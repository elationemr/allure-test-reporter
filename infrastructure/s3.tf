module "test-data-bucket" {
  source = "git::git@github.com:elationemr/terraform-modules.git//s3"

  project       = local.project
  environment   = local.workspace.environment
  bucket_suffix = "test-data-bucket"

  acl            = "public-read"
  use_encryption = false

  use_versioning = false
}