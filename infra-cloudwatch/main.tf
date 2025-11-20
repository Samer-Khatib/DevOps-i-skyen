terraform {
  required_version = ">= 1.5.0"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_sns_topic" "alerts" {
  name = "sentiment-alerts-${var.candidate_suffix}"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "latency_high" {
  alarm_name          = "sentiment-latency-high-${var.candidate_suffix}"
  alarm_description   = "Average analysis latency over threshold"
  namespace           = var.metrics_namespace
  metric_name         = var.latency_metric_name # uses default from variables.tf
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 5
  threshold           = var.latency_threshold_seconds
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "sentiment-dashboard-${var.candidate_suffix}"

  dashboard_body = jsonencode({
    widgets = [
      {
        "type" : "metric",
        "x" : 0, "y" : 0, "width" : 12, "height" : 6,
        "properties" : {
          "title" : "Analyses per minute",
          "region" : var.aws_region,
          "view" : "timeSeries",
          "stat" : "Sum",
          "period" : 60,
          "metrics" : [
            [var.metrics_namespace, var.counter_metric_name]
          ]
        }
      },
      {
        "type" : "metric",
        "x" : 12, "y" : 0, "width" : 12, "height" : 6,
        "properties" : {
          "title" : "Average latency (s)",
          "region" : var.aws_region,
          "view" : "timeSeries",
          "stat" : "Average",
          "period" : 60,
          "metrics" : [
            [var.metrics_namespace, var.latency_metric_name]
          ]
        }
      }
    ]
  })
}
