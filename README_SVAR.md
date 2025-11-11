Here’s a **short, exam-ready version** you can paste directly into your `README_SVAR.md` — clean, factual, and only what the sensor needs:

---

### AWS / CI Setup

* IAM user with programmatic access created.
* Region: `eu-west-1`.
* GitHub Actions secrets added:

  * `AWS_ACCESS_KEY_ID`
  * `AWS_SECRET_ACCESS_KEY`
  * `AWS_REGION = eu-west-1`
* Verified access using `aws sts get-caller-identity` and `aws s3 ls`.
* Terraform, AWS CLI, and SAM CLI validated locally and in CI.

---

### Terraform S3 Infrastructure

* **Bucket:** `kandidat-12345-data`
* **Region:** `eu-west-1`
* **Backend state:** `pgr301-terraform-state/infra-s3/terraform.tfstate`
* **Lifecycle rule:** Objects under `midlertidig/` → move to `STANDARD_IA` after 30 days → expire after 90 days.
* **Versioning:** Enabled.
* **force_destroy:** true (safe cleanup during testing).

**Workflow:** `.github/workflows/terraform-s3.yml`

* Runs `fmt`, `validate`, `plan` on PRs.
* Runs `apply` automatically on push to `main`.
* Uses AWS credentials from repo secrets.

**Verification:**

```bash
aws s3api head-bucket --bucket kandidat-12345-data
aws s3api get-bucket-lifecycle-configuration --bucket kandidat-12345-data
aws s3 ls s3://pgr301-terraform-state/infra-s3/
```

**Result:**
Bucket exists, lifecycle verified, Terraform state stored in S3, workflow green on main.

