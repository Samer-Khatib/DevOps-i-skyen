variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "bucket_name" {
  type = string
  description = "S3 bucket such as kandidat-123-data"
}

variable "transition_days" {
  type    = number
  default = 7
}

variable "expire_days" {
  type    = number
  default = 30
}
