-- ===========================
-- QC & VALIDATION
-- ===========================

-- Record counts per table
SELECT 'routes' AS table, COUNT(*) AS rows FROM ops.routes
UNION ALL
SELECT 'deliveries', COUNT(*) FROM ops.deliveries
UNION ALL
SELECT 'vehicles', COUNT(*) FROM ops.vehicles
UNION ALL
SELECT 'drivers', COUNT(*) FROM ops.drivers
UNION ALL
SELECT 'subcontractors', COUNT(*) FROM ops.subcontractors
UNION ALL
SELECT 'region_lookup', COUNT(*) FROM ops.region_lookup
UNION ALL
SELECT 'weather', COUNT(*) FROM ops.weather
UNION ALL
SELECT 'traffic', COUNT(*) FROM ops.traffic;

-- Date mismatch diagnostics
SELECT DISTINCT (NULLIF(TRIM(r.date),''))::date AS route_date
FROM ops_stg.routes_raw r
LEFT JOIN ops.weather w
  ON w.date = (NULLIF(TRIM(r.date),''))::date
WHERE w.date IS NULL
ORDER BY route_date;

-- Missing FK references (if any)
SELECT region FROM ops.routes WHERE region NOT IN (SELECT region_code FROM ops.region_lookup);
SELECT vehicle_id FROM ops.routes WHERE vehicle_id NOT IN (SELECT vehicle_id FROM ops.vehicles);
SELECT driver_id FROM ops.routes WHERE driver_id NOT IN (SELECT driver_id FROM ops.drivers);
