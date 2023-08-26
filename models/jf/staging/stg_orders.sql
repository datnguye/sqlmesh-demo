MODEL (
  name jf.stg_orders,
  kind VIEW,
  cron '@daily',
  grain ARRAY[order_id, customer_id]
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