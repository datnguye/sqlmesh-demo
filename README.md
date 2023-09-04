# sqlmesh-demo

POC of `sqlmesh` with Jaffle Shop data as an engineer trying stepping out from the `dbt` world!

Actually try to mimic [dbt Jaffle Shop project](https://github.com/dbt-labs/jaffle_shop) and get the first impression of this cool tool 🌟

_Environment used_:

- sqlmesh v0.30
- Windows 11
- VSCode with dbt extensions installed

## 1. Getting familiar with sqlmesh CLI

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
sqlmesh plan [dev]
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
```

**First impressions**:

- So far so good, the installation tooks quite a bit long, especially when installed the `pandas` 🏃‍♂️
- Lots of useful CLI commands 👍
- New concept with `plan` & `apply`, and the virtual environment defaults to `prod` 👍
- It creates DuckDB files by default and do transformation smoothly 🎉
- Project skeleton looks similar to dbt, but not quite, there are new things such as: `audit`, only `config.yml` (not dealing with `dbt_project.yml` and `profiles.yml`) 🎉
- Everything based `model` e.g. for a seed file we need to create a corresponding model.sql file, same for source files, no model global config 👍
- Each model has the individual config (kind, cron, grain) and the `SELECT` statement which are similar idea to dbt, but no Jinja syntax here! 🎉
- Great Web IDE with data lineage 🎉
- Oh wow! `sqlmesh prompt` command - LLM 🎉
- No package ecosystem but it seems to utilize the python's eco one which is huge 💯

**Struggling?!**:

- How to run a specific model and debug the compiled sql code?
  - `sqlmesh run` command only allow to run all stuff with a date range
  - `sqlmesh plan` command seems to be the same. Oh! `sqlmesh plan --select-model <model>` will do
  - `sqlmesh render <model>` command seems to be helpful to see the SQL compiled code
  - `sqlmesh evaluate <model>` command is my goal here, voila!
- How to generate the project documentation site and host it in Github Page? With `sqlmesh ui` command? It seems impossible as of v0.28?!
- What are the steps we should perform in CI/CD? I will find out later!

## 2. Model development and Testing

- **Adding seeds & models**
  - It is not so quick to add the seeds because I neeed to create the coresponding model files with explicitly specifying the list of columns and datatypes 😢
  - `sqlmesh evaluate raw_customers` produces an error "Cannot find snapshot for 'raw_customers'" 😢
    - Oh! I need to have the model name passed in! So, I should run `sqlmesh evaluate jf.raw_customers` ✅
  - To see the compiled sql code, let's use `sqlmesh render jf.stg_customers` 👍
  - Try to duplicate the model name within the model config, and `sqlmesh plan` will complain: `Error: Duplicate key 'jf.raw_customers' found in UniqueKeyDict<models>. Call dict.update(...) if this is intentional.` 👍
  - Auto-completion works very nicely when coding the model 🎉
  - A built-in linter with `sqlmesh format`, hmm...the result looks not great in my imagination, but still looks ok!👍
  - No incremental run or full refresh run, it is to deal with date range or full load by default 👍
  - Greate readability expo with zero Jinja code 🎉
  - Not a great expo with CLI typing because the command is long, easy to wrongly type and hence takes time 👎, but it is fine with Web IDE 💕
  - Aha! Semi-colonm is important bit here if it is not related to SQL e.g. model config, macros 👀
  - [Loop or Control flow ops](https://sqlmesh.readthedocs.io/en/stable/concepts/macros/sqlmesh_macros/#control-flow-operators) is cool even it takes sometime to get familiar with 👍
    - Found a limitation: `@EACH(@payment_methods, x -> ... as @x_amount)` will fail but work like a charm when change to `@EACH(@payment_methods, x -> ... as amount_@x)` ⚠️
  - Seems that the CLI logs was not exposed somewhere - hard to debug when something wrong happened 🤔
    - There we go! Let's set the env variable `SQLMESH_DEBUG=1` ✅
  - In the model kind of `INCREMENTAL_BY_UNIQUE_KEY`, the `unique_key` config is a tuple e.g. `(key1, key2)`, if I made it as an array `[key1, key2]`, it would hang your `sqlmesh` command(s) ⚠️
  - Plan & Apply in Postgress randomly have error message ❗, do it again with a success ⚠️

    ```bash
    Failed to create schema 'jf': duplicate key value violates unique constraint "pg_namespace_nspname_index"
    DETAIL:  Key (nspname)=(jf) already exists.

    Failed to create schema 'jf': duplicate key value violates unique constraint "pg_namespace_nspname_index"
    DETAIL:  Key (nspname)=(jf) already exists.
    ```

    - This is to be dealing with the concurrency config (default to 4 tasks), definitely an issue with Postgres adapter, but we can workaround by set it to `1` ✅
  - Take sometime to get familiar with new concept [Virtual Environment](https://tobikodata.com/virtual-data-environments.html). There are several schemas get created within `plan` operation including: your configured schema & the environment schemas 👍
    - Each env schema will be physically as:
      - Schema name is auto-prefixed by `sqlmesh__` e.g. `sqlmesh__jf` 👀
      - Table name is auto-prefixed by the configured schema name, and auto-suffixed with a hash e.g. `jf__orders__1347386500` 👀
  - Recommended to [join Slack community](https://tobikodata.com/slack), the team is very supportive when I asked questions🙏

- **Adding audits and tests**:
  - Audit is reusable - `@this_model` is represented to the attached model 🎉
    - Let's get familiar with `audit` command e.g. `sqlmesh audit --model jf.orders` 🏃
    - I need to add it to each model config 👀
    - It is NOT fully reusable if the column name is vary ⚠️
      - NO! Actually it allows to parameterize the audit with variable e.g. `@column is null` and then in the model config using `audits [assert_not_null(column=order_id)]`
    - Similar idea to dbt singular test - write the sql to fail the case 👍
      - I can join with other models if needed ✅
    - Modifying an audit requires to apply a plan first ❓
    - Quite easy to create the similar dbt generic tests in the audit: `not null`, `unique`, `accepted values`, `relationships` 👍
      - Actually they have those [buit-in audits here](https://sqlmesh.readthedocs.io/en/stable/concepts/audits/#built-in-audits) 🎉
    - The log output of audit seems not to mention the attached model ❓

      ```log
      (.env) C:\Users\DAT\Documents\Sources\sqlmesh-demo>sqlmesh audit                  
      Found 21 audit(s).
      assert_positive_order_ids PASS.
      assert_not_null PASS.
      assert_unique PASS.
      assert_not_null PASS.
      assert_not_null PASS.
      assert_not_null PASS.
      assert_not_null PASS.
      assert_not_null PASS.
      assert_not_null PASS.
      assert_not_null PASS.
      assert_accepted_values PASS.
      assert_unique PASS.
      assert_relationships PASS.
      assert_not_null PASS.
      assert_unique PASS.
      assert_not_null PASS.
      assert_unique PASS.
      assert_accepted_values PASS.
      assert_not_null PASS.
      assert_unique PASS.
      assert_accepted_values PASS.

      Finished with 0 audit errors and 0 audits skipped.
      Done.
      ```

  - Test is really `unit test` (with `duckdb` dialect) 🎉
    - I need to add yml file(s) to the `(repo)/tests` directory 👀
    - Might take time to implement because it requires to manually fake the data: both input and output ⚠️
    - Let's get familiar with `test` command e.g. `sqlmesh test -k test_full` 🏃
    - It has a risk of new SQL Syntax (in the modern DWH) which might be not supported in DuckDB ⚠️

- **Additional stuff**:
  - DRY with common functions
    - Let's try [Python macro](https://sqlmesh.readthedocs.io/en/stable/concepts/macros/sqlmesh_macros/#python-macro-functions) 👀
      - So far it's pefect 👍 until when trying with passing List arguments -- it is just hanging ⚠️
      - The syntax takes for a while to get familiar with (same expo when I started writting jinja) but the readability is better ✅
  - Column Level Security (aka Masking Policy), for example, in Snowflake ❓
    - Let's try [Pre/Post Statement](https://sqlmesh.readthedocs.io/en/stable/concepts/models/seed_models/#pre-and-post-statements) or [Statement](https://sqlmesh.readthedocs.io/en/stable/concepts/models/overview/#statements), better to get understanding of [Model Concept](https://sqlmesh.readthedocs.io/en/stable/concepts/models/sql_models/#model-ddl) first 👀
      - Voila I successfully managed it with sqlmesh macro + pre/post statement ✅
      - Here is a sample:
        - `(repo)/macros/snow-mask-ddl/schema_name.masking_func_name.sql` -- multiple masking funcs created in the `snow-mask-ddl` dir

        ```sql
        CREATE MASKING POLICY IF NOT EXISTS @schema.mp_customer_name AS (
            masked_column string
        ) RETURNS string ->
            CASE 
                WHEN CURRENT_ROLE() IN ('ANALYST') THEN masked_column
                    WHEN CURRENT_ROLE() IN ('SYSADMIN') THEN SHA2(masked_column)
            ELSE '**********'
        END;
        ```

        - 2 main macros to create&apply the func:

        ```python
        import os
        from sqlmesh import macro
        @macro()
        def apply_masking_policy(evaluator, column: str, func: str, params: str):
            param_list = str(params).split("|")
            return """
                INSERT INTO {table}(id) VALUES ('{value}') --faking sql here
                """.format(
                table=str(func), value=f"{column}-applied-{func}-with-{','.join(param_list)}"
            )
        @macro()
        def create_masking_policy(evaluator, func: str):
            ddl_dir = os.path.dirname(os.path.realpath(__file__))
            ddl_file = f"{ddl_dir}/snow-mask-ddl/{func}.sql"
            func_parts = str(func).split(".")
            assert len(func_parts) == 2

            schema = func_parts[0]
            with open(ddl_file, "r") as file:
                content = file.read()
                return content.replace("@schema", schema)
        ```

        - And, use it the model

        ```sql
        MODEL (
          name jf.customers,
          ...
        );

        @create_masking_policy(common.mp_customer_name);

        /model sql code here/;

        @apply_masking_policy(last_name, common.mp_customer_name, first_name | last_name)
        ```

  - Metadata analysis
    - State gets stored into the gateway database under the schema named `sqlmesh` by default 👍
      - Snapshot gets stored in `_snapshots` table, one row per model & version 👍
      - Seed gets stored in `_seeds` table, contains all seed data in a column 👀 -- definitely will have some limitation of size
      - Model schedule gets stored in `_intervals` table 👀
      - Run time per model or per run -- cannot find the info ❓
  
  - SqlMesh's Macros in another python package -- seems not support ❓

## 3. Setup CI

TBC

## 4. Deployment

TBC

Happy Engineering 🎉
