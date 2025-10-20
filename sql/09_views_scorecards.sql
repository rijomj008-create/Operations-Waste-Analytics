-- ===========================
-- PERFORMANCE SCORECARDS
-- ===========================

-- DRIVER SCORECARD
CREATE OR REPLACE VIEW ops.v_driver_scorecard AS
SELECT
  driver_id,
  driver_name,
  driver_type,
  COUNT(*) AS trips,
  ROUND(AVG(delay_minutes),2) AS avg_delay_min,
  ROUND(100.0*AVG(on_time_flag),2) AS on_time_pct,
  ROUND(AVG(total_cost_eur),2) AS avg_cost_per_trip,
  ROUND(AVG(utilisation_pct),2) AS avg_utilisation_pct,
  SUM(failed_deliveries) AS failed_deliveries
FROM ops.v_routes_enriched_costs
GROUP BY driver_id, driver_name, driver_type
ORDER BY avg_delay_min ASC;

-- SUBCONTRACTOR SCORECARD
CREATE OR REPLACE VIEW ops.v_subcontractor_scorecard AS
SELECT
  COALESCE(sub_id, -1)                       AS sub_id,
  COALESCE(subcontractor_name, 'In-house')   AS subcontractor,
  COUNT(*)                                   AS trips,
  ROUND(AVG(total_cost_eur), 2)              AS avg_cost_per_trip,
  ROUND(AVG(CASE WHEN total_distance_km>0 THEN total_cost_eur/total_distance_km END), 2) AS avg_cost_per_km,
  ROUND(100.0 * AVG(CASE WHEN on_time_flag=1 THEN 1 ELSE 0 END), 2) AS on_time_pct,
  SUM(failed_deliveries)                     AS failed_deliveries,
  ROUND(AVG(subcontractor_perf), 2)          AS avg_perf_score,
  ROUND(AVG(sub_base_cost_eur + sub_variable_km_cost_eur + sub_penalties_eur),2) AS avg_sub_cost_component
FROM ops.v_routes_enriched_costs
GROUP BY COALESCE(sub_id, -1), COALESCE(subcontractor_name, 'In-house')
ORDER BY subcontractor;
