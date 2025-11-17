# infra-cloudwatch

Observability stack for Sentiment application using custom CloudWatch metrics in namespace `SentimentApp-12345`.

Resources:
- SNS topic + email subscription for alerts
- CloudWatch dashboard (request count, average latency, sentiment score)
- CloudWatch alarm on average Latency > 5s (1 minute period)

## Prerequisites
- Terraform >= 1.5.0
- AWS credentials configured (env vars, profile, or instance role)
- Application publishing the following metrics to namespace `SentimentApp-12345`:
  - `RequestCount` (Count per request)
  - `Latency` (Seconds per request)
  - `SentimentScore` (Gauge value 0..1 or similar)

## Inputs
| Name | Description | Type | Default |
|------|-------------|------|---------|
| aws_region | AWS region | string | eu-west-1 |
| alert_email | Email for SNS subscription (must be confirmed) | string | n/a |

## Outputs
| Name | Description |
|------|-------------|
| sns_topic_arn | Alert topic ARN |
| latency_alarm_name | Name of high latency alarm |
| dashboard_name | Dashboard name |

## Backend
S3 backend configured in `main.tf`:
```
 bucket = "pgr301-terraform-state"
 key    = "infra-cloudwatch/terraform.tfstate"
 region = "eu-west-1"
```

## Usage
Example `terraform.tfvars`:
```hcl
alert_email = "you@example.com"
```

Commands:
```bash
cd infra-cloudwatch
terraform init
terraform validate
terraform plan -out plan.tfplan
terraform apply plan.tfplan
```

After apply, confirm the SNS subscription via the email you receive.

## Updating Metrics
If you change metric names in the application, update `dashboard.json` and the `aws_cloudwatch_metric_alarm` accordingly.

## Destroy
```bash
terraform destroy -auto-approve
```
