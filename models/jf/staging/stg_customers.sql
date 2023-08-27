MODEL (
  name jf.stg_customers,
  kind VIEW,
  cron '@daily',
  grain ARRAY[customer_id],
  audits ARRAY[
    ASSERT_NOT_NULL(column = customer_id),
    ASSERT_UNIQUE(columns = [customer_id])
  ]
);

WITH source AS (
  SELECT
    *
  FROM jf.raw_customers
), renamed AS (
  SELECT
    id AS customer_id,
    first_name,
    last_name
  FROM source
)
SELECT
  *
FROM renamed