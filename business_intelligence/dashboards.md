# Dashboard Specifications

> Dashboard designs and specifications for the Pharmacy Management System

---

## Dashboard Overview

The BI solution includes four main dashboards tailored to different user roles and business needs.

| Dashboard | Primary Users | Purpose |
|-----------|---------------|---------|
| Executive Dashboard | Management | High-level KPIs and trends |
| Operations Dashboard | Pharmacists | Daily operations monitoring |
| Inventory Dashboard | Stock Manager | Inventory management |
| Financial Dashboard | Finance Team | Revenue and payment tracking |

---

## 1. Executive Dashboard

### Layout

```
┌─────────────────────────────────────────────────────────────────────┐
│                      EXECUTIVE DASHBOARD                             │
│                    Last Updated: [Timestamp]                         │
├─────────────────┬─────────────────┬─────────────────┬───────────────┤
│   TOTAL REVENUE │  PRESCRIPTIONS  │   AVG ORDER     │   CUSTOMERS   │
│   ₣ 2,450,000   │      1,234      │    ₣ 1,986      │     892       │
│   ▲ 12% MTD     │   ▲ 8% MTD      │   ▲ 5% MTD      │   ▲ 15% MTD   │
├─────────────────┴─────────────────┴─────────────────┴───────────────┤
│                                                                      │
│  REVENUE TREND (Last 12 Months)                                     │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │    ▄▄                                                    ▄▄██  │ │
│  │   ████  ▄▄          ▄▄    ▄▄▄▄        ▄▄    ▄▄▄▄    ▄▄██████  │ │
│  │  ██████████    ▄▄██████████████  ▄▄██████████████████████████  │ │
│  │  Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec               │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
├──────────────────────────────────┬──────────────────────────────────┤
│  TOP 5 MEDICINES BY REVENUE      │  PRESCRIPTIONS BY STATUS         │
│  ┌────────────────────────────┐  │  ┌────────────────────────────┐  │
│  │ 1. Amoxicillin    ₣450K   │  │  │      ┌────┐                │  │
│  │ 2. Paracetamol    ₣380K   │  │  │      │COM-│  COMPLETED     │  │
│  │ 3. Ibuprofen      ₣320K   │  │  │      │PLET│  65%           │  │
│  │ 4. Metformin      ₣280K   │  │  │  ┌───┤ED  │                │  │
│  │ 5. Omeprazole     ₣245K   │  │  │  │DIS│    │  DISPENSED     │  │
│  └────────────────────────────┘  │  │  │PEN│    │  20%           │  │
│                                   │  │  └───┴────┘                │  │
│                                   │  │  NEW: 10% | VALIDATED: 5%  │  │
│                                   │  └────────────────────────────┘  │
└──────────────────────────────────┴──────────────────────────────────┘
```

### KPIs Displayed

| KPI | Calculation | Refresh Rate |
|-----|-------------|--------------|
| Total Revenue | SUM(payment.amount) WHERE status='COMPLETED' | Real-time |
| Prescription Count | COUNT(prescription_id) | Real-time |
| Average Order Value | Total Revenue / Prescription Count | Real-time |
| Active Customers | COUNT(DISTINCT patient_id) | Daily |
| Month-to-Date Growth | (Current MTD - Previous MTD) / Previous MTD | Daily |

### SQL Query Examples

```sql
-- Total Revenue MTD
SELECT SUM(amount) AS total_revenue
FROM payment
WHERE status = 'COMPLETED'
  AND TRUNC(payment_date, 'MM') = TRUNC(SYSDATE, 'MM');

-- Monthly Revenue Trend
SELECT TO_CHAR(payment_date, 'MON-YYYY') AS month,
       SUM(amount) AS revenue
FROM payment
WHERE status = 'COMPLETED'
  AND payment_date >= ADD_MONTHS(SYSDATE, -12)
GROUP BY TO_CHAR(payment_date, 'MON-YYYY')
ORDER BY MIN(payment_date);
```

---

## 2. Operations Dashboard

### Layout

```
┌─────────────────────────────────────────────────────────────────────┐
│                     OPERATIONS DASHBOARD                             │
│                Pharmacist: [Name] | Shift: [Hours]                   │
├─────────────────┬─────────────────┬─────────────────┬───────────────┤
│ PENDING ORDERS  │  IN PROGRESS    │   COMPLETED     │   ALERTS      │
│      23         │       5         │      156        │     ⚠ 3       │
│   ▼ View All    │   ▼ View All    │   Today         │   ▼ View      │
├─────────────────┴─────────────────┴─────────────────┴───────────────┤
│                                                                      │
│  PRESCRIPTION QUEUE                                                  │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │ ID    │ Patient        │ Doctor         │ Status   │ Time     │ │
│  ├───────┼────────────────┼────────────────┼──────────┼──────────┤ │
│  │ 1045  │ Uwimana Jean   │ Dr. Mukamana   │ NEW      │ 5 min    │ │
│  │ 1044  │ Habimana Eric  │ Dr. Uwase      │ NEW      │ 12 min   │ │
│  │ 1043  │ Mutoni Alice   │ Dr. Kagame     │ VALIDATED│ 18 min   │ │
│  │ 1042  │ Ndayisaba Paul │ Dr. Uwimana    │ VALIDATED│ 25 min   │ │
│  │ 1041  │ Ingabire Marie │ Dr. Nshimyu... │ VALIDATED│ 32 min   │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
├──────────────────────────────────┬──────────────────────────────────┤
│  TODAY'S METRICS                 │  ALERTS & NOTIFICATIONS          │
│  ┌────────────────────────────┐  │  ┌────────────────────────────┐  │
│  │ Avg Processing Time: 8 min │  │  │ ⚠ Amoxicillin low stock   │  │
│  │ Prescriptions/Hour: 12     │  │  │ ⚠ 3 medicines expiring    │  │
│  │ Fulfillment Rate: 94%      │  │  │ ⚠ Pending payment #1039   │  │
│  │ Items Dispensed: 423       │  │  │                            │  │
│  └────────────────────────────┘  │  └────────────────────────────┘  │
└──────────────────────────────────┴──────────────────────────────────┘
```

### KPIs Displayed

| KPI | Calculation | Refresh Rate |
|-----|-------------|--------------|
| Pending Orders | COUNT WHERE status = 'NEW' | Real-time |
| In Progress | COUNT WHERE status = 'VALIDATED' | Real-time |
| Completed Today | COUNT WHERE status IN ('DISPENSED','COMPLETED') AND date = TODAY | Real-time |
| Avg Processing Time | AVG(dispensing_date - issue_date) | Hourly |
| Fulfillment Rate | Completed / Total Prescriptions * 100 | Hourly |

### SQL Query Examples

```sql
-- Prescription Queue
SELECT p.prescription_id,
       pt.name AS patient_name,
       d.name AS doctor_name,
       p.status,
       ROUND((SYSDATE - p.issue_date) * 24 * 60) AS wait_minutes
FROM prescription p
JOIN patient pt ON p.patient_id = pt.patient_id
JOIN doctor d ON p.doctor_id = d.doctor_id
WHERE p.status IN ('NEW', 'VALIDATED')
ORDER BY p.issue_date;

-- Today's Fulfillment Rate
SELECT ROUND(
    COUNT(CASE WHEN status IN ('DISPENSED','COMPLETED') THEN 1 END) * 100.0 /
    NULLIF(COUNT(*), 0), 2
) AS fulfillment_rate
FROM prescription
WHERE TRUNC(issue_date) = TRUNC(SYSDATE);
```

---

## 3. Inventory Dashboard

### Layout

```
┌─────────────────────────────────────────────────────────────────────┐
│                      INVENTORY DASHBOARD                             │
│                   Last Sync: [Timestamp]                             │
├─────────────────┬─────────────────┬─────────────────┬───────────────┤
│  TOTAL ITEMS    │  LOW STOCK      │  OUT OF STOCK   │  EXPIRING     │
│     1,245       │    ⚠ 12         │    ⛔ 3         │   ⏰ 8        │
│   Products      │   Products      │   Products      │   < 30 days   │
├─────────────────┴─────────────────┴─────────────────┴───────────────┤
│                                                                      │
│  LOW STOCK ALERTS (Stock ≤ Reorder Level)                           │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │ Medicine          │ Current │ Reorder │ Shortage │ Action      │ │
│  ├───────────────────┼─────────┼─────────┼──────────┼─────────────┤ │
│  │ Amoxicillin 250mg │   45    │   50    │    5     │ [Order Now] │ │
│  │ Metformin 500mg   │   30    │   75    │   45     │ [Order Now] │ │
│  │ Omeprazole 20mg   │   12    │   40    │   28     │ [Order Now] │ │
│  │ Aspirin 100mg     │   20    │   50    │   30     │ [Order Now] │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
├──────────────────────────────────┬──────────────────────────────────┤
│  STOCK BY CATEGORY               │  EXPIRING SOON (< 30 Days)       │
│  ┌────────────────────────────┐  │  ┌────────────────────────────┐  │
│  │ Antibiotics    ████████ 35%│  │  │ Insulin Vial    15-Dec-24  │  │
│  │ Analgesics     ██████  25% │  │  │ Vaccine A       18-Dec-24  │  │
│  │ Cardiovascular ████    15% │  │  │ Syrup XYZ       22-Dec-24  │  │
│  │ Gastrointest.  ███     12% │  │  │ Ointment ABC    28-Dec-24  │  │
│  │ Others         ███     13% │  │  │                            │  │
│  └────────────────────────────┘  │  └────────────────────────────┘  │
│                                   │                                  │
├──────────────────────────────────┴──────────────────────────────────┤
│  INVENTORY MOVEMENT (Last 7 Days)                                    │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │         ADD ███████████████████████  +1,250 units              │ │
│  │      DEDUCT ████████████████        -890 units                 │ │
│  │      ADJUST ██                      +45 units                  │ │
│  └────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
```

### KPIs Displayed

| KPI | Calculation | Refresh Rate |
|-----|-------------|--------------|
| Total Products | COUNT(medicine_id) | Daily |
| Low Stock Items | COUNT WHERE current_stock <= reorder_level | Real-time |
| Out of Stock | COUNT WHERE current_stock = 0 | Real-time |
| Expiring Soon | COUNT WHERE expiry_date <= SYSDATE + 30 | Daily |
| Stock Value | SUM(current_stock * unit_price) | Daily |

### SQL Query Examples

```sql
-- Low Stock Medicines
SELECT medicine_id, name, current_stock, reorder_level,
       (reorder_level - current_stock) AS shortage
FROM medicine
WHERE current_stock <= reorder_level
ORDER BY shortage DESC;

-- Medicines Expiring Within 30 Days
SELECT medicine_id, name, expiry_date,
       (expiry_date - TRUNC(SYSDATE)) AS days_remaining
FROM medicine
WHERE expiry_date <= SYSDATE + 30
  AND expiry_date > SYSDATE
ORDER BY expiry_date;

-- Stock by Category
SELECT category,
       COUNT(*) AS product_count,
       SUM(current_stock) AS total_units,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM medicine
GROUP BY category
ORDER BY product_count DESC;
```

---

## 4. Financial Dashboard

### Layout

```
┌─────────────────────────────────────────────────────────────────────┐
│                      FINANCIAL DASHBOARD                             │
│                    Period: [Date Range Selector]                     │
├─────────────────┬─────────────────┬─────────────────┬───────────────┤
│  TOTAL REVENUE  │  COLLECTED      │   PENDING       │   AVG TICKET  │
│  ₣ 3,250,000    │  ₣ 2,890,000    │  ₣ 360,000      │   ₣ 2,150     │
│   This Month    │   89% Collected │   11% Pending   │   Per Order   │
├─────────────────┴─────────────────┴─────────────────┴───────────────┤
│                                                                      │
│  DAILY REVENUE (Current Month)                                       │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │  ₣150K│        ▄▄                  ▄▄                          │ │
│  │  ₣100K│   ▄▄  ████  ▄▄    ▄▄  ▄▄  ████  ▄▄    ▄▄              │ │
│  │   ₣50K│  ████ ████ ████  ████████ ████ ████  ████             │ │
│  │      0│──1────5────10───15───20───25───30──────────────────── │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
├──────────────────────────────────┬──────────────────────────────────┤
│  PAYMENT METHOD BREAKDOWN        │  TOP REVENUE BY DOCTOR           │
│  ┌────────────────────────────┐  │  ┌────────────────────────────┐  │
│  │                            │  │  │ Dr. Mukamana    ₣ 580,000  │  │
│  │     CASH        45%        │  │  │ Dr. Uwimana     ₣ 450,000  │  │
│  │     ████████████           │  │  │ Dr. Kagame      ₣ 380,000  │  │
│  │     INSURANCE   35%        │  │  │ Dr. Uwase       ₣ 320,000  │  │
│  │     █████████              │  │  │ Dr. Nshimyu...  ₣ 280,000  │  │
│  │     CARD        20%        │  │  │                            │  │
│  │     █████                  │  │  │                            │  │
│  └────────────────────────────┘  │  └────────────────────────────┘  │
│                                   │                                  │
├──────────────────────────────────┴──────────────────────────────────┤
│  PENDING PAYMENTS                                                    │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │ Prescription │ Patient        │ Amount    │ Days Old │ Action  │ │
│  ├──────────────┼────────────────┼───────────┼──────────┼─────────┤ │
│  │ #1039        │ Habimana Eric  │ ₣ 45,000  │ 5 days   │ [Follow]│ │
│  │ #1035        │ Mutoni Alice   │ ₣ 32,000  │ 8 days   │ [Follow]│ │
│  │ #1028        │ Ndayisaba Paul │ ₣ 78,000  │ 12 days  │ [Follow]│ │
│  └────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
```

### KPIs Displayed

| KPI | Calculation | Refresh Rate |
|-----|-------------|--------------|
| Total Revenue | SUM(amount) for period | Real-time |
| Collected | SUM(amount) WHERE status = 'COMPLETED' | Real-time |
| Pending | SUM(amount) WHERE status = 'PENDING' | Real-time |
| Collection Rate | Collected / Total * 100 | Real-time |
| Average Ticket | Total Revenue / COUNT(payments) | Daily |

### SQL Query Examples

```sql
-- Payment Method Breakdown
SELECT payment_method,
       COUNT(*) AS transaction_count,
       SUM(amount) AS total_amount,
       ROUND(SUM(amount) * 100.0 / SUM(SUM(amount)) OVER(), 2) AS percentage
FROM payment
WHERE status = 'COMPLETED'
  AND TRUNC(payment_date, 'MM') = TRUNC(SYSDATE, 'MM')
GROUP BY payment_method;

-- Revenue by Doctor
SELECT d.name AS doctor_name,
       COUNT(p.prescription_id) AS prescriptions,
       SUM(pay.amount) AS total_revenue
FROM doctor d
JOIN prescription p ON d.doctor_id = p.doctor_id
JOIN payment pay ON p.prescription_id = pay.prescription_id
WHERE pay.status = 'COMPLETED'
GROUP BY d.name
ORDER BY total_revenue DESC;

-- Pending Payments Aging
SELECT p.prescription_id,
       pt.name AS patient_name,
       pay.amount,
       TRUNC(SYSDATE) - TRUNC(p.issue_date) AS days_old
FROM payment pay
JOIN prescription p ON pay.prescription_id = p.prescription_id
JOIN patient pt ON p.patient_id = pt.patient_id
WHERE pay.status = 'PENDING'
ORDER BY days_old DESC;
```

---

## Dashboard Access Matrix

| Dashboard | Manager | Pharmacist | Finance | Executive |
|-----------|---------|------------|---------|-----------|
| Executive | ✓ | - | ✓ | ✓ |
| Operations | ✓ | ✓ | - | - |
| Inventory | ✓ | ✓ | - | - |
| Financial | ✓ | - | ✓ | ✓ |

---

## Refresh Schedules

| Dashboard | Refresh Type | Frequency |
|-----------|--------------|-----------|
| Executive | Scheduled | Every 15 minutes |
| Operations | Real-time | On data change |
| Inventory | Scheduled | Every 5 minutes |
| Financial | Scheduled | Every 10 minutes |
