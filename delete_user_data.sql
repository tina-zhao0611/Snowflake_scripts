-- Dangerous operation - should get DANGEROUS rating and be BLOCKED
USE DATABASE AIX_SHARED_DB;
USE SCHEMA PUBLIC;

-- This should be blocked by your safety analysis
DELETE FROM USERS WHERE LAST_LOGIN < '2023-01-01';

-- Drop column is also dangerous
ALTER TABLE USERS DROP COLUMN OLD_FIELD;