---
name: validate-design-document
description: "Validate a design document by spawning project-specific expert subagents in parallel. Use after writing a design document."
---

# Validate Design Document

## Overview

Validate a Resource Planner design document by spawning specialized expert subagents in parallel. Each expert reviews the document from their domain perspective and reports Critical / Warning / Note findings.

## Input

The design document path. If not provided, find the most recent file in `docs/plans/`.

## Step 1: Select Relevant Validators

Read the design document. Then decide which validators below are relevant. **If in doubt, include the validator.** Most designs will need 4–6 validators. Only skip when the design clearly has zero overlap with a domain.

### The Validators

| # | Validator | Prompt file | When to include |
|---|-----------|-------------|-----------------|
| 1 | Prisma & Database | `validators/prisma-database.md` | Touches data storage, queries, or schema |
| 2 | Auth & Permissions | `validators/auth-permissions.md` | Access control, roles, or user identity |
| 3 | React Frontend | `validators/react-frontend.md` | UI, routing, hooks, or components |
| 4 | API Contract | `validators/api-contract.md` | Fastify routes, type sharing, or validation |
| 5 | Monorepo & Integration | `validators/monorepo-integration.md` | Multiple packages or build pipeline |
| 6 | Devcontainer | `validators/devcontainer.md` | Local dev setup, Docker, or dev environment |
| 7 | E2E Tests | `validators/e2e-tests.md` | E2E/integration tests, Playwright, or test data |
| 8 | Simplifier | `validators/simplifier.md` | **Always include** |
| 9 | General Design Quality | `validators/general-design-quality.md` | **Always include** |

## Step 2: Spawn Validators in Parallel

For each selected validator:

1. **Read** its prompt file from the `validators/` directory (paths relative to this skill: `.claude/skills/validate-design-document/`)
2. **Replace** `{PATH}` in the prompt with the actual design document path
3. **Spawn** as a parallel foreground agent using `subagent_type: "general-purpose"`

Spawn **all selected validators in a single message** so they run in parallel.

## Step 3: Triage and Apply Results

After all validators complete, classify every finding:

### Bucket A: Auto-apply (confident, clear, no conflicts)

ALL of these must be true:
- Unambiguous — one obvious fix
- No other validator contradicts it
- Does not change scope, architecture, or business requirements

**Action:** Apply immediately, then list what was changed.

### Bucket B: Conflicts (validators disagree)

**Action:** Present each conflict with competing recommendations side by side. Ask the user to decide.

### Bucket C: Needs user input (uncertain or significant)

**Action:** List and ask the user which to accept, reject, or modify.

### Output Format

```
## Design Validation Results

**Validators run:** [list]
**Validators skipped:** [list with reasons]

### Auto-applied changes
- [change 1] — [which validator(s)]

### Conflicts (need your decision)

**Conflict 1: [topic]**
- [Validator A] recommends: ...
- [Validator B] recommends: ...

### Recommendations needing your input
- [finding 1] — [severity] — [which validator]
```

After the user responds to Buckets B and C, apply the accepted changes to the design document.
