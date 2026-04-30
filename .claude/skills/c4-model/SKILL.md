# Skill: C4 Architecture Model

Generate or update C4 architecture diagrams (Layers 1–3) for Resource Planner.
Outputs Mermaid C4 diagrams to `docs/c4/`. Layer 3 component diagrams are
derived from AST extraction — never hardcoded.

References:
- `.claude/skills/c4-model/references/c4-conventions.md` — C4 model rules
- `.claude/skills/c4-model/references/mermaid-syntax.md` — Mermaid C4 syntax
- `.claude/skills/c4-model/extract.ts` — AST extraction script

---

## Invocation

```
/c4-model [target]
```

`target` (optional, default = `all`):
- `all` — regenerate all diagrams and database schema
- `context` — Layer 1 only
- `containers` — Layer 2 only
- `components` — Layer 3 only (both backend and frontend)
- `database` — database schema only

---

## Step 0 — Prerequisites

Check whether `ts-morph` and `tsx` are available:

```bash
node -e "require('ts-morph')" 2>/dev/null && echo ok || echo missing
```

If missing, install them (workspace root, dev-only):

```bash
pnpm add -w -D ts-morph tsx
```

---

## Step 1 — Run AST extraction (for `components` or `all`)

```bash
npx tsx .claude/skills/c4-model/extract.ts
```

This writes two JSON files:
- `docs/c4/components-backend.json`
- `docs/c4/components-frontend.json`

These files are gitignored (intermediate artefacts). Read them immediately after
generating — do not skip even if they already exist, as they may be stale.

### Reading the JSON

Each file has this shape:

```jsonc
{
  "app": "backend",
  "components": {
    "modules/employees": {
      "key": "modules/employees",
      "label": "employees",
      "tsFiles": 3,
      "relations": ["plugins/prisma", "utils/errors"]
    }
  },
  "warnings": []
}
```

**Depth warnings**: if `warnings` is non-empty, some components contain >50 files.
Increase `defaultDepth` or add a `pathDepthOverride` in `extract.ts`, re-run,
and continue only when warnings are resolved.

### Pruning for diagrams

1. **Drop trivial keys**: barrel/config-only files with 1 ts file and no outgoing relations unless depended upon.
2. **Collapse leaf-only nodes**: components with relations pointing to them but zero outgoing relations and <3 files → treat as sub-component of parent.
3. **Cap at 20 nodes per diagram**. Split into sub-diagrams by boundary if needed.
4. **Prune high-fan-out edges**: show only the 5–6 most architecturally significant ones.

---

## Step 2 — Generate Layer 1: System Context

Write `docs/c4/context.md`.

```markdown
# C4 Layer 1 — System Context

> Resource Planner: internal tool for tracking employee allocations across projects.

\```mermaid
C4Context
  title System Context — Resource Planner

  Person(manager, "Resource Manager", "Plans and tracks employee allocations")
  Person(employee, "Employee", "Views their own assignments")

  System(resourceplanner, "Resource Planner", "Tracks employee allocations, bench status, and project utilisation")

  System_Ext(azure, "Azure Entra ID", "Identity provider — SSO and user sync")
  System_Ext(postgres, "PostgreSQL 16", "Persistent data store")

  Rel(manager, resourceplanner, "Uses", "HTTPS")
  Rel(employee, resourceplanner, "Uses", "HTTPS")
  Rel(resourceplanner, azure, "Authenticates via", "OAuth2 / OIDC")
  Rel(resourceplanner, postgres, "Reads/writes", "Prisma / TCP")
\```
```

---

## Step 3 — Generate Layer 2: Container Diagram

Write `docs/c4/containers.md`.

```markdown
# C4 Layer 2 — Container Diagram

\```mermaid
C4Container
  title Container Diagram — Resource Planner

  Person(user, "Resource Manager / Employee")

  System_Boundary(rp, "Resource Planner") {
    Container(frontend, "Frontend", "React 19 / TypeScript / Vite / Ant Design", "SPA. Dashboard, project and people views, allocation management.")
    Container(backend, "Backend API", "Fastify 5 / Node.js / TypeScript", "REST API. Auth via Azure OAuth2, CRUD for employees/projects/allocations, dashboard aggregations.")
    ContainerDb(db, "PostgreSQL 16", "Prisma ORM", "Employees, Projects, Allocations, TimeEntries.")
  }

  System_Ext(azure, "Azure Entra ID", "OAuth2 / OIDC")

  Rel(user, frontend, "Uses", "HTTPS / browser")
  Rel(frontend, backend, "Calls", "HTTPS / fetch (proxied via Vite in dev)")
  Rel(backend, db, "Reads/writes", "Prisma Client / TCP")
  Rel(backend, azure, "Authenticates", "OAuth2 code flow")
\```
```

---

## Step 4 — Generate Layer 3: Component Diagrams

Generate two files from the extracted JSON.

### 4a — `docs/c4/components-backend.md`

Read `docs/c4/components-backend.json`. Group by:

| Boundary label | Key prefix(es) |
|---|---|
| Modules | `modules/` |
| Plugins | `plugins/` |
| Jobs | `jobs/` |
| Utils | `utils/` |

Aim for ≤ 20 nodes. Draw edges from A → B only if B appears in A.relations.

### 4b — `docs/c4/components-frontend.md`

Read `docs/c4/components-frontend.json`. Group by:

| Boundary label | Key prefix(es) |
|---|---|
| Pages | `pages/` |
| Components | `components/` |
| Hooks | `hooks/` |
| API layer | `api/` |
| Context | `context/` |

---

## Step 5 — Extract Database Schema

**Requires**: Docker Compose Postgres must be running (`docker compose up -d`).

```bash
# Tables + columns
docker compose exec postgres psql -U resourceplanner -d resourceplanner -t -A -F'|' -c "
SELECT c.table_name, c.column_name, c.data_type,
       c.is_nullable, c.column_default IS NOT NULL AS has_default
FROM information_schema.columns c
JOIN information_schema.tables t
  ON c.table_name = t.table_name AND c.table_schema = t.table_schema
WHERE c.table_schema = 'public'
  AND t.table_type = 'BASE TABLE'
ORDER BY c.table_name, c.ordinal_position;
"

# Foreign keys
docker compose exec postgres psql -U resourceplanner -d resourceplanner -t -A -F'|' -c "
SELECT tc.table_name, kcu.column_name,
       ccu.table_name AS ref_table, ccu.column_name AS ref_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
  ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage ccu
  ON ccu.constraint_name = tc.constraint_name AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name, kcu.column_name;
"

# Enum types
docker compose exec postgres psql -U resourceplanner -d resourceplanner -t -A -F'|' -c "
SELECT t.typname, e.enumlabel
FROM pg_type t JOIN pg_enum e ON t.oid = e.enumtypid
ORDER BY t.typname, e.enumsortorder;
"
```

---

## Output files summary

| File | Layer | Regenerated by |
|---|---|---|
| `docs/c4/context.md` | L1 | `all`, `context` |
| `docs/c4/containers.md` | L2 | `all`, `containers` |
| `docs/c4/components-backend.md` | L3 | `all`, `components` |
| `docs/c4/components-frontend.md` | L3 | `all`, `components` |
| `docs/c4/database.md` | Schema | `all`, `database` |
| `docs/c4/components-*.json` | Intermediate | `extract.ts` (gitignored) |
