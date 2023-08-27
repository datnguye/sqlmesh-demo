MODEL (
  name jf.stg_orders,
  kind VIEW,
  cron '@daily',
  grain ARRAY[order_id, customer_id],
  audits ARRAY[
    ASSERT_NOT_NULL(column = order_id),
    ASSERT_UNIQUE(columns = [order_id]),
    ASSERT_ACCEPTED_VALUES(column = status, accepted_values = ARRAY['placed','shipped','completed','return_pending','returned']),
  ]
);

WITH source AS (
  SELECT
    *
  FROM jf.raw_orders
), renamed AS (
  SELECT
    id AS order_id,
    user_id AS customer_id,
    order_date,
    status
  FROM source
)
SELECT
  *
FROM renamed