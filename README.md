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

---

## 🚀 Project Objective

To replicate how an **Operations Analyst** would manage transport efficiency —
turning raw route, weather, and driver data into measurable KPIs, cost models, and performance simulations.

The focus wasn’t on flashy visuals, but on **decision enablement**:

* What’s driving cost per trip or per km?
* How much impact would a 10% rise in fuel or 5% gain in punctuality actually have?
* Which subcontractors deliver reliability, and which quietly burn margin?

The deliverable: a **data model and simulation dashboard** that management could use to forecast cost, test “what-if” improvements, and validate operational strategy before execution.

---

## 🧠 My Approach

I structured the project as if it were a 3-phase rollout in a real company:

| Phase                               | Goal                                                                                                   | Output                                                            |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------- |
| **Phase 1 – Data Foundation**       | Build relational schema linking routes, regions, vehicles, drivers, subcontractors, weather & traffic. | SQL schema with clean staging → final ops tables                  |
| **Phase 2 – Modeling & Enrichment** | Standardize cost, time, and performance metrics.                                                       | KPI-ready views for Power BI                                      |
| **Phase 3 – Simulation Layer**      | Enable management to test cost and performance outcomes.                                               | Power BI what-if parameters for fuel, delay cost, and punctuality |

This mirrors the analytical maturity curve — **from descriptive → diagnostic → prescriptive** — using only SQL, Python, and Power BI.

---

## 🧮 Key Insights Uncovered

Through this model, I could answer the same questions a hiring manager would expect from their analytics hire:

| Business Question                                                     | Analytical Answer                                                                |
| --------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| *Which regions have the highest cost per trip?*                       | Region D7 had ~40% higher per-trip cost, mainly due to subcontractor dependency. |
| *Do weather conditions correlate with delay?*                         | Heavy rain caused a 50% increase in delay minutes vs. clear days.                |
| *How does time slot affect performance?*                              | Early morning (06:00–08:00) had higher cost/km but better on-time %.             |
| *Can a 5% improvement in on-time performance materially reduce cost?* | Yes — roughly €800–€1,200 savings per week, depending on fuel multiplier.        |

These insights aren’t hypothetical — they’re measurable through the Power BI simulation model.

---

## 📊 Dashboard Overview

Each dashboard page represents a lens through which operations can be optimized:

### **1. Executive Dashboard**

High-level snapshot of total trips, average cost per km, on-time %, delay minutes, and delivery failures.
Built for daily operational briefings.

---

### **2. Cost Breakdown**

Shows cost composition per region and per trip (fuel, driver, subcontractor).
Helps prioritize where to cut waste and where to renegotiate subcontractor terms.

---

### **3. Subcontractor Performance**

Ranks subcontractors on reliability, cost/km, and failure rates.
The aim: identify partners who sustain profit, not just complete trips.

---

### **4. Drivers Performance**

Driver-level scorecard linking cost, delay, and success rate — helping distinguish between high-efficiency and high-risk drivers.

---

### **5. Weather & Traffic Impact**

Analyzes environmental influence — quantifying how rain or peak-hour traffic adds measurable delay and cost per km.

---

### **6. Performance Simulation**

An interactive model to test “what-if” scenarios:

* Fuel Price ±10%
* On-Time % Improvement (+5%)
* Delay Cost €/min

Management can immediately see **how operational improvements or external shocks change total cost** and cost delta by region or subcontractor.

---

## 🧩 Reproducibility & Scaling

This repository is designed for **plug-and-play extension** — meaning anyone can scale it from 10 days to 90+ days of operational data without touching the schema.

To reproduce locally:

### 1️⃣ Database Setup

1. Install PostgreSQL
2. Create the database:

   ```sql
   CREATE DATABASE transport_ops;
   ```
3. Run all SQL scripts from `/sql/` in order (01 → 10).
   This creates schemas (`ops`, `ops_stg`), loads staging data, and builds analytical views.

---

### 2️⃣ Data Generation (Optional)

If you want to generate new synthetic data:

```bash
cd python
pip install -r requirements.txt
python generate_synthetic.py
python load_to_postgres.py
```

> Adjust the `DAYS` parameter in `generate_synthetic.py` (default: 10) to simulate more days of operations.

---

### 3️⃣ Power BI Connection

1. Open `Operations_Performance_Dashboard.pbix`
2. Update the PostgreSQL connection string to your local DB
3. Refresh all visuals — everything should populate automatically

---

### 4️⃣ Optional: Extend the Model

* Add **live API weather data** to `ops.weather`
* Include **GPS route optimization metrics** in `ops.routes`
* Replace synthetic data with real company exports

---

## 🧠 Key Takeaways

This project isn’t about fancy visuals — it’s about mindset.

It reflects how I’d approach an **Operations or Data Analyst** role in a logistics or sustainability-driven company:

* Understand the **business levers** (fuel, time, routes, people)
* Structure data so it **answers financial questions instantly**
* Build tools that **replace gut instinct with measurable insight**

Every KPI, SQL view, and DAX measure here was built to mirror a real working environment — not coursework.

If I were handed a raw database in a new role, this is how I’d turn it into a decision system within weeks.

---

## 🪶 Author

**Rijo Mathew John**
Business Development & Data Analytics | Dublin, Ireland
📧 [rijomj008@gmail.com](mailto:rijomj008@gmail.com)
