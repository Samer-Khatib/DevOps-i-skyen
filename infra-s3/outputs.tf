output "bucket_name" { value = aws_s3_bucket.data.bucket }
output "bucket_arn"  { value = aws_s3_bucket.data.arn }
output "region"      { value = var.aws_region }
