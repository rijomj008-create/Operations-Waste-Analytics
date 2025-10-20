-- ===========================
-- v_routes_enriched
-- ===========================
-- Enrich raw route data with driver, region, subcontractor, and weather context

CREATE OR REPLACE VIEW ops.v_routes_enriched AS
SELECT
  r.route_id,
  r.date,
  r.region,
  rl.region_name,
  rl.traffic_level,
  r.vehicle_id,
  v.reg_no,
  v.capacity_tonnes,
  v.fuel_efficiency_km_per_litre,
  r.driver_id,
  d.driver_name,
  d.driver_type,
  r.sub_id,
  s.name AS subcontractor_name,
  s.performance_score AS subcontractor_perf,
  w.condition AS weather_condition,
  w.rainfall_mm,
  w.weather_delay_factor_min,
  r.planned_stops,
  r.actual_stops,
  r.total_distance_km,
  r.waste_collected_tonnes,
  r.fuel_litres_used,
  r.fuel_cost_eur,
  r.driver_cost_eur,
  r.sub_base_cost_eur,
  r.sub_variable_km_cost_eur,
  r.sub_penalties_eur,
  r.total_cost_eur,
  r.delay_minutes,
  r.on_time_flag,
  r.failed_deliveries,
  ROUND((r.actual_stops::numeric / NULLIF(r.planned_stops,0))*100,2) AS utilisation_pct
FROM ops.routes r
JOIN ops.region_lookup rl ON rl.region_code = r.region
JOIN ops.vehicles v        ON v.vehicle_id = r.vehicle_id
JOIN ops.drivers d         ON d.driver_id  = r.driver_id
LEFT JOIN ops.subcontractors s ON s.sub_id = r.sub_id
JOIN ops.weather w         ON w.date = r.date;
