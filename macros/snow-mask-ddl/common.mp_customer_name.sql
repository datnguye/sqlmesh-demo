CREATE TABLE IF NOT EXISTS @schema.mp_customer_name (id varchar); --testing as replacement of the correct DDL
--CREATE MASKING POLICY IF NOT EXISTS @schema.mp_customer_name AS (
--    masked_column string
--) RETURNS string ->
--    CASE 
--        WHEN CURRENT_ROLE() IN ('ANALYST') THEN masked_column
--            WHEN CURRENT_ROLE() IN ('SYSADMIN') THEN SHA2(masked_column)
--    ELSE '**********'
--END;