# 🧭 Transport Operations Analytics – Cost Efficiency & Simulation

### 🎯 A self-initiated project to test my readiness for an Operations Analytics role

This project started with a job description I came across for an **Operational Data Analyst** role at a logistics and sustainability-driven company.
Instead of just reading it, I decided to challenge myself:

> *If I actually got hired for this role, how would I approach the job from day one?*

So I built the entire stack — from data generation and warehousing to business modeling and simulation — exactly as I would if I were designing the company’s analytics system.

It became a test of how well I could turn operational chaos (routes, fuel, drivers, subcontractors, weather delays) into something measurable, actionable, and scalable.

---

## 🧩 The Challenge

Most operational analytics jobs talk about “reducing transport cost,” “improving on-time delivery,” and “understanding cost drivers.”
But few explain *how* to connect those dots with real data.

My challenge:

* Create a **complete data model** that mirrors transport operations
* Simulate cost and performance shifts with **what-if scenarios**
* Deliver **Power BI dashboards** that let decision-makers see the financial impact of every operational tweak
* Make it **scalable** enough to grow from 10 days of data to 60+ days with no schema changes

---

## 🧭 Why It Matters

Businesses often operate on gut feel — especially in logistics, where weather, driver behavior, and route complexity constantly shift.
I wanted to prove that a structured data pipeline can *replace instinct with insight* and *turn reactive decisions into predictive ones.*

This wasn’t an academic exercise.
It’s a practical case study built under the mindset:

> “If I were sitting in that role next week, this is how I’d build it.”

---

## ⚙️ Tech Stack

| Layer                      | Tools & Skills                                                   |
| -------------------------- | ---------------------------------------------------------------- |
| **Data Generation**        | Python (`pandas`, `numpy`, `faker`)                              |
| **Data Storage**           | PostgreSQL (schema design + staging + transformation SQL)        |
| **Modeling & Analysis**    | SQL (views, aggregations, performance KPIs)                      |
| **Visualization**          | Power BI (interactive dashboard, DAX measures, what-if analysis) |
| **Version Control & Docs** | GitHub + Markdown                                                |

## 🧩 Repository Structure

```
├─ python/
│  ├─ generate_synthetic.py
│  ├─ load_to_postgres.py
│  ├─ requirements.txt
│  ├─ .env.example
│  └─ data/
│      ├─ routes.csv
│      ├─ vehicles.csv
│      ├─ drivers.csv
│      ├─ weather.csv
│      ├─ ...
│
├─ sql/
│  ├─ 01_create_schema.sql
│  ├─ 02_create_staging_tables.sql
│  ├─ 03_copy_from_csv_examples.sql
│  ├─ 04_load_clean_ops.sql
│  ├─ 05_quality_checks.sql
│  ├─ 06_views_enriched.sql
│  ├─ 07_views_enriched_costs.sql
│  ├─ 08_views_kpis.sql
│  ├─ 09_views_scorecards.sql
│  ├─ 10_views_weather_traffic_impact.sql
│
├─ powerbi/
│  ├─ Operations_Performance_Dashboard.pbix
│  ├─ measures_dax.txt
│  ├─ theme.json
│  └─ screenshots/
│      ├─ Executive Dashboard.png
│      ├─ Cost Breakdown.png
│      ├─ Subcontractor Performance.png
│      ├─ Drivers Performance.png
│      ├─ Weather & Traffic Impact.png
│      └─ Simulation.png
│
└─ README.md
```

---

## 🧮 Key Analytical Views (PostgreSQL)

| View                            | Purpose                                                     |
| ------------------------------- | ----------------------------------------------------------- |
| `v_routes_enriched`             | Combines routes, drivers, vehicles, subcontractors, weather |
| `v_routes_enriched_costs`       | Adds cost per km, per stop, and per tonne metrics           |
| `v_kpi_daily / weekly / region` | Performance KPIs over time and geography                    |
| `v_subcontractor_scorecard`     | Evaluates cost efficiency and reliability of vendors        |
| `v_weather_impact`              | Quantifies weather delays and cost correlation              |
| `v_traffic_summary`             | Links time slots to on-time percentage and cost             |

---

## 📊 Dashboard Overview

### **1. Executive Dashboard**

Summarizes daily performance — trips, average cost/km, delays, and failures — with trend analysis for cost and on-time performance.

---

### **2. Cost Breakdown**

Decomposes cost per trip by region and cost component (fuel, driver, subcontractor) to reveal where operational inefficiencies sit.

---

### **3. Subcontractor Performance**

Compares in-house vs outsourced routes on cost, on-time %, and failure rate. Highlights where subcontractor penalties outweigh performance.

---

### **4. Drivers Performance**

Benchmarks drivers on delay, cost, and delivery success — a quick lens to identify outliers or training needs.

---

### **5. Weather & Traffic Impact**

Correlates environmental conditions with average delay and cost per km, uncovering data-driven patterns behind inefficiency.

---

### **6. Performance Simulation**

Interactive “what-if” model.
Users can tweak:

* **Fuel Price Multiplier**
* **On-Time Improvement %**
* **Delay Cost €/min**

…and instantly visualize the **cost delta by region and subcontractor**, quantifying how operational improvements translate into real savings.

---

## 🔍 Analytical Highlights

* **Data pipeline built end-to-end**: from Python synthetic data → PostgreSQL warehouse → Power BI simulation.
* **Dynamic DAX measures** replicate scenario planning directly within Power BI.
* **Scalable**: currently 10-day data; structure supports 60-90 days or live streaming from APIs.
* **Business realism**: designed after studying logistics KPIs, not arbitrary data.

---

## 🧠 Takeaways

This project pushed me to think like both a **data engineer** and an **operations strategist**.
Instead of stopping at visualization, the goal was to simulate decisions — to see how *data replaces gut feeling* in operational planning.

The lesson: **Operational analytics isn’t about dashboards — it’s about decisions.**
How small changes (fuel, routes, punctuality) ripple across cost and reliability.

---

## 🪶 Author

**Rijo Mathew John**
Operation & Data Analytics | Dublin, Ireland
📧 [rijomj008@gmail.com](mailto:rijomj008@gmail.com)
