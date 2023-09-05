from sqlmesh import macro


@macro()
def make_indicators(evaluator, string_column, string_values):
    return [
        f"""CASE
            WHEN {string_column} = {value} THEN {value} 
            ELSE CAST(NULL as VARCHAR)
        END AS {string_column.name}_{value.name}"""
        for value in string_values.expressions
    ]
