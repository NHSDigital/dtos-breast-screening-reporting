# Contributing

## Reporting bugs & suggesting features

Open a GitHub Issue with a clear title and enough detail to reproduce (for bugs) or justify (for features). Tag with the appropriate label.

## Development setup

See the [Quick start](../README.md#quick-start) in the README. In short:

```shell
make config                          # toolchain + Python deps
databricks configure --profile dev   # one-time auth setup
```

### Databricks CLI authentication

We use a **dev** CLI profile that targets the shared dev workspace. When you run `databricks configure --profile dev`, enter the workspace URL shown in `asset_bundles/databricks.yml`. Authenticate with your NHS Entra ID credentials.

### Per-developer isolation

The `dev` target in `databricks.yml` uses `mode: development`, which prefixes resources with your username. Schema variables are also scoped per-developer (e.g. `bronze_<your_short_name>`), so deploys are fully isolated — you can deploy and iterate without affecting anyone else. There is a GitHub Workflow which also deploys all pipelines on main so our databricks workspace is always up to date with the latest changes.


## Coding standards

- Follow the existing medallion pattern: **bronze** (raw ingest) → **silver** (clean/validate) → **gold** (aggregate).
- Keep pipeline yml files self contained - one file per pipeline and one per job.
- Keep pipeline Python files self-contained — one file per logical pipeline.
- Use `spark.conf.get("pipeline.<var>")` to read schema names; never hard-code catalog/schema names.

## Branch naming

```text
<type>/<ticket-number>-<description>
```

Where `<type>` is one of: `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style`, `test`.

Example: `feat/DSTA-1234-add-screening-uptake-pipeline`

## Commit messages

```text
<ticket-number>: <description>
```

Example: `DSTA-1234: add bronze layer for screening uptake`

## Pull request workflow

1. Push your branch and open a PR against `main`.
2. Ensure all CI checks pass (pre-commit hooks run automatically).
3. Request a review from at least one team member. Optionally and recommended also to request a review from copilot in the Github UI
4. Squash-merge once approved.
