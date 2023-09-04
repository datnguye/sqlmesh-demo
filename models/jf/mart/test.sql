MODEL (
  name other.test,
  kind FULL,
  cron '@daily',
  grain ARRAY[id],
);

with cte as (
  SELECT 1 as id,
)
select *--@make_indicators('vehicle', ARRAY['truck', 'bus']), *
from cte