-- ===========================
-- STAGING TABLES (raw CSV imports)
-- ===========================

CREATE SCHEMA IF NOT EXISTS ops_stg;
SET search_path TO ops_stg, public;

-- Each table mirrors its CSV headers — all TEXT for flexible import.

DROP TABLE IF EXISTS routes_raw;
CREATE TABLE routes_raw (
  route_id                  text,
  date                      text,
  region                    text,
  vehicle_id                text,
  driver_id                 text,
  sub_id                    text,
  planned_start             text,
  actual_start              text,
  planned_end               text,
  actual_end                text,
  planned_stops             text,
  actual_stops              text,
  total_distance_km         text,
  waste_collected_tonnes    text,
  fuel_litres_used          text,
  fuel_cost_eur             text,
  driver_cost_eur           text,
  sub_base_cost_eur         text,
  sub_variable_km_cost_eur  text,
  sub_penalties_eur         text,
  total_cost_eur            text,
  delay_minutes             text,
  on_time_flag              text,
  failed_deliveries         text
);

DROP TABLE IF EXISTS deliveries_raw;
CREATE TABLE deliveries_raw (
  delivery_id      text,
  route_id         text,
  client_id        text,
  delivery_time    text,
  status           text,
  weight_tonnes    text,
  region           text
);

DROP TABLE IF EXISTS vehicles_raw;
CREATE TABLE vehicles_raw (
  vehicle_id                   text,
  reg_no                       text,
  capacity_tonnes              text,
  fuel_efficiency_km_per_litre text
);

DROP TABLE IF EXISTS drivers_raw;
CREATE TABLE drivers_raw (
  driver_id    text,
  driver_name  text,
  driver_type  text
);

DROP TABLE IF EXISTS subcontractors_raw;
CREATE TABLE subcontractors_raw (
  sub_id                        text,
  name                          text,
  base_cost_per_trip            text,
  cost_per_km                   text,
  penalty_per_failed_delivery   text,
  performance_score             text
);

DROP TABLE IF EXISTS region_lookup_raw;
CREATE TABLE region_lookup_raw (
  region_code           text,
  region_name           text,
  traffic_level         text,
  avg_distance_km_min   text,
  avg_distance_km_max   text,
  typical_stops_min     text,
  typical_stops_max     text,
  collection_frequency  text
);

DROP TABLE IF EXISTS weather_raw;
CREATE TABLE weather_raw (
  date                      text,
  condition                 text,
  rainfall_mm               text,
  weather_delay_factor_min  text
);

DROP TABLE IF EXISTS traffic_raw;
CREATE TABLE traffic_raw (
  time_slot        text,
  traffic_level    text,
  delay_factor_min text
);
