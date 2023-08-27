AUDIT (
  name assert_not_null,
);

SELECT *
FROM @this_model
WHERE
  @column is null
