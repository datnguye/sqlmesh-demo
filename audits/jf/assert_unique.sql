AUDIT (
  name assert_unique,
);

SELECT @columns
FROM @this_model
GROUP BY @columns
HAVING COUNT(*) > 1
