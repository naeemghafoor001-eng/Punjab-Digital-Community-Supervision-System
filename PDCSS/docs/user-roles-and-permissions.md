# Punjab Digital Community Supervision System (PDCSS)
## User Roles and Permissions Specification

### 1. Role-Based Access Control (RBAC) Architecture
PDCSS enforces strict least-privilege Role-Based Access Control (RBAC) integrated with Attribute-Based Access Control (ABAC) for organizational scoping. Users authenticate via Keycloak IAM, receiving a signed JWT access token containing assigned role scopes and office assignment attributes (`district_id`, `division_id`, `tehsil_id`).

### 2. User Roles Taxonomy

| Role ID | Role Name | System Description & Scope | Primary App |
| :--- | :--- | :--- | :--- |
| `ROLE_SUPERVISEE` | Supervisee | Probationer or Parolee. Access strictly restricted to own profile, schedule, check-in submission, complaints, and notifications. | Supervisee Android App |
| `ROLE_PROBATION_OFFICER` | Probation Officer | Operational officer assigned court-ordered probationers in a specific Tehsil/District. Can manage assigned cases, field contacts, RNA/ISRP, and check-in reviews. | Officer Android App / Web Portal |
| `ROLE_PAROLE_OFFICER` | Parole Officer | Operational officer managing executive parole cases. Identical operational scope to Probation Officer with parole-specific condition tracking. | Officer Android App / Web Portal |
| `ROLE_DISTRICT_SUPERVISOR` | District Supervisory Officer | Assistant Director / District Officer managing all probation/parole cases within assigned District. Case transfer sign-off, violation review, district dashboards. | Web Portal / Officer Android App |
| `ROLE_DIVISIONAL_SUPERVISOR` | Divisional Supervisory Officer | Deputy Director / Regional Supervisor managing multiple districts in a Division. Regional oversight, inter-district transfer approval, resource management. | Web Portal |
| `ROLE_MONITORING_OFFICER` | Directorate Monitoring Officer | HQ Monitoring Cell Officer. Statewide read-only access to case metrics, performance bottlenecks, check-in completion rates, and compliance trends. | Web Portal |
| `ROLE_REHAB_OFFICER` | Rehabilitation Officer | Specialist managing rehabilitation assessments, vocational training referrals, psychological counseling logs, and social integration plans. | Web Portal / Officer Android App |
| `ROLE_AUDIT_OFFICER` | Audit Officer | Internal/External Auditor. Strictly read-only access to tamper-evident audit logs, security event logs, and compliance export history. | Web Portal |
| `ROLE_SYSTEM_ADMIN` | System Administrator | IT Infrastructure & Application Administrator. System configuration, user account creation, office hierarchy setup, server logs. **NO OPERATIONAL CASE DATA ACCESS.** | Web Portal |
| `ROLE_EXECUTIVE_VIEWER` | Director General / Leadership | High-level executive read-only dashboards, provincial statistical aggregation, macro compliance reporting. | Web Portal |

---

### 3. Detailed Permission Matrix

| Module / Feature | Supervisee | Probation / Parole Officer | District Supervisor | Divisional Supervisor | Directorate Monitoring | Rehab Officer | Audit Officer | System Admin | Executive Viewer |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **View Own Case Profile / Schedule** | **FULL** | Assigned | District | Division | Statewide | Assigned | Read-only | NO ACCESS | Aggregated |
| **Self Check-In & Photo Capture** | **CREATE** | NO | NO | NO | NO | NO | NO | NO | NO |
| **Officer-Assisted Check-In** | NO | **CREATE** | **CREATE** | NO | NO | NO | NO | NO | NO |
| **Create / Edit RNA & ISRP** | NO | **FULL** | View/Approve | View | Read-only | **FULL** | Read-only | NO ACCESS | NO |
| **Record Violation Notice** | NO | **CREATE** | View/Approve | View | Read-only | NO | Read-only | NO ACCESS | NO |
| **Approve / Close Violation** | NO | NO | **APPROVE** | **APPROVE** | NO | NO | NO | NO ACCESS | NO |
| **Initiate Case Transfer** | NO | **INITIATE** | **APPROVE** | **APPROVE** | NO | NO | NO | NO ACCESS | NO |
| **File Complaint / Assistance Req** | **CREATE** | View | View | View | View | View | Read-only | NO ACCESS | NO |
| **User Account & Role Management** | NO | NO | NO | NO | NO | NO | NO | **FULL** | NO |
| **View Immutable Audit Logs** | NO | NO | District Audit | Regional Audit | Statewide Audit | NO | **FULL** | System Audit | NO |
| **District / Provincial Dashboards** | NO | Own Summary | District View | Division View | Provincial View | Summary | Summary | System Health | **PROVINCIAL** |

---

### 4. System Administrator Isolation Boundary
To comply with Privacy Requirement #9 (*Separate system-administration privileges from operational case access*):
- The `ROLE_SYSTEM_ADMIN` can create user accounts, assign Keycloak roles, map officers to Tehsil/District IDs, configure MinIO storage endpoints, and inspect server health metrics.
- Backend API endpoints serving case profiles, check-in photos, supervision orders, medical/psychological evaluations, and probationer notes explicitly return `403 Forbidden` if invoked with `ROLE_SYSTEM_ADMIN` credentials.
- All administrative actions performed by `ROLE_SYSTEM_ADMIN` are logged to the tamper-evident audit log, which is monitored by `ROLE_AUDIT_OFFICER`.
