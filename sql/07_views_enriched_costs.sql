-- ===========================
-- v_routes_enriched_costs
-- ===========================
-- Extend enriched view with derived cost metrics and cost components

CREATE OR REPLACE VIEW ops.v_routes_enriched_costs AS
SELECT
  e.*,
  ROUND(e.fuel_cost_eur + e.driver_cost_eur + COALESCE(e.sub_base_cost_eur,0)
        + COALESCE(e.sub_variable_km_cost_eur,0) + COALESCE(e.sub_penalties_eur,0),2) AS cost_total_check,
  ROUND((e.total_cost_eur / NULLIF(e.total_distance_km,0)),2) AS cost_per_km,
  ROUND((e.total_cost_eur / NULLIF(e.actual_stops,0)),2) AS cost_per_stop,
  ROUND((e.total_cost_eur / NULLIF(e.waste_collected_tonnes,0)),2) AS cost_per_tonne
FROM ops.v_routes_enriched e;
