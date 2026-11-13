# RBAC vs Policy

Aspect: Who it constrains
RBAC (Role-Based Access Control): People and services
Azure Policy: The resources themselves

## RBAC in practice

RBAC is a role assignment with three components:

| WHO         | WHAT CAN THEY DO | WHERE                  |
| ----------- | ---------------- | ---------------------- |
| (identity)  | (role)           | (scope)                |
| Anna        | Contributor      | rg-webshop-prod        |
| CI Pipeline | Reader           | Subscription "Prod-EU" |
| Dev Team    | Owner            | rg-sandbox             |

Built-in roles:

| WHO               | WHAT CAN THEY DO                    |
| ----------------- | ----------------------------------- |
| Owner             | Everything + assign roles to others |
| Contributor       | Everything except assign roles      |
| Reader            | Read-only                           |
| User Access Admin | Only manage role assignments        |

## Policy in practice

A policy is a rule about how resources must be configured, regardless of who deploys them:

```json
{
  "if": {
    "field": "Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly",
    "equals": false
  },
  "then": {
    "effect": "Deny"
  }
}
```

| Effect            | What happens                                                           |
| ----------------- | ---------------------------------------------------------------------- |
| Deny              | Block the deployment/change                                            |
| Audit             | Allow but flag as non-compliant                                        |
| Modify            | Auto-fix the resource at deploy time                                   |
| DeployIfNotExists | Deploy a companion resource if missing (e.g., auto-enable diagnostics) |
| Disabled          | Policy exists but does nothing                                         |

## How they work together

RBAC is checked first (can you do this?), then Policy is evaluated (is this allowed to exist this way?). An Owner with full RBAC
permissions can still be blocked by policy — they're independent systems.

```
Developer tries to create a VM
---> RBAC allowed?
  ------> NO --> 403 Forbidden "You don't have permission"
  ------> YES
---> Policy compliant?
  ------> NO --> Deployment denied "VM size not allowed in this region"
  ------> YES
---> Resource created ✓
```

## Azure to AWS Comparison

**_Policy model differs:_**

**Azure:**
Azure Policy → rules on RESOURCE CONFIGURATION
RBAC → rules on WHO CAN DO WHAT

**AWS:**
SCPs → guardrails on WHAT ACCOUNTS CAN DO (deny-only)
IAM Policies → rules on WHO CAN DO WHAT (allow + deny)

Azure Policy and AWS SCPs are similar in concept (top-down guardrails), but Azure Policy is more feature-rich — it can audit, remediate,
and deploy companion resources, whereas SCPs only restrict.
