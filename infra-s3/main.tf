terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.20"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "data" {
  bucket = var.bucket_name
  tags   = local.common_tags
}

resource "aws_s3_bucket_versioning" "v" {
  bucket = aws_s3_bucket.data.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "enc" {
  bucket = aws_s3_bucket.data.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}

resource "aws_s3_bucket_public_access_block" "pab" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "lc" {
  bucket = aws_s3_bucket.data.id

  rule {
    id     = "midlertidig-rule"
    status = "Enabled"

    filter { prefix = "midlertidig/" }

    transition {
      days          = var.transition_days
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = var.expire_days
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lc_default" {
  bucket = aws_s3_bucket.data.id
  rule {
    id     = "default-keep"
    status = "Disabled"
  }
}

locals {
  common_tags = {
    project   = "pgr301-exam-2025"
    component = "s3-data"
  }
}

// Tagging is handled via the `tags` argument on the bucket resource in AWS provider v4+
