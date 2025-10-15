-- Test Table Creation Script for Snowflake Deployment Automation
-- Schema: AIX_SHARED_DB.PUBLIC
-- Purpose: Test GitHub webhook → Lambda → n8n → LangFlow → Liquibase pipeline
-- Created: 2025-10-14 22:10:20

--node testing 20:32

USE DATABASE AIX_SHARED_DB;
USE SCHEMA PUBLIC;

-- Create a test table for deployment automation testing
CREATE OR REPLACE TABLE AIX_SHARED_DB.PUBLIC.DEPLOYMENT_TEST_TABLE (
    -- Primary key and identifiers
    TEST_ID NUMBER(10,0) AUTOINCREMENT PRIMARY KEY,
    DEPLOYMENT_RUN_ID VARCHAR(50) NOT NULL,

    -- Test data fields
    TEST_NAME VARCHAR(100) NOT NULL,
    TEST_DESCRIPTION VARCHAR(500),
    TEST_STATUS VARCHAR(20) DEFAULT 'PENDING',

    -- Timestamp fields
    CREATED_TIMESTAMP TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    UPDATED_TIMESTAMP TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),

    -- Test metadata
    GITHUB_COMMIT_ID VARCHAR(50),
    DEPLOYED_BY VARCHAR(100),
    ENVIRONMENT VARCHAR(20) DEFAULT 'QA',

    -- JSON field for flexible test data
    TEST_METADATA VARIANT,

    -- Constraints
    CONSTRAINT CHK_TEST_STATUS CHECK (TEST_STATUS IN ('PENDING', 'RUNNING', 'PASSED', 'FAILED')),
    CONSTRAINT CHK_ENVIRONMENT CHECK (ENVIRONMENT IN ('DEV', 'QA', 'STAGING', 'PROD'))
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS IDX_DEPLOYMENT_TEST_STATUS 
ON AIX_SHARED_DB.PUBLIC.DEPLOYMENT_TEST_TABLE (TEST_STATUS);

CREATE INDEX IF NOT EXISTS IDX_DEPLOYMENT_TEST_TIMESTAMP 
ON AIX_SHARED_DB.PUBLIC.DEPLOYMENT_TEST_TABLE (CREATED_TIMESTAMP);

-- Insert sample test data
INSERT INTO AIX_SHARED_DB.PUBLIC.DEPLOYMENT_TEST_TABLE 
(DEPLOYMENT_RUN_ID, TEST_NAME, TEST_DESCRIPTION, GITHUB_COMMIT_ID, DEPLOYED_BY, TEST_METADATA)
VALUES 
('RUN_001', 'GitHub Webhook Test', 'Testing webhook trigger from repository push', 'abc123def456', 'automation-system', 
 PARSE_JSON('{"test_type": "webhook", "expected_result": "success", "priority": "high"}')),

('RUN_002', 'Schema Validation Test', 'Testing Liquibase schema deployment', 'def456ghi789', 'automation-system',
 PARSE_JSON('{"test_type": "schema", "expected_result": "success", "priority": "medium"}')),

('RUN_003', 'AI Agent Analysis Test', 'Testing LangFlow agent schema analysis', 'ghi789jkl012', 'automation-system',
 PARSE_JSON('{"test_type": "ai_analysis", "expected_result": "success", "priority": "high"}'));

-- Create a view for monitoring deployment tests
CREATE OR REPLACE VIEW AIX_SHARED_DB.PUBLIC.VW_DEPLOYMENT_TEST_SUMMARY AS
SELECT 
    ENVIRONMENT,
    TEST_STATUS,
    COUNT(*) AS TEST_COUNT,
    MIN(CREATED_TIMESTAMP) AS FIRST_TEST,
    MAX(CREATED_TIMESTAMP) AS LAST_TEST
FROM AIX_SHARED_DB.PUBLIC.DEPLOYMENT_TEST_TABLE
GROUP BY ENVIRONMENT, TEST_STATUS
ORDER BY ENVIRONMENT, TEST_STATUS;

-- Grant appropriate permissions (adjust as needed for your environment)
-- GRANT SELECT ON AIX_SHARED_DB.PUBLIC.DEPLOYMENT_TEST_TABLE TO ROLE ANALYST_ROLE;
-- GRANT ALL ON AIX_SHARED_DB.PUBLIC.DEPLOYMENT_TEST_TABLE TO ROLE ADMIN_ROLE;

-- Add comments to the table for documentation
COMMENT ON TABLE AIX_SHARED_DB.PUBLIC.DEPLOYMENT_TEST_TABLE IS 
'Test table for automated Snowflake deployment pipeline. Used to validate GitHub webhook integration, AI agent analysis, and schema deployment automation.';

COMMENT ON COLUMN AIX_SHARED_DB.PUBLIC.DEPLOYMENT_TEST_TABLE.TEST_ID IS 
'Auto-incrementing primary key for test records';

COMMENT ON COLUMN AIX_SHARED_DB.PUBLIC.DEPLOYMENT_TEST_TABLE.DEPLOYMENT_RUN_ID IS 
'Unique identifier for each deployment run, useful for tracking automated deployments';

COMMENT ON COLUMN AIX_SHARED_DB.PUBLIC.DEPLOYMENT_TEST_TABLE.TEST_METADATA IS 
'JSON field containing flexible test metadata and configuration';

-- Show table information
DESCRIBE TABLE AIX_SHARED_DB.PUBLIC.DEPLOYMENT_TEST_TABLE;

-- Verify data insertion
SELECT COUNT(*) AS TOTAL_RECORDS FROM AIX_SHARED_DB.PUBLIC.DEPLOYMENT_TEST_TABLE;

-- Display sample data
SELECT * FROM AIX_SHARED_DB.PUBLIC.DEPLOYMENT_TEST_TABLE LIMIT 5;

-- Show view results
SELECT * FROM AIX_SHARED_DB.PUBLIC.VW_DEPLOYMENT_TEST_SUMMARY;
