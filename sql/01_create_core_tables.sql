-- Ensure we’re writing into ops
SET search_path TO ops, public;

-- ===========================
-- DIMENSIONS / CONTEXT
-- ===========================

-- Regions / service areas
CREATE TABLE IF NOT EXISTS region_lookup (
  region_code              text PRIMARY KEY,
  region_name              text NOT NULL,
  traffic_level            text NOT NULL CHECK (traffic_level IN ('High','Medium','Low')),
  avg_distance_km_min      numeric(6,1) NOT NULL,
  avg_distance_km_max      numeric(6,1) NOT NULL,
  typical_stops_min        int NOT NULL,
  typical_stops_max        int NOT NULL,
  collection_frequency     text NOT NULL
);
CREATE INDEX IF NOT EXISTS region_lookup_traffic_level_idx ON region_lookup (traffic_level);

-- Traffic time-slot lookup
CREATE TABLE IF NOT EXISTS traffic (
  time_slot            text PRIMARY KEY,  -- e.g. '06:00-08:00'
  traffic_level        text NOT NULL CHECK (traffic_level IN ('High','Medium','Low')),
  delay_factor_min     int  NOT NULL
);

-- Fleet / vehicles
CREATE TABLE IF NOT EXISTS vehicles (
  vehicle_id                      int PRIMARY KEY,
  reg_no                          text NOT NULL,
  capacity_tonnes                 numeric(5,2) NOT NULL,
  fuel_efficiency_km_per_litre    numeric(5,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS vehicles_capacity_idx ON vehicles (capacity_tonnes);

-- Drivers
CREATE TABLE IF NOT EXISTS drivers (
  driver_id     int PRIMARY KEY,
  driver_name   text NOT NULL,
  driver_type   text NOT NULL CHECK (driver_type IN ('Employee','Subcontractor Driver'))
);
CREATE INDEX IF NOT EXISTS drivers_type_idx ON drivers (driver_type);

-- Subcontractors
CREATE TABLE IF NOT EXISTS subcontractors (
  sub_id                          int PRIMARY KEY,
  name                            text NOT NULL,
  base_cost_per_trip              numeric(10,2) NOT NULL,
  cost_per_km                     numeric(10,2) NOT NULL,
  penalty_per_failed_delivery     numeric(10,2) NOT NULL,
  performance_score               numeric(4,2)  NOT NULL
);
CREATE INDEX IF NOT EXISTS subcontractors_perf_idx ON subcontractors (performance_score);

-- Weather by day
CREATE TABLE IF NOT EXISTS weather (
  date                          date PRIMARY KEY,
  condition                     text NOT NULL,            -- e.g. Clear/Overcast/Light Rain/Heavy Rain/Windy
  rainfall_mm                   numeric(6,1) NOT NULL,
  weather_delay_factor_min      int NOT NULL
);
CREATE INDEX IF NOT EXISTS weather_condition_idx ON weather (condition);

-- ===========================
-- FACTS
-- ===========================

-- Routes (trip-level)
-- Drop explicitly only if you intend to rebuild it in dev workflows
-- DROP TABLE IF EXISTS routes;

CREATE TABLE IF NOT EXISTS routes (
  route_id                    int PRIMARY KEY,
  date                        date NOT NULL REFERENCES weather(date) ON UPDATE CASCADE ON DELETE RESTRICT,
  region                      text NOT NULL REFERENCES region_lookup(region_code) ON UPDATE CASCADE ON DELETE RESTRICT,
  vehicle_id                  int NOT NULL REFERENCES vehicles(vehicle_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  driver_id                   int NOT NULL REFERENCES drivers(driver_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  sub_id                      int NULL REFERENCES subcontractors(sub_id) ON UPDATE CASCADE ON DELETE SET NULL,

  planned_start               time NOT NULL,
  actual_start                time NOT NULL,
  planned_end                 time NOT NULL,
  actual_end                  time NOT NULL,

  planned_stops               int NOT NULL,
  actual_stops                int NOT NULL,

  total_distance_km           numeric(7,1) NOT NULL,
  waste_collected_tonnes      numeric(7,2) NOT NULL,

  fuel_litres_used            numeric(10,2) NOT NULL,
  fuel_cost_eur               numeric(12,2) NOT NULL,
  driver_cost_eur             numeric(12,2) NOT NULL,

  sub_base_cost_eur           numeric(12,2) NOT NULL,
  sub_variable_km_cost_eur    numeric(12,2) NOT NULL,
  sub_penalties_eur           numeric(12,2) NOT NULL,

  total_cost_eur              numeric(14,2) NOT NULL,
  delay_minutes               int NOT NULL,
  on_time_flag                int NOT NULL CHECK (on_time_flag IN (0,1)),
  failed_deliveries           int NOT NULL
);

-- Helpful indexes for common filters and joins
CREATE INDEX IF NOT EXISTS routes_date_idx        ON routes (date);
CREATE INDEX IF NOT EXISTS routes_region_idx      ON routes (region);
CREATE INDEX IF NOT EXISTS routes_vehicle_idx     ON routes (vehicle_id);
CREATE INDEX IF NOT EXISTS routes_driver_idx      ON routes (driver_id);
CREATE INDEX IF NOT EXISTS routes_sub_idx         ON routes (sub_id);
CREATE INDEX IF NOT EXISTS routes_on_time_idx     ON routes (on_time_flag);

-- Deliveries (stop-level)
-- Only drop if you intend to rebuild
-- DROP TABLE IF EXISTS deliveries;

CREATE TABLE IF NOT EXISTS deliveries (
  delivery_id        int PRIMARY KEY,
  route_id           int NOT NULL REFERENCES routes(route_id) ON UPDATE CASCADE ON DELETE CASCADE,
  client_id          int NOT NULL,
  delivery_time      timestamp NOT NULL,
  status             text NOT NULL CHECK (status IN ('Success','Failed')),
  weight_tonnes      numeric(10,3) NOT NULL,
  region             text NOT NULL REFERENCES region_lookup(region_code) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS deliveries_route_idx     ON deliveries (route_id);
CREATE INDEX IF NOT EXISTS deliveries_status_idx    ON deliveries (status);
CREATE INDEX IF NOT EXISTS deliveries_time_idx      ON deliveries (delivery_time);
