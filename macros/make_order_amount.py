from sqlmesh import macro


@macro()
def make_order_amounts(
    evaluator,
    payment_method_values=[],
    column__payment_method: str = "payment_method",
    column__amount: str = "amount",
):
    """Build SQL block to calculate the order amount based on the payment methods

    Args:
        evaluator (obj): SQLMesh evaluation context
        payment_method_values (List): Payment method value list
        column__payment_method (str, optional): Column name of the payment method. Defaults to "payment_method".
        column__amount (str, optional): Column name of the amount. Defaults to "amount".

    Returns:
        str: SQL block
    """
    return [
        f"""SUM(
            CASE 
                WHEN {column__payment_method} = {item}
                    THEN {column__amount}
                ELSE 0
            END
        ) AS {item.name}_amount
        """
        for item in payment_method_values.expressions
    ]
