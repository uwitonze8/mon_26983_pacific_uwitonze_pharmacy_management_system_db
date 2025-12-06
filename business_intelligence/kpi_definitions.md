# KPI Definitions

> Key Performance Indicators for the Pharmacy Management System

---

## Overview

This document defines all Key Performance Indicators (KPIs) used in the Pharmacy Management System's business intelligence solution. Each KPI includes its definition, calculation formula, target values, and monitoring frequency.

---

## KPI Categories

| Category | Description | Number of KPIs |
|----------|-------------|----------------|
| Financial | Revenue and payment metrics | 8 |
| Operational | Prescription and dispensing metrics | 7 |
| Inventory | Stock and supply chain metrics | 6 |
| Customer | Patient-related metrics | 5 |
| Staff | Employee performance metrics | 4 |

---

## Financial KPIs

### FIN-001: Total Revenue

| Attribute | Value |
|-----------|-------|
| **Definition** | Total amount collected from completed payments |
| **Formula** | `SUM(amount) WHERE status = 'COMPLETED'` |
| **Unit** | RWF (Rwandan Franc) |
| **Frequency** | Real-time |
| **Target** | Based on historical trends + growth target |
| **Owner** | Finance Manager |

```sql
SELECT SUM(amount) AS total_revenue
FROM payment
WHERE status = 'COMPLETED'
  AND payment_date BETWEEN :start_date AND :end_date;
```

---

### FIN-002: Average Transaction Value

| Attribute | Value |
|-----------|-------|
| **Definition** | Average amount per completed transaction |
| **Formula** | `Total Revenue / COUNT(completed payments)` |
| **Unit** | RWF |
| **Frequency** | Daily |
| **Target** | ≥ ₣2,000 |
| **Owner** | Finance Manager |

```sql
SELECT ROUND(AVG(amount), 2) AS avg_transaction_value
FROM payment
WHERE status = 'COMPLETED'
  AND payment_date BETWEEN :start_date AND :end_date;
```

---

### FIN-003: Collection Rate

| Attribute | Value |
|-----------|-------|
| **Definition** | Percentage of billed amount that has been collected |
| **Formula** | `(Collected Amount / Total Billed) × 100` |
| **Unit** | Percentage |
| **Frequency** | Daily |
| **Target** | ≥ 95% |
| **Owner** | Finance Manager |

```sql
SELECT ROUND(
    SUM(CASE WHEN status = 'COMPLETED' THEN amount ELSE 0 END) * 100.0 /
    NULLIF(SUM(amount), 0), 2
) AS collection_rate
FROM payment
WHERE payment_date BETWEEN :start_date AND :end_date;
```

---

### FIN-004: Revenue by Payment Method

| Attribute | Value |
|-----------|-------|
| **Definition** | Revenue breakdown by payment type (Cash/Card/Insurance) |
| **Formula** | `SUM(amount) GROUP BY payment_method` |
| **Unit** | RWF and Percentage |
| **Frequency** | Weekly |
| **Target** | Diversified payment mix |
| **Owner** | Finance Manager |

---

### FIN-005: Outstanding Payments

| Attribute | Value |
|-----------|-------|
| **Definition** | Total value of pending/unpaid transactions |
| **Formula** | `SUM(amount) WHERE status = 'PENDING'` |
| **Unit** | RWF |
| **Frequency** | Daily |
| **Target** | ≤ 10% of monthly revenue |
| **Owner** | Finance Manager |

---

### FIN-006: Revenue Growth Rate

| Attribute | Value |
|-----------|-------|
| **Definition** | Percentage change in revenue compared to previous period |
| **Formula** | `((Current Period - Previous Period) / Previous Period) × 100` |
| **Unit** | Percentage |
| **Frequency** | Monthly |
| **Target** | ≥ 5% month-over-month |
| **Owner** | Executive Management |

---

### FIN-007: Revenue per Doctor

| Attribute | Value |
|-----------|-------|
| **Definition** | Total revenue generated from each doctor's prescriptions |
| **Formula** | `SUM(payment.amount) GROUP BY doctor` |
| **Unit** | RWF |
| **Frequency** | Monthly |
| **Target** | Identify top performers |
| **Owner** | Pharmacy Manager |

---

### FIN-008: Average Days to Payment

| Attribute | Value |
|-----------|-------|
| **Definition** | Average time from prescription to payment completion |
| **Formula** | `AVG(payment_date - prescription.issue_date)` |
| **Unit** | Days |
| **Frequency** | Weekly |
| **Target** | ≤ 1 day |
| **Owner** | Finance Manager |

---

## Operational KPIs

### OPS-001: Prescription Fulfillment Rate

| Attribute | Value |
|-----------|-------|
| **Definition** | Percentage of prescriptions completed successfully |
| **Formula** | `(Completed Prescriptions / Total Prescriptions) × 100` |
| **Unit** | Percentage |
| **Frequency** | Daily |
| **Target** | ≥ 98% |
| **Owner** | Pharmacy Manager |

```sql
SELECT ROUND(
    COUNT(CASE WHEN status IN ('DISPENSED', 'COMPLETED') THEN 1 END) * 100.0 /
    NULLIF(COUNT(*), 0), 2
) AS fulfillment_rate
FROM prescription
WHERE issue_date BETWEEN :start_date AND :end_date;
```

---

### OPS-002: Average Processing Time

| Attribute | Value |
|-----------|-------|
| **Definition** | Average time from prescription creation to dispensing |
| **Formula** | `AVG(dispensing_date - issue_date)` |
| **Unit** | Minutes |
| **Frequency** | Hourly |
| **Target** | ≤ 15 minutes |
| **Owner** | Pharmacy Manager |

```sql
SELECT ROUND(AVG(
    (dm.dispensing_date - p.issue_date) * 24 * 60
), 2) AS avg_processing_minutes
FROM prescription p
JOIN dispensed_medicines dm ON p.prescription_id = dm.prescription_id
WHERE dm.dispensing_date BETWEEN :start_date AND :end_date;
```

---

### OPS-003: Prescriptions per Day

| Attribute | Value |
|-----------|-------|
| **Definition** | Average number of prescriptions processed daily |
| **Formula** | `COUNT(prescriptions) / Number of Days` |
| **Unit** | Count |
| **Frequency** | Daily |
| **Target** | Based on capacity planning |
| **Owner** | Pharmacy Manager |

---

### OPS-004: Peak Hour Volume

| Attribute | Value |
|-----------|-------|
| **Definition** | Hour with highest prescription volume |
| **Formula** | `COUNT(prescriptions) GROUP BY HOUR` |
| **Unit** | Count per hour |
| **Frequency** | Weekly |
| **Target** | Used for staffing decisions |
| **Owner** | Pharmacy Manager |

---

### OPS-005: Prescription Status Distribution

| Attribute | Value |
|-----------|-------|
| **Definition** | Breakdown of prescriptions by current status |
| **Formula** | `COUNT(*) GROUP BY status` |
| **Unit** | Count and Percentage |
| **Frequency** | Real-time |
| **Target** | Minimal backlog in NEW/VALIDATED |
| **Owner** | Pharmacy Manager |

---

### OPS-006: Items per Prescription

| Attribute | Value |
|-----------|-------|
| **Definition** | Average number of medicine items per prescription |
| **Formula** | `COUNT(prescription_items) / COUNT(prescriptions)` |
| **Unit** | Count |
| **Frequency** | Weekly |
| **Target** | Monitoring only |
| **Owner** | Pharmacy Manager |

---

### OPS-007: Validation Error Rate

| Attribute | Value |
|-----------|-------|
| **Definition** | Percentage of prescriptions requiring re-validation |
| **Formula** | `(Rejected Validations / Total Validations) × 100` |
| **Unit** | Percentage |
| **Frequency** | Weekly |
| **Target** | ≤ 2% |
| **Owner** | Pharmacy Manager |

---

## Inventory KPIs

### INV-001: Stock Turnover Rate

| Attribute | Value |
|-----------|-------|
| **Definition** | How many times inventory is sold and replaced |
| **Formula** | `Cost of Goods Sold / Average Inventory Value` |
| **Unit** | Ratio |
| **Frequency** | Monthly |
| **Target** | 8-12 times per year |
| **Owner** | Stock Manager |

---

### INV-002: Low Stock Alert Count

| Attribute | Value |
|-----------|-------|
| **Definition** | Number of medicines at or below reorder level |
| **Formula** | `COUNT WHERE current_stock <= reorder_level` |
| **Unit** | Count |
| **Frequency** | Real-time |
| **Target** | 0 (ideal) |
| **Owner** | Stock Manager |

```sql
SELECT COUNT(*) AS low_stock_count
FROM medicine
WHERE current_stock <= reorder_level;
```

---

### INV-003: Out of Stock Rate

| Attribute | Value |
|-----------|-------|
| **Definition** | Percentage of products with zero stock |
| **Formula** | `(Zero Stock Items / Total Items) × 100` |
| **Unit** | Percentage |
| **Frequency** | Daily |
| **Target** | ≤ 1% |
| **Owner** | Stock Manager |

---

### INV-004: Expiry Loss Rate

| Attribute | Value |
|-----------|-------|
| **Definition** | Value of medicines lost due to expiration |
| **Formula** | `SUM(expired_stock × unit_price) / Total Inventory Value` |
| **Unit** | Percentage |
| **Frequency** | Monthly |
| **Target** | ≤ 0.5% |
| **Owner** | Stock Manager |

---

### INV-005: Inventory Accuracy

| Attribute | Value |
|-----------|-------|
| **Definition** | Match between system records and physical count |
| **Formula** | `(Matching Items / Total Items Counted) × 100` |
| **Unit** | Percentage |
| **Frequency** | Monthly (during audit) |
| **Target** | ≥ 99% |
| **Owner** | Stock Manager |

---

### INV-006: Days of Supply

| Attribute | Value |
|-----------|-------|
| **Definition** | Number of days current stock will last |
| **Formula** | `Current Stock / Average Daily Usage` |
| **Unit** | Days |
| **Frequency** | Weekly |
| **Target** | 30-60 days for most items |
| **Owner** | Stock Manager |

---

## Customer KPIs

### CUS-001: Active Patients

| Attribute | Value |
|-----------|-------|
| **Definition** | Patients with prescriptions in the last 90 days |
| **Formula** | `COUNT(DISTINCT patient_id) WHERE issue_date >= SYSDATE - 90` |
| **Unit** | Count |
| **Frequency** | Weekly |
| **Target** | Growth trend |
| **Owner** | Pharmacy Manager |

---

### CUS-002: New Patient Acquisition

| Attribute | Value |
|-----------|-------|
| **Definition** | Number of new patients registered in period |
| **Formula** | `COUNT WHERE created_date IN period` |
| **Unit** | Count |
| **Frequency** | Monthly |
| **Target** | ≥ 10% growth |
| **Owner** | Pharmacy Manager |

---

### CUS-003: Patient Visit Frequency

| Attribute | Value |
|-----------|-------|
| **Definition** | Average prescriptions per patient |
| **Formula** | `COUNT(prescriptions) / COUNT(DISTINCT patients)` |
| **Unit** | Ratio |
| **Frequency** | Monthly |
| **Target** | Indicates loyalty |
| **Owner** | Pharmacy Manager |

---

### CUS-004: Top Patients by Revenue

| Attribute | Value |
|-----------|-------|
| **Definition** | Ranking of patients by total spending |
| **Formula** | `SUM(payment.amount) GROUP BY patient ORDER BY DESC` |
| **Unit** | RWF |
| **Frequency** | Monthly |
| **Target** | Identify VIP customers |
| **Owner** | Pharmacy Manager |

---

### CUS-005: Patient Wait Time

| Attribute | Value |
|-----------|-------|
| **Definition** | Average time patient waits for prescription |
| **Formula** | `AVG(service_completion_time - arrival_time)` |
| **Unit** | Minutes |
| **Frequency** | Daily |
| **Target** | ≤ 10 minutes |
| **Owner** | Pharmacy Manager |

---

## Staff KPIs

### STF-001: Prescriptions per Pharmacist

| Attribute | Value |
|-----------|-------|
| **Definition** | Average prescriptions dispensed per pharmacist |
| **Formula** | `COUNT(dispensed) / COUNT(DISTINCT pharmacist)` |
| **Unit** | Count |
| **Frequency** | Daily |
| **Target** | Based on workload standards |
| **Owner** | Pharmacy Manager |

```sql
SELECT ph.name,
       COUNT(dm.dispensed_id) AS prescriptions_dispensed
FROM pharmacist ph
LEFT JOIN dispensed_medicines dm ON ph.pharmacist_id = dm.pharmacist_id
WHERE dm.dispensing_date BETWEEN :start_date AND :end_date
GROUP BY ph.name
ORDER BY prescriptions_dispensed DESC;
```

---

### STF-002: Revenue per Pharmacist

| Attribute | Value |
|-----------|-------|
| **Definition** | Revenue generated by each pharmacist's dispensed prescriptions |
| **Formula** | `SUM(payment.amount) GROUP BY pharmacist` |
| **Unit** | RWF |
| **Frequency** | Monthly |
| **Target** | Fair distribution |
| **Owner** | Pharmacy Manager |

---

### STF-003: Error Rate per Staff

| Attribute | Value |
|-----------|-------|
| **Definition** | Dispensing errors attributed to each pharmacist |
| **Formula** | `COUNT(errors) / COUNT(prescriptions) × 100` |
| **Unit** | Percentage |
| **Frequency** | Monthly |
| **Target** | ≤ 0.1% |
| **Owner** | Pharmacy Manager |

---

### STF-004: Staff Utilization Rate

| Attribute | Value |
|-----------|-------|
| **Definition** | Percentage of working hours spent on productive tasks |
| **Formula** | `(Productive Hours / Total Shift Hours) × 100` |
| **Unit** | Percentage |
| **Frequency** | Weekly |
| **Target** | 75-85% |
| **Owner** | Pharmacy Manager |

---

## KPI Dashboard Summary

| KPI ID | KPI Name | Current | Target | Status |
|--------|----------|---------|--------|--------|
| FIN-001 | Total Revenue | - | - | 🟢 |
| FIN-003 | Collection Rate | - | ≥ 95% | 🟢 |
| OPS-001 | Fulfillment Rate | - | ≥ 98% | 🟡 |
| OPS-002 | Avg Processing Time | - | ≤ 15 min | 🟢 |
| INV-002 | Low Stock Count | - | 0 | 🔴 |
| INV-003 | Out of Stock Rate | - | ≤ 1% | 🟢 |
| CUS-001 | Active Patients | - | Growth | 🟢 |

**Status Legend:**
- 🟢 On Target
- 🟡 Warning (within 10% of target)
- 🔴 Below Target

---

## KPI Review Schedule

| Review Type | Frequency | Participants |
|-------------|-----------|--------------|
| Daily Huddle | Daily | Pharmacists, Manager |
| Weekly Review | Weekly | Manager, Finance |
| Monthly Board | Monthly | Executive Team |
| Quarterly Strategy | Quarterly | All Stakeholders |
