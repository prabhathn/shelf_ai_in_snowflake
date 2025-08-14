-- Setup for Shelf AI Demo using Meta's Segment Anything 1.0 Model


-- ###############################################################################################
-- CREATE SNOWFLAKE OBJECTS
-- ###############################################################################################
USE ROLE ACCOUNTADMIN;
CREATE ROLE IF NOT EXISTS SHELF_AI_ROLE;

GRANT CREATE DATABASE ON ACCOUNT TO ROLE SHELF_AI_ROLE;
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE SHELF_AI_ROLE;
GRANT CREATE COMPUTE POOL ON ACCOUNT TO ROLE SHELF_AI_ROLE;
GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE SHELF_AI_ROLE;
GRANT MONITOR USAGE ON ACCOUNT TO ROLE SHELF_AI_ROLE;
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE SHELF_AI_ROLE;
GRANT ROLE SHELF_AI_ROLE TO ROLE ACCOUNTADMIN;

// Create Database, Warehouse, and Image stage
USE ROLE SHELF_AI_ROLE;
CREATE OR REPLACE DATABASE SHELF_AI_DEMO_DB;
CREATE OR REPLACE SCHEMA SHELF_AI_SCHEMA;

USE DATABASE SHELF_AI_DEMO_DB;
USE SCHEMA SHELF_AI_SCHEMA;


-- Create stages for images. You can either create a Snowflake-hosted stage or use an external stage
-- from S3, for example

-- Internal Stage - You can either upload files to this stage using Snowsight UI or us SnowSQL to PUT
-- files from your local device to this stage.
CREATE STAGE SHELF_IMAGE_UPLOAD
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

-- External Stage
-- See https://docs.snowflake.com/en/sql-reference/sql/create-stage#label-create-external-stage-examples
-- for documentation on how to create an external stage
-- CREATE STAGE my_ext_stage
-- URL='s3://load/files/'
-- STORAGE_INTEGRATION = myint;


-- ###############################################################################################
-- CREATE EXTERNAL ACCESS INTEGRATIONS (EAI'S)
--
-- EAI's are specific security features that allow Snowflake to access an external
-- endpoint. If using in a Snowflake Notebook, you will need to go to Notebook Settings and
-- enable each of the required EAI's.
-- ###############################################################################################

USE ROLE ACCOUNTADMIN;

-- EAI: Pypi for access to key python packages like `diffusers`
CREATE OR REPLACE NETWORK RULE PYPI_NETWORK_RULE
    TYPE = HOST_PORT
    MODE = EGRESS
    VALUE_LIST = ('pypi.org', 'pypi.python.org', 'pythonhosted.org',  'files.pythonhosted.org');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION PYPI_ACCESS_INTEGRATION
    ALLOWED_NETWORK_RULES = (PYPI_NETWORK_RULE)
    ENABLED = true;

GRANT USAGE ON INTEGRATION PYPI_ACCESS_INTEGRATION TO ROLE SHELF_AI_ROLE;

-- EAI: Facebook Segment Anything download location
CREATE OR REPLACE NETWORK RULE SEGMENT_ANYTHING_NETWORK_RULE
    TYPE = HOST_PORT
    MODE = EGRESS
    VALUE_LIST= ('dl.fbaipublicfiles.com');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION SEGMENT_ANYTHING_EAI
    ALLOWED_NETWORK_RULES = (SEGMENT_ANYTHING_NETWORK_RULE)
    ENABLED = true;

GRANT USAGE ON INTEGRATION SEGMENT_ANYTHING_EAI TO ROLE SHELF_AI_ROLE;
