# Punjab Digital Community Supervision System (PDCSS)
## Data Retention and Archival Policy - Draft

> [!IMPORTANT]
> **Legal Notice**: All retention windows, archival schedules, and deletion rules specified in this document are draft proposals based on standard public-sector record management practices. **All retention schedules require formal PP&PS legal or administrative approval** before automated purge scripts are deployed to production.

---

### 1. Data Classification and Proposed Retention Matrix

| Data Category | Operational Retention Period | Post-Supervision Archival Window | Permanent Purge Condition | Legal Approval Status |
| :--- | :--- | :--- | :--- | :--- |
| **Supervisee Master Profile (PII)** | Duration of Active Supervision Order | 10 Years in Cold Archive | Permanent archive or purge upon court order | **Requires PP&PS legal or administrative approval** |
| **Court Orders & Legal Supervision Records** | Duration of Active Supervision Order | 20 Years in Cold Archive | Permanent historical record retention | **Requires PP&PS legal or administrative approval** |
| **Digital Check-In Location Logs (PostGIS)** | 12 Months from Check-In Date | 3 Years Aggregated Anonymized | Purged after 4 Years total | **Requires PP&PS legal or administrative approval** |
| **Check-In Live Photographs (MinIO)** | 6 Months from Check-In Date | 1 Year for Flagged/Disputed Photos | Unflagged photos purged after 1 Year | **Requires PP&PS legal or administrative approval** |
| **Contact Logs & Officer Notes** | Duration of Active Supervision Order | 10 Years post-discharge | Purged after 10 Years | **Requires PP&PS legal or administrative approval** |
| **RNA & ISRP Documents** | Duration of Active Supervision Order | 10 Years post-discharge | Purged after 10 Years | **Requires PP&PS legal or administrative approval** |
| **Violation Records & Supervisory Sign-offs** | Duration of Active Supervision Order | 15 Years post-discharge | Permanent legal record if court-submitted | **Requires PP&PS legal or administrative approval** |
| **Immutable Audit Trail Records** | 5 Years Online Queryable | 10 Years Encrypted Offline Backup | Permanent immutable audit ledger | **Requires PP&PS legal or administrative approval** |
| **Temporary Mobile Offline Sync Queues** | Purged immediately upon successful sync verification | N/A (Local cache wiped) | Wiped after server receipt confirmation | Technical Policy (Approved) |

---

### 2. Automated Archival & Destruction Mechanisms
1. **Automated Lifecycle Policy**: MinIO bucket lifecycle policies automatically transition unflagged check-in photos from hot S3 storage to cold archive after 180 days, and hard-delete after 365 days.
2. **Cryptographic Erasure (Right to Erasure Compliance)**: Where court or administrative orders mandate record expungement, encryption keys for archived supervisee record blobs are destroyed, rendering data permanently unrecoverable.
3. **Audit Log Exception**: Immutable audit log entries recording the expungement event itself (stating date, authorized officer ID, and court order reference) are permanently retained without PII payload.
