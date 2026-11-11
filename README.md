# Azure Learning

Hands-on AZ-104 and AZ-305 preparation.

## Goals

- Understand Azure administration through practical exercises.
- Reproduce infrastructure with Terraform.
- Explain architectural trade-offs.
- Apply relevant findings to the e-commerce platform.

## Environment

- Windows with Ubuntu WSL
- VS Code connected to WSL
- Git
- Azure CLI
- Terraform

## Setup

See docs/setup.md.

## Labs

| Lab | Topic                     | Status  |
| --- | ------------------------- | ------- |
| 01  | Storage and lifecycle     | Planned |
| 02  | Entra ID and RBAC         | Planned |
| 03  | VNet and private endpoint | Planned |
| 04  | Monitoring and alerts     | Planned |

## Workflow

1. Read the lab objectives and prerequisites.
2. Confirm the Azure subscription.
3. Review resource costs and cleanup.
4. Deploy.
5. Verify expected behavior.
6. Perform the troubleshooting exercise.
7. Record findings.
8. Destroy disposable resources.

## Conventions

- One independent Terraform root per lab.
- Never commit credentials, state, or deployment plans.
- Commit provider lock files.
- Record observed results separately from expectations.
