from sqlmesh import macro


@macro()
def make_indicators(evaluator, string_column, string_values):
    cases = []

    for value in string_values:
        cases.append(
            f"CASE WHEN {string_column} = '{value}' THEN '{value}' ELSE NULL END AS {string_column}_{value}"
        )

    return cases
