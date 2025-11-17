terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.20"
    }
  }
  backend "s3" {
    bucket = "pgr301-terraform-state"
    key    = "infra-cloudwatch/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  namespace    = "SentimentApp-12345"
  common_tags  = {
    project   = "pgr301-exam-2025"
    component = "cloudwatch-obs"
  }
}

resource "aws_sns_topic" "alerts" {
  name = "sentiment-alerts"
  tags = local.common_tags
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# CloudWatch Dashboard referencing custom application metrics.
# Ensure your application publishes metrics: RequestCount, Latency, SentimentScore to the namespace.
resource "aws_cloudwatch_dashboard" "sentiment" {
  dashboard_name = "sentiment-app-dashboard"
  dashboard_body = file("${path.module}/dashboard.json")
}

# Alarm on average Latency > 5 seconds over one 60s period.
resource "aws_cloudwatch_metric_alarm" "latency_high" {
  alarm_name          = "sentiment-latency-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Latency"
  namespace           = local.namespace
  period              = 60
  statistic           = "Average"
  threshold           = 5
  alarm_description   = "Average Latency > 5s in last minute"
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  tags                = local.common_tags
}
