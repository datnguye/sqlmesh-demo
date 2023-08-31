MODEL (
  name jf.orders,
  kind FULL,
  cron '@daily',
  grain ARRAY[order_id, customer_id],
  audits ARRAY[
    ASSERT_NOT_NULL(column = order_id),
    ASSERT_NOT_NULL(column = customer_id),
    ASSERT_NOT_NULL(column = amount),
    ASSERT_NOT_NULL(column = amount_credit_card),
    ASSERT_NOT_NULL(column = amount_coupon),
    ASSERT_NOT_NULL(column = amount_bank_transfer),
    ASSERT_NOT_NULL(column = amount_gift_card),
    ASSERT_ACCEPTED_VALUES(column = status, accepted_values = ARRAY['placed','shipped','completed','return_pending','returned']),
    ASSERT_UNIQUE(columns = [order_id]),
    ASSERT_RELATIONSHIPS(column_name = customer_id, to = jf.customers, field = customer_id)
  ]
);

@DEF(payment_methods, ARRAY['credit_card', 'coupon', 'bank_transfer', 'gift_card']);

WITH orders AS (
  SELECT
    *
  FROM jf.stg_orders
), payments AS (
  SELECT
    *
  FROM jf.stg_payments
), order_payments AS (
  SELECT
    order_id,
    @EACH(
      @payment_methods,
      x -> SUM(CASE WHEN payment_method = x THEN amount ELSE 0 END) AS amount_@x
    ),
    --try python macro
    @make_order_amount(credit_card),
    @make_order_amount(coupon),
    SUM(amount) AS total_amount
  FROM payments
  GROUP BY
    order_id
), final AS (
  SELECT
    orders.order_id,
    orders.customer_id,
    orders.order_date,
    orders.status,
    @EACH(@payment_methods, x -> order_payments.amount_@x),
    order_payments.total_amount AS amount
  FROM orders
  LEFT JOIN order_payments
    ON orders.order_id = order_payments.order_id
)
SELECT
  *
FROM final