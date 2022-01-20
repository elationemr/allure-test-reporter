resource "aws_lambda_function" "generate_report_lambda" {
  filename      = "generate_report_lambda.zip"
  function_name = "generate_report_lambda"
  role          = aws_iam_role.instance_role.arn
  handler       = "function.generate_report"

  s3_bucket = aws_s3_bucket.test_data_bucket.id
  s3_key    = aws_s3_bucket_object.generate_report_lambda.key

  source_code_hash = data.archive_file.generate_report_lambda.output_base64sha256

  runtime = "python3.9"

  environment {
    variables = {
      cluster = local.workspace.cluster
    }
  }
}

data "archive_file" "generate_report_lambda" {
  type = "zip"

  source_dir  = "${path.module}/src/generate-report"
  output_path = "${path.module}/generate-report.zip"
}

resource "aws_s3_bucket_object" "generate_report_lambda" {
  bucket = aws_s3_bucket.test_data_bucket.id

  key    = "generate-report.zip"
  source = data.archive_file.generate_report_lambda.output_path

  etag = filemd5(data.archive_file.generate_report_lambda.output_path)
}