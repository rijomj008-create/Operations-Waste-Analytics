-- Create logical schemas for clean (ops) and raw (ops_stg)
CREATE SCHEMA IF NOT EXISTS ops;
CREATE SCHEMA IF NOT EXISTS ops_stg;

-- Optional: default search path while developing
SET search_path TO ops, public;
