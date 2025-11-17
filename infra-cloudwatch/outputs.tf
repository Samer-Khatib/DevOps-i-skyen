output "sns_topic_arn" {
  value       = aws_sns_topic.alerts.arn
  description = "ARN of the alerts SNS topic"
}

output "latency_alarm_name" {
  value       = aws_cloudwatch_metric_alarm.latency_high.alarm_name
  description = "Name of the latency alarm"
}

output "dashboard_name" {
  value       = aws_cloudwatch_dashboard.sentiment.dashboard_name
  description = "Name of the CloudWatch dashboard"
}
