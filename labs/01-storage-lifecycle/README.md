# 01 — Storage and lifecycle

## Status

In progress — no Azure resources deployed. Record real observations only after running each exercise.

## Scenario

An e-commerce system exports order audit snapshots and processing reports to object storage. Recent files must be easy to retrieve; older files should move to cheaper storage automatically. Operators need to know who can configure the storage account versus who can read blob content. Build a small, disposable Azure Blob Storage lab with Terraform, verify a lifecycle rule without waiting for its background execution, and clean everything up.

AWS analogy: Azure storage account + blob container + blob is broadly comparable to S3's service configuration + bucket + object, but **a storage account is not an S3 bucket**. A storage account is a management boundary hosting services; Azure blob containers sit inside it. Azure RBAC, credentials, networking and tier semantics are not interchangeable with S3.

## Learning objectives

By the end, I can:

- Explain storage accounts, containers, blobs, redundancy, and the selected account kind.
- Upload, inspect, download, and verify a blob.
- Distinguish Azure Resource Manager (management plane) from blob operations (data plane).
- Compare Hot, Cool, Cold and Archive tiers, including retrieval and minimum retention implications.
- Configure and inspect a lifecycle management policy using Terraform.
- Explain why lifecycle processing is asynchronous and cannot be asserted to run immediately.
- Diagnose a deliberate permission failure safely.
- Destroy resources and verify deletion.

## Prerequisites

- **Knowledge:** Terraform basics, Azure subscriptions/resource groups, basic identity and RBAC; AWS comparisons are conceptual only.
- **Tools:** Ubuntu WSL terminal, VS Code in WSL, Git, Azure CLI (`az`), Terraform (`terraform`), optional Azure Portal.
- **Azure permissions:** access to the intended subscription; for deployment, permission to create/manage a resource group, Storage account, blob containers and a lifecycle policy (typically Contributor at the lab scope or an equivalent scoped role). Blob operations with Microsoft Entra ID need an appropriate **data-plane** role (for example Storage Blob Data Contributor), which Contributor alone does not grant. If role assignments are part of troubleshooting, creating them requires additional role-assignment permissions; never assume them.
- **Previous labs:** none.
- **Safety:** confirm tenant, subscription and region; use fake sample data; never paste tokens, access keys, SAS tokens or tenant-private identifiers in notes.

## Resources and costs

| Resource | Purpose | Cost consideration |
| --- | --- | --- |
| Resource group | One isolated cleanup boundary | No direct RG charge |
| Standard GPv2 Storage account (StorageV2, Standard_LRS) | Host Blob service | Capacity, transactions, data transfer and tier-dependent charges; LRS is a deliberate low-cost lab choice, not production guidance |
| Private blob container | Hold sample blobs | Included in blob storage usage |
| Tiny test blobs | Verify upload, download, tier and data access | Minimal capacity and operation charges |
| Lifecycle management policy | Transition eligible block blobs from Hot to Cool | Rule itself is not a per-hour resource; transitions and subsequent operations can incur charges |

**Cost controls:** use tiny files, keep the lab short, do not enable Archive in this lab, avoid production or shared resources, and run Terraform destroy at the end. Cool/Cold/Archive tiers can impose minimum storage duration or early-deletion charges; using a policy does not eliminate charges. Prices depend on Azure region and account configuration. Verify with [Azure Blob Storage pricing](https://azure.microsoft.com/pricing/details/storage/blobs/).

## Working directories

- All Git and Azure preflight commands: repository root in **Ubuntu WSL**, unless specifically noted.
- Terraform commands: `labs/01-storage-lifecycle/infra` in **Ubuntu WSL**.
- Portal observations: browser on **Windows**.
- All commands marked **user runs**; this lesson does not execute Azure deployments on your behalf.

## Planned Terraform files

Create during Exercise 2, not beforehand:

- `infra/versions.tf`: Terraform and azurerm provider version constraints.
- `infra/providers.tf`: provider configuration and required features.
- `infra/variables.tf`: subscription-independent inputs (region, name suffix).
- `infra/main.tf`: resource group, GPv2 account, private container.
- `infra/outputs.tf`: non-secret resource names and IDs.
- `infra/lifecycle.tf`: lifecycle policy (added in Exercise 5).

Use a **local Terraform state** for this disposable lab; it is ignored by Git, must not be shared, and must remain available until destroy. Check `git status` before committing. Commit the generated `.terraform.lock.hcl`; do not commit state, plans, `*.tfvars`, credentials or sample private data.

## Exercises

### Exercise 1 — Verify identity, subscription, and tooling (no resources)

**Task:** From the repository root in Ubuntu WSL, run:

```bash
git branch --show-current
git status --short
az account show --query '{subscription:name, id:id, tenant:tenantId, state:state, isDefault:isDefault}' -o json
az version --query '"azure-cli"' -o tsv
terraform version
```

**Expected result:** branch is `lab/01-storage-lifecycle`; subscription is the intended active subscription; Azure CLI and Terraform report versions. A clean Git tree is desirable; do not discard existing work to make it clean.

**Verification:** inspect the printed branch, subscription and tool versions; optionally confirm the subscription in Azure Portal → Subscriptions. Do not publish subscription/tenant IDs.

**Gate:** stop and share redacted outputs before Exercise 2. We will choose a region, naming convention and Terraform provider configuration together.

### Exercise 2 — Define and plan infrastructure (no deployment yet)

**Task:** Write minimal Terraform for one resource group, one Standard GPv2/LRS storage account with blob public access disabled, and a private container. Use a unique lowercase storage-account name (3–24 letters/digits). Initialize and format the configuration; run `terraform validate` and `terraform plan` in `infra/`. Do not use account keys for routine data access.

**Expected result:** Terraform validates and proposes only intended lab resources; nothing has been created.

**Verification:** inspect the plan and compare resource types/settings against Azure documentation. **Gate:** share the plan summary before apply.

### Exercise 3 — Deploy and observe

**Task:** After checking the plan, run `terraform apply` yourself from `infra/`. Observe the resource group, storage account and container with Azure CLI and Portal.

**Expected result:** an isolated RG, GPv2 storage account, and private container exist.

**Verification:** `terraform state list`, `az storage account show`, and Portal → Storage accounts → account → Data storage → Containers. Record actual names and the chosen location.

### Exercise 4 — Blob CRUD and identity boundary

**Task:** Create a harmless text blob locally; upload and download it using Azure CLI with `--auth-mode login`. Compare checksums/content. Inspect role assignments and distinguish ARM permissions from Blob data permissions. If data-plane authorization fails, record the error rather than automatically using an account key.

**Expected result:** upload/download succeeds only when the active principal has required blob data access (e.g. Storage Blob Data Contributor). Role changes may take time to propagate.

**Verification:** blob listed in CLI/Portal, downloaded content matches original; identify the effective data-plane role or diagnose the denial.

### Exercise 5 — Tiers and lifecycle policy

**Task:** Review Hot, Cool, Cold and Archive behavior. Using Terraform, add a lifecycle rule for **block blobs under a specific prefix** that transitions Hot blobs to Cool after a chosen number of days since modification (use a nonzero period, e.g. 30 days). Plan and apply after inspection.

**Expected result:** policy is attached to the storage account and shows the selected rule, prefix filter and threshold.

**Verification:** check Terraform state/plan, Azure CLI (`az storage account management-policy show`) and Portal → Data management → Lifecycle management. **Do not require the tier to change immediately**: lifecycle rules run asynchronously and time-dependent eligibility needs actual blob age. Verify **configuration**, not same-session execution.

### Exercise 6 — Troubleshooting: role mismatch

**Task:** Reproduce or analyze a `403 AuthorizationPermissionMismatch` (or another documented data-plane authorization error) when the principal lacks Blob Data permissions but can view management resources. Use CLI/Portal role assignments, principal identity and operation scope to distinguish an RBAC problem from networking or a bad resource name. Avoid removing your own management access.

**Expected result:** a written root-cause hypothesis, evidence and safe remediation plan; if access permits, retest after authorized RBAC correction. No dangerous role changes are required.

**Verification:** record error text (redacted), checks performed and successful retest or explanation in `troubleshooting.md`.

### Exercise 7 — Cleanup and verification

**Task:** From `infra/`, inspect `terraform plan -destroy`, then run `terraform destroy` yourself. Verify with `az group exists --name <lab-rg-name>`. Do not delete unrelated resource groups.

**Expected result:** destroy completes and the lab RG no longer exists.

**Verification:** CLI returns `false`; Azure Portal no longer lists the lab RG after refresh. Preserve non-sensitive learning notes and configuration, but not credentials or state.

## Results

| Check | Expected result | Actual result |
| --- | --- | --- |
| Subscription + tools | Intended subscription; working CLI/Terraform | Not tested |
| Terraform plan | Only designated RG/account/container | Not tested |
| Resource deployment | RG, private container and GPv2 account exist | Not tested |
| Blob round-trip | Content matches | Not tested |
| Management/data access | Permissions distinguished by operation | Not tested |
| Lifecycle rule | Prefix and age rule visible | Not tested |
| Troubleshooting | Evidence-based diagnosis recorded | Not tested |
| Cleanup | Lab RG absent | Not tested |

## Cleanup

From the Ubuntu WSL terminal:

```bash
cd labs/01-storage-lifecycle/infra
terraform plan -destroy
terraform destroy
az group exists --name <lab-rg-name>
```

Replace the placeholder with the actual Terraform-managed resource group name. Run the `cd` from the **repository root**. If state is lost, stop: do **not** assume Terraform destroy can find resources without its state; inventory the lab RG before any manual deletion. Verify no residual billable resources.

## Completion checklist

- [ ] Exercises completed
- [ ] Results verified
- [ ] Notes written in `notes.md`
- [ ] Review questions answered in `review.md`
- [ ] Troubleshooting documented
- [ ] Resources cleaned up
- [ ] Changes committed (without Terraform state or secrets)

## References

- [Azure Storage account overview](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview)
- [Blob access tiers](https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview)
- [Blob lifecycle management overview](https://learn.microsoft.com/en-us/azure/storage/blobs/lifecycle-management-overview)
- [Authorize access to blobs using Microsoft Entra ID](https://learn.microsoft.com/en-us/azure/storage/blobs/authorize-access-azure-active-directory)
- [Assign an Azure role for access to blob data](https://learn.microsoft.com/en-us/azure/storage/blobs/assign-azure-role-data-access)
- [AzureRM Terraform provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
