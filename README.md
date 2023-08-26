# sqlmesh-demo

POC of sqlmesh with Jaffle Shop

```bash
# 1. Create virtual environment & Activate it
python -m venv .env
.\.env\Scripts\activate.bat


# 2. Install sqlmesh and the dependencies if any
pip install -r requirements.txt # sqlmesh
sqlmesh --version # 0.28.0
sqlmesh --help
    # Usage: sqlmesh [OPTIONS] COMMAND [ARGS]...

    #   SQLMesh command line tool.

    # Options:
    #   --version          Show the version and exit.
    #   -p, --paths TEXT   Path(s) to the SQLMesh config/project.
    #   --config TEXT      Name of the config object. Only applicable to
    #                      configuration defined using Python script.
    #   --gateway TEXT     The name of the gateway.
    #   --ignore-warnings  Ignore warnings.
    #   --help             Show this message and exit.

    # Commands:
    #   audit                   Run audits.
    #   create_external_models  Create a schema file containing external model...
    #   dag                     Renders the dag using graphviz.
    #   diff                    Show the diff between the current context and a...
    #   evaluate                Evaluate a model and return a dataframe with a...
    #   fetchdf                 Runs a sql query and displays the results.
    #   format                  Format all models in a given directory.
    #   ide                     Start a browser-based SQLMesh IDE.
    #   info                    Print information about a SQLMesh project.
    #   init                    Create a new SQLMesh repository.
    #   invalidate              Invalidates the target environment, forcing its...
    #   migrate                 Migrate SQLMesh to the current running version.
    #   plan                    Plan a migration of the current context's...
    #   prompt                  Uses LLM to generate a SQL query from a prompt.
    #   render                  Renders a model's query, optionally expanding...
    #   rollback                Rollback SQLMesh to the previous migration.
    #   run                     Evaluates the DAG of models using the built-in...
    #   table_diff              Show the diff between two tables.
    #   test                    Run model unit tests.
    #   ui                      Start a browser-based SQLMesh UI.

# 3. Initialize the project skeleton with Postgres dialect, and do the very first runs
sqlmesh init postgres
    # (repo)
    # ├───audits
    # │       assert_positive_order_ids.sql
    # ├───macros
    # │       __init__.py
    # ├───models
    # │       full_model.sql
    # │       incremental_model.sql
    # │       seed_model.sql
    # ├───seeds
    # │       seed_data.csv
    # └───tests
    #         test_full_model.yaml
sqlmesh info
    # Models: 3
    # Macros: 11
    # Data warehouse connection succeeded
    # Test connection succeeded
sqlmesh plan
    # ======================================================================
    # Successfully Ran 1 tests against duckdb
    # ----------------------------------------------------------------------
    # New environment `prod` will be created from `prod`
    # Summary of differences against `prod`:
    # └── Added Models:
    #     ├── sqlmesh_example.seed_model
    #     ├── sqlmesh_example.incremental_model
    #     └── sqlmesh_example.full_model
    # Models needing backfill (missing dates):
    # ├── sqlmesh_example.seed_model: 2023-08-25 - 2023-08-25
    # ├── sqlmesh_example.incremental_model: 2020-01-01 - 2023-08-25
    # └── sqlmesh_example.full_model: 2020-01-01 - 2023-08-25
    # Apply - Backfill Tables [y/n]: y
    # Creating new model versions ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 100.0% • 3/3 • 0:00:00
    # All model versions have been created successfully
    # Evaluating models ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 100.0% • 3/3 • 0:00:00
    # All model batches have been executed successfully
    # Virtually Updating 'prod' ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 100.0% • 0:00:00
    # The target environment has been updated successfully
sqlmesh run
    # No models scheduled to run at this time.
sqlmesh audit
    # Found 1 audit(s).
    # assert_positive_order_ids PASS.

    # Finished with 0 audit errors and 0 audits skipped.
    # Done.
sqlmesh test
    # .
    # ----------------------------------------------------------------------
    # Ran 1 test in 0.162s

    # OK

# 4. Add Jaffle Shop data & the models mimic dbt demo
# check repo at (repo)/TBU

# 5. Add CI with Github Workflow
# check repo at (repo)/.github/workflows
```


Happy Engineering :tada: