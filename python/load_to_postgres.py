import os, psycopg2
from dotenv import load_dotenv

load_dotenv()

# --- DB Connection ---
conn = psycopg2.connect(
    host=os.getenv("PG_HOST", "localhost"),
    port=os.getenv("PG_PORT", "5432"),
    dbname=os.getenv("PG_DB", "Operations Waste Management"),
    user=os.getenv("PG_USER", "postgres"),
    password=os.getenv("PG_PASSWORD", "changeme")
)
cur = conn.cursor()

def copy(table, csv_path):
    print(f"Loading {csv_path} → {table}")
    with open(csv_path, "r", encoding="utf-8") as f:
        cur.copy_expert(sql=f"COPY {table} FROM STDIN WITH CSV HEADER", file=f)
    conn.commit()
    print("✅ Done.")

# --- Load files into staging tables ---
copy("ops_stg.routes_raw", "python/data/routes.csv")
copy("ops_stg.deliveries_raw", "python/data/deliveries.csv")
copy("ops_stg.drivers_raw", "python/data/drivers.csv")
copy("ops_stg.subcontractors_raw", "python/data/subcontractors.csv")
copy("ops_stg.region_lookup_raw", "python/data/region_lookup.csv")
copy("ops_stg.weather_raw", "python/data/weather.csv")
copy("ops_stg.traffic_raw", "python/data/traffic.csv")
copy("ops_stg.vehicles_raw", "python/data/vehicles.csv")

cur.close()
conn.close()
print("✅ All files loaded into PostgreSQL staging schema.")
