---
name: commit
description: Creates git commits following conventional commit format. Use when committing changes, preparing commit messages, or when user runs /commit.
---

# Commit Workflow

## Staging Behavior

- **Default**: Add all changes and commit (`git add . && git commit`)
- **User-staged**: If user has already staged changes (visible in `git status` as "Changes to be committed"), commit only the staged changes without running `git add`

### How to detect user-staged changes

Run `git status --porcelain` and check:
- If there are lines starting with `A`, `M`, `D`, etc. in the first column (staged), commit only those
- If all changes are unstaged (second column only), add all and commit

### Arguments

- `/commit` - Add all changes and commit
- `/commit --staged` or `/commit -s` - Commit only user-staged changes (no git add)

# Commit Message Guidelines

When creating commit messages, follow these conventions:

## Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code (formatting, missing semicolons, etc.)
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **build**: Changes that affect the build system or external dependencies
- **ci**: Changes to CI configuration files and scripts
- **chore**: Other changes that don't modify src or test files

## Rules

1. **Subject line**: Use imperative mood ("add feature" not "added feature")
2. **Subject length**: Keep under 50 characters
3. **No period**: Don't end the subject line with a period
4. **Capitalize**: Capitalize the first letter of the subject
5. **Body**: Wrap at 72 characters, explain *what* and *why* vs. *how*
6. **Scope**: Optional, indicates the module/component affected
7. **No Co-Authored-By**: Do not include Co-Authored-By lines in commit messages

## Examples

```
feat(auth): add JWT token refresh mechanism

Implement automatic token refresh when the access token expires.
This prevents users from being logged out during active sessions.

Closes #123
```

```
fix(api): handle null response from payment gateway

The payment gateway occasionally returns null for declined cards.
Added proper null checking to prevent 500 errors.
```

```
docs: update API documentation for v2 endpoints
```

```
refactor(database): extract connection pooling logic

Move connection pool management to a dedicated class for better
testability and reuse across different database adapters.
```

## Breaking Changes

For breaking changes, add `BREAKING CHANGE:` in the footer or append '!' after the type:

```
feat(api)!: change authentication endpoint response format

BREAKING CHANGE: The /auth/login endpoint now returns a different
JSON structure. See migration guide for details.
```
