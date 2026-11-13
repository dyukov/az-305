# Identity

An **identity** is anything that can authenticate against your Entra ID tenant. It's the answer to "who or what is making this request?"

| Identiuty Type    | What it is                                             | Example                          |
| ----------------- | ------------------------------------------------------ | -------------------------------- |
| User              | A person                                               | <alex@contoso.com>               |
| Group             | A collection of users/identities                       | "Backend Devs" security group    |
| Service Principal | An app/service identity (created via app registration) | CI/CD pipeline                   |
| Managed Identity  | Azure-managed service principal (no creds to handle)   | An App Service calling Key Vault |

Once authenticated, the identity gets a token — then Azure checks what that identity is allowed to do. That's where RBAC and Policy come in.

## Azure to AWS Comparison

**_The fundamental architectural difference_**

```s
  Azure:                                    AWS:
  ┌─────────────────────────┐              ┌─────────────────────────────┐
  │  Entra ID Tenant        │              │  AWS Organization           │
  │  ┌───────────────────┐  │              │                             │
  │  │ ALL identities    │  │              │  Account A   Account B      │
  │  │ live HERE         │  │              │  ┌──────┐   ┌──────┐        │
  │  └───────────────────┘  │              │  │IAM   │   │IAM   │        │
  │                         │              │  │Users │   │Users │        │
  │  Sub A    Sub B    Sub C│              │  │Roles │   │Roles │        │
  │  (no own identity store)│              │  └──────┘   └──────┘        │
  └─────────────────────────┘              └─────────────────────────────┘
                                            + Identity Center for SSO
```

**_Important differences_**

| Concern       | Azure                                           | AWS                                                |
| ------------- | ----------------------------------------------- | -------------------------------------------------- |
| Identity      | `az login` (one login, access to all subs)      | Credentials (scoped to one account)                |
| Target scope  | Must specify subscription explicitly            | Implicit from credentials                          |
| Cross-account | Just change `ARM_SUBSCRIPTION_ID`               | Switch profile or assume a role in another account |
| Region        | `Set in resource definitions or provider block` | `AWS_REGION` env var or provider block             |

Azure's model is centralized identity by default.
AWS arrived at the same pattern with Identity Center,
but it's an opt-in layer on top of the originally per-account IAM design.

**_Comparison on 1 User to N Azure Subscription/AWS Account_**

|                           | Azure                        | AWS (Legacy IAM)              | AWS (Identity Center)               |
| ------------------------- | ---------------------------- | ----------------------------- | ----------------------------------- |
| User exists in            | Tenant (once)                | Single account (once)         | Identity Center (once)              |
| Access to multiple scopes | RBAC across subscriptions    | Assume roles across accounts  | Permission sets across accounts     |
| Credential management     | Centralized in Entra ID      | Per-account                   | Centralized in Identity Center      |
| User experience           | One login, pick subscription | Login, then `sts assume-role` | One SSO portal, pick account + role |
