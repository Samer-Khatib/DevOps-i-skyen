variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"
}

variable "metrics_namespace" {
  description = "Micrometer/CloudWatch namespace used by the app"
  type        = string
  default     = "SentimentApp-12345"
}

variable "latency_metric_name" {
  description = "Timer metric name"
  type        = string
  default     = "bedrock.latency.seconds"
}

variable "counter_metric_name" {
  description = "Counter metric name"
  type        = string
  default     = "sentiment.analyses.count"
}

variable "latency_threshold_seconds" {
  description = "Alarm threshold for average latency (seconds)"
  type        = number
  default     = 5
}

variable "candidate_suffix" {
  description = "Suffix to make names unique (e.g., 12345)"
  type        = string
  default     = "12345"
}

variable "alert_email" {
  description = "Email address to receive SNS alerts"
  type        = string
}
