-- ===========================
-- CSV IMPORT EXAMPLES (pgAdmin or psql)
-- ===========================
-- Use \COPY or pgAdmin Import to load raw data from python/data/*.csv
-- Example (psql shell):
-- \COPY ops_stg.routes_raw FROM 'python/data/routes.csv' WITH CSV HEADER

\COPY ops_stg.routes_raw FROM 'python/data/routes.csv' WITH CSV HEADER;
\COPY ops_stg.deliveries_raw FROM 'python/data/deliveries.csv' WITH CSV HEADER;
\COPY ops_stg.vehicles_raw FROM 'python/data/vehicles.csv' WITH CSV HEADER;
\COPY ops_stg.drivers_raw FROM 'python/data/drivers.csv' WITH CSV HEADER;
\COPY ops_stg.subcontractors_raw FROM 'python/data/subcontractors.csv' WITH CSV HEADER;
\COPY ops_stg.region_lookup_raw FROM 'python/data/region_lookup.csv' WITH CSV HEADER;
\COPY ops_stg.weather_raw FROM 'python/data/weather.csv' WITH CSV HEADER;
\COPY ops_stg.traffic_raw FROM 'python/data/traffic.csv' WITH CSV HEADER;
