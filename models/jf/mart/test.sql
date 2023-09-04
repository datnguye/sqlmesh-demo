MODEL (
  name other.test,
  kind FULL,
  cron '@daily',
  grain ARRAY[id]
);

WITH cte AS (
  SELECT
    1 AS id
)
SELECT
  * /* @make_indicators('vehicle', ARRAY['truck', 'bus']), *  trigger PR */
FROM cte