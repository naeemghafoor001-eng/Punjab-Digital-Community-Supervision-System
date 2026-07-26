-- Enable PostGIS spatial extensions on pdcss_db
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Verify PostGIS installation
SELECT PostGIS_Full_Version();
