AUDIT (
  name assert_relationships,
);

WITH this as (
  SELECT @column_name
  FROM @this_model
  WHERE @column_name IS NOT NULL
),

ref as (
  SELECT @field
  FROM @to
  WHERE @field IS NOT NULL
)

SELECT
FROM this
JOIN ref ON ref.@field = this.@column_name
WHERE ref.@field IS NULL
