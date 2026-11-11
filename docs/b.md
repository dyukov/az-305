# Git

## Commit-message conventions

### A common format, called Conventional Commits

| Prefix      | Purpose                                    | Example                                      |
| ----------- | ------------------------------------------ | -------------------------------------------- |
| `feat:`     | New functionality                          | `feat: add order cancellation`               |
| `fix:`      | Bug fix                                    | `fix: reject duplicate payment events`       |
| `docs:`     | Documentation                              | `docs: explain storage lifecycle rules`      |
| `style:`    | Formatting without changing behavior       | `style: format TypeScript files`             |
| `refactor:` | Restructure code without changing behavior | `refactor: extract event envelope builder`   |
| `perf:`     | Performance improvement                    | `perf: batch DynamoDB writes`                |
| `test:`     | Add or update tests                        | `test: cover duplicate event delivery`       |
| `build:`    | Build system or dependencies               | `build: update TypeScript`                   |
| `ci:`       | CI/CD configuration                        | `ci: add Terraform validation workflow`      |
| `chore:`    | Other maintenance and setup                | `chore: initialize Azure learning workspace` |
| `revert:`   | Revert an earlier change                   | `revert: remove inventory caching`           |

## `git diff`

| Command             | Shows                                                                             |
| ------------------- | --------------------------------------------------------------------------------- |
| `git diff`          | **Unstaged changes:** working files compared with the staging area                |
| `git diff --cached` | **Staged changes:** staging area compared with your last commit                   |
| `git diff HEAD`     | Both staged and unstaged changes to tracked files, compared with your last commit |

## `git amend`

`git add .`
`git diff --cached`
`git commit --amend --no-edit`
`git push --force-with-lease`
