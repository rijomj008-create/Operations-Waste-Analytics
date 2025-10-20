import argparse, os, pandas as pd, numpy as np
from datetime import date, timedelta
from faker import Faker

fake = Faker()

def daterange(start, days):
    for i in range(days):
        yield start + timedelta(days=i)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--start", type=lambda s: date.fromisoformat(s), default=date(2025,8,1))
    ap.add_argument("--days", type=int, default=10)
    ap.add_argument("--outdir", default="python/data")
    args = ap.parse_args()
    os.makedirs(args.outdir, exist_ok=True)

    # ---------- VEHICLES ----------
    vehicles = pd.DataFrame({
        "vehicle_id": range(1, 11),
        "reg_no": [f"KG-{100+i}" for i in range(10)],
        "capacity_tonnes": np.random.choice([6,8,10,12], 10),
        "fuel_efficiency": np.random.uniform(3.5, 5.5, 10).round(2)
    })
    vehicles.to_csv(f"{args.outdir}/vehicles.csv", index=False)

    # ---------- DRIVERS ----------
    drivers = pd.DataFrame({
        "driver_id": range(200, 212),
        "driver_name": [f"Driver_{i}" for i in range(200,212)],
        "driver_type": np.random.choice(["In-house","Agency"], 12)
    })
    drivers.to_csv(f"{args.outdir}/drivers.csv", index=False)

    # ---------- SUBCONTRACTORS ----------
    subs = pd.DataFrame({
        "sub_id": range(1,6),
        "name": [f"SubCo_{i}" for i in range(1,6)],
        "cost_per_trip": np.random.uniform(120,160,5).round(2),
        "fuel_cost": np.random.uniform(20,40,5).round(2),
        "penalty_fees": np.random.uniform(0,30,5).round(2),
        "performance_score": np.random.uniform(0.7,0.95,5).round(2)
    })
    subs.to_csv(f"{args.outdir}/subcontractors.csv", index=False)

    # ---------- REGION LOOKUP ----------
    region_lookup = pd.DataFrame({
        "region_code": ["D1","D2","D7","D8","D12"],
        "region_name": ["City Centre N","South City","Smithfield","Docklands","Inchicore"],
        "traffic_level": np.random.choice(["Low","Medium","High"], 5),
        "avg_distance_km_min":[10,12,14,12,15],
        "avg_distance_km_max":[22,24,28,26,30],
        "typical_stops_min":[8,8,10,9,9],
        "typical_stops_max":[16,18,20,18,20],
        "collection_frequency":["7 days","7 days","Mon/Wed/Fri","Tue/Thu/Sat","Mon–Fri"]
    })
    region_lookup.to_csv(f"{args.outdir}/region_lookup.csv", index=False)

    # ---------- WEATHER ----------
    dates = list(daterange(args.start, args.days))
    conditions = ["Clear","Light Rain","Heavy Rain","Windy","Overcast"]
    weather = pd.DataFrame({
        "date": dates,
        "condition": np.random.choice(conditions, len(dates)),
        "rainfall_mm": np.random.uniform(0,20,len(dates)).round(1),
        "weather_delay_factor_min": np.random.choice([0,5,10,15,20,25,30], len(dates))
    })
    weather.to_csv(f"{args.outdir}/weather.csv", index=False)

    # ---------- TRAFFIC ----------
    traffic = pd.DataFrame({
        "time_slot": ["06:00-08:00","08:00-10:00","10:00-16:00","16:00-18:00","18:00-22:00","Off-hours"],
        "traffic_delay_factor_min":[6,10,3,9,4,1]
    })
    traffic.to_csv(f"{args.outdir}/traffic.csv", index=False)

    # ---------- ROUTES & DELIVERIES ----------
    rng = np.random.default_rng(7)
    routes, deliveries = [], []
    route_id = 1

    for d in dates:
        for region in region_lookup["region_code"]:
            v = rng.integers(1,11)
            driver = rng.integers(200,212)
            sub = rng.choice([None,1,2,3,4,5], p=[0.7,0.06,0.06,0.06,0.06,0.06])
            planned_stops = rng.integers(9,18)
            actual_stops = max(0, planned_stops + rng.integers(-2,3))
            dist = rng.uniform(14,28)
            waste = dist/4 + rng.uniform(-1,1)
            delay = max(0, rng.integers(-5,25))
            on_time = 1 if delay<=10 else 0
            failed = max(0, rng.integers(0,3))
            fuel_l = dist/ rng.uniform(3.5,5.5)
            driver_cost = 100 + 2*delay
            fuel_cost = fuel_l*1.75
            sub_base = 0 if sub is None else 160
            sub_km = 0 if sub is None else dist*2.2
            sub_pen = 0 if sub is None else failed*25
            total_cost = driver_cost + fuel_cost + sub_base + sub_km + sub_pen

            routes.append([route_id,d,region,v,driver,sub,
                           "06:30","06:40","12:30","12:50",
                           planned_stops,actual_stops,round(dist,1),round(waste,2),
                           round(fuel_l,2),round(fuel_cost,2),round(driver_cost,2),
                           round(sub_base,2),round(sub_km,2),round(sub_pen,2),
                           round(total_cost,2),delay,on_time,failed])

            for i in range(actual_stops):
                deliveries.append([
                    f"{route_id:05d}-{i+1}", route_id, rng.integers(1000,9999),
                    f"{d} 09:{rng.integers(10,59):02d}:00",
                    rng.choice(["Success","Failed"], p=[0.93,0.07]),
                    round(rng.uniform(0.1,0.5),3), region
                ])
            route_id += 1

    routes = pd.DataFrame(routes, columns=[
        "route_id","date","region","vehicle_id","driver_id","sub_id",
        "planned_start","actual_start","planned_end","actual_end",
        "planned_stops","actual_stops","total_distance_km","waste_collected_tonnes",
        "fuel_litres_used","fuel_cost_eur","driver_cost_eur",
        "sub_base_cost_eur","sub_variable_km_cost_eur","sub_penalties_eur",
        "total_cost_eur","delay_minutes","on_time_flag","failed_deliveries"
    ])
    deliveries = pd.DataFrame(deliveries, columns=[
        "delivery_id","route_id","client_id","delivery_time","status","weight_tonnes","region"
    ])

    routes.to_csv(f"{args.outdir}/routes.csv", index=False)
    deliveries.to_csv(f"{args.outdir}/deliveries.csv", index=False)

    print(f"✅ Synthetic data generated for {args.days} days → {args.outdir}/")

if __name__ == "__main__":
    main()
