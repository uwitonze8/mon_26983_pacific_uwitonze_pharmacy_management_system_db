# Screenshots Guide

> Required screenshots for Pharmacy Management System documentation

---

## Screenshot Checklist

### Phase 1: Database Setup

| # | Screenshot Name | Description | Status |
|---|-----------------|-------------|--------|
| 1 | `01_pdb_creation.png` | PDB creation command and success message | ⬜ |
| 2 | `02_pdb_open.png` | PDB opened and saved state | ⬜ |
| 3 | `03_user_creation.png` | pharmacy_user creation and privileges | ⬜ |
| 4 | `04_connection_test.png` | SQL Developer connection to PDB | ⬜ |

### Phase 2: Table Creation

| # | Screenshot Name | Description | Status |
|---|-----------------|-------------|--------|
| 5 | `05_create_sequences.png` | Sequences created successfully | ⬜ |
| 6 | `06_create_tables.png` | Tables creation script execution | ⬜ |
| 7 | `07_tables_list.png` | All tables visible in SQL Developer | ⬜ |
| 8 | `08_table_structure.png` | Sample table structure (e.g., PRESCRIPTION) | ⬜ |

### Phase 3: Data Insertion

| # | Screenshot Name | Description | Status |
|---|-----------------|-------------|--------|
| 9 | `09_insert_doctors.png` | Doctor data insertion | ⬜ |
| 10 | `10_insert_patients.png` | Patient data insertion | ⬜ |
| 11 | `11_insert_medicines.png` | Medicine data insertion | ⬜ |
| 12 | `12_data_verification.png` | SELECT queries showing inserted data | ⬜ |

### Phase 4: Procedures & Functions

| # | Screenshot Name | Description | Status |
|---|-----------------|-------------|--------|
| 13 | `13_package_creation.png` | PHARMACY_PKG package creation | ⬜ |
| 14 | `14_package_body.png` | Package body compilation success | ⬜ |
| 15 | `15_procedure_test.png` | Testing process_prescription procedure | ⬜ |
| 16 | `16_function_test.png` | Testing calculate_prescription_total function | ⬜ |

### Phase 5: Triggers

| # | Screenshot Name | Description | Status |
|---|-----------------|-------------|--------|
| 17 | `17_trigger_creation.png` | Trigger creation (trg_dispense_medicine) | ⬜ |
| 18 | `18_trigger_test.png` | Trigger firing and stock update | ⬜ |
| 19 | `19_audit_trigger.png` | Audit log trigger working | ⬜ |
| 20 | `20_low_stock_alert.png` | Low stock alert trigger | ⬜ |

### Phase 6: Queries & Reports

| # | Screenshot Name | Description | Status |
|---|-----------------|-------------|--------|
| 21 | `21_basic_queries.png` | Basic SELECT queries results | ⬜ |
| 22 | `22_join_queries.png` | JOIN operations with results | ⬜ |
| 23 | `23_analytics_query.png` | Revenue or inventory analytics | ⬜ |
| 24 | `24_report_output.png` | Inventory report procedure output | ⬜ |

### Phase 7: Business Intelligence

| # | Screenshot Name | Description | Status |
|---|-----------------|-------------|--------|
| 25 | `25_revenue_report.png` | Daily/monthly revenue report | ⬜ |
| 26 | `26_low_stock_report.png` | Low stock medicines report | ⬜ |
| 27 | `27_prescription_status.png` | Prescription status distribution | ⬜ |
| 28 | `28_payment_analysis.png` | Payment method breakdown | ⬜ |

### Phase 8: Testing & Validation

| # | Screenshot Name | Description | Status |
|---|-----------------|-------------|--------|
| 29 | `29_workflow_test.png` | Complete prescription workflow test | ⬜ |
| 30 | `30_error_handling.png` | Error handling (business rule violation) | ⬜ |
| 31 | `31_audit_log_view.png` | Audit log entries | ⬜ |
| 32 | `32_inventory_log.png` | Inventory transaction log | ⬜ |

### Phase 9: Database Diagrams

| # | Screenshot Name | Description | Status |
|---|-----------------|-------------|--------|
| 33 | `33_erd_diagram.png` | Entity Relationship Diagram | ⬜ |
| 34 | `34_schema_diagram.png` | Database schema overview | ⬜ |
| 35 | `35_relationships.png` | Foreign key relationships | ⬜ |

### Phase 10: Oracle Enterprise Manager

| # | Screenshot Name | Description | Status |
|---|-----------------|-------------|--------|
| 36 | `36_oem_dashboard.png` | OEM main dashboard | ⬜ |
| 37 | `37_oem_performance.png` | Performance metrics | ⬜ |
| 38 | `38_oem_storage.png` | Storage/tablespace usage | ⬜ |

---

## How to Take Screenshots

### Windows
- **Full Screen:** Press `Windows + PrtScn`
- **Active Window:** Press `Alt + PrtScn`
- **Snipping Tool:** Press `Windows + Shift + S`

### Recommended Settings
- **Format:** PNG (better quality)
- **Resolution:** At least 1920x1080
- **File Size:** Keep under 5MB per image

---

## Screenshot Guidelines

### Do's ✅
- Include relevant context (window title, date/time if relevant)
- Show successful execution messages
- Capture complete query results
- Include line numbers in code screenshots
- Show clear output/results

### Don'ts ❌
- Don't crop important information
- Don't show personal/sensitive data
- Don't include unrelated windows
- Don't use blurry/low-quality images

---

## Folder Structure

```
screenshots/
├── 01_database_setup/
│   ├── 01_pdb_creation.png
│   ├── 02_pdb_open.png
│   ├── 03_user_creation.png
│   └── 04_connection_test.png
├── 02_tables/
│   ├── 05_create_sequences.png
│   ├── 06_create_tables.png
│   ├── 07_tables_list.png
│   └── 08_table_structure.png
├── 03_data/
│   ├── 09_insert_doctors.png
│   ├── 10_insert_patients.png
│   ├── 11_insert_medicines.png
│   └── 12_data_verification.png
├── 04_procedures/
│   ├── 13_package_creation.png
│   ├── 14_package_body.png
│   ├── 15_procedure_test.png
│   └── 16_function_test.png
├── 05_triggers/
│   ├── 17_trigger_creation.png
│   ├── 18_trigger_test.png
│   ├── 19_audit_trigger.png
│   └── 20_low_stock_alert.png
├── 06_queries/
│   ├── 21_basic_queries.png
│   ├── 22_join_queries.png
│   ├── 23_analytics_query.png
│   └── 24_report_output.png
├── 07_business_intelligence/
│   ├── 25_revenue_report.png
│   ├── 26_low_stock_report.png
│   ├── 27_prescription_status.png
│   └── 28_payment_analysis.png
├── 08_testing/
│   ├── 29_workflow_test.png
│   ├── 30_error_handling.png
│   ├── 31_audit_log_view.png
│   └── 32_inventory_log.png
├── 09_diagrams/
│   ├── 33_erd_diagram.png
│   ├── 34_schema_diagram.png
│   └── 35_relationships.png
├── 10_oem/
│   ├── 36_oem_dashboard.png
│   ├── 37_oem_performance.png
│   └── 38_oem_storage.png
└── README.md (this file)
```

---

## Priority Screenshots (Must Have)

If you're short on time, these are the **MUST HAVE** screenshots:

1. ✅ **PDB Creation** (`01_pdb_creation.png`)
2. ✅ **Tables List** (`07_tables_list.png`)
3. ✅ **Data Verification** (`12_data_verification.png`)
4. ✅ **Package Creation** (`13_package_creation.png`)
5. ✅ **Trigger Working** (`18_trigger_test.png`)
6. ✅ **ERD Diagram** (`33_erd_diagram.png`)
7. ✅ **Analytics Query** (`23_analytics_query.png`)
8. ✅ **Audit Log** (`31_audit_log_view.png`)

---

## Tips for Quality Screenshots

1. **Clear SQL Developer View**
   - Increase font size for readability
   - Close unnecessary panels
   - Show output clearly

2. **For Query Results**
   - Show both the query and results
   - Include column headers
   - Show enough rows to demonstrate

3. **For Procedures/Triggers**
   - Show creation success message
   - Show test execution
   - Show expected output

4. **For Reports**
   - Show complete output
   - Include headers/titles
   - Show data clearly formatted

---

## Screenshot Template Queries

I'll create SQL scripts that generate good screenshot content in the next files.
