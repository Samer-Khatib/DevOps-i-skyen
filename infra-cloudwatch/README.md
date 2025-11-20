# infra-cloudwatch

Creates:
- CloudWatch Dashboard (analysis count, latency, last company count + alarm widget)
- CloudWatch Alarm on average latency
- SNS Topic + Email subscription

## Inputs
- `metrics_namespace` = your Phase 7 namespace (e.g., SentimentApp-12345)
- `alert_email` = your email to receive alerts
- `candidate_suffix` = unique suffix (12345 or your name)

## Apply (bash/PowerShell inside repo root)
```bash
cd infra-cloudwatch

terraform init \
  -backend-config="bucket=pgr301-terraform-state" \
  -backend-config="key=infra-cloudwatch/terraform.tfstate" \
  -backend-config="region=eu-west-1"

terraform plan -var="metrics_namespace=SentimentApp-12345" \
  -var="alert_email=<YOUR_EMAIL>" \
  -var="candidate_suffix=12345"

terraform apply -auto-approve \
  -var="metrics_namespace=SentimentApp-12345" \
  -var="alert_email=<YOUR_EMAIL>" \
  -var="candidate_suffix=12345"
