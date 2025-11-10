# infra-s3

Creates S3 bucket for exam results with lifecycle for `midlertidig/`.

## Usage (local)
```powershell
cd infra-s3
ni terraform.tfvars -Value @"
bucket_name     = "kandidat-<nummer>-data"
transition_days = 7
expire_days     = 30
"@
terraform init -backend-config="bucket=pgr301-terraform-state" -backend-config="key=${PWD}/terraform.tfstate" -backend-config="region=eu-west-1"
terraform fmt -check
terraform validate
terraform plan
terraform apply -auto-approve
