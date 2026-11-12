# Review — 01 Storage and lifecycle

Answer **after** the hands-on exercises, without looking at the README first. Use short explanations and examples from your deployment. Keep your original answer, then add corrections after verification.

## Question 1 — Resource hierarchy
What is the relationship between a resource group, storage account, blob container and blob? Which is closest to an S3 bucket, and why is the mapping imperfect?

### My answer
Not answered yet.

### Correction after checking
Not checked yet.

## Question 2 — Architecture choice
Why use a Standard GPv2 StorageV2 account with LRS for this lab? What tradeoffs would affect production redundancy and availability?

### My answer
Not answered yet.

### Correction after checking
Not checked yet.

## Question 3 — Management plane versus data plane
You can run `az storage account show`, but `az storage blob download --auth-mode login` fails with authorization denied. Explain what this does and does not prove.

### My answer
Not answered yet.

### Correction after checking
Not checked yet.

## Question 4 — RBAC
How do Contributor and Storage Blob Data Contributor differ? Can you infer blob-data access solely from the Azure Portal showing the storage account?

### My answer
Not answered yet.

### Correction after checking
Not checked yet.

## Question 5 — Tiers
Compare Hot, Cool, Cold and Archive in terms of access latency, storage/operation costs and early-deletion/minimum-duration considerations. Which tier is appropriate for a file you need to download immediately?

### My answer
Not answered yet.

### Correction after checking
Not checked yet.

## Question 6 — Lifecycle timing
A lifecycle rule is configured to transition eligible blobs from Hot to Cool after 30 days. You applied Terraform five minutes ago but see no tier change. Is this a failed test? What evidence actually verifies the policy?

### My answer
Not answered yet.

### Correction after checking
Not checked yet.

## Question 7 — IaC and drift
What would `terraform plan` tell you after manually editing a lifecycle rule in the Portal? What information must remain available for `terraform destroy`?

### My answer
Not answered yet.

### Correction after checking
Not checked yet.

## Scenario question — E-commerce retention
An order-processing application produces audit snapshots daily. Recent snapshots need fast retrieval; older ones are rarely opened. Propose a storage/tiering policy, access model and Terraform-owned boundaries. Explain the security/cost tradeoffs, and identify what cannot be tested instantaneously.

### My decision and reasoning
Not answered yet.

## Practical challenge
Without the walkthrough, locate the storage account and lifecycle rule through Azure CLI, explain the difference between the management and blob-data authorization used, prove a test blob's downloaded contents match its uploaded contents, and verify lab cleanup. Record command outputs without secrets.

### Result
Not attempted yet.

## Topics to revisit

- Add any concepts I could not explain convincingly.
