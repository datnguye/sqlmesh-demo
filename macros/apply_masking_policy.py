from sqlmesh import macro


@macro()
def apply_masking_policy(evaluator, column: str, func: str, params: str):
    param_list = str(params).split("|")
    return """
        INSERT INTO {table}(id) VALUES ('{value}')
        """.format(
        table=str(func), value=f"{column}-applied-{func}-with-{','.join(param_list)}"
    )
