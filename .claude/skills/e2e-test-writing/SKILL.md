---
name: e2e-test-writing
description: "E2E Test Writing - Use this skill to create, debug, or modify Playwright E2E tests. Uses a 3-agent pipeline: Test Writer → Implementer → Validator."
user_invocable: true
---

# E2E Test Writing — 3-Agent Pipeline

Each test is produced by a sequential pipeline of three agents. The orchestrator (you) picks the flow, spawns each agent in order, records learnings, and loops.

```
/e2e-test-writing <flow>       # Single flow through the pipeline
/e2e-test-writing auto         # Auto-loop: pick flows, pipeline, learn, repeat
```

> **Note**: No Playwright setup exists yet. If running for the first time, Agent 1 will need to scaffold `packages/frontend/playwright.config.ts` and install `@playwright/test` before writing tests.

---

## Pipeline Overview

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Agent 1: TEST   │ ──▶ │  Agent 2: IMPL   │ ──▶ │  Agent 3: VALID  │
│  WRITER          │     │  (fixer)         │     │  (validator)     │
│                  │     │                  │     │                  │
│ • Explore flow   │     │ • Read the test  │     │ • Run full suite │
│ • Write test     │     │ • Add data-testid│     │ • Report results │
│ • Run test       │     │ • Fix app code   │     │ • Flag regressions│
│ • Report result  │     │ • Run test again │     │                  │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

---

## Agent 1: Test Writer

Spawn with `Agent` tool. Give it this prompt (fill in `<FLOW>`):

```
You are the E2E Test Writer agent. Your job: create a Playwright test for the flow "<FLOW>".

WORKING DIRECTORY: /home/ranerp/Coding/internal-tools/resource-planner

## What to produce
1. A Playwright test file: `packages/frontend/e2e/<name>.spec.ts`

## Process
1. EXPLORE the app code to understand the flow:
   - Read relevant page components in `packages/frontend/src/pages/`
   - Read relevant React components to understand UI elements, API calls, navigation
   - Note which `data-testid` attributes exist and which are missing
2. CHECK if Playwright is set up:
   - Look for `packages/frontend/playwright.config.ts`
   - If missing, create it and install `@playwright/test` as a dev dependency
3. CHECK existing tests in `packages/frontend/e2e/` to follow established patterns
4. WRITE the test file following these rules:
   - Import from `@playwright/test`
   - Use `data-testid` selectors: `page.locator('[data-testid="..."]')`
   - Prefix test data with `E2E Test` (cleanup can use this prefix)
   - No hardcoded timeouts — rely on Playwright's default expect timeout
5. RUN the test: `cd packages/frontend && pnpm exec playwright test e2e/<name>.spec.ts`
6. REPORT a structured result:
   - FILES_CREATED: list of files created/modified
   - TEST_RESULT: pass/fail
   - MISSING_TESTIDS: data-testid attributes needed (file path + element + suggested name)
   - ISSUES: any problems encountered

## Auth
The app uses Azure Entra ID OAuth2. For local E2E tests, bypass auth by setting
a mock session cookie or using a test-only auth route — check if one exists in
`packages/backend/src/plugins/auth.ts` before implementing.

IMPORTANT: Do NOT modify React components for data-testid additions yourself. Report them in MISSING_TESTIDS — that is Agent 2's job.
```

---

## Agent 2: Implementer

Spawn ONLY if Agent 1 reports MISSING_TESTIDS or test failures. Give it this prompt:

```
You are the E2E Implementer agent. Agent 1 created a test that needs fixes to pass.

WORKING DIRECTORY: /home/ranerp/Coding/internal-tools/resource-planner

## Agent 1 Report
<paste Agent 1's full report here>

## Your job
1. READ the test files Agent 1 created to understand what's expected
2. FIX the issues:
   - Add missing `data-testid` attributes to React components
   - Fix any app-side bugs that prevent the test from passing
   - Do NOT modify test files unless the test has a clear bug
3. For data-testid additions: add `data-testid="name"` directly to JSX elements. Use kebab-case.
4. RUN the test: `cd packages/frontend && pnpm exec playwright test e2e/<name>.spec.ts`
5. If it still fails, debug iteratively
6. REPORT:
   - FILES_MODIFIED: list of React/app files changed
   - TESTIDS_ADDED: list of data-testid values added and where
   - TEST_RESULT: pass/fail
   - FIXES_APPLIED: description of what was fixed and why
```

---

## Agent 3: Validator

Spawn after Agent 2 reports success (or after Agent 1 if test already passes). Give it this prompt:

```
You are the E2E Validator agent. A new test was added and should be passing. Validate the full suite.

WORKING DIRECTORY: /home/ranerp/Coding/internal-tools/resource-planner

## Your job
1. Run the full test suite: `cd packages/frontend && pnpm exec playwright test`
2. REPORT:
   - TOTAL_TESTS: number of tests run
   - PASSED: count
   - FAILED: count
   - REGRESSIONS: tests that were passing before but now fail
   - NEW_TEST_STATUS: did the newly added test pass?
   - VERDICT: ALL_GREEN or REGRESSIONS_FOUND
3. If there are regressions, describe what broke and which file changes likely caused it
```

---

## Orchestrator Protocol

### Single Flow Mode (`/e2e-test-writing <flow>`)

1. Spawn **Agent 1** for the requested flow. Wait for result.
2. If Agent 1 reports MISSING_TESTIDS or failure → spawn **Agent 2**. Wait for result.
3. Spawn **Agent 3** (Validator). Wait for result.
4. **Record learnings** (see below).
5. Report summary to user.

### Auto-Loop Mode (`/e2e-test-writing auto`)

```
consecutive_no_learning = 0

while consecutive_no_learning < 2:
  1. Read all e2e/*.spec.ts files to see current coverage
  2. Pick the most valuable untested flow (see priority list)
  3. Announce: "Next flow: <description>. Reason: <why>"
  4. Run the 3-agent pipeline
  5. Record learnings
  6. If new learnings: consecutive_no_learning = 0
     If no new learnings: consecutive_no_learning += 1
```

### Flow Priority (for auto mode)

1. Core happy paths: login, view dashboard, create allocation, view project/person
2. Error/edge cases of existing flows
3. Different user roles (manager vs regular employee)
4. Allocation conflict validation

---

## Recording Learnings

After each pipeline completes, reflect on what was learned. A "learning" is something surprising, a debugging insight, a pattern for future tests, or a pitfall to avoid.

Check the Learnings section below first — if already there, it is NOT new.

If there ARE new learnings → append to `## Learnings` using the Edit tool.

---

## Learnings

(Automatically appended below as tests are written.)
