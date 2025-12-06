# System Architecture

> Technical architecture documentation for the Pharmacy Management System

---

## Overview

The Pharmacy Management System is built on Oracle Database 21c using PL/SQL for business logic implementation. The architecture follows a modular design pattern with clear separation between data storage, business logic, and security layers.

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        APPLICATION LAYER                         │
│                    (SQL Developer / OEM)                         │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                        SECURITY LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐  │
│  │   Roles     │  │  Privileges │  │    Audit Triggers       │  │
│  │  & Users    │  │   Control   │  │    & Logging            │  │
│  └─────────────┘  └─────────────┘  └─────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      BUSINESS LOGIC LAYER                        │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                    PHARMACY_PKG                           │   │
│  │  ┌────────────────┐  ┌────────────────┐                  │   │
│  │  │   Procedures   │  │   Functions    │                  │   │
│  │  │ - process_     │  │ - calculate_   │                  │   │
│  │  │   prescription │  │   prescription_│                  │   │
│  │  │ - generate_    │  │   total        │                  │   │
│  │  │   inventory_   │  │                │                  │   │
│  │  │   report       │  │                │                  │   │
│  │  └────────────────┘  └────────────────┘                  │   │
│  │  ┌────────────────┐  ┌────────────────┐                  │   │
│  │  │    Cursors     │  │   Exceptions   │                  │   │
│  │  │ - c_active_    │  │   Handling     │                  │   │
│  │  │   prescriptions│  │                │                  │   │
│  │  │ - c_low_stock  │  │                │                  │   │
│  │  └────────────────┘  └────────────────┘                  │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                        TRIGGER LAYER                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  │
│  │ trg_dispense_   │  │ trg_inventory_  │  │ trg_audit_      │  │
│  │ medicine        │  │ update          │  │ log             │  │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                         DATA LAYER                               │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐   │
│  │ DOCTOR  │ │ PATIENT │ │MEDICINE │ │PRESCRIP-│ │ PAYMENT │   │
│  │         │ │         │ │         │ │  TION   │ │         │   │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘   │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐               │
│  │PHARMA-  │ │PRESCRIP-│ │DISPENSED│ │INVENTORY│               │
│  │  CIST   │ │TION_ITEM│ │_MEDICINE│ │  _LOG   │               │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘               │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                     ORACLE DATABASE 19c                          │
│                 Pluggable Database (PDB)                         │
│            mon_26983_pacific_pharmacy_db                         │
└─────────────────────────────────────────────────────────────────┘
```

---

## Layer Descriptions

### 1. Application Layer
- **SQL Developer**: Primary interface for database development and administration
- **Oracle Enterprise Manager (OEM)**: Monitoring, performance tuning, and alerts

### 2. Security Layer
- **User Management**: Separate users with role-based access control
- **Privilege Control**: CONNECT, RESOURCE, DBA grants as needed
- **Audit Triggers**: Track all INSERT, UPDATE, DELETE operations

### 3. Business Logic Layer
- **PHARMACY_PKG**: Main package containing all business procedures and functions
- **Procedures**: Handle prescription processing, inventory management, reporting
- **Functions**: Calculate totals, validate data, retrieve information
- **Cursors**: Iterate through active prescriptions, low-stock medicines

### 4. Trigger Layer
- **trg_dispense_medicine**: Validates and processes medicine dispensing
- **trg_inventory_update**: Automatically updates stock levels
- **trg_audit_log**: Records all data modifications for audit trail

### 5. Data Layer
- **9 Core Tables**: Store all operational data
- **Referential Integrity**: Foreign key constraints ensure data consistency
- **Sequences**: Auto-generate primary key values

---

## Database Configuration

| Property | Value |
|----------|-------|
| Database Type | Oracle 19c Pluggable Database |
| PDB Name | mon_26983_pacific_pharmacy_db |
| Character Set | AL32UTF8 |
| Admin User | pacific |
| Application User | pharmacy_user |

---

## Data Flow

### Prescription Processing Flow

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  Doctor  │────▶│ Create   │────▶│ Validate │────▶│ Dispense │
│  Login   │     │Prescript.│     │ (Pharm.) │     │ Medicine │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
                                                         │
                                                         ▼
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  Alert   │◀────│  Update  │◀────│  Update  │◀────│ Process  │
│ Low Stock│     │   Stock  │     │  Status  │     │ Payment  │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
```

### Inventory Management Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Add New   │────▶│   Update    │────▶│    Log      │
│   Stock     │     │   Medicine  │     │ Transaction │
└─────────────┘     └─────────────┘     └─────────────┘
                           │
                           ▼
                    ┌─────────────┐
                    │ Check Stock │
                    │   Level     │
                    └─────────────┘
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
       ┌─────────────┐          ┌─────────────┐
       │  Normal     │          │  Low Stock  │
       │  Operation  │          │   Alert     │
       └─────────────┘          └─────────────┘
```

---

## Component Interactions

| Component | Interacts With | Purpose |
|-----------|----------------|---------|
| DOCTOR | PRESCRIPTION | Creates prescriptions for patients |
| PATIENT | PRESCRIPTION | Receives prescriptions |
| PRESCRIPTION | PRESCRIPTION_ITEMS | Contains multiple medicine items |
| MEDICINE | PRESCRIPTION_ITEMS | Referenced in prescription items |
| PHARMACIST | DISPENSED_MEDICINES | Records who dispensed medicines |
| PRESCRIPTION | PAYMENT | Links payment to prescription |
| MEDICINE | INVENTORY_LOG | Tracks all stock changes |

---

## Performance Considerations

### Indexing Strategy
- Primary keys: B-tree indexes (automatic)
- Foreign keys: Indexed for join optimization
- Status columns: Indexed for frequent filtering
- Date columns: Indexed for range queries

### Query Optimization
- Use of bind variables in procedures
- Cursor optimization with bulk collect where appropriate
- Execution plan analysis for complex queries
