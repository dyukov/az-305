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

```
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
