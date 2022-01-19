resource "aws_s3_bucket" "test_data_bucket" {
  bucket        = "${local.project}-${local.workspace.environment}-test-data-bucket"
  acl           = "public-read"
  force_destroy = false
#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm = "AES256"
#       }
#     }
#   }
  tags = local.default_tags
}
