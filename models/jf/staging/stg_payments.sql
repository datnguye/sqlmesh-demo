MODEL (
  name jf.stg_payments,
  kind VIEW,
  cron '@daily',
  grain ARRAY[payment_id]
);

WITH source AS (
  SELECT
    *
  FROM jf.raw_payments
), renamed AS (
  SELECT
    id AS payment_id,
    order_id,
    payment_method,
    amount /* `amount` is currently stored in cents, so we convert it to dollars */ / 100 AS amount
  FROM source
)
SELECT
  *
FROM renamed