terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "data" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "v" {
  bucket = aws_s3_bucket.data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lc" {
  bucket = aws_s3_bucket.data.id

  rule {
    id     = "midlertidig-rule"
    status = "Enabled"

    filter {
      prefix = "midlertidig/"
    }

    transition {
      days          = var.transition_days
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = var.expire_days
    }
  }
}
