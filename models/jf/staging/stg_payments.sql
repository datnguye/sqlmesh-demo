MODEL (
  name jf.stg_payments,
  kind VIEW,
  cron '@daily',
  grain ARRAY[payment_id],
  audits ARRAY[
    ASSERT_NOT_NULL(column = payment_id),
    ASSERT_UNIQUE(columns = [payment_id]),
    ASSERT_ACCEPTED_VALUES(column = payment_method, accepted_values = ARRAY['credit_card','coupon','bank_transfer','gift_card']),
  ]
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