import os
from sqlmesh import macro


@macro()
def create_masking_policy(evaluator, func: str):
    ddl_dir = os.path.dirname(os.path.realpath(__file__))
    ddl_file = f"{ddl_dir}/snow-mask-ddl/{func}.sql"
    func_parts = str(func).split(".")
    assert len(func_parts) == 2

    schema = func_parts[0]
    with open(ddl_file, "r") as file:
        content = file.read()
        
    return ";".join([
        f"CREATE SCHEMA IF NOT EXISTS {schema}",
        content.replace("@schema", schema)
    ])
