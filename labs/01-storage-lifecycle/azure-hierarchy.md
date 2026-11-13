# Azure Hierarchy

```
Azure AD Tenant (Organization)
└── Management Group (optional)
    └── Subscription ← billing + access boundary
        └── Resource Group
            └── Resources (VMs, DBs, App Services, etc.)
```

## Full hierarchy comparison

|                 | Tenant                   | Management Group           | Subscription                      | Resource Group                  | Resource                 |
| --------------- | ------------------------ | -------------------------- | --------------------------------- | ------------------------------- | ------------------------ |
| Purpose         | Identity & directory     | Governance at scale        | Billing and access boundary       | Lifecycle & deployment grouping | Actual service instance  |
| Contains        | Users, Groups, Apps, MGs | Subscriptions or child MGs | Resource Groups                   | Resources                       | Nothing (leaf node)      |
| Parent          | None (top level)         | Tenant or another MG       | Management Group or Tenant (root) | Subscription                    | Resource Group           |
| Cardinality     | One per org (typically)  | Many per tenant            | Many per RG                       | Many per subscription           | Many per RG              |
| RBAC scope      | No (use MG/sub level)    | Yes - inherits down        | Yes - inherits down               | Yes - inherits down             | Yes - most granular      |
| Policy scope    | No                       | Yes - inherits down        | Yes - inherits down               | Yes - inherits down             | No (applied via RG/sub)  |
| Billing         | No                       | No - just governance       | Yes - the billing unit            | No - costs roll up to sub       | Yes - generates cost     |
| Delete behavior | Delete everything        | Removes container only     | Must be empty first               | Deletes all resources inside    | Deletes single resource  |
| Region          | No                       | No                         | No                                | Metadata region only            | Yes - deployed to region |
| Required        | Yes                      | No (optional)              | Yes                               | Yes                             | Yes                      |

## Quick mental model

Tenant → WHO you are (identity)
Management Group → WHO must follow WHAT rules (governance)
Subscription → WHO pays (billing)
Resource Group → WHAT belongs together (lifecycle)
Resource → THE actual thing (compute, storage, network...)

## Azure to AWS Comparison

|                  | Azure                     | AWS                                                             |
| ---------------- | ------------------------- | --------------------------------------------------------------- |
| Tenant           | Microsoft Entra ID Tenant | AWS Organization (root account)                                 |
| Management Group | Management Group          | Organizational Unit (OU)                                        |
| Subscription     | Subscription              | AWS Account                                                     |
| Resource Group   | Resource Group            | No direct equivalent (tags + CloudFormation stacks are closest) |
| Resource         | Resource                  | Resource                                                        |

**_Key differences to note_**

**Resource Group has no AWS equivalent** — this is the biggest structural difference. In Azure, every resource must belong to an RG. In AWS,
resources just exist in an account; you use tags and CloudFormation stacks for organization, but neither is mandatory.

**Subscription ≈ AWS Account** — but with a nuance. In AWS, each account has its own IAM users/roles (identity is per-account by default,
unified via IAM Identity Center). In Azure, identity is centralized in the tenant — subscriptions share the same user directory.
