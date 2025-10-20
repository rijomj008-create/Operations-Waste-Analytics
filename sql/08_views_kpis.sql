-- ===========================
-- KPI Views (daily, weekly, region)
-- ===========================

-- DAILY KPIs
CREATE OR REPLACE VIEW ops.v_kpi_daily AS
SELECT
  date,
  COUNT(*) AS trips,
  ROUND(AVG(total_cost_eur),2) AS avg_cost,
  ROUND(SUM(total_distance_km),2) AS total_distance,
  ROUND(SUM(waste_collected_tonnes),2) AS total_waste,
  ROUND(100.0*AVG(on_time_flag),2) AS on_time_pct,
  ROUND(AVG(delay_minutes),2) AS avg_delay_min,
  SUM(failed_deliveries) AS failed_deliveries
FROM ops.v_routes_enriched_costs
GROUP BY date
ORDER BY date;

-- REGION DAILY KPIs
CREATE OR REPLACE VIEW ops.v_kpi_region_daily AS
SELECT
  date,
  region,
  region_name,
  COUNT(*) AS trips,
  ROUND(SUM(total_cost_eur),2) AS total_cost,
  ROUND(AVG(total_cost_eur),2) AS avg_cost_per_trip,
  ROUND(SUM(total_distance_km),2) AS total_distance,
  ROUND(AVG(total_distance_km),2) AS avg_distance_per_trip,
  ROUND(100.0*AVG(on_time_flag),2) AS on_time_pct,
  ROUND(AVG(delay_minutes),2) AS avg_delay_min
FROM ops.v_routes_enriched_costs
GROUP BY date, region, region_name
ORDER BY date, region;

-- WEEKLY KPIs
CREATE OR REPLACE VIEW ops.v_kpi_weekly AS
SELECT
  DATE_TRUNC('week', date)::date AS week_start,
  COUNT(*) AS trips,
  ROUND(SUM(total_cost_eur),2) AS total_cost,
  ROUND(AVG(total_cost_eur),2) AS avg_cost_per_trip,
  ROUND(100.0*AVG(on_time_flag),2) AS on_time_pct,
  ROUND(AVG(delay_minutes),2) AS avg_delay_min,
  SUM(failed_deliveries) AS failed_deliveries
FROM ops.v_routes_enriched_costs
GROUP BY 1
ORDER BY 1;

-- MONTHLY KPIs
CREATE OR REPLACE VIEW ops.v_kpi_monthly AS
SELECT
  DATE_TRUNC('month', date)::date AS month_start,
  COUNT(*) AS trips,
  ROUND(SUM(total_cost_eur),2) AS total_cost,
  ROUND(AVG(total_cost_eur),2) AS avg_cost_per_trip,
  ROUND(100.0*AVG(on_time_flag),2) AS on_time_pct,
  ROUND(AVG(delay_minutes),2) AS avg_delay_min,
  SUM(failed_deliveries) AS failed_deliveries
FROM ops.v_routes_enriched_costs
GROUP BY 1
ORDER BY 1;
