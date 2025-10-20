-- ===========================
-- WEATHER & TRAFFIC IMPACT
-- ===========================

CREATE OR REPLACE VIEW ops.v_weather_impact AS
SELECT
  weather_condition,
  ROUND(AVG(delay_minutes),2) AS avg_delay_min,
  ROUND(100.0*AVG(on_time_flag),2) AS on_time_pct,
  ROUND(AVG(total_cost_eur),2) AS avg_cost_per_trip,
  COUNT(*) AS trips
FROM ops.v_routes_enriched_costs
GROUP BY weather_condition
ORDER BY avg_delay_min DESC;

CREATE OR REPLACE VIEW ops.v_traffic_summary AS
SELECT
  t.traffic_level,
  ROUND(AVG(r.delay_minutes),2) AS avg_delay_min,
  ROUND(100.0*AVG(r.on_time_flag),2) AS on_time_pct,
  ROUND(AVG(r.total_cost_eur),2) AS avg_cost_per_trip,
  COUNT(*) AS trips
FROM ops.v_routes_enriched_costs r
JOIN ops.region_lookup rl ON rl.region_code = r.region
JOIN ops.traffic t ON t.traffic_level = rl.traffic_level
GROUP BY t.traffic_level
ORDER BY avg_delay_min DESC;
