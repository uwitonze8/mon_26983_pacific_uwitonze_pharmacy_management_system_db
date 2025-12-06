# Design Decisions

> Documentation of key architectural and design choices made during system development

---

## Overview

This document outlines the rationale behind major design decisions in the Pharmacy Management System. Understanding these decisions helps maintain consistency and guides future development.

---

## Database Design Decisions

### 1. Pluggable Database Architecture

**Decision:** Use Oracle Pluggable Database (PDB) instead of traditional standalone database.

**Rationale:**
- Better resource isolation and management
- Easier backup and recovery at PDB level
- Simplified database consolidation
- Reduced administrative overhead

**Trade-offs:**
- Requires Oracle 12c or later
- Additional complexity in initial setup

---

### 2. Prescription Status Workflow

**Decision:** Implement a status-based workflow with four states: NEW → VALIDATED → DISPENSED → COMPLETED.

**Rationale:**
- Clear audit trail of prescription lifecycle
- Enables validation checkpoints before dispensing
- Supports business rules enforcement via triggers
- Allows for prescription tracking and reporting

**Alternatives Considered:**
- Simple binary (pending/complete) - Rejected: insufficient granularity
- Free-form status - Rejected: inconsistent data entry

---

### 3. Separate Prescription and Prescription_Items Tables

**Decision:** Normalize prescriptions into header (PRESCRIPTION) and detail (PRESCRIPTION_ITEMS) tables.

**Rationale:**
- Follows 3NF normalization principles
- Supports multiple medicines per prescription
- Reduces data redundancy
- Enables flexible medicine quantity per prescription

**Trade-offs:**
- Requires joins for complete prescription view
- Slightly more complex queries

---

### 4. Inventory Logging

**Decision:** Create separate INVENTORY_LOG table instead of tracking changes in MEDICINE table.

**Rationale:**
- Complete audit history of all stock changes
- Supports inventory reconciliation
- Enables trend analysis and forecasting
- Non-destructive record keeping

**Alternatives Considered:**
- Storing only current stock - Rejected: no history tracking
- Using Oracle audit trails only - Rejected: limited analytical capability

---

## PL/SQL Design Decisions

### 5. Package-Based Business Logic

**Decision:** Encapsulate all business logic in PHARMACY_PKG package.

**Rationale:**
- Single point of maintenance for business rules
- Better code organization and reusability
- Improved performance through package state
- Cleaner separation of concerns

**Package Contents:**
- Procedures for data operations
- Functions for calculations and lookups
- Cursors for common data access patterns
- Constants for shared values

---

### 6. Trigger-Based Stock Management

**Decision:** Use AFTER INSERT trigger on DISPENSED_MEDICINES to automatically update stock.

**Rationale:**
- Ensures stock updates cannot be bypassed
- Maintains data consistency automatically
- Centralizes stock deduction logic
- Reduces application code complexity

**Trade-offs:**
- Trigger debugging can be challenging
- Must carefully manage trigger execution order
- Performance impact on high-volume inserts

---

### 7. Exception Handling Strategy

**Decision:** Use custom application errors (-20001 to -20999) for business rule violations.

**Rationale:**
- Clear distinction between system and business errors
- Meaningful error messages for users
- Consistent error handling across procedures
- Easier debugging and logging

**Error Code Ranges:**
| Range | Purpose |
|-------|---------|
| -20001 to -20010 | Prescription validation errors |
| -20011 to -20020 | Inventory/stock errors |
| -20021 to -20030 | Payment processing errors |
| -20031 to -20040 | Security/access errors |

---

### 8. Cursor Declaration in Package Spec

**Decision:** Declare commonly used cursors in package specification.

**Rationale:**
- Reusable across multiple procedures
- Consistent data access patterns
- Easier maintenance of cursor logic
- Clear documentation of available cursors

**Cursors Defined:**
- `c_active_prescriptions`: Prescriptions pending processing
- `c_low_stock_medicines`: Medicines below reorder level

---

## Security Design Decisions

### 9. Audit Logging Implementation

**Decision:** Implement comprehensive audit logging via triggers on all core tables.

**Rationale:**
- Regulatory compliance requirements
- Security incident investigation capability
- Change tracking for accountability
- Support for data recovery scenarios

**Logged Information:**
- User performing action
- Timestamp of action
- Operation type (INSERT/UPDATE/DELETE)
- Table affected
- Old and new values

---

### 10. Role-Based Access Control

**Decision:** Create separate database users with specific privilege grants.

**Rationale:**
- Principle of least privilege
- Clear separation of duties
- Audit trail per user
- Simplified access management

**User Roles:**
| User Type | Privileges |
|-----------|------------|
| Admin | Full DBA access |
| Pharmacist | CRUD on operational tables |
| Report User | SELECT only on specific views |

---

## Data Integrity Decisions

### 11. Foreign Key Constraints

**Decision:** Enforce referential integrity via foreign key constraints with RESTRICT delete behavior.

**Rationale:**
- Prevents orphan records
- Database-level enforcement (cannot be bypassed)
- Clear relationship documentation
- Supports cascade operations where appropriate

**Trade-offs:**
- Requires careful insert order
- Delete operations may be blocked

---

### 12. Check Constraints for Business Rules

**Decision:** Implement check constraints for simple validations (positive prices, valid status values).

**Rationale:**
- Database-level validation
- Cannot be bypassed by application code
- Self-documenting constraints
- Better performance than trigger validation

**Constraints Implemented:**
- Unit_Price > 0
- Current_Stock >= 0
- Status IN ('NEW', 'VALIDATED', 'DISPENSED', 'COMPLETED')
- Payment_Method IN ('CASH', 'CARD', 'INSURANCE')

---

### 13. Sequence-Based Primary Keys

**Decision:** Use Oracle sequences for all primary key generation.

**Rationale:**
- Guaranteed uniqueness
- No contention on key generation
- Sequential values for easier debugging
- Standard Oracle best practice

**Sequence Naming Convention:** `seq_<table>_id`

---

## Performance Decisions

### 14. Indexing Strategy

**Decision:** Create indexes on frequently queried columns beyond primary keys.

**Rationale:**
- Faster query execution
- Reduced full table scans
- Improved join performance
- Better report generation times

**Indexed Columns:**
- Status fields (frequent filtering)
- Date fields (range queries)
- Foreign key columns (join optimization)

---

### 15. Avoiding Unnecessary Triggers

**Decision:** Limit triggers to essential business logic only.

**Rationale:**
- Triggers add overhead to DML operations
- Debugging complexity increases with triggers
- Keep business logic in packages when possible
- Only use triggers when enforcement cannot be bypassed

---

## Future Considerations

### Potential Enhancements
1. Partitioning for large tables (PRESCRIPTION, INVENTORY_LOG)
2. Materialized views for complex reports
3. Advanced queuing for async notifications
4. Integration APIs via Oracle REST Data Services

### Migration Path
- Current design supports migration to cloud (Oracle Cloud)
- Package-based logic simplifies API creation
- Audit logging supports compliance in any environment
