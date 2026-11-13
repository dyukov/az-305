# Azure Tags

Tags are key-value labels you attach to Azure resources (`env = prod`, `owner = team-payments`). They don't change how a resource behaves. They're metadata used for organising resources, reporting costs, automation and governance.

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-payments-prod"
  location = "westeurope"
  tags = {
    environment = "prod"
    owner       = "team-payments"
    costCenter  = "CC-1042"
  }
}
```

What they're used for

| Use             | How tags help                                                                                                                                    |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| Cost management | Cost Management can filter and group spend by tag, e.g. "how much does `costCenter=CC-1042` cost?" **This is the #1 reason companies use tags.** |
| Ownership       | `owner` / `contact` tags tell you who to ask about a resource someone left running                                                               |
| Environment     | Separating `dev` / `test` / `prod` when they share a subscription                                                                                |
| Automation      | Scripts act on tags, e.g. shut down VMs tagged `autoShutdown=true` at 18:00                                                                      |
| Governance      | Azure Policy can require tags or apply them automatically                                                                                        |
| Lifecycle       | `expiresOn=2026-12-31` lets a cleanup job find temporary resources                                                                               |

Rules and limits

| Rule                        | Detail                                                                                                                           |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| Max tags per resource       | 50                                                                                                                               |
| Key length                  | 512 characters (128 for storage accounts)                                                                                        |
| Value length                | 256 characters                                                                                                                   |
| Case                        | Key names are case-insensitive, values are case-sensitive. `Env` and `env` count as the same key, and that causes drift trouble. |
| **No inheritance**          | **A resource does NOT get its resource group's tags automatically.** This is the classic gotcha.                                 |
| Not every resource supports | Most do. A few child resources don't.                                                                                            |
| Not secret                  | Anyone with read access can see tags. Never put secrets or personal data in them.                                                |

**_IMPORTANT!_**
**The inheritance gotcha and how teams fix it**

You tag the resource group, open Cost Management, and the costs aren't grouped. That's because costs are recorded per resource, and the resources inside the group don't carry the group's tags. There are three fixes:

| Approach                                                 | How                                                                                                       |
| -------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| Azure Policy **"Inherit a tag from the resource group"** | Built-in policy with a `modify` effect. It copies the tag onto resources when they're created or updated. |
| Cost Management **tag inheritance** setting              | Applies subscription or resource group tags to cost records only. It doesn't change the resources.        |
| Terraform                                                | Define the tags once and pass them to every resource (see below)                                          |

The usual Terraform pattern

```hcl
locals {
  common_tags = {
    environment = var.environment
    owner       = "team-payments"
    managedBy   = "terraform"
  }
}

resource "azurerm_storage_account" "sa" {
  # ...
  tags = merge(local.common_tags, { dataClass = "confidential" })
}
```

`managedBy = "terraform"` is a useful convention. It warns people not to change the resource by hand in the portal.

**Drift trap:** if Azure Policy adds tags that your Terraform code doesn't define, every `plan` will want to remove them, and the policy will add them back. Either define those tags in Terraform as well, or use `lifecycle { ignore_changes = [tags["someTag"]] }`.

Azure Policy effects for tags

| Effect   | What it does                                        | Typical use                                        |
| -------- | --------------------------------------------------- | -------------------------------------------------- |
| `deny`   | Blocks creating a resource without the required tag | Enforce that `costCenter` must exist               |
| `modify` | Adds or replaces the tag automatically              | Inherit tags from the resource group, set defaults |
| `audit`  | Allows the resource but reports it as non-compliant | Soft rollout before switching to `deny`            |

**Compared with AWS**

The idea is the same in both clouds. The differences are:

| Aspect                 | Azure                                    | AWS                                                           |
| ---------------------- | ---------------------------------------- | ------------------------------------------------------------- |
| Max tags               | 50                                       | 50                                                            |
| Cost reporting         | Cost Management, tags usable right away  | Each tag must be **activated** as a cost allocation tag first |
| Provider-wide defaults | None built into `azurerm`. Use `locals`. | `default_tags` block in the `aws` provider                    |
| Enforcement            | Azure Policy                             | SCPs / Tag Policies (AWS Organizations)                       |

Both clouds also have ways to organise resources other than tags. In Azure, resource groups, subscriptions and management groups provide **hard boundaries for access control (RBAC), policy and lifecycle.** Tags are **soft labels that cut across those boundaries.**

**Interview angle**

- If asked "How do you handle cost allocation in Azure?",
- a strong answer is:
  "A mandatory tag set (environment, owner, costCenter) enforced with Azure Policy,
  deny for new resources and modify to inherit from the resource group.
  Tags are defined centrally in Terraform locals.
  Cost Management views and budgets are grouped by costCenter."
  That covers governance, IaC and FinOps in one answer.
