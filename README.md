Pharmacy Management System – PL/SQL Oracle Database Project

Student Info
Name: Uwitonze pacific
Student ID: 26983
Course: Database Development with PL/SQL (INSY 8311)
Lecturer: Eric Maniraguha
Academic Year: 2025–2026
Introduction:

Modern pharmacies face increasing challenges due to manual processes that often result in prescription errors, inventory mismatches, delayed patient services, and data inconsistencies.

To address these pain points, this project introduces a Pharmacy Management System built using Oracle Database and PL/SQL programming. The system provides automation, real-time tracking, and secure data management for prescriptions, inventory, and payments—enhancing service delivery and operational efficiency.

The project was implemented in eight phases, covering everything from problem analysis and business modeling to logical design, implementation, testing, and reporting.

Project Timeline and Structure

Phase | Title

(Phase 1:  Problem Statement). Identifying Core Challenges – Pinpointing the key pharmacy pain points (prescription errors, stock mismatches, billing delays) and defining exactly what our system must solve.

(Phase 2:  Business Process Modeling). Mapping Essential Workflows – Drawing a clear flowchart of prescription issuance → validation → dispensing → billing → stock update, and assigning who does each step.

(Phase 3:  Logical Model Design). Designing Strong Foundations – Translating workflow into tables (Patients, Doctors, Medicines, Prescriptions, Payments), defining fields and relationships to ensure clean, normalized data.

(Phase 4:  Physical Database Implementation). Building the Database – Creating the Oracle pluggable database (mon_26630_pascal_pharmacy_db), setting up user privileges, and connecting Oracle Enterprise Manager for real-time monitoring.

(Phase 5:  Data Insertion). Populating with Meaningful Data – Loading realistic sample records (patients, doctors, medicines, prescriptions, payments) to validate constraints and simulate real-world operations.

(Phase 6:  Transaction Handling). Ensuring Data Integrity – Writing PL/SQL procedures, functions, and packages for core actions (issue prescription, process payment), using cursors and exception blocks to keep data accurate.

(Phase 7:  Security Features). Securing Sensitive Information – Implementing triggers to auto-update stock and block changes on weekdays/holidays, plus audit tables and triggers to log every data-change attempt.

(Phase 8: Reporting and Query Optimization). Delivering Actionable Insights – Crafting analytical queries (low-stock alerts, sales summaries), tuning indexes for speed, and preparing final reports and a 10-slide presentation for stakeholders.

 Phase 1: Problem Statement.

 Problem Definition

Pharmacies often face operational inefficiencies due to manual handling of prescriptions, outdated inventory tracking methods, and unstructured patient records. These issues contribute to:

--Medication errors and mismatched prescriptions

Delays in service

Out-of-stock problems

Lost revenue due to poor billing and payment tracking

 Context
This Pharmacy Management System is designed for community and hospital-based pharmacies where data integrity, automation, and quick access to patient information are critical.

 Target Users

Pharmacists – Manage inventory, fulfill prescriptions

Doctors – Issue prescriptions

Patients – Get medication, view history

Managers – View analytics, track performance

Project Goals
Automate prescription workflows

Track inventory levels and alert on low stock
