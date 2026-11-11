# Setup

## General Component Setup

| Component                   | Where it lives/runs         | Reason                                        |
| --------------------------- | --------------------------- | --------------------------------------------- |
| Windows Terminal            | Windows                     | Opens your Ubuntu terminal                    |
| VS Code desktop application | Windows                     | Editor interface                              |
| VS Code WSL extension       | Windows                     | Connects the editor to Ubuntu                 |
| Git                         | Ubuntu WSL                  | Works directly with Linux project files       |
| Azure CLI                   | Ubuntu WSL                  | Runs lab commands                             |
| Terraform                   | Ubuntu WSL                  | Deploys infrastructure                        |
| Project files               | Ubuntu filesystem           | Keeps tools and files in the same environment |
| Azure Portal                | Windows browser             | GUI exercises and inspection                  |
| PowerShell                  | Add when needed for lessons | Practice Azure PowerShell administration      |

## Tooling

### Ubuntu 26.04 tooling

| Tool              | Why you need it                                              |
| ----------------- | ------------------------------------------------------------ |
| `git`             | Version control                                              |
| `openssh-client`  | SSH authentication to GitHub or GitLab                       |
| `curl`            | HTTP requests and downloads                                  |
| `wget`            | File downloads; some installation instructions use it        |
| `ca-certificates` | Trusted certificates for HTTPS                               |
| `gnupg`           | Verify package repository signatures                         |
| `lsb-release`     | Identify Ubuntu release information                          |
| `jq`              | Query and transform JSON returned by Azure CLI               |
| `unzip`, `zip`    | Handle downloaded tools and deployment archives              |
| `build-essential` | Compiler and build utilities for tools needing native builds |
| `python3`         | Small automation scripts                                     |
| `python3-venv`    | Isolated Python environments                                 |

### Additional tooling

| Additional tool            | Add when                                     |
| -------------------------- | -------------------------------------------- |
| Node.js + TypeScript       | Writing Functions or application experiments |
| Azure Functions Core Tools | Running Functions locally                    |
| Docker                     | Starting container labs                      |
| PowerShell + Az module     | Practicing Azure PowerShell                  |
| Bicep CLI                  | Practicing ARM/Bicep deployments             |
| Storage Explorer           | A storage exercise benefits from its GUI     |

### VSCode Extensions

| Name                   | Why                                |
| ---------------------- | ---------------------------------- |
| WSL                    | Connect Windows VS Code to Ubuntu  |
| HashiCorp Terraform    | Terraform language support         |
| markdownlint           | Catch Markdown formatting problems |
| Dracula Theme Official | To see besser                      |
