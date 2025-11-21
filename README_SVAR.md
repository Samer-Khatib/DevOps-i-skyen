Deliverables Checklist

- S3 bucket created via Terraform with lifecycle rules  
- Terraform CI workflow (validate → plan → apply)  
- SAM template deployed and writing output to `/midlertidig/`  
- SAM GitHub Action fixed (PR → validate/build, main → deploy)  
- Spring Boot Bedrock app containerized (Java 21, multi-stage)  
- Docker Hub automatic build/push workflow  
- Custom Micrometer → CloudWatch metrics visible in my namespace  
- Terraform-created CloudWatch Dashboard + Alarm + SNS subscription  
- Full evidence gathered in this README_SVAR.md  

---

Infrastructure (S3)

**Bucket Name**
`kandidat-12345-data`

**Region**
`eu-west-1`

**Lifecycle Summary**
Prefix: `midlertidig/`

- Transition to `STANDARD_IA` after **30 days**  
- Expire after **60 days**

---

Evidence (Terraform S3)

**Terraform CI (successful run)**
https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/19247448977

**PR Validation**
https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/19269922365

**Main Branch Apply Run**
https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/19538976577

**AWS CLI Lifecycle Check**
```

aws s3api get-bucket-lifecycle-configuration --bucket kandidat-12345-data

````

---

SAM Application (Comprehend)

**Deployed API Gateway URL**
https://si8ygy7wtk.execute-api.eu-west-1.amazonaws.com/Prod/analyze/

**Sample Test**
```bash
curl -s -X POST https://si8ygy7wtk.execute-api.eu-west-1.amazonaws.com/Prod/analyze/ \
  -H "Content-Type: application/json" \
  -d '{"text":"Apple launches new AI features while Microsoft faces security concerns."}'
````

**Evidence of Object Written to S3**

`s3://kandidat-12345-data/midlertidig/2025/11/<uuid>.json`

**CLI Confirmation**

```
aws s3 ls s3://kandidat-12345-data/midlertidig/
```

**SAM Workflow Evidence**

* PR run (validate/build only):
  [https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/19269922365](https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/19269922365)
* Main run (deploy):
  [https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/19538976577](https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/19538976577)

---

Docker Build & Publish

**Workflow**

`.github/workflows/docker-build.yml`

**Successful Run**

[https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/1954085905](https://github.com/Samer-Khatib/DevOps-i-skyen/actions/runs/1954085905)

**Docker Hub Image**

[https://hub.docker.com/r/samer77/sentiment-docker](https://hub.docker.com/r/samer77/sentiment-docker)

Tags published:

* `latest`
* `sha-<shortsha>`

---

Metrics & Observability

**Custom Metrics Implemented**

* **Timer** — Bedrock latency
* **Gauge** — Last analyzed company count

These appear under my CloudWatch namespace:
`SentimentApp-12345`

**Screenshots**
<img width="2496" height="1240" alt="Screenshot 2025-11-19 163605" src="https://github.com/user-attachments/assets/d2739861-4af0-4d0e-afa7-cb0d8638888f" />
<img width="2502" height="1240" alt="Screenshot 2025-11-20 140338" src="https://github.com/user-attachments/assets/b8573373-1b3e-4b2b-a8ba-4eed24e58ce6" />
<img width="2502" height="1241" alt="Screenshot 2025-11-20 140416" src="https://github.com/user-attachments/assets/0dd30965-a5aa-4157-a5c8-ebd8d7744eb6" />
<img width="2501" height="1240" alt="Screenshot 2025-11-20 141835" src="https://github.com/user-attachments/assets/a5e9bf02-8c04-41f1-be93-4a2e98c7bf72" />
<img width="2502" height="1235" alt="Screenshot 2025-11-20 141853" src="https://github.com/user-attachments/assets/7af64e89-4411-4faf-b250-4d6afe415485" />


```
![CloudWatch Metrics](media/cloudwatch-metrics.png)
![CloudWatch Alarm](media/cloudwatch-alarm.png)
```

---

## 📈 CloudWatch Dashboard + Alarm

Infrastructure created manually via `infra-cloudwatch` Terraform:

* Dashboard visualizing two custom metrics
* Latency alarm (p95 > 5s)
* SNS email subscription (confirmed)

Screenshots included in the media section.

---

## 📄 Notes for Sensor

To run workflows in your fork:

* Add GitHub Actions secrets:

  * `AWS_ACCESS_KEY_ID`
  * `AWS_SECRET_ACCESS_KEY`
  * `AWS_REGION`
  * `DOCKER_USERNAME`
  * `DOCKER_TOKEN`
* All IaC and CI workflows are path-filtered
* Re-running any workflow will use your secrets
