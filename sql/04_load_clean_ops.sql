-- ===========================
-- CLEAN LOAD INTO FINAL TABLES (FK-safe)
-- ===========================
SET search_path TO ops, public;

BEGIN;

-- ROUTES
INSERT INTO routes (
  route_id, date, region, vehicle_id, driver_id, sub_id,
  planned_start, actual_start, planned_end, actual_end,
  planned_stops, actual_stops, total_distance_km, waste_collected_tonnes,
  fuel_litres_used, fuel_cost_eur, driver_cost_eur,
  sub_base_cost_eur, sub_variable_km_cost_eur, sub_penalties_eur,
  total_cost_eur, delay_minutes, on_time_flag, failed_deliveries
)
SELECT
  (NULLIF(TRIM(route_id), ''))::int,
  (NULLIF(TRIM(date), ''))::date,
  NULLIF(TRIM(region), ''),
  (NULLIF(TRIM(vehicle_id), ''))::int,
  (NULLIF(TRIM(driver_id), ''))::int,
  CASE
    WHEN sub_id IS NULL OR TRIM(sub_id) = '' THEN NULL
    WHEN TRIM(sub_id) ~ '^[0-9]+(\.0+)?$' THEN ((TRIM(sub_id))::numeric)::int
    ELSE NULL
  END AS sub_id,
  (NULLIF(TRIM(planned_start), ''))::time,
  (NULLIF(TRIM(actual_start), ''))::time,
  (NULLIF(TRIM(planned_end), ''))::time,
  (NULLIF(TRIM(actual_end), ''))::time,
  (NULLIF(TRIM(planned_stops), ''))::int,
  (NULLIF(TRIM(actual_stops), ''))::int,
  (NULLIF(TRIM(total_distance_km), ''))::numeric(7,1),
  (NULLIF(TRIM(waste_collected_tonnes), ''))::numeric(7,2),
  (NULLIF(TRIM(fuel_litres_used), ''))::numeric(10,2),
  (NULLIF(TRIM(fuel_cost_eur), ''))::numeric(12,2),
  (NULLIF(TRIM(driver_cost_eur), ''))::numeric(12,2),
  (NULLIF(TRIM(sub_base_cost_eur), ''))::numeric(12,2),
  (NULLIF(TRIM(sub_variable_km_cost_eur), ''))::numeric(12,2),
  (NULLIF(TRIM(sub_penalties_eur), ''))::numeric(12,2),
  (NULLIF(TRIM(total_cost_eur), ''))::numeric(14,2),
  (NULLIF(TRIM(delay_minutes), ''))::int,
  (NULLIF(TRIM(on_time_flag), ''))::int,
  (NULLIF(TRIM(failed_deliveries), ''))::int
FROM ops_stg.routes_raw;
COMMIT;

-- WEATHER
BEGIN;
INSERT INTO weather (date, condition, rainfall_mm, weather_delay_factor_min)
SELECT
  (NULLIF(TRIM(date), ''))::date,
  NULLIF(TRIM(condition), ''),
  COALESCE(NULLIF(TRIM(rainfall_mm), ''), '0')::numeric(6,1),
  (NULLIF(TRIM(weather_delay_factor_min), ''))::int
FROM ops_stg.weather_raw
ON CONFLICT (date) DO NOTHING;
COMMIT;

-- REGION LOOKUP
INSERT INTO region_lookup (
  region_code, region_name, traffic_level,
  avg_distance_km_min, avg_distance_km_max,
  typical_stops_min, typical_stops_max, collection_frequency
)
SELECT
  TRIM(r.region_code),
  NULLIF(TRIM(r.region_name), ''),
  CASE UPPER(TRIM(r.traffic_level))
       WHEN 'HIGH' THEN 'High'
       WHEN 'MEDIUM' THEN 'Medium'
       WHEN 'LOW' THEN 'Low'
       ELSE 'Medium'
  END,
  (NULLIF(TRIM(r.avg_distance_km_min), ''))::numeric(6,1),
  (NULLIF(TRIM(r.avg_distance_km_max), ''))::numeric(6,1),
  (NULLIF(TRIM(r.typical_stops_min), ''))::int,
  (NULLIF(TRIM(r.typical_stops_max), ''))::int,
  NULLIF(TRIM(r.collection_frequency), '')
FROM ops_stg.region_lookup_raw r
ON CONFLICT (region_code) DO NOTHING;

-- TRAFFIC
INSERT INTO traffic (time_slot, traffic_level, delay_factor_min)
SELECT
  TRIM(time_slot),
  CASE UPPER(TRIM(traffic_level))
       WHEN 'HIGH' THEN 'High'
       WHEN 'MEDIUM' THEN 'Medium'
       WHEN 'LOW' THEN 'Low'
       ELSE 'Low'
  END,
  (NULLIF(TRIM(delay_factor_min), ''))::int
FROM ops_stg.traffic_raw
ON CONFLICT (time_slot) DO NOTHING;

-- VEHICLES
INSERT INTO vehicles (vehicle_id, reg_no, capacity_tonnes, fuel_efficiency_km_per_litre)
SELECT
  (NULLIF(TRIM(vehicle_id), ''))::int,
  NULLIF(TRIM(reg_no), ''),
  (NULLIF(TRIM(capacity_tonnes), ''))::numeric(5,2),
  (NULLIF(TRIM(fuel_efficiency_km_per_litre), ''))::numeric(5,2)
FROM ops_stg.vehicles_raw
ON CONFLICT (vehicle_id) DO NOTHING;

-- DRIVERS
INSERT INTO drivers (driver_id, driver_name, driver_type)
SELECT
  (NULLIF(TRIM(driver_id), ''))::int,
  NULLIF(TRIM(driver_name), ''),
  CASE
    WHEN UPPER(TRIM(driver_type)) IN ('EMPLOYEE','E') THEN 'Employee'
    WHEN UPPER(TRIM(driver_type)) LIKE 'SUB%' THEN 'Subcontractor Driver'
    ELSE 'Employee'
  END
FROM ops_stg.drivers_raw
ON CONFLICT (driver_id) DO NOTHING;

-- SUBCONTRACTORS
INSERT INTO subcontractors (
  sub_id, name, base_cost_per_trip, cost_per_km,
  penalty_per_failed_delivery, performance_score
)
SELECT
  (NULLIF(TRIM(sub_id), ''))::int,
  NULLIF(TRIM(name), ''),
  (NULLIF(TRIM(base_cost_per_trip), ''))::numeric(10,2),
  (NULLIF(TRIM(cost_per_km), ''))::numeric(10,2),
  (NULLIF(TRIM(penalty_per_failed_delivery), ''))::numeric(10,2),
  (NULLIF(TRIM(performance_score), ''))::numeric(4,2)
FROM ops_stg.subcontractors_raw
ON CONFLICT (sub_id) DO NOTHING;

-- DELIVERIES
INSERT INTO deliveries (
  delivery_id, route_id, client_id, delivery_time, status, weight_tonnes, region
)
SELECT
  (NULLIF(TRIM(d.delivery_id), ''))::int,
  (NULLIF(TRIM(d.route_id), ''))::int,
  (NULLIF(TRIM(d.client_id), ''))::int,
  (NULLIF(TRIM(d.delivery_time), ''))::timestamp,
  CASE WHEN UPPER(TRIM(d.status)) = 'FAILED' THEN 'Failed' ELSE 'Success' END,
  (NULLIF(TRIM(d.weight_tonnes), ''))::numeric(10,3),
  NULLIF(TRIM(d.region), '')
FROM ops_stg.deliveries_raw d
JOIN ops.routes r
  ON r.route_id = (NULLIF(TRIM(d.route_id), ''))::int;
