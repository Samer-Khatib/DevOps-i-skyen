variable "aws_region" {
  type    = string
  default = "eu-west-1"
  description = "AWS region for CloudWatch resources"
}

variable "alert_email" {
  type        = string
  description = "Email address to subscribe to SNS alerts. Must be confirmed after apply."
}
