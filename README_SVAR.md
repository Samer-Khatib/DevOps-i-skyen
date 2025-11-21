README_SVAR.md — PGR301 Exam Deliverables
Here is all required evidence for the PGR301 DevOps exam.

Deliverables Checklist
•	S3 bucket created via Terraform with lifecycle rules
•	Terraform CI workflow (validate/plan/apply)
•	SAM template deployed and writing output to /midlertidig/
•	SAM GitHub Action fixed (PR → validate/build, main → deploy)
•	Spring Boot Bedrock app containerized (Java 21, multi-stage)
•	Docker Hub automatic build/push workflow
•	Custom Micrometer → CloudWatch metrics visible in my namespace
•	Terraform-created CloudWatch Dashboard + Alarm + SNS subscription
•	Full evidence gathered in this README_SVAR.md

Infrastructure (S3)
Bucket Name
kandidat-12345-data
Region
eu-west-1
Lifecycle Summary
Prefix midlertidig/
•	Transition to STANDARD_IA after 30 days
•	Expire after 60 days
Evidence
•	Successful CI run:
Terraform S3: https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/19247448977
workflow PR validation: https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/19269922365
workflow deploy run: https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/19538976577
Docker Build & Publish: https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/19540859095

•	AWS CLI inspection:
aws s3api get-bucket-lifecycle-configuration --bucket kandidat-12345-data

SAM Application (Comprehend)
Deployed API Gateway URL
https://si8ygy7wtk.execute-api.eu-west-1.amazonaws.com/Prod/analyze/
Sample Test
curl -s -X POST https://si8ygy7wtk.execute-api.eu-west-1.amazonaws.com/Prod/analyze/ \
  -H "Content-Type: application/json" \
  -d '{"text":"Apple launches new AI features while Microsoft faces security concerns."}'
Evidence of Object Written to S3
Example object written to:
s3://kandidat-12345-data/midlertidig/2025/11/<uuid>.json
CLI confirmation:
aws s3 ls s3://kandidat-12345-data/midlertidig/
Action Evidence
•	PR run (validate/build only): <https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/19269922365>
•	Main run (deploy): <https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/19538976577>

SAM GitHub Workflow (Fixed)
•	PR → sam validate + sam build
•	Main → sam validate + sam build + sam deploy
Workflow path:<img width="2496" height="1240" alt="Screenshot 2025-11-19 163605" src="https://github.com/user-attachments/assets/b38ebd11-6332-468d-bb74-eb5906975423" />

.github/workflows/sam-deploy.yml
Prove:
•	PR run (no deploy): <https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/19269922365>
•	Main run (deploy success): <https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/19538976577>

Docker Image (Spring Boot + Bedrock)
Dockerfile (Multi-stage, Java 21, Corretto Runtime)
Implemented inside sentiment-docker/.
Local Test Command
docker run -e AWS_ACCESS_KEY_ID=... \
  -e AWS_SECRET_ACCESS_KEY=... \
  -e S3_BUCKET_NAME=kandidat-12345-data \
  -p 8080:8080 sentiment-docker:latest
Sample Response
Include the successful /api/analyze response from your local run.
Docker Hub Image
<dockerhub-username>/sentiment-docker:latest

Docker Build & Publish CI
Workflow path:
.github/workflows/docker-build.yml
Trigger
Push to main
Filters on:
sentiment-docker/**
Tags Produced
•	latest
•	sha-<shortsha>
Evidence:
•	Successful workflow run: <https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/19540859095>
•	Docker Hub image visible: < https://hub.docker.com/r/samer77/sentiment-docker>
Image name: samer77/sentiment-docker:latest 

Observability (Custom Metrics → CloudWatch)
Namespace
SentimentApp-12345
Custom Metrics Implemented
1.	Timer: bedrock.latency.seconds
o	Dimensions: company=TestCompany, model=nova-micro-v1:0
2.	Gauge: sentiment.last_company_count
3.	Existing Counter still present.
Evidence
Screenshots included in repository:

<img width="2496" height="1240" alt="Screenshot 2025-11-19 163605" src="https://github.com/user-attachments/assets/ceb196f4-ac8e-4042-97d9-f2927e16db9a" />
<img width="2502" height="1240" alt="Screenshot 2025-11-20 140338" src="https://github.com/user-attachments/assets/73a8f9f4-5ca4-431d-a750-bf0fb7ce62d2" />
<img width="2502" height="1241" alt="Screenshot 2025-11-20 140416" src="https://github.com/user-attachments/assets/01da39bd-de4f-42a7-bb40-64ea493795de" />
<img width="2501" height="1240" alt="Screenshot 2025-11-20 141835" src="https://github.com/user-attachments/assets/948711ec-19de-4271-b371-62a77cad13c7" />
<img width="2502" height="1235" alt="Screenshot 2025-11-20 141853" src="https://github.com/user-attachments/assets/49938bfc-4e05-474d-9b1e-529a50383638" />


•	Namespace visible
•	Timer metrics (avg/max/sum/count) visible
•	Dimensions visible (company, model)

CloudWatch Dashboard & Alarm (Terraform)
Infrastructure Location
infra-cloudwatch/
Resources Created
•	Dashboard with:
o	Bedrock latency (avg)
o	Company-count gauge
•	Alarm (alarm1234) on
bedrock.latency.seconds.avg >= 5
•	SNS topic + email subscription
Evidence
Included screenshots:
•	Dashboard view
•	Alarm moving to "INSUFFICIENT DATA" / "ALARM"
•	SNS email received

Sensor Instructions (How to Run Workflows)
Terraform (infra-s3)
Requires secrets:
AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION
SAM Deploy
Same AWS secrets required.
Docker Build Workflow
Requires secrets:
DOCKER_USERNAME, DOCKER_TOKEN,
plus AWS secrets for internal tests.
Local Execution of SAM
Inside sam-comprehend:
sam build
sam local start-api --parameter-overrides "ParameterKey=S3BucketName,ParameterValue=kandidat-12345-data"
•	All required elements of the exam have been completed.

