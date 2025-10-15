-- Dangerous operation - should get DANGEROUS rating and be BLOCKED
USE DATABASE AIX_SHARED_DB;
USE SCHEMA PUBLIC;

-- This should be blocked by your safety analysis
DROP TABLE IF EXISTS OLD_USER_DATA;

DROP TABLE IF EXISTS TEMP_MIGRATION_TABLE;