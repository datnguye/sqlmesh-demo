AUDIT (
  name assert_accepted_values,
);

SELECT *
FROM @this_model
WHERE
  @column not in @accepted_values
